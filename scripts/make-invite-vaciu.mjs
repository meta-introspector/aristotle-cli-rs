#!/usr/bin/env node
/** Mint a fresh limited Kant pass locally; never posts or prints the source pass. */
import fs from 'node:fs/promises';
import os from 'node:os';
import path from 'node:path';
import { fileURLToPath } from 'node:url';

const name = process.argv[2] || 'vaciu';
const limit = Number(process.argv[3] || 1);
if (name !== 'vaciu') throw new Error('usage: make-invite-vaciu vaciu 1');
if (!Number.isInteger(limit) || limit < 1 || limit > 1000) throw new Error('limit must be an integer from 1 to 1000');

const dir = await fs.mkdtemp(path.join(os.tmpdir(), 'kant-pass-'));
try {
  const base = 'https://kant-zk-pastebin.pages.dev';
  for (const file of ['kant-pass.mjs', 'kant-net.mjs', 'kantzk.mjs', 'kant-diag.mjs']) {
    const response = await fetch(`${base}/${file}`);
    if (!response.ok) throw new Error(`failed to load ${file} (${response.status})`);
    await fs.writeFile(path.join(dir, file), await response.text(), { mode: 0o600 });
  }
  const P = await import(`${pathToFileURL(path.join(dir, 'kant-pass.mjs'))}`);
  const K = await import(`${pathToFileURL(path.join(dir, 'kantzk.mjs'))}`);
  let input = '';
  if (process.stdin.isTTY) {
    process.stderr.write('Paste the current invite/pass, then press Ctrl-D:\n');
  }
  input = (await new Promise(resolve => {
    let value = '';
    process.stdin.setEncoding('utf8');
    process.stdin.on('data', chunk => { value += chunk; });
    process.stdin.on('end', () => resolve(value.trim()));
  }));
  const share = K.parseShareUrl(input);
  const code = share ? K.envelopeEncode(share) : input;
  const invite = P.pastePass(code);
  if (!invite || !invite.secret) throw new Error('invalid Kant invite/pass');
  const fresh = P.mintPass(invite, limit);
  console.log(P.passUrl(`${base}/paste.html`, fresh));
} finally {
  await fs.rm(dir, { recursive: true, force: true });
}

function pathToFileURL(file) {
  return new URL(`file://${file}`).href;
}
