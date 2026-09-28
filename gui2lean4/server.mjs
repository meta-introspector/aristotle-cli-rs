#!/usr/bin/env node
import http from 'node:http';
import fs from 'node:fs';
import path from 'node:path';
import { spawn } from 'node:child_process';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const proofRoot = path.resolve(process.env.GUI2LEAN4_ARTIFACT_ROOT || path.join(root, 'data', 'gui2lean4', 'proofs'));
const capture = path.join(root, 'gui2lean4', 'capture-proof.mjs');
const port = Number(process.env.GUI2LEAN4_PORT || 9890);
let running = null;
fs.mkdirSync(proofRoot, { recursive: true });

const safeRun = name => /^run-[A-Za-z0-9_-]+$/.test(name) ? name : null;
function latestRun() {
  return fs.readdirSync(proofRoot, { withFileTypes: true }).filter(e => e.isDirectory() && safeRun(e.name)).map(e => e.name).sort().reverse()[0] || null;
}
function manifest(run) {
  if (!run) return null;
  try { return { run, ...JSON.parse(fs.readFileSync(path.join(proofRoot, run, 'proof-manifest.json'), 'utf8')) }; } catch { return { run }; }
}
function json(res, status, value) {
  const body = JSON.stringify(value, null, 2);
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8', 'Content-Length': Buffer.byteLength(body), 'Cache-Control': 'no-store' });
  res.end(body);
}
function artifact(res, run, file) {
  if (!safeRun(run) || file.includes('..') || file.includes('/') || file.includes('\\')) return res.writeHead(404).end();
  const full = path.join(proofRoot, run, file);
  if (!fs.existsSync(full) || !fs.statSync(full).isFile()) return res.writeHead(404).end();
  const types = { '.webm': 'video/webm', '.png': 'image/png', '.zip': 'application/zip', '.json': 'application/json' };
  res.writeHead(200, { 'Content-Type': types[path.extname(file)] || 'application/octet-stream', 'Content-Length': fs.statSync(full).size, 'Cache-Control': 'no-store' });
  fs.createReadStream(full).pipe(res);
}
function startRun() {
  if (running) return false;
  const run = `run-${new Date().toISOString().replace(/[^0-9A-Za-z]+/g, '-')}`;
  const dir = path.join(proofRoot, run);
  fs.mkdirSync(dir, { recursive: true });
  const log = fs.createWriteStream(path.join(dir, 'capture.log'));
  const child = spawn(process.env.NODE_BIN || 'node', [capture], { cwd: root, env: { ...process.env, GUI2LEAN4_ARTIFACT_DIR: dir, GUI2LEAN4_PROOF_URL: process.env.GUI2LEAN4_PROOF_URL || 'http://127.0.0.1:9876/api/v3/project' }, stdio: ['ignore', 'pipe', 'pipe'] });
  child.stdout.pipe(log); child.stderr.pipe(log);
  running = { run, startedAt: new Date().toISOString(), pid: child.pid };
  child.on('close', (code, signal) => { log.write(`\nexit=${code} signal=${signal || ''}\n`); log.end(); running = null; });
  return true;
}
http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  if (req.method === 'GET' && url.pathname === '/') {
    const body = fs.readFileSync(path.join(root, 'gui2lean4', 'index.html'));
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-store' }); return res.end(body);
  }
  if (req.method === 'GET' && url.pathname === '/api/status') return json(res, 200, { running, latest: manifest(latestRun()) });
  if (req.method === 'POST' && url.pathname === '/api/run') return json(res, startRun() ? 202 : 409, { started: Boolean(running), running });
  const match = url.pathname.match(/^\/artifacts\/([^/]+)\/(.+)$/);
  if (req.method === 'GET' && match) return artifact(res, decodeURIComponent(match[1]), decodeURIComponent(match[2]));
  res.writeHead(404).end('not found');
}).listen(port, '127.0.0.1', () => console.log(`GUI2Proof listening on 127.0.0.1:${port}`));
