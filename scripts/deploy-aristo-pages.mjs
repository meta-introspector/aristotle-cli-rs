#!/usr/bin/env node
/**
 * Deploy a public Aristo project snapshot with the service-only Cloudflare
 * credentials loaded by systemd from the sops vault.
 *
 * Deliberate ceiling: this deploys the public HTML snapshot, not private
 * project source.  Upgrade when the Aristo API exposes an authenticated
 * export endpoint and the proof flow has an explicit user consent step.
 */
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const envFile = process.env.GUI2PROOF_RUNTIME_ENV || '/run/gui2proof/cloudflare.env';
const sourceUrl = process.env.GUI2PROOF_ARISTO_PUBLIC_URL ||
  'https://aristotle.harmonic.fun/projects/0f9b0981-1dc9-4321-a46b-53e3cc6ee6e3';
const projectName = process.env.GUI2PROOF_PAGES_PROJECT || 'gui2proof-aristo-test';
const wrangler = process.env.WRANGLER_BIN || path.join(root, 'wrangler');

if (!/^https:\/\/aristotle\.harmonic\.fun\/projects\/[0-9a-f-]+\/?$/i.test(sourceUrl)) {
  throw new Error('source URL must be a public Aristotle project URL');
}
if (!/^[a-z0-9][a-z0-9-]{0,61}[a-z0-9]$/.test(projectName)) throw new Error('invalid Pages project name');
if (!fs.existsSync(envFile)) throw new Error('Cloudflare runtime credentials are not loaded');
for (const line of fs.readFileSync(envFile, 'utf8').split('\n')) {
  const match = line.match(/^([A-Z_][A-Z0-9_]*)=(.*)$/);
  if (match) process.env[match[1]] = match[2];
}
const accountId = process.env.CLOUDFLARE_ACCOUNT_ID;
const token = process.env.CLOUDFLARE_API_TOKEN;
if (!/^[a-f0-9]{32}$/i.test(accountId || '') || !token) throw new Error('Cloudflare runtime credentials are incomplete');

const response = await fetch(sourceUrl, { headers: { accept: 'text/html' } });
if (!response.ok) throw new Error(`Aristo public page fetch failed (${response.status})`);
const html = await response.text();
const tempRoot = fs.mkdtempSync(path.join(os.tmpdir(), 'gui2proof-pages-'));
const site = path.join(tempRoot, 'site');
fs.mkdirSync(site);
fs.writeFileSync(path.join(site, 'index.html'), html, { mode: 0o600 });

const childEnv = { ...process.env, CLOUDFLARE_ACCOUNT_ID: accountId, CLOUDFLARE_API_TOKEN: token };
const run = (args) => execFileSync(wrangler, args, {
  cwd: root,
  env: childEnv,
  encoding: 'utf8',
  stdio: ['ignore', 'pipe', 'pipe'],
  maxBuffer: 4 * 1024 * 1024,
});
try {
  const projects = await fetch(`https://api.cloudflare.com/client/v4/accounts/${accountId}/pages/projects`, {
    headers: { authorization: `Bearer ${token}` },
  });
  if (!projects.ok) throw new Error(`Cloudflare Pages project listing failed (${projects.status})`);
  const listed = await projects.json();
  if (!listed.success) throw new Error('Cloudflare Pages project listing was rejected');
  if (!listed.result.some(p => p.name === projectName)) {
    run(['pages', 'project', 'create', projectName, '--production-branch', 'main']);
  }
  run(['pages', 'deploy', site, '--project-name', projectName, '--branch', 'main',
    '--commit-message', 'GUI2Proof Aristo public snapshot', '--commit-dirty']);
  const updated = await fetch(`https://api.cloudflare.com/client/v4/accounts/${accountId}/pages/projects/${projectName}`, {
    headers: { authorization: `Bearer ${token}` },
  });
  const details = updated.ok ? await updated.json() : { success: false };
  const subdomain = details.result?.subdomain || `${projectName}.pages.dev`;
  console.log(JSON.stringify({ deployed: true, project: projectName, sourceUrl, url: `https://${subdomain}`, bytes: Buffer.byteLength(html) }));
} finally {
  fs.rmSync(tempRoot, { recursive: true, force: true });
}
