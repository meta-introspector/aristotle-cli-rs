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

## Browser-rendered capture and proof submission

Install the Node browser dependency and Chromium once:

```bash
npm install --prefix gui2lean4
npx --prefix gui2lean4 playwright install chromium
```

Run the self-deployment workflow with Playwright:

```bash
GUI2LEAN4_BASE_URL=https://aristotle-manager.pages.dev \
  GUI2LEAN4_PROOF_URL=http://127.0.0.1:9876/api/v3/project \
  node gui2lean4/capture-proof.mjs
```

The workflow records a WebM video, screenshots, a Playwright trace, and a
redacted manifest, then posts the manifest and a Lean witness to the local
Aristo proof service. The proof service checks only `.lean` attachments;
metadata and media are evidence artifacts, not executable source.

For VNC or an interactive browser, use the same route and artifact settings
with a headed Playwright context; never record API keys, cookies, local
storage, or authorization headers.

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
