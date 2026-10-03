#!/usr/bin/env node
/**
 * GUI2Proof invite test — drives the kant chat UI in a real browser against
 * the relay origin named in the invite (arg 1 = invite-url file).
 * Usage: node guiproof-invite.mjs /tmp/kant-invite-local.txt
 */
import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';

const inviteFile = process.argv[2];
if (!inviteFile) { console.error('usage: guiproof-invite.mjs <invite-url-file>'); process.exit(2); }
const inviteUrl = fs.readFileSync(inviteFile, 'utf8').trim();
const base = new URL(inviteUrl).origin;
const outDir = process.env.GUI2PROOF_ARTIFACT_DIR
  || `/mnt/data1/time-2026/05-may/07/arist/data/gui2lean4/invite-${Date.now()}`;
fs.mkdirSync(outDir, { recursive: true });

const require = createRequire(import.meta.url);
const { chromium } = require(path.join('/mnt/data1/time-2026/05-may/07/arist/gui2lean4', 'node_modules', 'playwright'));

const browser = await chromium.launch({ headless: true });
const page = await browser.newPage({ viewport: { width: 1280, height: 900 } });
const consoleLog = [];
page.on('console', m => consoleLog.push(`${m.type()}: ${m.text()}`));
page.on('pageerror', e => consoleLog.push(`pageerror: ${e.message}`));

const checks = [];
const check = (name, ok, extra = {}) => { checks.push({ name, ok, ...extra }); console.log(`${ok ? 'PASS' : 'FAIL'} ${name}${extra.detail ? ' — ' + extra.detail : ''}`); };

try {
  // NB: the app holds a WebSocket + polls, so networkidle never fires.
  await page.goto(inviteUrl, { waitUntil: 'domcontentloaded', timeout: 30_000 });
  await page.waitForTimeout(2_500);
  check('page-opened', (await page.title()).includes('Kant'), { detail: await page.title() });
  await page.screenshot({ path: path.join(outDir, '01-opened.png'), fullPage: true });

  // The invite in the hash walks straight into the room; else paste it manually.
  const chatVisible = await page.locator('#s-chat section.on, section#s-chat.on').count()
    || await page.locator('#say').isVisible().catch(() => false);
  if (!chatVisible) {
    await page.locator('#joinbox').fill(inviteUrl);
    await page.locator('#btn-dojoin').click();
    await page.waitForTimeout(1_500);
  }
  const inRoom = await page.locator('#say').isVisible().catch(() => false);
  check('joined-room', inRoom);
  await page.screenshot({ path: path.join(outDir, '02-joined.png'), fullPage: true });

  if (inRoom) {
    const text = `gui2proof invite test ${new Date().toISOString()} (${base})`;
    await page.locator('#say').fill(text);
    await page.locator('#btn-send').click();
    await page.waitForTimeout(2_000);
    const chat = await page.locator('#chat').innerText().catch(() => '');
    check('gui-post-accepted', chat.includes('gui2proof invite test'), { detail: chat.slice(0, 120) });
    await page.screenshot({ path: path.join(outDir, '03-posted.png'), fullPage: true });
  }

  fs.writeFileSync(path.join(outDir, 'result.json'), JSON.stringify({
    base, checks, console: consoleLog.slice(-20), at: new Date().toISOString(),
  }, null, 2));
} finally {
  await browser.close();
}
const allOk = checks.every(c => c.ok);
console.log(allOk ? 'ALL CHECKS PASSED' : 'SOME CHECKS FAILED');
process.exit(allOk ? 0 : 1);
