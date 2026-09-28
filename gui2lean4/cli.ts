#!/usr/bin/env tsx
/**
 * Generic GUI2Lean4 extractor for hosted proof/evaluation UIs.
 *
 * Configure routes with GUI2LEAN4_ROUTES as a JSON array:
 *   [{"name":"Aristo UI","path":"/aristo/","url":"https://example.test/aristo/","role":"proof UI"}]
 *
 * The command only makes claims about the captured DOM and accessibility
 * properties.  Lean verification is opt-in via GUI2LEAN4_LEAN_FILE.
 */
import fs from 'node:fs';
import path from 'node:path';
import { execFileSync } from 'node:child_process';
import { extractPageA11y, PageA11yTree } from './a11y-extractor.js';

type Route = { name: string; path: string; url: string; role?: string };

function routes(): Route[] {
  const configured = process.env.GUI2LEAN4_ROUTES;
  if (configured) return JSON.parse(configured) as Route[];
  const base = (process.env.GUI2LEAN4_BASE_URL || 'https://aristotle-manager.pages.dev').replace(/\/$/, '');
  const routePath = process.env.GUI2LEAN4_PATH || '/';
  return [{ name: 'Hosted Aristo UI', path: routePath, url: `${base}${routePath}`, role: 'proof UI' }];
}

async function fetchHtml(url: string): Promise<string | null> {
  try {
    const response = await fetch(url, { signal: AbortSignal.timeout(15_000) });
    return response.ok ? await response.text() : null;
  } catch {
    return null;
  }
}

async function main() {
  const targets = routes();
  const results: PageA11yTree[] = [];
  let offline = 0;

  for (const target of targets) {
    const html = await fetchHtml(target.url);
    if (!html) {
      offline++;
      console.log(`${target.path} [OFFLINE] ${target.url}`);
      continue;
    }
    const tree = extractPageA11y(html, target.path);
    results.push(tree);
    const violations = tree.elements.filter(element => !element.a11yCompliant).length;
    console.log(`${target.path} ${tree.elementCount} elements, ${tree.interactiveCount} interactive, ${violations} violations`);
  }

  const totalElements = results.reduce((sum, page) => sum + page.elementCount, 0);
  const totalInteractive = results.reduce((sum, page) => sum + page.interactiveCount, 0);
  const totalCompliant = results.reduce((sum, page) => sum + page.accessibleCount, 0);
  const output = path.resolve(process.cwd(), process.env.GUI2LEAN4_OUTPUT || 'data/gui2lean4-catalog.json');
  fs.mkdirSync(path.dirname(output), { recursive: true });
  fs.writeFileSync(output, JSON.stringify({
    capturedAt: new Date().toISOString(),
    source: targets.map(target => ({ name: target.name, path: target.path, url: target.url, role: target.role })),
    summary: {
      totalPages: results.length,
      offlinePages: offline,
      totalElements,
      totalInteractive,
      totalCompliant,
      complianceRatePct: totalElements ? Math.round(totalCompliant / totalElements * 100) : 100,
    },
    pages: results,
  }, null, 2));
  console.log(`Wrote ${output}`);

  const leanFile = process.env.GUI2LEAN4_LEAN_FILE;
  if (leanFile) {
    execFileSync(process.env.LEAN_BIN || 'lean', [path.resolve(leanFile)], { stdio: 'inherit' });
    console.log(`Lean verification passed: ${leanFile}`);
  }
  if (!results.length) process.exitCode = 1;
}

main().catch(error => {
  console.error(`GUI2LEAN4 failed: ${error instanceof Error ? error.message : String(error)}`);
  process.exitCode = 1;
});
