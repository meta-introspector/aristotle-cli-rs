#!/usr/bin/env node
/**
 * Exchange a one-time Cloudflare bootstrap token for a narrowly scoped,
 * account-owned Pages token used by the systemd deployment service.
 *
 * The bootstrap token is supplied only through CF_BOOTSTRAP_TOKEN and is
 * never written, printed, or included in proof artifacts.
 */
import fs from 'node:fs';
import os from 'node:os';
import path from 'node:path';

const accountId = process.env.CLOUDFLARE_ACCOUNT_ID || process.argv[2];
const bootstrap = process.env.CF_BOOTSTRAP_TOKEN;
const output = process.env.GUI2PROOF_CLOUDFLARE_ENV ||
  path.join(os.homedir(), '.config', 'gui2proof', 'cloudflare.env');
if (!accountId || !/^[a-f0-9]{32}$/i.test(accountId)) throw new Error('CLOUDFLARE_ACCOUNT_ID must be a 32-character account ID');
if (!bootstrap) throw new Error('CF_BOOTSTRAP_TOKEN is required');

const api = 'https://api.cloudflare.com/client/v4';
const headers = { Authorization: `Bearer ${bootstrap}`, 'Content-Type': 'application/json' };
async function request(url, options = {}) {
  const response = await fetch(url, { ...options, headers: { ...headers, ...(options.headers || {}) } });
  const body = await response.json().catch(() => ({}));
  if (!response.ok || body.success === false) {
    throw new Error(`Cloudflare API request failed (${response.status})`);
  }
  return body.result;
}

const groups = await request(`${api}/accounts/${accountId}/tokens/permission_groups`);
const pagesWrite = (Array.isArray(groups) ? groups : []).find(group =>
  group.name === 'Pages Write' && (group.scopes || []).includes('com.cloudflare.api.account'));
if (!pagesWrite?.id) throw new Error('Cloudflare Pages Write permission group was not available');

const expires = new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString();
const token = await request(`${api}/accounts/${accountId}/tokens`, {
  method: 'POST',
  body: JSON.stringify({
    name: 'gui2proof-pages-deploy',
    policies: [{
      effect: 'allow',
      permission_groups: [{ id: pagesWrite.id, meta: {} }],
      resources: { [`com.cloudflare.api.account.${accountId}`]: '*' },
    }],
    expires_on: expires,
  }),
});
if (!token?.value) throw new Error('Cloudflare did not return the new token value');

fs.mkdirSync(path.dirname(output), { recursive: true, mode: 0o700 });
const temp = `${output}.tmp-${process.pid}`;
fs.writeFileSync(temp, `CLOUDFLARE_ACCOUNT_ID=${accountId}\nCLOUDFLARE_API_TOKEN=${token.value}\n`, { mode: 0o600 });
fs.renameSync(temp, output);
console.log(JSON.stringify({
  stored: output,
  tokenId: token.id,
  expiresOn: token.expires_on || expires,
  permissions: ['Pages Write'],
}, null, 2));
