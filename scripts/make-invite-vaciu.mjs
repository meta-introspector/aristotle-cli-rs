#!/usr/bin/env node
/**
 * Mint a fresh limited Kant pass locally; never posts or prints the source pass.
 *
 * By default this imports the pinned copies of the Kant helpers that live
 * alongside this script. It will NOT fetch and execute code from a remote host:
 * anyone able to write to that host would otherwise get arbitrary code
 * execution on the operator's machine, with the operator's pass on stdin.
 *
 * Set KANT_FETCH_REMOTE=1 to fall back to fetching the helpers from the
 * published Pages site. Only do that if you trust the deployment and have
 * reviewed what you are about to import.
 */
import path from 'node:path';
import { fileURLToPath, pathToFileURL } from 'node:url';

const here = path.dirname(fileURLToPath(import.meta.url));
const helpers = ['kant-pass.mjs', 'kant-net.mjs', 'kantzk.mjs', 'kant-diag.mjs'];
const fetchRemote = process.env.KANT_FETCH_REMOTE === '1';

const name = process.argv[2] || 'vaciu';
const limit = Number(process.argv[3] || 1);
if (name !== 'vaciu') throw new Error('usage: make-invite-vaciu vaciu 1');
if (!Number.isInteger(limit) || limit < 1 || limit > 1000) {
  throw new Error('limit must be an integer from 1 to 1000');
}

let dir = here;
let cleanup = () => {};
if (fetchRemote) {
  const fs = await import('node:fs/promises');
  const os = await import('node:os');
  const base = 'https://kant-zk-pastebin.pages.dev';
  process.stderr.write(`WARNING: importing remote code from ${base}\n`);
  dir = await fs.mkdtemp(path.join(os.tmpdir(), 'kant-pass-'));
  cleanup = () => fs.rm(dir, { recursive: true, force: true });
  for (const file of helpers) {
    const response = await fetch(`${base}/${file}`);
    if (!response.ok) throw new Error(`failed to load ${file} (${response.status})`);
    await fs.writeFile(path.join(dir, file), await response.text(), { mode: 0o600 });
  }
}

try {
  const P = await import(pathToFileURL(path.join(dir, 'kant-pass.mjs')).href);
  const K = await import(pathToFileURL(path.join(dir, 'kantzk.mjs')).href);

  let input = '';
  if (process.stdin.isTTY) {
    process.stderr.write('Paste the current invite/pass, then press Ctrl-D:\n');
  }
  input = await new Promise(resolve => {
    let value = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', chunk => {
      value += chunk;
    });
    process.stdin.on('end', () => resolve(value.trim()));
  });

  const share = K.parseShareUrl(input);
  const code = share ? K.envelopeEncode(share) : input;
  const invite = P.pastePass(code);
  if (!invite || !invite.secret) throw new Error('invalid Kant invite/pass');
  const fresh = P.mintPass(invite, limit);
  // The solana proxy currently emits duplicate CORS headers in some paths;
  // use the Cloudflare relay twin for browser-postable passes by default.
  fresh.relay = process.env.KANT_RELAY || 'https://kant-zk-relay.jmikedupont2.workers.dev';
  const base = 'https://kant-zk-pastebin.pages.dev';
  console.log(P.passUrl(`${base}/paste.html`, fresh));
} finally {
  await cleanup();
}