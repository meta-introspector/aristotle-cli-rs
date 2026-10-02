#!/usr/bin/env node
/**
 * Simulate the vaciu room workflow without consuming a user-provided pass.
 *
 * IMPORTANT — this produces a SIMULATION, not proof of a browser-side post.
 * The public relay does not send CORS headers, so a browser cannot complete the
 * POST itself. We therefore intercept the page's `/room/**` request to capture
 * the line the GUI constructed, fulfill it locally so the page renders its
 * normal success state, and then issue the real POST from Node. Every artifact
 * this script writes is labelled `simulated: true` and `browserPosted: false`.
 * Do not cite these artifacts as evidence that the GUI performed the post.
 */
import fs from 'node:fs';
import path from 'node:path';
import { createRequire } from 'node:module';
import { fileURLToPath } from 'node:url';

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..');
const dryRun = process.env.VACIU_DRY_RUN !== '0';
const link = process.env.VACIU_TEST_URL;
const relayUrl =
  process.env.VACIU_RELAY_URL ??
  'https://solana.solfunmeme.com/relay/room/89e3c2a8499c476bab2c49ba106910d0a1406ddb959d47d1c468a7df250df2f6';
const roomId = process.env.VACIU_ROOM_ID ?? new URL(relayUrl).pathname.split('/').pop();

if (!dryRun && !link) {
  throw new Error('real vaciu test requires VACIU_TEST_URL; refusing to read or reuse a pass file');
}

const outDir = path.join(root, 'data', 'gui2lean4', 'proofs', 'run-vaciu-room-simulation');
fs.mkdirSync(outDir, { recursive: true });

/** Strip anything URL-shaped (invite links carry the pass in the fragment). */
const redact = text => String(text).replace(/https?:\/\/\S+/g, '[redacted-url]');

const writeResult = payload => {
  const result = { simulated: true, browserPosted: false, ...payload };
  fs.writeFileSync(path.join(outDir, 'result.json'), JSON.stringify(result, null, 2));
  return result;
};

async function main() {
  const require = createRequire(import.meta.url);
  const { chromium } = require(path.join(root, 'gui2lean4', 'node_modules', 'playwright'));
  const browser = await chromium.launch({ headless: true });
  const page = await browser.newPage({ viewport: { width: 1280, height: 900 } });
  let capturedLine = null;

  try {
    await page.route('**/room/**', async route => {
      if (route.request().method() === 'POST') capturedLine = route.request().postData();
      // Let the page render its normal success state; the real witnessed line is
      // posted below from Node because the public relay does not allow browser CORS.
      await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ cursor: 0 }) });
    });

    await page.goto(link || 'https://kant-zk-pastebin.pages.dev/paste.html', {
      waitUntil: 'networkidle',
      timeout: 30_000,
    });
    await page.waitForTimeout(2_000);

    if (dryRun) {
      await page.locator('#text').fill('vaciu dry-run: GUI flow rendered without consuming a room pass.');
      await page.screenshot({ path: path.join(outDir, 'vaciu-room-dry-run.png'), fullPage: true });
      const result = writeResult({
        dryRun: true,
        postAttempted: false,
        redaction: 'No pass was loaded or sent.',
      });
      console.log(JSON.stringify({ ...result, artifactDir: outDir }, null, 2));
      return;
    }

    if (await page.locator('#post').isDisabled()) {
      await page.locator('#joinbox').fill(link);
      await page.locator('#join').click();
      try {
        await page.waitForFunction(() => !document.querySelector('#post')?.disabled, null, { timeout: 30_000 });
      } catch {
        const log = redact(await page.locator('#log').innerText().catch(() => ''));
        throw new Error(`vaciu join failed: ${log}`);
      }
    }

    const text =
      'vaciu simulation: GUI2Proof verified the sops-backed Aristo Pages deployment; this is the one permitted room post.';
    await page.locator('#text').fill(text);
    await page.locator('#post').click();
    await new Promise(resolve => setTimeout(resolve, 500));
    if (!capturedLine) throw new Error('vaciu GUI did not construct a kzchat line');

    const pass = link.split('#', 2)[1];
    if (!pass) throw new Error('VACIU_TEST_URL carries no pass fragment');
    const response = await fetch(relayUrl, {
      method: 'POST',
      headers: { 'content-type': 'text/plain', 'x-kant-pass': pass },
      body: capturedLine,
    });
    if (!response.ok) throw new Error(`vaciu relay refused (${response.status})`);
    const body = await response.json().catch(() => ({}));

    await page.evaluate(out => {
      const d = document.createElement('div');
      d.textContent = `relay accepted (cursor ${out.cursor})`;
      d.className = 'ok';
      document.querySelector('#log').prepend(d);
    }, body);
    await page.waitForFunction(
      () => [...document.querySelectorAll('#log div')].some(e => /posted \(cursor/.test(e.textContent)),
      null,
      { timeout: 5_000 },
    );

    await page.screenshot({ path: path.join(outDir, 'vaciu-room-simulated-post.png'), fullPage: true });
    const result = writeResult({
      dryRun: false,
      postAttempted: true,
      postedFrom: 'node',
      corsBlockedInBrowser: true,
      room: roomId,
      relay: redact(relayUrl),
      log: redact(await page.locator('#log').innerText()),
      redaction: 'pass link omitted',
    });
    console.log(JSON.stringify({ ...result, artifactDir: outDir }, null, 2));
  } finally {
    await browser.close();
  }
}

await main();