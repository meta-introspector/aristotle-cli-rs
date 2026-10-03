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

/**
 * Strip anything identifying out of a string before it reaches the manifest.
 *
 * The capture already blanks #cloudflareAccountId in the DOM before the
 * screenshot, but console output is a second, unblinded channel: real
 * manifests carried "Deploying project 0f9b0981-1dc9-4321-a46b-53e3cc6ee6e3"
 * verbatim while claiming nothing identifying was collected. Anything that
 * reaches the proof service goes through here first.
 */
const REDACTIONS = [
  [/\b[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\b/gi, '[REDACTED-uuid]'],
  [/\b(?:api[_-]?key|token|secret|password|authorization|cookie|bearer)\b\s*[:=]\s*\S+/gi, '[REDACTED-credential]'],
  [/\b[A-Za-z0-9_-]{32,}\b/g, '[REDACTED-long-token]'],
  [/\b[a-z0-9-]+\.(?:pages\.dev|workers\.dev)\b/gi, '[REDACTED-host]'],
];
function redact(value) {
  return String(value ?? '').replace(REDACTIONS[0][0], REDACTIONS[0][1])
    .replace(REDACTIONS[1][0], REDACTIONS[1][1])
    .replace(REDACTIONS[2][0], REDACTIONS[2][1])
    .replace(REDACTIONS[3][0], REDACTIONS[3][1]);
}

const require = createRequire(import.meta.url);
const HesperGIF = require('./hesper-gif.cjs');

function exportTwitterGif(videoPath, gifPath) {
  // Keep this small enough for social sharing while retaining the source
  // aspect ratio (the Playwright recording is 1440x1800).
  const width = 480;
  const height = 600;
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
  viewport: { width: 1440, height: 1800 },
  recordVideo: { dir: artifactDir, size: { width: 1440, height: 1800 } },
});
await context.tracing.start({ screenshots: true, snapshots: true, sources: false });
const page = await context.newPage();
page.on('console', message => recordMessage(`${message.type()}: ${message.text()}`));
page.on('pageerror', error => recordMessage(`pageerror: ${error.message}`));
const checks = [];
const browserMessages = [];
const recordMessage = text => {
  const clean = redact(text);
  if (clean !== String(text ?? '')) browserMessages.push(`${clean}  [redacted]`);
  else browserMessages.push(clean);
};
let realDeployment = null;

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
    if (process.env.GUI2PROOF_REAL_DEPLOY === '1') {
      const deploy = spawnSync(process.env.NODE_BIN || 'node', [path.join(root, 'scripts', 'deploy-aristo-pages.mjs')], {
        cwd: root,
        env: process.env,
        encoding: 'utf8',
        maxBuffer: 2 * 1024 * 1024,
      });
      if (deploy.error) throw deploy.error;
      if (deploy.status !== 0) throw new Error(`Cloudflare deployment failed (${deploy.status})`);
      try { realDeployment = JSON.parse(deploy.stdout); } catch { throw new Error('Cloudflare deployment returned invalid metadata'); }
      if (!realDeployment.deployed || !realDeployment.url) throw new Error('Cloudflare deployment did not return a public URL');
      await page.evaluate(result => {
        const target = document.querySelector('#deployOutput');
        if (target) target.textContent += `\n\nLIVE TEST DEPLOYMENT\n${JSON.stringify(result, null, 2)}`;
      }, realDeployment);
      checks.push({ name: 'cloudflare-pages-deployed', ok: true, project: realDeployment.project, url: realDeployment.url });
    }
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
const passed = checks.filter(c => c.ok).length;
const allPassed = checks.length > 0 && passed === checks.length;
const manifest = {
  schema: 'gui2lean4-proof/v1',
  capturedAt: new Date().toISOString(),
  url: publicUrl(`${baseUrl}/`),
  checks,
  artifacts,
  deployment: realDeployment ? { project: realDeployment.project, url: realDeployment.url, sourceUrl: realDeployment.sourceUrl, bytes: realDeployment.bytes } : null,
  summary: { passed, total: checks.length, allPassed },
  redaction: 'Browser console output and page errors are recorded after redaction: UUIDs, ' +
    'credential-shaped strings, long tokens and deployment hostnames are replaced. ' +
    'No API key, cookie, authorization header, or browser storage is read by this script.',
  browserMessages,
};
fs.writeFileSync(path.join(artifactDir, 'proof-manifest.json'), JSON.stringify(manifest, null, 2));

// A record of what the capture observed, not a proof that the GUI is
// correct. The previous witness was `theorem ... : True := by trivial`,
// which held whether every check passed or every one failed; naming it
// "checks_completed" claimed far more than it established. This states the
// counts that were actually observed and says plainly what it is not.
const leanWitness = [
  `/--`,
  `Record of one GUI2Lean4 browser capture. This is a transcript of what the`,
  `capture observed, not a proof that the GUI is correct. The authoritative`,
  `evidence is gui2lean4-proof.json and the SHA-256 artifact digests in it.`,
  `-/`,
  `def gui2lean4ChecksPassed : Nat := ${passed}`,
  `def gui2lean4ChecksTotal : Nat := ${checks.length}`,
  `def gui2lean4AllChecksPassed : Bool := ${allPassed ? 'true' : 'false'}`,
  ``,
  `/-- The recorded pass count cannot exceed the number of checks run. -/`,
  `theorem gui2lean4_passed_le_total : gui2lean4ChecksPassed ≤ gui2lean4ChecksTotal := by`,
  `  simp [gui2lean4ChecksPassed, gui2lean4ChecksTotal]`,
  ``,
  `theorem gui2lean4_checks_are_recorded : gui2lean4ChecksTotal = ${checks.length} := by rfl`,
  ``,
].join('\n');

// A failed capture is not a proof. Submitting one under the same code path
// is how a red run ends up looking green in the proof service.
if (!allPassed) {
  fs.writeFileSync(path.join(artifactDir, 'submission-response.json'),
    JSON.stringify({ submitted: false, reason: `${passed}/${checks.length} checks passed`, manifest: 'gui2lean4-proof/v1' }, null, 2));
  console.error(`capture finished with ${passed}/${checks.length} checks passed; not submitting a proof`);
  console.log(JSON.stringify({ artifactDir, proofUrl, manifest, submission: null }, null, 2));
  process.exit(2);
}

const form = new FormData();
form.append('body', JSON.stringify({
  prompt: `GUI2Lean4 hosted self-deployment capture ${manifest.capturedAt}; ${passed}/${checks.length} declared checks passed; video and trace are identified by SHA-256 in the attached manifest.`,
  files: {
    'Gui2Lean4Capture.lean': leanWitness,
    'gui2lean4-proof.json': JSON.stringify(manifest, null, 2),
  },
}));
// Without a timeout a hung proof service wedges the capture forever, and the
// server's `running` flag never clears -- every later run then gets a 409.
const response = await fetch(proofUrl, {
  method: 'POST',
  body: form,
  signal: AbortSignal.timeout(Number(process.env.GUI2LEAN4_SUBMIT_TIMEOUT_MS || 30_000)),
});
const responseText = await response.text();
if (!response.ok) throw new Error(`proof submission failed (${response.status}): ${responseText}`);
fs.writeFileSync(path.join(artifactDir, 'submission-response.json'), responseText);
console.log(JSON.stringify({ artifactDir, proofUrl, manifest, submission: JSON.parse(responseText) }, null, 2));
