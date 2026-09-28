#!/usr/bin/env python3
"""Render configured GUI routes with Chromium and export a DOM/a11y capture.

Set GUI2LEAN4_ROUTES to a JSON array of {name, path, url, role} objects.
The default captures the production Aristo Pages UI. This renderer is
headless by default; a Playwright/VNC session can consume the same route file
and preserve the recording separately.
"""
import asyncio
import json
import os
import shutil
import time
from pathlib import Path
from pyppeteer import launch

DEFAULT_ROUTE = {"name": "Hosted Aristo UI", "path": "/", "url": "https://aristotle-manager.pages.dev/", "role": "proof UI"}

DOM_EXTRACTOR = r"""() => {
  const roleFor = el => el.getAttribute('role') || ({header:'banner',nav:'navigation',main:'main',section:'region',button:'button',a:'link',h1:'heading',h2:'heading',h3:'heading'}[el.tagName.toLowerCase()] || 'generic');
  const nameFor = el => {
    const labelled = el.getAttribute('aria-label');
    if (labelled) return labelled.trim();
    const labelledBy = el.getAttribute('aria-labelledby');
    if (labelledBy) return (document.getElementById(labelledBy)?.textContent || '').replace(/\s+/g, ' ').trim().slice(0, 100);
    if (el.getAttribute('title')) return el.getAttribute('title').trim();
    if (el.tagName.toLowerCase() === 'img' && el.getAttribute('alt')) return el.getAttribute('alt').trim();
    if (el.getAttribute('placeholder')) return el.getAttribute('placeholder').trim();
    return (el.textContent || '').replace(/\s+/g, ' ').trim().slice(0, 100);
  };
  const elements = [];
  document.querySelectorAll('*').forEach(el => {
    const tag = el.tagName.toLowerCase();
    const role = roleFor(el);
    const accessibleName = nameFor(el);
    const interactive = ['button','a','input','select','textarea'].includes(tag) || ['button','link'].includes(role);
    if (interactive || ['banner','navigation','main','region','heading'].includes(role)) {
      elements.push({id: el.id || `${tag}-${elements.length}`, tag, role, accessibleName,
        renderedText: (el.textContent || '').replace(/\s+/g, ' ').trim().slice(0, 120),
        isInteractive: interactive, hasAccessibleLabel: accessibleName.length > 0,
        a11yCompliant: !interactive || accessibleName.length > 0});
    }
  });
  return {title: document.title, elementCount: elements.length,
    interactiveCount: elements.filter(e => e.isInteractive).length, elements: elements.slice(0, 500)};
}"""


def configured_routes():
    raw = os.environ.get("GUI2LEAN4_ROUTES")
    if raw:
        return json.loads(raw)
    base = os.environ.get("GUI2LEAN4_BASE_URL", "https://aristotle-manager.pages.dev").rstrip("/")
    route = os.environ.get("GUI2LEAN4_PATH", "/")
    return [{**DEFAULT_ROUTE, "path": route, "url": f"{base}{route}"}]


async def main():
    executable = shutil.which("chromium") or shutil.which("google-chrome") or "/usr/bin/google-chrome-stable"
    browser = await launch(executablePath=executable, headless=True, args=[
        "--no-sandbox", "--disable-setuid-sandbox", "--disable-dev-shm-usage", "--disable-gpu"
    ], handleSIGINT=False, handleSIGTERM=False, handleSIGHUP=False)
    pages = []
    for route in configured_routes():
        page = await browser.newPage()
        try:
            await page.goto(route["url"], {"waitUntil": "networkidle2", "timeout": 30_000})
            await asyncio.sleep(float(os.environ.get("GUI2LEAN4_SETTLE_SECONDS", "1")))
            data = await page.evaluate(DOM_EXTRACTOR)
            data.update({"name": route.get("name", route["path"]), "path": route["path"], "url": route["url"], "role": route.get("role", "")})
            pages.append(data)
            print(f"{route['path']} {data['elementCount']} elements, {data['interactiveCount']} interactive")
        except Exception as error:
            print(f"{route['path']} [ERROR: {error}]")
        finally:
            await page.close()
    await browser.close()

    output = Path(os.environ.get("GUI2LEAN4_RENDER_OUTPUT", "data/gui2lean4-rendered.json"))
    output.parent.mkdir(parents=True, exist_ok=True)
    elements = sum(page.get("elementCount", 0) for page in pages)
    interactive = sum(page.get("interactiveCount", 0) for page in pages)
    compliant = sum(sum(1 for item in page.get("elements", []) if item.get("a11yCompliant", True)) for page in pages)
    with output.open("w", encoding="utf-8") as stream:
        json.dump({"capturedAt": int(time.time() * 1000), "engine": "Chromium DOM/a11y renderer",
                   "summary": {"totalPages": len(pages), "totalElements": elements,
                                "totalInteractive": interactive, "totalCompliant": compliant},
                   "pages": pages}, stream, indent=2)
    print(f"Wrote {output}")


if __name__ == "__main__":
    asyncio.run(main())
