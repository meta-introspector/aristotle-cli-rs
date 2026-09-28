#!/usr/bin/env node
import fs from 'node:fs';

const envFile = process.env.GUI2PROOF_RUNTIME_ENV || '/run/gui2proof/cloudflare.env';
try {
  for (const line of fs.readFileSync(envFile, 'utf8').split('\n')) {
    const match = line.match(/^([A-Z_][A-Z0-9_]*)=(.*)$/);
    if (match) process.env[match[1]] = match[2];
  }
} catch { /* optional until the vault secret is provisioned */ }
await import('../gui2lean4/server.mjs');
