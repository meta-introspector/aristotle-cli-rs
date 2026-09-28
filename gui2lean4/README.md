# GUI2Lean4

Reusable browser-to-evidence extraction for Aristo and other proof UIs.
This is the generic portion extracted from the Twitterstorm Gui2Lean4 work;
Twitterstorm routes, telemetry names, theorem names, and hard-coded ports are
not part of this implementation.

## Static capture

Requires Node with `tsx` available:

```bash
GUI2LEAN4_BASE_URL=https://aristotle-manager.pages.dev \
  npx tsx gui2lean4/cli.ts
```

Use multiple routes with a JSON configuration:

```bash
export GUI2LEAN4_ROUTES='[
  {"name":"Aristo UI","path":"/","url":"https://aristotle-manager.pages.dev/","role":"proof UI"},
  {"name":"Local UI","path":"/aristo/","url":"https://solana.solfunmeme.com/aristo/","role":"proof UI"}
]'
npx tsx gui2lean4/cli.ts
```

The output is `data/gui2lean4-catalog.json`. It records captured DOM
accessibility properties and reports violations; it does not claim that the
UI values are mathematically true.

## Browser-rendered capture

With Chromium and Pyppeteer installed:

```bash
GUI2LEAN4_BASE_URL=https://aristotle-manager.pages.dev \
  python3 gui2lean4/render-a11y.py
```

The rendered capture is written to `data/gui2lean4-rendered.json`. A future
Playwright/VNC recorder should use the same `GUI2LEAN4_ROUTES` file and save
video, screenshots, browser trace, and the JSON capture as one proof bundle.

## Optional Lean verification

The extractor can compile an explicitly selected Lean file after capture:

```bash
GUI2LEAN4_LEAN_FILE=path/to/Gui2Lean4.lean \
  npx tsx gui2lean4/cli.ts
```

No Twitterstorm-specific Lean theorem is implicitly selected.

## Redaction

Do not record API keys, cookies, authorization headers, browser local storage,
or private Cloudflare values in catalogs, screenshots, videos, or traces.
