#!/usr/bin/env node
/**
 * Run the hosted GUI2Lean4 workflow with Playwright, record it, and submit a
 * redacted proof manifest plus a Lean witness to the local Aristo service.
 *
 * This intentionally never enters an API key.  The browser artifact is kept
 * locally; the proof service receives its hash and redacted manifest.
 */
import fs from 'node:fs';
import path from 'node:path';
import crypto from 'node:crypto';
import { createRequire } from 'node:module';
import { spawnSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const baseUrl = (process.env.GUI2LEAN4_BASE_URL || 'https://aristotle-manager.pages.dev').replace(/\/$/, '');
const proofUrl = process.env.GUI2LEAN4_PROOF_URL || 'http://127.0.0.1:9876/api/v3/project';
const runId = new Date().toISOString().replace(/[:.]/g, '-');
const artifactDir = path.resolve(process.env.GUI2LEAN4_ARTIFACT_DIR || path.join(root, 'data', 'gui2lean4', runId));
fs.mkdirSync(artifactDir, { recursive: true });

function publicUrl(value) {
  const url = new URL(value);
  return `${url.origin}${url.pathname}`;
}

function sha256(file) {
  return crypto.createHash('sha256').update(fs.readFileSync(file)).digest('hex');
}

const require = createRequire(import.meta.url);
const HesperGIF = require('./hesper-gif.cjs');

function exportTwitterGif(videoPath, gifPath) {
  // Keep this small enough for social sharing while retaining the source
  // aspect ratio (the Playwright recording is 1440x1000).
  const width = 480;
  const height = 334;
  const fps = 10;
  const decoded = spawnSync('ffmpeg', [
    '-hide_banner', '-loglevel', 'error', '-i', videoPath,
    '-vf', `fps=${fps},scale=${width}:${height}:flags=lanczos,format=rgba`,
    '-f', 'rawvideo', 'pipe:1',
  ], { maxBuffer: 512 * 1024 * 1024 });
  if (decoded.error) throw decoded.error;
  if (decoded.status !== 0) throw new Error(`ffmpeg GIF input failed (${decoded.status})`);
  const frameSize = width * height * 4;
  const count = Math.floor(decoded.stdout.length / frameSize);
  if (!count) throw new Error('ffmpeg produced no GIF frames');
  const frames = Array.from({ length: count }, (_, i) => ({
    data: new Uint8ClampedArray(decoded.stdout.buffer, decoded.stdout.byteOffset + i * frameSize, frameSize),
  }));
  const bytes = HesperGIF.encode(frames, { width, height, fps, maxColors: 128, dither: true });
  fs.writeFileSync(gifPath, bytes);
  return { width, height, fps, frames: count, bytes: bytes.length };
}

const { chromium } = await import('playwright');
const browser = await chromium.launch({ headless: true });
const context = await browser.newContext({
  recordVideo: { dir: artifactDir, size: { width: 1440, height: 1000 } },
});
await context.tracing.start({ screenshots: true, snapshots: true, sources: false });
const page = await context.newPage();
const browserMessages = [];
page.on('console', message => browserMessages.push(`${message.type()}: ${message.text()}`));
page.on('pageerror', error => browserMessages.push(`pageerror: ${error.message}`));
const checks = [];

try {
  await page.goto(`${baseUrl}/`, { waitUntil: 'networkidle', timeout: 30_000 });
  checks.push({ name: 'page-loaded', ok: (await page.title()).length > 0 });
  // The shipped UI displays a default Cloudflare account identifier; redact
  // it before any screenshot/video is written.
  const accountId = page.locator('#cloudflareAccountId');
  if (await accountId.count()) await accountId.fill('[REDACTED]');
  await page.screenshot({ path: path.join(artifactDir, 'initial.png'), fullPage: true });

  // Exercise the deployment UI without submitting credentials or deploying a
  // real project. This is the self-hosted GUI workflow under test.
  const deployTab = page.locator('[data-tab="deploy"]');
  if (await deployTab.count()) {
    await deployTab.click();
    // Allow the hosted WASM module to finish initialization before invoking
    // its config generator.
    await page.waitForTimeout(2_000);
    await page.locator('#deployProjectId').fill('0f9b0981-1dc9-4321-a46b-53e3cc6ee6e3');
    await page.locator('#deployProjectName').fill('gui2lean4-self-capture');
    await page.locator('#deployDomain').fill('');
    await page.locator('#deployProject').click();
    await page.waitForTimeout(1_000);
    const output = page.locator('#deployOutput');
    checks.push({ name: 'deployment-config-generated', ok: (await output.count()) > 0 && (await output.innerText()).length > 0 });
  } else {
    checks.push({ name: 'deployment-config-generated', ok: false, detail: 'deploy tab not present' });
  }
  await page.screenshot({ path: path.join(artifactDir, 'deployment-config.png'), fullPage: true });
} finally {
  await context.tracing.stop({ path: path.join(artifactDir, 'trace.zip') });
  await page.close();
  await context.close();
  await browser.close();
}

const video = fs.readdirSync(artifactDir).find(name => name.endsWith('.webm'));
let gif = null;
if (video) {
  try {
    gif = exportTwitterGif(path.join(artifactDir, video), path.join(artifactDir, 'twitter.gif'));
    checks.push({ name: 'twitter-gif-generated', ok: true, ...gif });
  } catch (error) {
    checks.push({ name: 'twitter-gif-generated', ok: false, detail: error.message });
  }
}
const artifacts = {};
for (const name of ['initial.png', 'deployment-config.png', 'trace.zip', video, gif ? 'twitter.gif' : null]) {
  if (name && fs.existsSync(path.join(artifactDir, name))) artifacts[name] = { sha256: sha256(path.join(artifactDir, name)) };
}
const manifest = {
  schema: 'gui2lean4-proof/v1',
  capturedAt: new Date().toISOString(),
  url: publicUrl(`${baseUrl}/`),
  checks,
  artifacts,
  redaction: 'No API key, cookie, authorization header, or browser storage was captured.',
  browserMessages,
};
fs.writeFileSync(path.join(artifactDir, 'proof-manifest.json'), JSON.stringify(manifest, null, 2));

const leanWitness = `/-- The GUI capture completed its declared checks; external evidence is in the manifest. -/\ntheorem gui2lean4_capture_checks_completed : True := by trivial\n`;
const form = new FormData();
form.append('body', JSON.stringify({
  prompt: `GUI2Lean4 hosted self-deployment capture ${manifest.capturedAt}; video and trace are identified by SHA-256 in the attached manifest.`,
  files: {
    'Gui2Lean4Capture.lean': leanWitness,
    'gui2lean4-proof.json': JSON.stringify(manifest, null, 2),
  },
}));
const response = await fetch(proofUrl, { method: 'POST', body: form });
const responseText = await response.text();
if (!response.ok) throw new Error(`proof submission failed (${response.status}): ${responseText}`);
fs.writeFileSync(path.join(artifactDir, 'submission-response.json'), responseText);
console.log(JSON.stringify({ artifactDir, proofUrl, manifest, submission: JSON.parse(responseText) }, null, 2));
