/-
# The page

The UI and the single self-contained HTML file it lives in: settings, the
dropped bundle, the selection table and preview, the plan, the tokens, the
run and the log — with every module it needs inlined, so the page has no
external reference of any kind.
-/
import RequestProject.Edge.Cf.Site.PageConfig

namespace CfDeploy
namespace Site

/-! ## The page -/

/-- The first part of the UI: the log console, the settings panel, the
credential, and reading the bundle that was dropped on the page. -/
def uiTopJs : String :=
r##"// ------------------------------------------------------------------ the UI
const $ = (id) => document.getElementById(id);

const EVENTS = [];
function render() {
  const min = LEVELS[$('level').value];
  const frag = document.createDocumentFragment();
  let shown = 0;
  for (const ev of EVENTS) {
    if (LEVELS[ev.level] < min) continue;
    shown++;
    const div = document.createElement('div');
    div.className = 'l-' + (ev.kind === 'step-ok' || ev.kind === 'mint-ok' ? 'ok' : ev.level);
    div.textContent = formatEvent(ev);
    frag.appendChild(div);
  }
  const log = $('log');
  log.replaceChildren(frag);
  const errs = EVENTS.filter((e) => e.level === 'error').length;
  const warns = EVENTS.filter((e) => e.level === 'warn').length;
  $('counts').textContent = `${EVENTS.length} events · ${shown} shown · ${warns} warn · ${errs} error`;
  if ($('follow').checked) log.scrollTop = log.scrollHeight;
}
const push = (ev) => { EVENTS.push(ev); render(); };
const say = (level, kind, msg, fields = {}) =>
  push({ t: new Date().toISOString(), level, kind, msg, ...fields });
const setState = (s) => { $('state').textContent = s; };

$('level').addEventListener('change', render);
$('clear').addEventListener('click', () => { EVENTS.length = 0; render(); say('info', 'log', 'log cleared'); });
$('copy').addEventListener('click', async () => {
  try {
    await navigator.clipboard.writeText(EVENTS.map(formatEvent).join('\n'));
    say('info', 'log', 'log copied to the clipboard');
  } catch (e) {
    say('warn', 'log', 'could not copy: ' + e.message);
  }
});
const download = (name, data, type) => {
  const url = URL.createObjectURL(new Blob([data], { type }));
  const a = document.createElement('a');
  a.href = url; a.download = name; a.click();
  URL.revokeObjectURL(url);
  say('info', 'log', 'wrote ' + name);
};
$('save').addEventListener('click', () =>
  download('cfdeploy.log', EVENTS.map(formatEvent).join('\n') + '\n', 'text/plain'));
$('savejson').addEventListener('click', () =>
  download('cfdeploy-log.json', JSON.stringify(EVENTS, null, 2) + '\n', 'application/json'));

window.addEventListener('error', (e) =>
  say('error', 'window', 'uncaught error: ' + (e.message ?? e)));
window.addEventListener('unhandledrejection', (e) =>
  say('error', 'window', 'unhandled rejection: ' +
    ((e.reason && e.reason.message) || String(e.reason))));

say('info', 'page', 'cfdeploy, self-contained: this page carries the whole tool', {
  build: typeof CFDEPLOY_BUILD === 'undefined' ? '(unstamped)' : CFDEPLOY_BUILD,
  url: typeof location === 'undefined' ? '(none)' : location.href,
});
if ($('build')) $('build').textContent = CFDEPLOY_BUILD;

// ------------------------------------------------------------- the settings
const FIELDS = ['account', 'project', 'kv', 'userid', 'zone', 'host', 'apibase', 'recipe'];
const STORE = 'cfdeploy.settings';

function loadSettings() {
  let saved = {};
  try { saved = JSON.parse(localStorage.getItem(STORE) ?? '{}'); } catch { saved = {}; }
  for (const f of FIELDS) if (saved[f] !== undefined && $(f)) $(f).value = saved[f];
  if (saved.strip !== undefined) $('strip').checked = !!saved.strip;
  if (Object.keys(saved).length) say('info', 'settings', 'restored your last settings from this browser');
}
function saveSettings() {
  const out = { strip: $('strip').checked };
  for (const f of FIELDS) if ($(f)) out[f] = $(f).value;
  try { localStorage.setItem(STORE, JSON.stringify(out)); } catch { /* private mode */ }
}
try { loadSettings(); } catch (e) { say('warn', 'settings', 'could not restore settings: ' + e.message); }

function config() {
  return {
    account: $('account').value.trim(),
    project: $('project').value.trim() || 'site',
    kvNamespace: $('kv').value.trim(),
    zone: $('zone').value.trim() || null,
    hostname: $('host').value.trim() || null,
    pages: $('recipe').value === 'pages',
    branch: 'main',
  };
}
const userId = () => $('userid').value.trim() || 'USER_ID';
const apiBase = () => $('apibase').value.trim() || null;

// ---------------------------------------------------------------- the kernel
// The FNV-1a content hashes are computed by the WebAssembly kernel that
// `RequestProject.Wasm.Encode` emitted from the Lean model, inlined into
// this page.  If it will not instantiate we fall back to the same
// arithmetic in JavaScript and say so.
try {
  const raw = atob(KERNEL_WASM_B64);
  const bytes = new Uint8Array(raw.length);
  for (let i = 0; i < raw.length; i++) bytes[i] = raw.charCodeAt(i);
  const { instance } = await WebAssembly.instantiate(bytes, {});
  const ex = instance.exports;
  const ok = BigInt.asUintN(64, ex.fnv_offset()) === 14695981039346656037n &&
    BigInt.asUintN(64, ex.hex_lo(171n)) === 98n &&
    BigInt.asUintN(64, ex.fits_kv(1n)) === 1n;
  if (ok) {
    useKernel(ex);
    say('info', 'wasm', `deployment kernel loaded (${bytes.length} bytes, ` +
      `${Object.keys(ex).length} exports); content hashes come from it`,
      { exports: Object.keys(ex).join(', ') });
  } else {
    say('warn', 'wasm', 'the kernel answered unexpectedly; using the JavaScript fallback');
  }
} catch (e) {
  say('warn', 'wasm', 'no WebAssembly kernel here: ' + (e && e.message ? e.message : e),
    { hint: 'the identical FNV-1a arithmetic in JavaScript is used instead' });
}

// ---------------------------------------------------------------- the bundle
// RAW is every member of the archive; ASSETS is what the selection below
// publishes, at the paths it will be served from.  The plan, the preview
// and the terminal transcript all speak about ASSETS.
let RAW = [];
let ASSETS = [];
let BUNDLE = '(none)';
let PLAN = null;
const DROPPED = new Set();

function renderAssets() {
  if (!ASSETS.length) {
    $('assets').innerHTML = RAW.length
      ? '<em>this selection publishes nothing</em>'
      : '<em>no bundle loaded yet</em>';
    return;
  }
  const total = totalBytes(ASSETS);
  const rows = ASSETS.map((a) =>
    `<tr><td>${a.hash}</td><td>${a.size}</td><td>${a.contentType}</td><td>${a.path}</td></tr>`).join('');
  $('assets').innerHTML = `<p>${BUNDLE}: publishing ${ASSETS.length} of ${RAW.length} ` +
    `file(s), ${total} byte(s)</p>` +
    `<table><tr><th>hash</th><th>size</th><th>type</th><th>path</th></tr>${rows}</table>`;
}

async function setBundle(bytes, name) {
  BUNDLE = name;
  say('info', 'bundle', `reading ${name} (${bytes.length ?? bytes.byteLength} bytes)`);
  const t0 = Date.now();
  try {
    RAW = await assetsOfTgz($('strip').checked, bytes);
  } catch (e) {
    RAW = [];
    ASSETS = [];
    say('error', 'bundle', 'could not read the bundle: ' + (e && e.message ? e.message : e), {
      hint: 'it must be a gzip-compressed tar archive (.tgz / .tar.gz)',
    });
    renderAssets();
    setState('no bundle');
    return;
  }
  DROPPED.clear();
  say('info', 'bundle', `${RAW.length} member(s), ` +
    `${totalBytes(RAW)} byte(s), hashed in ${Date.now() - t0} ms`);
  fillSubdirs();
  applyBundleConfig();
  applySelectionNow();
}

"##

/-- The last part: the selection table and preview, the plan, the
tokens, the run, and what the page remembers between visits. -/
def uiRestJs : String :=
r##"// ------------------------------------------------------------- the selection
// `RequestProject.Cf.Select`, in the page: which members are published,
// where they are served from, and — for the others — why not.  The preset
// and the size cap are the Lean values, so this table is the same table
// `cfdeploy select` prints.

function parseSize(s) {
  const t = String(s ?? '').trim().toLowerCase();
  if (t === '' || t === '0' || t === 'none') return 0;
  const m = t.match(/^(\d+)\s*([kmg]?)i?b?$/);
  if (!m) return CF_MAX_ASSET;
  const mult = { '': 1, k: 1024, m: 1048576, g: 1073741824 }[m[2]];
  return Number(m[1]) * mult;
}

const patternList = (s) => String(s ?? '').split(/[\s,]+/).filter((x) => x !== '');
const valueOf = (id) => ($(id) ? $(id).value : '');

function selection() {
  return {
    subdir: valueOf('subdir'),
    includes: patternList(valueOf('includes')),
    excludes: patternList(valueOf('excludes')),
    dropPaths: [...DROPPED],
    maxBytes: parseSize(valueOf('maxsize')),
  };
}

function fillSubdirs() {
  const el = $('subdir');
  if (!el) return;
  const cur = el.value;
  const dirs = topDirs(RAW);
  el.innerHTML = ['<option value="">(the whole bundle)</option>']
    .concat(dirs.map((d) => `<option value="${d}">${d}/</option>`)).join('');
  el.value = dirs.includes(cur) ? cur : '';
}

function renderSelection() {
  const sel = selection();
  const rep = selectionReport(sel, RAW);
  const kept = rep.filter((r) => r.verdict.tag === 'keep');
  if ($('selsummary')) {
    $('selsummary').textContent = RAW.length
      ? `publishing ${kept.length} of ${RAW.length} file(s), ` +
        `${totalBytes(kept.map((r) => r.asset))} of ${totalBytes(RAW)} byte(s)`
      : 'no bundle loaded yet';
  }
  if (!$('seltable')) return;
  const rows = rep.map((r) => {
    const keep = r.verdict.tag === 'keep';
    const served = keep ? servedOf(sel, r.asset) : '';
    return `<tr><td><input type="checkbox" data-path="${r.asset.path}"` +
      `${DROPPED.has(r.asset.path) ? '' : ' checked'}></td>` +
      `<td>${keep ? 'publish' : 'skip'}</td><td>${r.asset.size}</td>` +
      `<td>${r.asset.path}</td><td>${served}</td><td>${r.verdict.reason}</td></tr>`;
  }).join('');
  $('seltable').innerHTML = RAW.length
    ? '<table><tr><th></th><th></th><th>size</th><th>in the bundle</th>' +
      `<th>served as</th><th>why</th></tr>${rows}</table>`
    : '<em>load a bundle first</em>';
  const boxes = $('seltable').querySelectorAll
    ? $('seltable').querySelectorAll('input[type=checkbox]') : [];
  for (const b of boxes) {
    b.addEventListener('change', () => {
      const p = b.getAttribute('data-path');
      if (b.checked) DROPPED.delete(p); else DROPPED.add(p);
      applySelectionNow();
    });
  }
}

function applySelectionNow() {
  const sel = selection();
  ASSETS = applySelection(sel, RAW);
  renderSelection();
  renderAssets();
  stopPreview();
  fillPreviewEntries();
  rebuildPlan();
  saveSettings();
}

// the preset the CLI uses, unless this browser remembers something else
if ($('excludes') && !$('excludes').value.trim()) $('excludes').value = LEAN_PRESET.join('\n');
if ($('maxsize') && !$('maxsize').value.trim()) $('maxsize').value = String(CF_MAX_ASSET);

for (const f of ['subdir', 'includes', 'excludes', 'maxsize']) {
  const el = $(f);
  if (el && el.addEventListener) el.addEventListener('change', () => applySelectionNow());
}
const on = (id, kind, fn) => {
  const el = $(id);
  if (el && el.addEventListener) el.addEventListener(kind, fn);
};
on('selpreset', 'click', () => {
  if ($('excludes')) $('excludes').value = LEAN_PRESET.join('\n');
  if ($('includes')) $('includes').value = '';
  if ($('maxsize')) $('maxsize').value = String(CF_MAX_ASSET);
  DROPPED.clear();
  say('info', 'select', 'back to the preset: no Lean sources, no build tree, no wrangler config');
  applySelectionNow();
});
on('seleverything', 'click', () => {
  if ($('excludes')) $('excludes').value = '';
  if ($('includes')) $('includes').value = '';
  if ($('maxsize')) $('maxsize').value = '0';
  if ($('subdir')) $('subdir').value = '';
  DROPPED.clear();
  say('warn', 'select', 'publishing the bundle exactly as it is, Lean sources and all');
  applySelectionNow();
});
on('selnone', 'click', () => {
  for (const a of RAW) DROPPED.add(a.path);
  applySelectionNow();
});
on('selall', 'click', () => { DROPPED.clear(); applySelectionNow(); });
on('dltoml', 'click', () => {
  download(CONFIG_FILE_NAME, renderToml(configOfForm()), 'text/plain');
  say('info', 'config', `wrote ${CONFIG_FILE_NAME}: put it beside your project, or at the ` +
    'root of the bundle you upload, and these settings come back by themselves');
});
on('savesel', 'click', () =>
  download('selection.json', JSON.stringify({
    selection: selection(),
    files: selectionReport(selection(), RAW).map((r) => ({
      path: r.asset.path, size: r.asset.size, hash: r.asset.hash,
      verdict: r.verdict.tag, reason: r.verdict.reason,
      served: r.verdict.tag === 'keep' ? servedOf(selection(), r.asset) : '',
    })),
  }, null, 2) + '\n', 'application/json'));

// ---------------------------------------------------------------- the preview
// The published site, served from memory: every file becomes a blob URL
// and the references between them are rewritten to those URLs, so what
// the iframe shows is the tree as it will be served — with nothing
// uploaded and no server anywhere.
let PREVIEW_URLS = [];

function stopPreview() {
  for (const u of PREVIEW_URLS) {
    try { URL.revokeObjectURL(u); } catch { /* not a real URL in a stub DOM */ }
  }
  PREVIEW_URLS = [];
  const f = $('preview');
  if (f) f.removeAttribute ? f.removeAttribute('src') : (f.src = '');
}

function fillPreviewEntries() {
  const el = $('previewentry');
  if (!el) return;
  const docs = ASSETS.filter((a) => /\.(html?|txt|svg|json|css|md)$/i.test(a.path));
  const list = (docs.length ? docs : ASSETS).map((a) => a.path);
  const cur = el.value;
  el.innerHTML = list.map((p) => `<option value="${p}">${p}</option>`).join('');
  el.value = list.includes(cur) ? cur : (entryOf(ASSETS) ?? '');
}

function buildPreview() {
  if (!ASSETS.length) { say('warn', 'preview', 'nothing is published yet'); return; }
  stopPreview();
  const urls = new Map();
  const blobFor = (a, body) => {
    const u = URL.createObjectURL(new Blob([body], { type: a.contentType }));
    PREVIEW_URLS.push(u);
    urls.set(a.path, u);
  };
  const dec = new TextDecoder();
  const isCss = (a) => /\.css$/i.test(a.path);
  const isHtml = (a) => /\.html?$/i.test(a.path);
  for (const a of ASSETS) if (!isCss(a) && !isHtml(a)) blobFor(a, a.contents);
  for (const a of ASSETS) {
    if (isCss(a)) blobFor(a, rewriteRefs(dec.decode(a.contents), a.path, (p) => urls.get(p)));
  }
  for (const a of ASSETS) {
    if (isHtml(a)) blobFor(a, rewriteRefs(dec.decode(a.contents), a.path, (p) => urls.get(p)));
  }
  const want = valueOf('previewentry') || entryOf(ASSETS);
  const url = urls.get(want);
  if (!url) { say('warn', 'preview', `${want} is not in the published set`); return; }
  const frame = $('preview');
  if (frame) frame.src = url;
  say('info', 'preview', `previewing ${want} with ${ASSETS.length} file(s) from memory`, {
    hint: 'nothing has been uploaded: these are blob URLs in this tab',
  });
}

on('previewgo', 'click', buildPreview);
on('previewstop', 'click', () => { stopPreview(); say('info', 'preview', 'preview cleared'); });

// ------------------------------------------------------------------ the plan
function rebuildPlan() {
  const cfg = config();
  if (!ASSETS.length) {
    $('plan').innerHTML = '<em>load a bundle first</em>';
    $('needs').innerHTML = '<em>load a bundle first</em>';
    PLAN = null;
    setState('no bundle');
    return;
  }
  const missing = [];
  if (!cfg.account) missing.push('account id');
  if (!cfg.pages && !cfg.kvNamespace) missing.push('KV namespace id');
  PLAN = buildPlan(cfg, ASSETS);
  const rows = PLAN.steps.map((s, i) =>
    `<tr><td>${i + 1}</td><td>${s.method}</td>` +
    `<td>${s.url.replace(CF_API, '')}</td><td>${s.role}</td><td>${s.describe}</td></tr>`).join('');
  $('plan').innerHTML =
    `<table><tr><th>#</th><th>method</th><th>path</th><th>role</th><th>what it does</th></tr>${rows}</table>`;
  const needs = requiredTokens(PLAN);
  $('needs').innerHTML =
    '<table><tr><th>role</th><th>permission groups</th><th>resources</th></tr>' +
    needs.map((n) => `<tr><td>${n.role}</td><td>${n.groups.join('<br>')}</td>` +
      `<td>${n.resources.join('<br>')}</td></tr>`).join('') + '</table>';
  say('info', 'plan', `${PLAN.steps.length} step(s), ${needs.length} scoped token(s)`,
    { roles: needs.map((n) => n.role) });
  const free = PLAN.steps.filter((s) => s.groups.length === 0).length;
  if (free) say('info', 'plan', `${free} step(s) need no API token at all`);
  if (missing.length) {
    say('warn', 'plan', 'still missing: ' + missing.join(', '),
      { hint: 'the plan is shown with the fields you have; fill them in before deploying' });
    setState('incomplete');
  } else {
    setState('ready');
  }
  saveSettings();
}

for (const f of FIELDS.concat(['strip'])) {
  const el = $(f);
  if (el && el.addEventListener) {
    el.addEventListener('change', () => { if (ASSETS.length) rebuildPlan(); else saveSettings(); });
  }
}

// ------------------------------------------------------------- loading a tgz
const fileEl = $('file');
if (fileEl && fileEl.addEventListener) {
  fileEl.addEventListener('change', async () => {
    const f = fileEl.files && fileEl.files[0];
    if (!f) return;
    await setBundle(new Uint8Array(await f.arrayBuffer()), f.name);
  });
}
const dropEl = $('drop');
if (dropEl && dropEl.addEventListener) {
  dropEl.addEventListener('dragover', (e) => { e.preventDefault(); dropEl.className = 'drop over'; });
  dropEl.addEventListener('dragleave', () => { dropEl.className = 'drop'; });
  dropEl.addEventListener('drop', async (e) => {
    e.preventDefault();
    dropEl.className = 'drop';
    const f = e.dataTransfer && e.dataTransfer.files && e.dataTransfer.files[0];
    if (!f) return;
    await setBundle(new Uint8Array(await f.arrayBuffer()), f.name);
  });
}
$('fetchtgz').addEventListener('click', async () => {
  const url = $('tgzurl').value.trim();
  if (!url) { say('warn', 'bundle', 'give a URL of a .tgz first'); return; }
  say('info', 'bundle', 'fetching ' + url);
  try {
    const res = await fetch(url);
    if (!res.ok) throw new Error('HTTP ' + res.status);
    await setBundle(new Uint8Array(await res.arrayBuffer()), url.split('/').pop() || url);
  } catch (e) {
    say('error', 'bundle', 'could not fetch it: ' + (e && e.message ? e.message : e), {
      hint: 'the other origin has to allow this one by CORS; otherwise download it and drop it here',
    });
  }
});

$('saveplan').addEventListener('click', () => {
  if (!PLAN) { say('warn', 'plan', 'no plan yet'); return; }
  download('deploy-plan.json', JSON.stringify(PLAN, null, 2) + '\n', 'application/json');
});
$('saveworker').addEventListener('click', () => {
  if (!ASSETS.length) { say('warn', 'plan', 'no bundle yet'); return; }
  download('worker.mjs', workerScript(ASSETS), 'text/javascript');
});
$('savemanifest').addEventListener('click', () => {
  if (!ASSETS.length) { say('warn', 'plan', 'no bundle yet'); return; }
  download('manifest.json', manifestJson(ASSETS), 'application/json');
});

// ------------------------------------------------------------- connectivity
async function probe(target, quiet) {
  try {
    const res = await fetch(target + '/user/tokens/verify');
    if (!quiet) say('info', 'check', `${target} is reachable: HTTP ${res.status} ` +
      '(401/403 without a token is the expected answer)');
    return true;
  } catch (e) {
    if (!quiet) say('error', 'check', `${target} is not reachable: ${e && e.message ? e.message : e}`, {
      hint: 'browsers apply CORS to api.cloudflare.com — deploy this page with its Worker ' +
            '(_worker.js), which proxies /cf, and put /cf in the API base field',
    });
    return false;
  }
}
$('check').addEventListener('click', () => probe(apiBase() ?? CF_API, false));

// If this page is served by its own Worker, the same origin proxies the
// API at /cf — then the browser's CORS rules do not apply at all.
if (!$('apibase').value.trim() && typeof location !== 'undefined' &&
    (location.protocol === 'http:' || location.protocol === 'https:')) {
  try {
    const res = await fetch('/cf/user/tokens/verify');
    const body = await res.text();
    if (/"success"/.test(body)) {
      $('apibase').value = '/cf';
      say('info', 'check', 'this page is served with its API proxy: using /cf, ' +
        'so no CORS rule applies to the deployment');
    } else {
      say('info', 'check', 'no /cf proxy on this origin; requests go straight to api.cloudflare.com',
        { hint: 'if the browser blocks them, deploy this page with the _worker.js beside it' });
    }
  } catch {
    say('info', 'check', 'no /cf proxy on this origin; requests go straight to api.cloudflare.com');
  }
}

// -------------------------------------- when this page cannot reach the API
// Browsers apply CORS to api.cloudflare.com, and a page on a static host
// is a cross-origin caller: the deployment requests are refused before
// they are sent.  Nothing here needs a proxy — the same plan, as text you
// run yourself, plus the two proxies you can put in front of it.
function assetFiles() {
  const files = ASSETS.map((a) => ({ name: a.hash, bytes: a.contents }));
  const workerStep = PLAN && PLAN.steps.find((s) => s.payload && s.payload.startsWith('worker:'));
  if (workerStep) {
    files.push({
      name: fileNameOf(workerStep.payload),
      bytes: new TextEncoder().encode(workerScript(ASSETS)),
    });
  }
  return files;
}

const showText = (s) => { if ($('curlout')) $('curlout').textContent = s; };
const copy = async (what, s) => {
  showText(s);
  try {
    await navigator.clipboard.writeText(s);
    say('info', 'offline', what + ' copied to the clipboard');
  } catch (e) {
    say('warn', 'offline', 'could not copy ' + what + ' (' + e.message + '); it is shown below');
  }
};

on('dlscript', 'click', () => {
  if (!PLAN) { say('warn', 'offline', 'load a bundle first'); return; }
  download('deploy.sh', deployShellScript(PLAN), 'text/x-shellscript');
  say('info', 'offline', 'deploy.sh: the same plan as curl — ' +
    'sh deploy.sh --dry-run shows every request, ' +
    'CF_API_TOKEN=... sh deploy.sh mints the scoped tokens and runs it');
});
on('dlpayload', 'click', () => {
  if (!ASSETS.length) { say('warn', 'offline', 'nothing is published yet'); return; }
  const files = assetFiles();
  download('payload.tar', tarOf(files), 'application/x-tar');
  say('info', 'offline', `payload.tar: ${files.length} file(s) as assets/<hash>; ` +
    'tar xf payload.tar next to deploy.sh');
});
on('copycurl', 'click', () => {
  if (!PLAN) { say('warn', 'offline', 'load a bundle first'); return; }
  copy('the curl commands', curlCommands(apiBase() ?? CF_API, PLAN.steps) + '\n');
});
on('dlagent', 'click', () => {
  download('cf-agent.mjs', AGENT_JS, 'text/javascript');
  say('info', 'offline', 'cf-agent.mjs: run CF_API_TOKEN=... node cf-agent.mjs and paste ' +
    'the API base it prints into the field above; the key never leaves your machine');
});
on('copyagent', 'click', () => copy('the agent installer', AGENT_INSTALL));
on('dlproxy', 'click', () => {
  download('_worker.js', PROXY_JS, 'text/javascript');
  say('info', 'offline', '_worker.js: a CORS proxy for the Cloudflare API. Deploy it ' +
    '(npx wrangler deploy) and put its URL in the API base field — both ' +
    'https://proxy.example.workers.dev/cf and ...?apiurl= are understood');
});
// ---- the gate: this browser's own key, and requests signed with it
let IDENTITY = null;

async function identity() {
  if (!IDENTITY) IDENTITY = await loadIdentity();
  return IDENTITY;
}

function bindingOf() {
  const cfg = config();
  const names = [cfg.project, cfg.kvNamespace].filter((x) => x);
  return { accounts: cfg.account ? [cfg.account] : [], zones: cfg.zone ? [cfg.zone] : [],
           names, mayMint: true };
}

/** The `fetch` the run should use: signed, when the API base is a gate. */
async function transport() {
  const base = apiBase();
  if (!base) return { fetchImpl: fetch, gate: null };
  let info = null;
  try {
    info = await gateInfo(base, fetch);
  } catch {
    return { fetchImpl: fetch, gate: null };
  }
  if (!info) return { fetchImpl: fetch, gate: null };
  const me = await identity();
  say('info', 'gate', `the API base is a cfdeploy gate: every request is signed as ${me.id}`, {
    clients: info.clients, gateHoldsToken: info.hasToken, alg: info.alg,
  });
  if (!info.clients) {
    say('warn', 'gate', 'the gate has no clients enrolled yet: it will refuse every request', {
      hint: 'copy this client\'s enrolment below and put it in CFDEPLOY_CLIENTS',
    });
  }
  return { fetchImpl: gatedFetch(me, base, fetch), gate: info };
}

on('showclient', 'click', async () => {
  const me = await identity();
  if ($('clientstate')) $('clientstate').textContent = 'this client is ' + me.id;
  showText(JSON.stringify([enrolment(me, bindingOf())], null, 2));
  say('info', 'gate', `this browser signs as ${me.id}`, {
    hint: 'the private key is non-extractable and stays in this browser',
  });
});
on('copyenrol', 'click', async () => {
  const me = await identity();
  if ($('clientstate')) $('clientstate').textContent = 'this client is ' + me.id;
  await copy('the enrolment record', JSON.stringify([enrolment(me, bindingOf())], null, 2) + '\n');
  say('info', 'gate', 'put it in the gate: npx wrangler secret put CFDEPLOY_CLIENTS', {
    boundTo: bindingOf(),
  });
});
on('dlgate', 'click', () => {
  download('_worker.js', GATE_JS, 'text/javascript');
  say('info', 'gate', 'the gate Worker: deploy it, enrol this client, then use its URL ' +
    'as the API base');
});
on('dlgatetoml', 'click', () => download('wrangler.toml', GATE_TOML, 'text/plain'));
on('forgetkey', 'click', async () => {
  await resetIdentity();
  IDENTITY = null;
  if ($('clientstate')) $('clientstate').textContent = 'key forgotten; a new one is made on demand';
  say('warn', 'gate', 'this browser forgot its key: the enrolled record no longer matches, ' +
    'so remove it from CFDEPLOY_CLIENTS');
});

on('findagent', 'click', async () => {
  const url = valueOf('agenturl').trim() || 'http://127.0.0.1:8787';
  say('info', 'offline', 'looking for a local agent at ' + url);
  try {
    const res = await fetch(url + '/agent/health');
    const info = await res.json();
    if (info && info.agent === 'cfdeploy') {
      say('info', 'offline', `an agent is running at ${url}` +
        (info.hasToken ? ' and holds a CF_API_TOKEN of its own' : ' with no token of its own'), {
        hint: 'paste the API base the agent printed (it carries the access key) above',
      });
    } else {
      say('warn', 'offline', `something answered at ${url}, but it is not a cfdeploy agent`);
    }
  } catch (e) {
    say('warn', 'offline', `no agent at ${url}: ${e && e.message ? e.message : e}`, {
      hint: 'download cf-agent.mjs below, or paste the installer into a terminal',
    });
  }
});

// -------------------------------------------------------------------- run
async function payloads() {
  const out = {};
  for (const a of ASSETS) out[a.hash] = a.contents;
  const workerStep = PLAN.steps.find((s) => s.payload && s.payload.startsWith('worker:'));
  if (workerStep) {
    out[workerStep.payload] = new TextEncoder().encode(workerScript(ASSETS));
    say('info', 'assets', 'generated the serving Worker for this bundle',
      { bytes: out[workerStep.payload].length });
  }
  say('info', 'assets', `${Object.keys(out).length} payload(s) ready`);
  return out;
}

$('go').addEventListener('click', async () => {
  if (!PLAN) { say('error', 'run', 'no plan: load a .tgz bundle first'); return; }
  const cfg = config();
  if (!cfg.account) { say('error', 'run', 'the account id is required'); return; }
  $('go').disabled = true;
  const dry = $('dry').checked;
  setState(dry ? 'dry run…' : 'deploying…');
  say('info', 'run', dry ? 'starting a dry run (nothing is sent)' : 'starting a deployment',
    { steps: PLAN.steps.length, apiBase: apiBase() ?? CF_API });
  try {
    const assets = await payloads();
    const { fetchImpl } = await transport();
    if (dry) {
      const out = await runPlan({}, { plan: PLAN, assets, dryRun: true, onEvent: push,
        apiBase: apiBase(), fetchImpl });
      say('info', 'run', `dry run finished: ${out.length} step(s) inspected, nothing sent`);
      setState('dry run done');
      return;
    }
    const admin = $('admin').value.trim();
    if (!admin) {
      say('error', 'run', 'no admin token given; paste one, or tick "dry run"');
      setState('ready');
      return;
    }
    const needs = requiredTokens(PLAN);
    const expiresOn = new Date(Date.now() + 15 * 60 * 1000).toISOString().replace(/\.\d+Z$/, 'Z');
    const mintedIds = {};
    const tokens = await mintTokens(admin, needs, expiresOn, fetchImpl, push, apiBase(),
      mintedIds);
    const out = await runPlan(tokens, { plan: PLAN, assets, onEvent: push,
      apiBase: apiBase(), fetchImpl, tokenIds: mintedIds });
    if ($('revoke').checked) {
      await revokeTokens(admin, mintedIds, fetchImpl, push, apiBase());
    } else {
      say('warn', 'revoke-end', 'the minted tokens were kept; they expire at ' + expiresOn);
    }
    const bad = out.filter((l) => l.status !== 'ok');
    say(bad.length ? 'error' : 'info', 'run',
      bad.length ? `finished with ${bad.length} problem step(s)` : 'deployment finished cleanly');
    setState(bad.length ? 'failed' : 'done');
  } catch (e) {
    say('error', 'run', 'aborted: ' + (e && e.message ? e.message : e));
    setState('failed');
  } finally {
    $('go').disabled = false;
  }
});

renderAssets();
rebuildPlan();
say('info', 'page', 'ready — drop an Aristotle .tgz above, or paste its URL');

// for the console, and for the test harness
globalThis.cfsite = {
  events: EVENTS, setBundle, rebuildPlan, config, plan: () => PLAN, assets: () => ASSETS,
  buildPlan, requiredTokens, runPlan, mintTokens, revokeTokens, resolveTokenRefs,
  workerScript, manifestJson, assetsOfTgz,
  raw: () => RAW, selection, applySelectionNow, selectionReport, applySelection, topDirs,
  identity, transport, enrolment, bindingOf, gatedFetch, gateInfo,
  deployShellScript, curlCommands, tarOf, buildPreview, rewriteRefs, entryOf,
};
"##

/-- The UI: settings, the dropped bundle, the plan, the tokens, the run,
and the log console that is live from the first line. -/
def uiJs : String := uiTopJs ++ configUiJs ++ uiRestJs

/-- Everything above the inline module script. -/
def pageHead : String :=
r##"<!doctype html>
<!-- Generated from Lean by RequestProject.Cf.Site — do not edit.
     Self-contained: the deployment client, the token minter, the bundle
     reader, the plan builder and the WebAssembly kernel are all inlined
     here, so this one file is the whole tool. -->
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>cfdeploy — least-privilege Cloudflare deployment</title>
<style>
  :root { color-scheme: light dark; }
  body { font: 15px/1.5 ui-monospace, SFMono-Regular, Menlo, monospace; margin: 2rem auto;
         max-width: 64rem; padding: 0 1rem; }
  h1 { font-size: 1.3rem; margin-bottom: .2rem; }
  p.sub { opacity: .8; margin-top: 0; }
  fieldset { border: 1px solid #8886; border-radius: 6px; margin: 1rem 0; }
  legend { padding: 0 .4rem; opacity: .8; }
  input[type=password], input[type=text] { width: 100%; font: inherit; padding: .35rem; }
  button { font: inherit; padding: .35rem .8rem; margin-right: .4rem; }
  select { font: inherit; padding: .3rem; }
  label { display: block; margin: .4rem 0; }
  .grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(18rem, 1fr)); gap: 0 1rem; }
  table { border-collapse: collapse; width: 100%; font-size: .85em; display: block;
          max-height: 22rem; overflow: auto; }
  td, th { text-align: left; padding: .2rem .5rem; border-bottom: 1px solid #8883;
           vertical-align: top; }
  .drop { border: 2px dashed #8886; border-radius: 8px; padding: 1.2rem; text-align: center; }
  .drop.over { border-color: #2a7; background: rgba(42, 170, 119, .12); }
  #log { background: #8881; padding: .6rem; border-radius: 6px; height: 24rem; overflow: auto;
         white-space: pre-wrap; word-break: break-word; font-size: .85em; }
  .row { display: flex; align-items: center; gap: .6rem; flex-wrap: wrap; margin-bottom: .5rem; }
  .l-debug { opacity: .65; }
  .l-warn  { color: #b80; }
  .l-error { color: #c33; }
  .l-ok    { color: #2a7; }
  .badge { border: 1px solid #8886; border-radius: 999px; padding: 0 .5rem; font-size: .8em; }
  small { opacity: .8; }
  textarea { width: 100%; font: inherit; font-size: .85em; padding: .35rem; }
  iframe { width: 100%; height: 26rem; border: 1px solid #8886; border-radius: 6px;
           background: #fff; }
  pre { background: #8881; padding: .6rem; border-radius: 6px; overflow: auto;
        font-size: .85em; white-space: pre-wrap; word-break: break-word; }
</style>
</head>
<body>
<h1>cfdeploy</h1>
<p class="sub">Publish an Aristotle <code>.tgz</code> to Cloudflare. Every request is
signed by its own short-lived API token carrying exactly the permissions
that request needs — the plan, the permissions and the token requests are
computed here, in this page, by the model extracted from Lean.</p>

<fieldset>
  <legend>1 — the bundle</legend>
  <div class="drop" id="drop">
    <p>Drop an Aristotle <code>.tgz</code> here, or</p>
    <p><input id="file" type="file" accept=".tgz,.gz,.tar.gz,application/gzip"></p>
    <p><small>or fetch one by URL:</small><br>
      <input id="tgzurl" type="text" placeholder="https://example.com/bundle.tgz" autocomplete="off">
      <button id="fetchtgz">Fetch</button></p>
  </div>
  <label><input id="strip" type="checkbox" checked> strip the archive's top-level directory
    from the served paths</label>
  <div id="assets"><em>no bundle loaded yet</em></div>
</fieldset>

<fieldset>
  <legend>2 — what gets published</legend>
  <p><small>An Aristotle bundle is a whole project; a site is a part of it.
  Drop one and this page picks the <em>site directory</em> — the shallowest
  directory with an <code>index.html</code> in it — so the Lean sources, the build
  tree and the manifests stay behind.  Choose “(the whole bundle)” to publish
  everything instead.  A <code>cfdeploy.toml</code> at the root of the bundle
  overrides all of it, and <em>Download cfdeploy.toml</em> writes one from what you
  see here.  Nothing is uploaded until you deploy — this is the same selection
  <code>cfdeploy select</code> applies, with the same globs, the same size cap and
  the same reasons.</small></p>
  <div class="grid">
    <label>subdirectory to publish<br><select id="subdir">
      <option value="">(the whole bundle)</option>
    </select>
      <small>its contents become the root of the site</small></label>
    <label>largest file to publish (bytes; 0 for no cap)<br>
      <input id="maxsize" type="text" autocomplete="off" placeholder="26214400"></label>
    <label>exclude (one glob per line)<br>
      <textarea id="excludes" rows="6" spellcheck="false"></textarea></label>
    <label>include only (one glob per line; empty means everything)<br>
      <textarea id="includes" rows="6" spellcheck="false"></textarea></label>
  </div>
  <p>
    <button id="selpreset">Reset to the preset</button>
    <button id="seleverything">Publish everything</button>
    <button id="selall">Tick all</button>
    <button id="selnone">Untick all</button>
    <button id="savesel">Download selection.json</button>
    <button id="dltoml">Download cfdeploy.toml</button>
  </p>
  <p><span id="selsummary" class="badge">no bundle loaded yet</span></p>
  <div id="seltable"><em>load a bundle first</em></div>
</fieldset>

<fieldset>
  <legend>3 — preview</legend>
  <p><small>The published files, rendered from this tab's memory: every file
  becomes a blob URL and the links between them are rewritten, so this is the
  tree as it will be served. Nothing is uploaded and no server is involved.</small></p>
  <p>
    <label style="display:inline">entry <select id="previewentry"></select></label>
    <button id="previewgo">Preview</button>
    <button id="previewstop">Clear</button>
  </p>
  <iframe id="preview" sandbox="allow-scripts allow-forms allow-popups" title="preview"></iframe>
</fieldset>

<fieldset>
  <legend>4 — where it goes</legend>
  <div class="grid">
    <label>Cloudflare account id<br><input id="account" type="text" autocomplete="off"
      placeholder="32 hex characters">
      <small>the dashboard URL after <code>dash.cloudflare.com/</code></small></label>
    <label>Worker script / Pages project name<br><input id="project" type="text"
      autocomplete="off" placeholder="site"></label>
    <label>Workers KV namespace id (Worker recipe)<br><input id="kv" type="text"
      autocomplete="off">
      <small>Storage &amp; Databases &rsaquo; KV in the dashboard, or
      <code>npx wrangler kv namespace create assets</code></small></label>
    <label>recipe<br><select id="recipe">
      <option value="worker" selected>Worker + KV</option>
      <option value="pages">Pages direct upload</option>
    </select></label>
    <label>zone id (optional — DNS record and cache purge)<br><input id="zone" type="text"
      autocomplete="off"></label>
    <label>hostname (optional)<br><input id="host" type="text" autocomplete="off"
      placeholder="site.example.com"></label>
    <label>Cloudflare user id (used in the token resource keys)<br><input id="userid"
      type="text" autocomplete="off" placeholder="USER_ID"></label>
    <label>API base — empty for api.cloudflare.com, <code>/cf</code> for this page's own proxy<br>
      <input id="apibase" type="text" autocomplete="off" placeholder="/cf"></label>
  </div>
  <p><small>These settings stay in this browser (localStorage). The API token below never does.</small></p>
</fieldset>

<fieldset>
  <legend>5 — the plan</legend>
  <div id="plan"><em>load a bundle first</em></div>
  <p>
    <button id="saveplan">Download deploy-plan.json</button>
    <button id="saveworker">Download worker.mjs</button>
    <button id="savemanifest">Download manifest.json</button>
  </p>
</fieldset>

<fieldset>
  <legend>6 — the tokens this plan needs</legend>
  <div id="needs"><em>load a bundle first</em></div>
</fieldset>

<fieldset>
  <legend>7 — authorize and run</legend>
  <p>Paste a token that may <em>create tokens</em> (<code>API Tokens Write</code> on your
  user). It is used once, to mint the scoped tokens above, and is never
  sent with a deployment request, never logged, and never stored: closing
  the tab forgets it.</p>
  <input id="admin" type="password" placeholder="Cloudflare API token with API Tokens Write"
    autocomplete="off">
  <label><input id="dry" type="checkbox" checked> dry run (show every request, send nothing)</label>
  <label><input id="revoke" type="checkbox" checked> revoke the minted tokens when the run
    finishes</label>
  <button id="go">Deploy</button>
  <button id="check">Check connectivity</button>
  <span id="state" class="badge">starting…</span>
</fieldset>

<fieldset>
  <legend>8 — no proxy? run it from a terminal</legend>
  <p><small>Browsers apply CORS to <code>api.cloudflare.com</code>: a page on a plain
  static host cannot call it, and the deployment above will fail with
  <em>Failed to fetch</em>. That is a browser rule, not a missing feature — so the
  page hands you the same plan in a form that has no browser in it. Pick one:</small></p>

  <p><strong>a. run it yourself.</strong> <code>deploy.sh</code> is the plan as
  <code>curl</code>, one scoped token per role, credentials read from the environment and
  never written into the file. <code>payload.tar</code> is the files it uploads.</p>
  <pre id="shellhint">tar xf payload.tar          # writes assets/&lt;content hash&gt;
sh deploy.sh --dry-run      # every request, nothing sent
CF_API_TOKEN=... sh deploy.sh</pre>
  <p>
    <button id="dlscript">Download deploy.sh</button>
    <button id="dlpayload">Download payload.tar</button>
    <button id="copycurl">Copy the curl commands</button>
  </p>

  <p><strong>b. an agent on your machine.</strong> It holds the key where the key
  already is, answers CORS, and is reachable only through the access key it
  prints — paste that URL into <em>API base</em> above and the page deploys normally.</p>
  <p>
    <label style="display:inline">agent <input id="agenturl" type="text"
      style="width:16rem" placeholder="http://127.0.0.1:8787" autocomplete="off"></label>
    <button id="findagent">Find the agent</button>
    <button id="dlagent">Download cf-agent.mjs</button>
    <button id="copyagent">Copy the one-line installer</button>
  </p>

  <p><strong>c. the gate: a Worker only your own clients can use.</strong> One tiny
  Worker on your own account. It answers CORS, it can hold the Cloudflare token
  itself so the browser never sees one, and it forwards a request only when that
  request is <em>signed</em> by a client you enrolled and stays inside the deployment
  that client is bound to. This browser has a key pair of its own: the private half
  is non-extractable and never leaves it; what you enrol is the public half.</p>
  <p>
    <button id="showclient">Show this client</button>
    <button id="copyenrol">Copy this client's enrolment</button>
    <button id="dlgate">Download the gate _worker.js</button>
    <button id="dlgatetoml">Download its wrangler.toml</button>
    <button id="forgetkey">Forget this key</button>
  </p>
  <p><small>Enrol it once — <code>npx wrangler secret put CFDEPLOY_CLIENTS</code> — then put
  the Worker's URL in <em>API base</em>. The page notices the gate and signs every request
  from then on. A plain, unauthenticated CORS proxy is still available if you want
  one: <button id="dlproxy">Download the open proxy _worker.js</button></small></p>
  <p><span id="clientstate" class="badge">this browser's key is generated on first use</span></p>

  <pre id="curlout"></pre>
</fieldset>

<fieldset>
  <legend>9 — log</legend>
  <div class="row">
    <label>level
      <select id="level">
        <option value="debug">debug</option>
        <option value="info" selected>info</option>
        <option value="warn">warn</option>
        <option value="error">error</option>
      </select>
    </label>
    <label><input id="follow" type="checkbox" checked> follow</label>
    <span id="counts" class="badge">0 events</span>
    <button id="copy">Copy</button>
    <button id="save">Download .log</button>
    <button id="savejson">Download .json</button>
    <button id="clear">Clear</button>
  </div>
  <div id="log"></div>
</fieldset>

<script type="module">
"##

/-- Everything below it. -/
def pageTail : String :=
r##"</script>

<p><small>Build <code id="build">(unstamped)</code> — the same identifier
<code>cfdeploy version</code> prints and <code>/version.json</code> serves, so you can tell
at a glance whether what is deployed is what you built.</small></p>
<p><small>Nothing here phones home: the page has no external reference of any
kind, and the only requests it makes are the ones listed in the plan.
Browsers apply CORS to <code>api.cloudflare.com</code>; serve this page with the
<code>_worker.js</code> next to it and it proxies the API at <code>/cf</code> on its own
origin, which is why the API base field is filled in for you when that
proxy is there.</small></p>
</body>
</html>
"##

/-- The one module script of the page: the shared log, the token minter,
the deployment client, the bundle reader and plan builder, the kernel and
the UI — in that order, in one scope. -/
def pageScriptBody : String :=
  "// ===== cf-log.mjs =====\n" ++ inlineModule JsEmit.logModuleJs ++ "\n" ++
  "// ===== cf-tokens.mjs =====\n" ++ inlineModule JsEmit.tokenClientJs ++ "\n" ++
  "// ===== cf-deploy.mjs =====\n" ++ inlineModule JsEmit.deployClientBodyJs ++ "\n" ++
  "// ===== the Lean constants =====\n" ++ inlineModule generatedConstsJs ++ "\n" ++
  "// ===== the configuration convention =====\n" ++ inlineModule configConstsJs ++ "\n" ++
  "// ===== the offline programs =====\n" ++ inlineModule offlineProgramsJs ++ "\n" ++
  "// ===== the gate client =====\n" ++ inlineModule Gate.gateClientJs ++ "\n" ++
  "// ===== the bundle reader and the plan builder =====\n" ++ inlineModule coreJs ++ "\n" ++
  "const KERNEL_WASM_B64 = '" ++ base64 WasmKernel.kernelBytes ++ "';\n" ++
  "// ===== the page =====\n" ++ uiJs

/-- **The build stamp**: a content hash of the page's own code.  The page
shows it, the Worker serves it at `/version.json` and `cfdeploy version`
prints it, so “is what is deployed what I built?” is a question with an
answer. -/
def buildId : String := buildIdOf pageScriptBody

/-- The page's script, stamped with the build id. -/
def pageScript : String :=
  "const CFDEPLOY_BUILD = '" ++ buildId ++ "';\n" ++ pageScriptBody

/-- **The whole tool, as one file.**  No script, style, font or image is
loaded from anywhere: the only requests it ever makes are the ones its
plan lists. -/
def singlePageHtml : String := pageHead ++ pageScript ++ pageTail

end Site
end CfDeploy
