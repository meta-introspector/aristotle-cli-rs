import RequestProject.Nix.NixWars.Holo.Instance

/-!
# The holographic archive as a page: `www/holo.html`

`Instance.lean` lays eleven concepts out as one 99-byte file.  This file writes
that file (`www/holo-archive.bin`) and a page that reads it the way a client
would read a hundred-gigabyte one: by asking for a byte range and decoding what
comes back.

Everything the page knows is emitted from Lean — the cells, their offsets and
lengths, the bytes themselves, the depth shells around each concept, the `M₁₁`
address of each concept and the description lengths of the three candidate
models.  The page's script is a transcription of `decodeCell`, `ball` and
`view`; `www/holo-selftest.mjs` runs it headless against the Lean-computed
values.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Holo
namespace Page

open Archive M11 Instance

/-! ## Emission helpers -/

/-- Escape a string for a JSON literal. -/
def esc (s : String) : String :=
  ((s.replace "\\" "\\\\").replace "\"" "\\\"").replace "\n" "\\n"

/-- A JSON string. -/
def str (s : String) : String := "\"" ++ esc s ++ "\""

/-- A list of numbers, as JSON. -/
def nats (ns : List Nat) : String := "[" ++ String.intercalate "," (ns.map toString) ++ "]"

/-- A list of lists of numbers, as JSON. -/
def natss (ns : List (List Nat)) : String :=
  "[" ++ String.intercalate "," (ns.map nats) ++ "]"

/-! ## The data -/

/-- The bytes of the archive. -/
def archiveBytes : List Nat := holoArchive.bytes

/-- The offsets, one per cell, and the end of the file. -/
def archiveOffsets : List Nat := (List.range 12).map holoArchive.offset

/-- The depth-`d` neighbourhood of each concept, `d = 0, 1, 2`, sorted. -/
def archiveBalls : List (List (List Nat)) :=
  (List.range 11).map fun k => (List.range 3).map fun d => (holoArchive.ball k d).mergeSort (· ≤ ·)

/-- The depth-`d` shell of each concept, `d = 0, 1, 2`, sorted. -/
def archiveShells : List (List (List Nat)) :=
  (List.range 11).map fun k => (List.range 3).map fun d => (holoArchive.shell k d).mergeSort (· ≤ ·)

/-- One cell, as JSON. -/
def cellJson (i : Nat) : String :=
  let c := conceptCell i
  "{\"key\":" ++ toString c.key ++
  ",\"name\":" ++ str (conceptNames.getD i "?") ++
  ",\"off\":" ++ toString (holoArchive.offset i) ++
  ",\"len\":" ++ toString c.size ++
  ",\"payload\":" ++ nats c.payload ++
  ",\"links\":" ++ nats c.links ++
  ",\"coord\":" ++ nats (conceptCoord i) ++ "}"

/-- The whole table of cells. -/
def cellsJson : String :=
  "[" ++ String.intercalate ",\n" ((List.range 11).map cellJson) ++ "]"

/-- The candidate models and their description lengths. -/
def modelsJson : String :=
  let row (M : Model) : String :=
    "{\"name\":" ++ str M.name ++ ",\"cost\":" ++ toString M.cost ++
    ",\"residual\":" ++ toString (M.residual holoArchive).length ++
    ",\"dl\":" ++ toString (M.descriptionLength holoArchive 8) ++ "}"
  "[" ++ String.intercalate ",\n" (candidates.map row) ++ "]"

/-- The block of Lean-emitted data shared by the page and the self-test. -/
def dataBlock : String :=
  "const CELLS = " ++ cellsJson ++ ";\n" ++
  "const BYTES = " ++ nats archiveBytes ++ ";\n" ++
  "const OFFSETS = " ++ nats archiveOffsets ++ ";\n" ++
  "const BALLS = [" ++ String.intercalate ",\n" (archiveBalls.map natss) ++ "];\n" ++
  "const SHELLS = [" ++ String.intercalate ",\n" (archiveShells.map natss) ++ "];\n" ++
  "const MODELS = " ++ modelsJson ++ ";\n" ++
  "const WINDOW = {\"from\":3,\"count\":5,\"centre\":5,\"depth\":2};\n"

/-! ## The script both the page and the self-test run -/

/-- A transcription of `decodeCell`, `ball`, `shell` and `view`. -/
def scriptBlock : String := r##"
// decodeCell: read one cell off the front of a byte stream.
function decodeCell(bs) {
  if (bs.length < 2) return null;
  const key = bs[0], n = bs[1], rest = bs.slice(2);
  if (rest.length < n) return null;
  const payload = rest.slice(0, n), rest1 = rest.slice(n);
  if (rest1.length < 1) return null;
  const m = rest1[0], rest2 = rest1.slice(1);
  if (rest2.length < m) return null;
  return { cell: { key: key, payload: payload, links: rest2.slice(0, m) },
           rest: rest2.slice(m) };
}
// One range request against the whole file.
function range(bytes, off, len) { return bytes.slice(off, off + len); }
// The neighbours of a concept, from the cells already known.
function nbrs(cells, k) {
  const c = cells.find(c => c.key === k);
  return c ? c.links : [];
}
// ball: everything within d links.
function ball(cells, k, d) {
  let seen = [k];
  for (let i = 0; i < d; i++) {
    const next = seen.slice();
    for (const x of seen) for (const y of nbrs(cells, x)) if (!next.includes(y)) next.push(y);
    seen = next;
  }
  return seen.slice().sort((a, b) => a - b);
}
// shell: what first becomes reachable at depth d.
function shell(cells, k, d) {
  if (d === 0) return [k];
  const inner = ball(cells, k, d - 1);
  return ball(cells, k, d).filter(x => !inner.includes(x)).sort((a, b) => a - b);
}
// The view of a client holding a set of concepts.
function view(cells, loaded) {
  const out = [];
  for (const c of cells) if (loaded.includes(c.key)) for (const f of c.payload) out.push(f);
  return out;
}
"##

/-! ## The self-test -/

/-- The checks, shared with the page. -/
def checksBlock : String := r##"
function holoChecks(t) {
  t("the file is 99 bytes", BYTES.length === 99);
  t("every value written is a byte", BYTES.every(b => b >= 0 && b < 256));
  t("the offsets are the emitted table",
    JSON.stringify(OFFSETS) === JSON.stringify([0,9,18,27,36,45,54,63,72,81,90,99]));
  let total = 0;
  for (const c of CELLS) {
    t("cell " + c.name + " starts at " + c.off, OFFSETS[c.key] === c.off);
    t("cell " + c.name + " is " + c.len + " bytes", c.len === c.payload.length + c.links.length + 3);
    const got = decodeCell(range(BYTES, c.off, c.len));
    t("one range request returns " + c.name,
      got !== null && got.cell.key === c.key &&
      JSON.stringify(got.cell.payload) === JSON.stringify(c.payload) &&
      JSON.stringify(got.cell.links) === JSON.stringify(c.links));
    t("and stops exactly at the end of " + c.name, got !== null && got.rest.length === 0);
    const tail = decodeCell(BYTES.slice(c.off));
    t("seeking to " + c.off + " and reading on also returns " + c.name,
      tail !== null && tail.cell.key === c.key);
    total += c.len;
  }
  t("the cells tile the file", total === BYTES.length);
  for (let i = 1; i < CELLS.length; i++)
    t("cell " + i + " begins where cell " + (i - 1) + " ends",
      CELLS[i].off === CELLS[i-1].off + CELLS[i-1].len);
  // no fact is stored twice
  const facts = [].concat(...CELLS.map(c => c.payload));
  t("overlap is zero: " + facts.length + " facts, all distinct",
    new Set(facts).size === facts.length);
  // links resolve, and they are mutual
  for (const c of CELLS) for (const k of c.links) {
    t(c.name + " -> " + k + " resolves", CELLS.some(d => d.key === k));
    t(c.name + " -> " + k + " is mutual", nbrs(CELLS, k).includes(c.key));
  }
  // the depth shells
  for (const c of CELLS) for (let d = 0; d < 3; d++) {
    t("ball(" + c.key + "," + d + ") is the Lean one",
      JSON.stringify(ball(CELLS, c.key, d)) === JSON.stringify(BALLS[c.key][d]));
    t("shell(" + c.key + "," + d + ") is the Lean one",
      JSON.stringify(shell(CELLS, c.key, d)) === JSON.stringify(SHELLS[c.key][d]));
  }
  for (const c of CELLS) {
    const b1 = ball(CELLS, c.key, 1), b2 = ball(CELLS, c.key, 2);
    t("the shells around " + c.key + " are disjoint",
      shell(CELLS, c.key, 1).every(x => !shell(CELLS, c.key, 2).includes(x)));
    t("and they exhaust the ball around " + c.key,
      JSON.stringify(b2.slice().sort((a,b)=>a-b)) ===
      JSON.stringify([].concat(shell(CELLS,c.key,0), shell(CELLS,c.key,1), shell(CELLS,c.key,2))
        .sort((a,b)=>a-b)));
    t("depth 1 around " + c.key + " is bigger than depth 0", b1.length > 1);
  }
  // the view only grows, and loading everything reconstructs the corpus
  let loaded = [], seen = 0;
  for (const c of CELLS) {
    loaded = loaded.concat([c.key]);
    const v = view(CELLS, loaded);
    t("loading " + c.name + " strictly raises the view", v.length > seen);
    seen = v.length;
  }
  t("loading every cell reconstructs the corpus", seen === facts.length);
  // one request, a window of cells, all within depth
  const win = CELLS.slice(WINDOW.from, WINDOW.from + WINDOW.count);
  const bytesOfWindow = OFFSETS[WINDOW.from + WINDOW.count] - OFFSETS[WINDOW.from];
  let bs = range(BYTES, OFFSETS[WINDOW.from], bytesOfWindow), got = [];
  for (let i = 0; i < WINDOW.count; i++) { const r = decodeCell(bs); got.push(r.cell); bs = r.rest; }
  t("one request returns " + WINDOW.count + " cells",
    got.length === WINDOW.count && bs.length === 0);
  t("and they are the cells of the window",
    JSON.stringify(got.map(c => c.key)) === JSON.stringify(win.map(c => c.key)));
  const centre = ball(CELLS, WINDOW.centre, WINDOW.depth);
  t("every cell of the window is within depth " + WINDOW.depth + " of the centre",
    got.every(c => centre.includes(c.key)));
  // the M11 overlay
  for (const c of CELLS) {
    t(c.name + " has a 4-point address", c.coord.length === 4 &&
      new Set(c.coord).size === 4 && c.coord.every(x => x < 11));
  }
  t("the eleven addresses are distinct",
    new Set(CELLS.map(c => c.coord.join(","))).size === CELLS.length);
  const best = MODELS.reduce((a, b) => (b.dl < a.dl ? b : a));
  t("the M11 overlay has no residual",
    MODELS.find(m => m.name === "M11 Cayley").residual === 0);
  t("and it is the cheapest description", best.name === "M11 Cayley");
  for (const m of MODELS)
    t(m.name + " costs " + m.dl + " bits", m.dl === m.cost + 8 * m.residual);
}
"##

/-- The extra checks the self-test runs outside the page: the file on disk, and
the page itself run headless against a stubbed DOM. -/
def harnessBlock : String := r##"
let fails = 0, n = 0;
const t = (what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
};
holoChecks(t);

// the file on disk is the archive Lean emitted
const onDisk = Array.from(fs.readFileSync("www/holo-archive.bin"));
t("www/holo-archive.bin is the Lean archive, byte for byte",
  JSON.stringify(onDisk) === JSON.stringify(BYTES));
for (const c of CELLS) {
  const got = decodeCell(onDisk.slice(c.off, c.off + c.len));
  t("a range request on the real file returns " + c.name,
    got !== null && got.cell.key === c.key && got.rest.length === 0);
}

// the page itself, headless: its script run against a stubbed DOM
function runPage(file) {
  const src = fs.readFileSync("www/" + file, "utf8");
  const m = src.match(/<script>([\s\S]*)<\/script>/);
  const created = [], byId = new Map();
  const mkEl = (tag) => {
    const el = {
      tagName: tag, innerHTML: "", textContent: "", className: "", dataset: {},
      style: {}, children: [], parent: null, onclick: null,
      appendChild(c) { c.parent = el; el.children.push(c); }
    };
    created.push(el);
    return el;
  };
  const document = {
    getElementById(id) {
      if (!byId.has(id)) { const el = mkEl("div"); el.id = id; byId.set(id, el); }
      return byId.get(id);
    },
    createElement: mkEl,
    querySelectorAll(sel) {
      const id = sel.split(" ")[0].slice(1);
      return created.filter(e => e.parent && e.parent.id === id);
    }
  };
  const sandbox = {
    document, console, JSON, Math, Number, String, Set, Array,
    fetch: async () => { throw new Error("no server"); }
  };
  vm.createContext(sandbox);
  vm.runInContext(m[1], sandbox, { filename: file });
  return { created, byId };
}

let dom = null, err = null;
try { dom = runPage("holo.html"); } catch (e) { err = e; }
t("the page's own script runs headless", err === null);
if (dom) {
  t("the page draws the table of cells",
    dom.byId.get("table").innerHTML.includes("MONSTROUS_MOONSHINE"));
  const buttons = dom.created.filter(e => e.tagName === "button" && e.onclick);
  t("the page wires up its controls", buttons.length >= 22);
  let pressErr = null, pressed = 0;
  const reset = buttons.filter(b => b.textContent === "FORGET EVERYTHING");
  for (const b of buttons.filter(b => b.textContent !== "FORGET EVERYTHING")) {
    try { await b.onclick(); pressed++; } catch (e) { pressErr = pressErr || e; }
  }
  const out = dom.byId.get("out").textContent;
  t("the page shows a range request", out.includes("Range: bytes="));
  t("loading every cell fills the view",
    dom.byId.get("viewout").innerHTML.includes("cells loaded : 11 of 11"));
  for (const b of reset) {
    try { await b.onclick(); pressed++; } catch (e) { pressErr = pressErr || e; }
  }
  t("forgetting everything empties the view",
    dom.byId.get("viewout").innerHTML.includes("cells loaded : 0 of 11"));
  t(pressed + " controls pressed, none of them threw", pressErr === null);
  const shellout = dom.byId.get("shellout").textContent;
  t("the page shows the batches", shellout.includes("R0 = ") && shellout.includes("R2 = "));
  t("the page shows the overlay", dom.byId.get("m11out").textContent.includes("M11 Cayley"));
}

console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- The self-test file. -/
def holoSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Holo/Page.lean. Run: node www/holo-selftest.mjs\n" ++
  "import fs from 'node:fs';\nimport vm from 'node:vm';\n" ++
  dataBlock ++ scriptBlock ++ checksBlock ++ harnessBlock

/-! ## The page -/

/-- The page. -/
def holoPage : String :=
  r##"<!doctype html>
<html lang="en"><head><meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>HOLOGRAPHIC KNOWLEDGE ARCHIVE</title>
<style>
body { background:#07100a; color:#8dff9d; font-family:ui-monospace,Menlo,Consolas,monospace;
       margin:0; padding:1rem; }
h1 { font-size:1.1rem; letter-spacing:.2em; }
h2 { font-size:.85rem; letter-spacing:.18em; color:#4fd07a; margin:1.4rem 0 .4rem; }
table { border-collapse:collapse; font-size:.75rem; }
td, th { border:1px solid #1c4a2a; padding:.2rem .45rem; text-align:right; }
th { color:#4fd07a; font-weight:normal; }
td.k, th.k { text-align:left; }
button { background:#08240f; color:#8dff9d; border:1px solid #2b6b3c; padding:.25rem .5rem;
         font:inherit; cursor:pointer; margin:.1rem; }
button:hover { background:#0e3a18; }
button.on { background:#17612a; }
pre { white-space:pre-wrap; font-size:.72rem; line-height:1.35; }
.dim { color:#3f7d52; }
.bar { display:inline-block; height:.55rem; background:#2fae56; vertical-align:middle; }
</style></head><body>
<h1>HOLOGRAPHIC KNOWLEDGE ARCHIVE</h1>
<p class="dim">One static file. Each concept is one cell at a known byte offset; a client fetches
a cell with a single HTTP range request and decodes it on its own. Links move the coordinate;
the more cells you load, the more of the whole you can see. Everything below is emitted from the
Lean development in <code>RequestProject/NixWars/Holo/</code>.</p>

<h2>THE ARCHIVE</h2>
<div id="table"></div>

<h2>FETCH</h2>
<p class="dim">Click a concept: the page issues <code>Range: bytes=o-(o+l-1)</code> against
<code>holo-archive.bin</code> when it is served over HTTP, and falls back to slicing the copy of
the file embedded below when opened from disk. Either way only the cell's own bytes are decoded.</p>
<div id="buttons"></div>
<pre id="out"></pre>

<h2>YOUR VIEW</h2>
<pre id="viewout"></pre>

<h2>DEPTH: STAGGERED BATCHES</h2>
<p class="dim">Pick a seed and a depth: R0, R1, R2 are the shells, each one batch of requests.</p>
<div id="shellbuttons"></div>
<pre id="shellout"></pre>

<h2>THE M11 OVERLAY</h2>
<pre id="m11out"></pre>

<h2>THE FILE</h2>
<pre id="bytes"></pre>
<p class="dim"><a href="index.html" style="color:#4fd07a">back to the lobby</a></p>
<script>
"##
  ++ dataBlock ++ scriptBlock ++ r##"
const out = document.getElementById("out");
const viewout = document.getElementById("viewout");
let loaded = [];

function fmt(c) { return CELLS.find(x => x.key === c).name; }

function renderTable() {
  let h = "<table><tr><th class='k'>concept</th><th>key</th><th>offset</th><th>bytes</th>" +
    "<th class='k'>links</th><th class='k'>M11 address</th></tr>";
  for (const c of CELLS)
    h += "<tr><td class='k'>" + c.name + "</td><td>" + c.key + "</td><td>" + c.off +
      "</td><td>" + c.len + "</td><td class='k'>" + c.links.map(fmt).join(", ") +
      "</td><td class='k'>(" + c.coord.join(" ") + ")</td></tr>";
  document.getElementById("table").innerHTML = h + "</table>";
}

async function fetchCell(c) {
  let bytes = null, how = "embedded copy";
  try {
    const r = await fetch("holo-archive.bin",
      { headers: { Range: "bytes=" + c.off + "-" + (c.off + c.len - 1) } });
    if (r.ok) {
      const buf = new Uint8Array(await r.arrayBuffer());
      bytes = Array.from(buf.length === c.len ? buf : buf.slice(c.off, c.off + c.len));
      how = r.status === 206 ? "HTTP 206 partial content" : "HTTP 200, sliced locally";
    }
  } catch (e) { bytes = null; }
  if (bytes === null) bytes = range(BYTES, c.off, c.len);
  const got = decodeCell(bytes);
  if (!loaded.includes(c.key)) loaded.push(c.key);
  out.textContent =
    "GET holo-archive.bin\nRange: bytes=" + c.off + "-" + (c.off + c.len - 1) +
    "\n   (" + how + ")\n\n" +
    "bytes   " + bytes.join(" ") + "\n" +
    "cell    " + c.name + "  (key " + got.cell.key + ")\n" +
    "carries " + got.cell.payload.join(", ") + "\n" +
    "links   " + got.cell.links.map(fmt).join(", ") + "\n" +
    "address (" + c.coord.join(" ") + ")\n" +
    "left over after decoding: " + got.rest.length + " bytes";
  renderView();
}

function renderView() {
  const v = view(CELLS, loaded);
  const pct = Math.round(100 * v.length / [].concat(...CELLS.map(c => c.payload)).length);
  viewout.innerHTML =
    "cells loaded : " + loaded.length + " of " + CELLS.length + "  (" +
      loaded.map(fmt).join(", ") + ")\n" +
    "bytes fetched: " + loaded.reduce((s, k) => s + CELLS.find(c => c.key === k).len, 0) +
      " of " + BYTES.length + "\n" +
    "supporting material in view: " + v.length + "\n" +
    "<span class='bar' style='width:" + (pct * 2) + "px'></span> " + pct + "% of the corpus";
  for (const b of document.querySelectorAll("#buttons button"))
    b.className = loaded.includes(Number(b.dataset.key)) ? "on" : "";
}

function renderButtons() {
  const d = document.getElementById("buttons");
  for (const c of CELLS) {
    const b = document.createElement("button");
    b.textContent = c.name;
    b.dataset.key = String(c.key);
    b.onclick = () => fetchCell(c);
    d.appendChild(b);
  }
  const r = document.createElement("button");
  r.textContent = "FORGET EVERYTHING";
  r.onclick = () => { loaded = []; out.textContent = ""; renderView(); };
  d.appendChild(r);
}

function renderShells(k) {
  let s = "seed: " + fmt(k) + "\n";
  let requests = 0, bytes = 0;
  for (let d = 0; d < 3; d++) {
    const R = shell(CELLS, k, d);
    requests += R.length ? 1 : 0;
    bytes += R.reduce((a, x) => a + CELLS.find(c => c.key === x).len, 0);
    s += "R" + d + " = { " + R.map(fmt).join(", ") + " }\n";
  }
  s += "\n" + requests + " batches, " + bytes + " bytes, " +
    ball(CELLS, k, 2).length + " cells within depth 2.";
  document.getElementById("shellout").textContent = s;
}

function renderShellButtons() {
  const d = document.getElementById("shellbuttons");
  for (const c of CELLS) {
    const b = document.createElement("button");
    b.textContent = c.name;
    b.onclick = () => renderShells(c.key);
    d.appendChild(b);
  }
}

function renderM11() {
  let s = "Each concept is given the M11 element a^i, and the overlay predicts a link exactly\n" +
    "when two concepts differ by one generator of M11.\n\n";
  for (const m of MODELS)
    s += m.name.padEnd(12) + " model " + String(m.cost).padStart(4) + " bits" +
      " + residual " + String(m.residual).padStart(3) + " pairs x 8 bits" +
      " = " + String(m.dl).padStart(4) + " bits\n";
  const best = MODELS.reduce((a, b) => (b.dl < a.dl ? b : a));
  s += "\nsmallest description: " + best.name +
    "  (the structure is selected, not imposed)\n" +
    "residual pairs are kept, not discarded: model + residual reproduces the archive exactly.";
  document.getElementById("m11out").textContent = s;
}

function renderBytes() {
  let s = "";
  for (const c of CELLS) {
    s += String(c.off).padStart(3, "0") + "  " +
      range(BYTES, c.off, c.len).map(b => String(b).padStart(3)).join(" ") +
      "   " + c.name + "\n";
  }
  document.getElementById("bytes").textContent = s;
}

renderTable(); renderButtons(); renderShellButtons(); renderView();
renderShells(0); renderM11(); renderBytes();
</script>
</body></html>
"##

/-- Write the archive file, the page and the self-test. -/
def writeHolo : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeBinFile "www/holo-archive.bin"
    (ByteArray.mk (archiveBytes.map (fun b => UInt8.ofNat b)).toArray)
  IO.FS.writeFile "www/holo.html" holoPage
  IO.FS.writeFile "www/holo-selftest.mjs" holoSelfTest
  IO.println s!"holo: archive {archiveBytes.length} bytes, page {holoPage.length} bytes, \
    self-test {holoSelfTest.length} bytes"

#eval writeHolo

end Page
end Holo
end NixWars
