#!/usr/bin/env node
/** Encrypt the two existing ~/.cloudflare* accounts into the tracker vault. */
import crypto from 'node:crypto';
import fs from 'node:fs';
import path from 'node:path';
import { spawnSync } from 'node:child_process';

if (process.getuid?.() !== 0) throw new Error('run as root so /etc/tracker-vault can be written');
const home = process.env.CLOUDFLARE_HOME || '/home/mdupont';
const vault = process.env.TRACKER_VAULT_DIR || '/etc/tracker-vault';
const outDir = path.join(vault, 'secrets');
const recipientText = fs.readFileSync(path.join(vault, 'vault.pub'), 'utf8');
const recipient = recipientText.match(/age1[0-9a-z]{20,}/i)?.[0];
if (!recipient) throw new Error('no age recipient in vault.pub');

const accounts = [
  { name: 'cloudflare-account-0', id: path.join(home, '.cloudflare-account.id'), token: path.join(home, '.cloudflare') },
  { name: 'cloudflare-account-1', id: path.join(home, '.cloudflare-credentials', 'odd-thunder-678a-account.id'), token: path.join(home, '.cloudflare-credentials', 'odd-thunder-678a-api.token') },
];
fs.mkdirSync(outDir, { recursive: true, mode: 0o700 });
function encrypt(name, value) {
  const plain = `/dev/shm/gui2proof-${crypto.randomBytes(8).toString('hex')}.json`;
  const target = path.join(outDir, `${name}.enc.json`);
  const temp = `${target}.tmp-${process.pid}`;
  try {
    fs.writeFileSync(plain, JSON.stringify({ value: value.trim(), updated: new Date().toISOString(), by: 'home-cloudflare-import' }), { mode: 0o600 });
    const run = spawnSync('sops', ['-e', '--input-type', 'json', '--age', recipient, plain], { encoding: 'utf8', maxBuffer: 1 << 20 });
    if (run.status !== 0) throw new Error(`sops failed for ${name}`);
    fs.writeFileSync(temp, run.stdout, { mode: 0o600 });
    fs.renameSync(temp, target);
  } finally {
    try { fs.unlinkSync(plain); } catch {}
    try { fs.unlinkSync(temp); } catch {}
  }
}
for (const account of accounts) {
  if (!fs.existsSync(account.id) || !fs.existsSync(account.token)) throw new Error(`missing files for ${account.name}`);
  encrypt(`${account.name}-id`, fs.readFileSync(account.id, 'utf8'));
  encrypt(`${account.name}-token`, fs.readFileSync(account.token, 'utf8'));
}
// Account 0 is the configured Pages account used by GUI2Proof.
encrypt('cloudflare-pages-token', fs.readFileSync(accounts[0].token, 'utf8'));
console.log(JSON.stringify({ imported: accounts.map(a => a.name), pagesSecret: 'cloudflare-pages-token' }, null, 2));
