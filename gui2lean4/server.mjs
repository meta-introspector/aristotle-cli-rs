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
  // Newest by modification time, not by name. Sorting names put
  // `run-vaciu-room-simulation` above every timestamped run ('v' > '2'),
  // so the page showed a September proof as "Latest proof" even though
  // newer runs existed on disk.
  const runs = fs.readdirSync(proofRoot, { withFileTypes: true })
    .filter(e => e.isDirectory() && safeRun(e.name));
  let newest = null, newestAt = -Infinity;
  for (const e of runs) {
    let at;
    try { at = fs.statSync(path.join(proofRoot, e.name)).mtimeMs; }
    catch { continue; }
    if (at > newestAt) { newestAt = at; newest = e.name; }
  }
  return newest;
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
  const types = { '.webm': 'video/webm', '.gif': 'image/gif', '.png': 'image/png', '.zip': 'application/zip', '.json': 'application/json' };
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
  running = { run, startedAt: new Date().toISOString(), pid: child.pid, child };
  // A capture that never exits used to pin `running` for the life of the
  // process, so every later POST /api/run returned 409 forever with nothing
  // on screen to say why. Bound it, and say so in the status.
  const limitMs = Number(process.env.GUI2LEAN4_RUN_TIMEOUT_MS || 15 * 60_000);
  const watchdog = setTimeout(() => {
    try { child.kill('SIGTERM'); } catch { /* already gone */ }
    try { log.write(`\nwatchdog: no exit within ${limitMs}ms; terminated\n`); log.end(); } catch { /* already closed */ }
    running = null;
  }, limitMs);
  if (watchdog.unref) watchdog.unref();
  child.on('close', (code, signal) => {
    clearTimeout(watchdog);
    log.write(`\nexit=${code} signal=${signal || ''}\n`); log.end();
    if (running && running.pid === child.pid) running = null;
  });
  return true;
}

// A capture outliving the server is an orphan holding a browser and a port.
// Take it down with us -- and then actually exit: registering a SIGTERM
// handler replaces node's default terminate, so without the explicit exit
// the server would shrug off `systemctl stop` and keep the port.
for (const sig of ['exit', 'SIGINT', 'SIGTERM']) {
  process.on(sig, () => {
    if (running) {
      try { running.child?.kill('SIGTERM'); } catch { /* already gone */ }
      running = null;
    }
    if (sig !== 'exit') process.exit(0);
  });
}
http.createServer((req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  if (req.method === 'GET' && url.pathname === '/') {
    const body = fs.readFileSync(path.join(root, 'gui2lean4', 'index.html'));
    res.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8', 'Cache-Control': 'no-store' }); return res.end(body);
  }
  if (req.method === 'GET' && url.pathname === '/api/status') {
    // `running` carries the child handle; the UI should never see it. It
    // must stay null when idle -- the page tests truthiness, so an empty
    // object here would read as "capture running…" forever.
    const { child, ...shown } = running || {};
    return json(res, 200, { running: running ? shown : null, latest: manifest(latestRun()) });
  }
  if (req.method === 'POST' && url.pathname === '/api/run') return json(res, startRun() ? 202 : 409, { started: Boolean(running), running });
  const match = url.pathname.match(/^\/artifacts\/([^/]+)\/(.+)$/);
  if (req.method === 'GET' && match) return artifact(res, decodeURIComponent(match[1]), decodeURIComponent(match[2]));
  res.writeHead(404).end('not found');
}).listen(port, '127.0.0.1', () => console.log(`GUI2Proof listening on 127.0.0.1:${port}`));
