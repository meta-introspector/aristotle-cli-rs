#!/usr/bin/env node
/** Load one sops/age vault value into a root-created, service-only env file. */
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';
import { execFileSync, spawnSync } from 'node:child_process';

const vaultDir = process.env.TRACKER_VAULT_DIR || '/etc/tracker-vault';
const secretName = process.env.GUI2PROOF_CLOUDFLARE_SECRET || 'cloudflare-pages-token';
const output = process.env.GUI2PROOF_RUNTIME_ENV || '/run/gui2proof/cloudflare.env';
if (!/^[A-Za-z0-9][A-Za-z0-9._-]{0,63}$/.test(secretName)) throw new Error('invalid vault secret name');
const source = path.join(vaultDir, 'secrets', `${secretName}.enc.json`);
if (!fs.existsSync(source)) {
  try { fs.unlinkSync(output); } catch { /* optional until bootstrap is complete */ }
  process.exit(0);
}
const sops = process.env.SOPS_BIN || 'sops';
const result = spawnSync(sops, ['-d', '--output-type', 'json', source], {
  env: { ...process.env, SOPS_AGE_KEY_FILE: path.join(vaultDir, 'vault.key'), SOPS_AGE_RECIPIENTS_FILE: path.join(vaultDir, 'vault.pub') },
  encoding: 'utf8', maxBuffer: 1 << 20,
});
if (result.status !== 0) throw new Error(`sops decrypt failed (${result.status})`);
const value = JSON.parse(result.stdout).value;
if (typeof value !== 'string' || !value) throw new Error('vault secret has no string value');
const uid = Number(execFileSync('id', ['-u', 'mdupont'], { encoding: 'utf8' }).trim());
const gid = Number(execFileSync('id', ['-g', 'mdupont'], { encoding: 'utf8' }).trim());
fs.mkdirSync(path.dirname(output), { recursive: true, mode: 0o755 });
const temp = `${output}.tmp-${process.pid}`;
fs.writeFileSync(temp, `CLOUDFLARE_API_TOKEN=${value}\n`, { mode: 0o600 });
fs.chownSync(temp, uid, gid);
fs.renameSync(temp, output);
