import RequestProject.Gvcs.Rig.Stock

/-!
# The single page

`web/rigs.html` is the whole game in one file: the workshop, the course, the
shell, the tables generated from the Lean definitions, and the WebAssembly
module of `RequestProject/Rig/Wasm.lean` sealed in as text.  There is no
`<script src=...>`, no `<link>`, no image and no `fetch`, so opening the file
from disk is enough to build a machine and drive it.
-/

namespace LifeTrac
namespace Rig

open Wasm Web

/-! ## The page -/

/-- A string as a JavaScript string literal. -/
def jsStr (s : String) : String :=
  "\"" ++ ((s.replace "\\" "\\\\").replace "\"" "\\\"") ++ "\""

/-- A list of integers as a JavaScript array. -/
def jsInts (l : List Int) : String :=
  "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- A list of naturals as a JavaScript array. -/
def jsNats (l : List Nat) : String :=
  "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- The nine tables, as JavaScript, taken from the Lean definitions. -/
def tablesJs : String :=
  "const TBL = [" ++ String.intercalate ",\n  "
    ((List.range 9).map (fun j => jsInts ((List.range 7).map (tables.getD j massTbl)))) ++ "];\n"

/-- The constants of the game, as JavaScript, taken from the Lean
definitions. -/
def constsJs : String :=
  "const GRIDW = " ++ toString gridW ++ ", GRIDH = " ++ toString gridH ++
    ", GRIDD = " ++ toString gridD ++ ", GRIDN = " ++ toString gridN ++ ";\n" ++
  "const KINDN = " ++ toString kindN ++ ", BUDGET = " ++ toString budget ++ ";\n" ++
  "const TRACK = " ++ toString track ++ ", LANEMAX = " ++ toString laneMax ++
    ", VMAX = " ++ toString vmax ++ ";\n" ++
  "const ZONELO = " ++ toString zoneLo ++ ", ZONEHI = " ++ toString zoneHi ++
    ", ZONELANE = " ++ toString zoneLane ++ ", BITE = " ++ toString bite ++ ";\n" ++
  "const TICKHZ = " ++ toString tickHz ++ ", DEADZONE = " ++ toString deadZone ++
    ", TAPR = " ++ toString tapRadius ++ ", HOLDMS = " ++ toString holdMs ++ ";\n" ++
  "const B64 = " ++ jsStr (String.ofList b64Alphabet) ++ ";\n" ++
  "const STOCK = [" ++ String.intercalate ",\n  " (stockDesigns.map (fun p =>
    "{name:" ++ jsStr p.1 ++ ", cells:" ++ jsNats (cellsOf p.2) ++ "}")) ++ "];\n" ++
  tablesJs

/-- The head of the document: the shell and the stylesheet. -/
def headHtml : String := r####"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no, viewport-fit=cover">
<title>Rig Rally — build it, then drive it</title>
<style>
:root {
  --bg: #14161a; --panel: #1e222a; --line: #2c313c; --ink: #e8ecf4;
  --dim: #97a1b4; --hot: #ffb43f; --good: #63d18a; --bad: #ef6d6d;
}
* { box-sizing: border-box; -webkit-tap-highlight-color: transparent; }
html, body {
  margin: 0; padding: 0; height: 100%; background: var(--bg); color: var(--ink);
  font: 15px/1.4 ui-sans-serif, system-ui, -apple-system, "Segoe UI", Roboto, sans-serif;
  overscroll-behavior: none; touch-action: manipulation; user-select: none;
}
#app { display: flex; flex-direction: column; height: 100%; max-width: 720px; margin: 0 auto; }
header {
  display: flex; align-items: center; gap: 8px; padding: 8px 10px;
  border-bottom: 1px solid var(--line); background: var(--panel);
}
header h1 { font-size: 15px; margin: 0; font-weight: 650; letter-spacing: .02em; }
header .sp { flex: 1; }
button {
  font: inherit; color: var(--ink); background: var(--panel); border: 1px solid var(--line);
  border-radius: 10px; padding: 8px 12px; cursor: pointer;
}
button:active { background: #2a3040; }
button.on { border-color: var(--hot); color: var(--hot); }
main { flex: 1; overflow: auto; -webkit-overflow-scrolling: touch; }
.pane { display: none; padding: 10px; }
.pane.on { display: block; }
.row { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
.card { background: var(--panel); border: 1px solid var(--line); border-radius: 12px; padding: 10px; margin-bottom: 10px; }
.card h2 { font-size: 13px; margin: 0 0 8px; color: var(--dim); text-transform: uppercase; letter-spacing: .08em; }
#grid { touch-action: none; width: 100%; height: auto; display: block; border-radius: 10px; background: #10131a; }
.pal { display: grid; grid-template-columns: repeat(4, 1fr); gap: 6px; }
.pal button { display: flex; align-items: center; gap: 6px; justify-content: flex-start; padding: 7px 8px; font-size: 13px; }
.sw { width: 14px; height: 14px; border-radius: 4px; border: 1px solid #0006; }
table.stats { width: 100%; border-collapse: collapse; font-variant-numeric: tabular-nums; }
table.stats td { padding: 2px 0; }
table.stats td:last-child { text-align: right; color: var(--hot); }
.bar { height: 8px; border-radius: 4px; background: #0d1017; overflow: hidden; }
.bar > i { display: block; height: 100%; background: var(--good); }
.bad > i { background: var(--bad); }
.verdict { font-weight: 650; }
.ok { color: var(--good); } .no { color: var(--bad); }
#code { width: 100%; font: 13px/1.4 ui-monospace, SFMono-Regular, Menlo, monospace;
  background: #10131a; color: var(--ink); border: 1px solid var(--line); border-radius: 10px; padding: 8px; }
#stage { touch-action: none; width: 100%; display: block; background: #0d1017; border-radius: 12px; }
#pads { position: relative; height: 190px; margin-top: 8px; touch-action: none; }
.pad { position: absolute; bottom: 6px; width: 132px; height: 132px; border-radius: 50%;
  background: radial-gradient(circle at 50% 50%, #232a36, #171b23); border: 1px solid var(--line); }
.pad .knob { position: absolute; left: 50%; top: 50%; width: 54px; height: 54px; margin: -27px 0 0 -27px;
  border-radius: 50%; background: #39445a; border: 1px solid #4a5670; }
.pad.left { left: 6px; } .pad.right { right: 6px; }
.pad .cap { position: absolute; width: 100%; text-align: center; top: -20px; color: var(--dim); font-size: 12px; }
.btns { position: absolute; left: 50%; bottom: 12px; transform: translateX(-50%); display: flex; flex-direction: column; gap: 8px; }
.btns button { width: 104px; height: 56px; border-radius: 14px; font-weight: 650; }
.hud { display: grid; grid-template-columns: repeat(4, 1fr); gap: 6px; margin-top: 8px; }
.hud div { background: var(--panel); border: 1px solid var(--line); border-radius: 10px; padding: 6px 8px; }
.hud b { display: block; font-size: 11px; color: var(--dim); font-weight: 500; text-transform: uppercase; letter-spacing: .06em; }
.hud span { font-variant-numeric: tabular-nums; font-size: 17px; }
.note { color: var(--dim); font-size: 12px; margin-top: 6px; }
footer { padding: 8px 10px; border-top: 1px solid var(--line); color: var(--dim); font-size: 12px; }
</style>
</head>
<body>
<div id="app">
<header>
  <h1>Rig Rally</h1>
  <span class="sp"></span>
  <button id="tabBuild" class="on">Build</button>
  <button id="tabDrive">Drive</button>
</header>
<main>
  <section id="paneBuild" class="pane on">
    <div class="card">
      <h2>Layer <span id="layerNo">1</span> of 2 — tap to place, swipe to turn</h2>
      <canvas id="grid" width="640" height="340"></canvas>
      <div class="note">Swipe left or right on the grid to turn it over; swipe up or down
      to pick the next block. Tap a cell holding the same block to take it off.</div>
    </div>
    <div class="card">
      <h2>Blocks</h2>
      <div class="pal" id="pal"></div>
    </div>
    <div class="card">
      <h2>The machine</h2>
      <table class="stats" id="statTbl"></table>
      <div style="margin:8px 0 4px" class="bar" id="costBar"><i style="width:0%"></i></div>
      <div class="verdict" id="verdict"></div>
    </div>
    <div class="card">
      <h2>Share</h2>
      <textarea id="code" rows="2" spellcheck="false"></textarea>
      <div class="row" style="margin-top:8px">
        <button id="copy">Copy code</button>
        <button id="load">Load code</button>
        <button id="clear">Empty grid</button>
      </div>
      <div class="row" style="margin-top:8px" id="stockRow"></div>
      <div class="note" id="shareNote">Thirty-five characters. Paste one in and press Load.</div>
    </div>
  </section>
  <section id="paneDrive" class="pane">
    <canvas id="stage" width="640" height="300"></canvas>
    <div class="hud">
      <div><b>Speed</b><span id="hSpeed">0</span></div>
      <div><b>Load</b><span id="hLoad">0</span></div>
      <div><b>Fuel</b><span id="hFuel">0</span></div>
      <div><b>Score</b><span id="hScore">0</span></div>
    </div>
    <div id="pads">
      <div class="pad left" id="padL"><div class="cap">steer</div><div class="knob" id="knobL"></div></div>
      <div class="btns">
        <button id="bScoop">SCOOP</button>
        <button id="bBrake">BRAKE</button>
      </div>
      <div class="pad right" id="padR"><div class="cap">throttle</div><div class="knob" id="knobR"></div></div>
    </div>
    <div class="note" id="driveNote"></div>
    <div class="row" style="margin-top:8px"><button id="restart">Restart run</button></div>
  </section>
</main>
<footer id="foot">Built from a Lean development: the rule book is compiled to WebAssembly and the page carries it.</footer>
</div>
<script>
"####

/-- The interface: the workshop, the course and the controls. -/
def uiJs : String := r####"
// ---------------------------------------------------------------------------
// The blocks.  Names and colours only: every number about a block comes from
// TBL, which is generated from the Lean tables.
const KINDS = [
  {name:"empty",   col:"#171b23"},
  {name:"frame",   col:"#7f8ba3"},
  {name:"wheel",   col:"#3f4756"},
  {name:"engine",  col:"#ef6d6d"},
  {name:"tank",    col:"#63a7d1"},
  {name:"ballast", col:"#8c6b3f"},
  {name:"scoop",   col:"#ffb43f"}
];
const STATNAMES = ["mass","power","grip","capacity","cost","fuel","wheels","engines","tanks"];
const STATUNIT  = ["kg","","mm/tick","kg","","ml","","",""];

let W = null;                 // the module's exports
let design = new Array(GRIDN).fill(0);
let layer = 0, kind = 1;
let mode = "build";
let timer = null;

// ---------------------------------------------------------------------------
// Share codes.  This is the same format as RequestProject/Rig/Share.lean:
// two cells to a base64 character, a version prefix, and a checksum.
function packPairs(cells) {
  const out = [];
  for (let i = 0; i + 1 < cells.length; i += 2) out.push(cells[i] * 7 + cells[i + 1]);
  if (cells.length % 2) out.push(cells[cells.length - 1] * 7);
  return out;
}
function unpackPairs(vals) {
  const out = [];
  for (const v of vals) { out.push(Math.floor(v / 7)); out.push(v % 7); }
  return out;
}
function shareSum(vals) {
  let s = 0;
  for (const v of vals) s += v;
  return (s + vals.length) % 64;
}
function encodeDesign(cells) {
  const vals = packPairs(cells);
  let s = "R1";
  for (const v of vals) s += B64[v];
  return s + B64[shareSum(vals)];
}
function decodeDesign(str) {
  const s = (str || "").trim();
  if (s.length !== 35 || s[0] !== "R" || s[1] !== "1") return null;
  const rest = s.slice(2);
  const vals = [];
  for (let i = 0; i < 32; i++) {
    const v = B64.indexOf(rest[i]);
    if (v < 0 || v >= 49) return null;
    vals.push(v);
  }
  if (B64.indexOf(rest[32]) !== shareSum(vals)) return null;
  return unpackPairs(vals);
}

// ---------------------------------------------------------------------------
// The design, and the module's copy of it.
function pushDesign() {
  for (let i = 0; i < GRIDN; i++) W.place(BigInt(i), BigInt(design[i]));
}
function setCell(i, k) { design[i] = k; W.place(BigInt(i), BigInt(k)); refreshBuild(); }
function stats() {
  const out = [];
  for (let j = 0; j < 9; j++) out.push(Number(W.stat(BigInt(j))));
  return out;
}

// ---------------------------------------------------------------------------
// The workshop.
const grid = document.getElementById("grid");
const gx = grid.getContext("2d");

function cellRect(i) {
  const z = Math.floor(i / (GRIDW * GRIDH));
  const r = i % (GRIDW * GRIDH);
  const x = r % GRIDW, y = Math.floor(r / GRIDW);
  const pad = 8, sq = Math.floor((grid.width - 2 * pad) / GRIDW);
  return {x: pad + x * sq, y: pad + (GRIDH - 1 - y) * sq, s: sq, z: z, cx: x, cy: y};
}
function drawGrid() {
  gx.clearRect(0, 0, grid.width, grid.height);
  const pad = 8, sq = Math.floor((grid.width - 2 * pad) / GRIDW);
  grid.height = 2 * pad + GRIDH * sq;
  gx.fillStyle = "#10131a";
  gx.fillRect(0, 0, grid.width, grid.height);
  // the other layer, as a ghost
  for (let i = 0; i < GRIDN; i++) {
    const r = cellRect(i);
    if (r.z === layer || design[i] === 0) continue;
    gx.fillStyle = KINDS[design[i]].col;
    gx.globalAlpha = 0.18;
    gx.fillRect(r.x + 2, r.y + 2, r.s - 4, r.s - 4);
    gx.globalAlpha = 1;
  }
  for (let i = 0; i < GRIDN; i++) {
    const r = cellRect(i);
    if (r.z !== layer) continue;
    gx.strokeStyle = "#2c313c";
    gx.lineWidth = 1;
    gx.strokeRect(r.x + 0.5, r.y + 0.5, r.s - 1, r.s - 1);
    if (design[i] === 0) continue;
    gx.fillStyle = KINDS[design[i]].col;
    roundRect(gx, r.x + 3, r.y + 3, r.s - 6, r.s - 6, 5);
    gx.fill();
    if (design[i] === 2) {                    // a wheel gets a hub
      gx.fillStyle = "#10131a";
      gx.beginPath();
      gx.arc(r.x + r.s / 2, r.y + r.s / 2, r.s * 0.16, 0, 6.284);
      gx.fill();
    }
  }
  document.getElementById("layerNo").textContent = String(layer + 1);
}
function roundRect(c, x, y, w, h, r) {
  c.beginPath();
  c.moveTo(x + r, y);
  c.arcTo(x + w, y, x + w, y + h, r);
  c.arcTo(x + w, y + h, x, y + h, r);
  c.arcTo(x, y + h, x, y, r);
  c.arcTo(x, y, x + w, y, r);
  c.closePath();
}
function refreshBuild() {
  drawGrid();
  const s = stats();
  const t = document.getElementById("statTbl");
  t.innerHTML = "";
  for (let j = 0; j < 9; j++) {
    const tr = document.createElement("tr");
    const a = document.createElement("td"), b = document.createElement("td");
    a.textContent = STATNAMES[j];
    b.textContent = s[j] + (STATUNIT[j] ? " " + STATUNIT[j] : "");
    tr.appendChild(a); tr.appendChild(b); t.appendChild(tr);
  }
  const bar = document.getElementById("costBar");
  const frac = Math.min(1, s[4] / BUDGET);
  bar.firstElementChild.style.width = (100 * frac).toFixed(1) + "%";
  bar.className = "bar" + (s[4] > BUDGET ? " bad" : "");
  const v = Number(W.valid()) === 1;
  const why = [];
  if (s[6] < 2) why.push("two wheels");
  if (s[7] < 1) why.push("an engine");
  if (s[8] < 1) why.push("a tank");
  if (s[4] > BUDGET) why.push("a bill of at most " + BUDGET);
  document.getElementById("verdict").innerHTML = v
    ? '<span class="ok">Ready to drive — ' + s[4] + " of " + BUDGET + "</span>"
    : '<span class="no">Needs ' + why.join(", ") + "</span>";
  document.getElementById("code").value = encodeDesign(design);
  drawPalette();
}
function drawPalette() {
  const pal = document.getElementById("pal");
  pal.innerHTML = "";
  for (let k = 0; k < KINDN; k++) {
    const b = document.createElement("button");
    if (k === kind) b.className = "on";
    const sw = document.createElement("span");
    sw.className = "sw";
    sw.style.background = KINDS[k].col;
    b.appendChild(sw);
    const lab = document.createElement("span");
    lab.textContent = k === 0 ? "erase" : KINDS[k].name + " " + TBL[4][k];
    b.appendChild(lab);
    b.onclick = () => { kind = k; refreshBuild(); };
    pal.appendChild(b);
  }
}

// ---------------------------------------------------------------------------
// Gestures.  classify() is RequestProject/Rig/Touch.lean's reading of a drag.
function classify(dx, dy, dt) {
  if (Math.abs(dx) <= TAPR && Math.abs(dy) <= TAPR) return dt < HOLDMS ? "tap" : "hold";
  if (Math.abs(dy) <= Math.abs(dx)) return dx > 0 ? "right" : "left";
  return dy > 0 ? "down" : "up";
}
let gStart = null;
grid.addEventListener("pointerdown", (e) => {
  grid.setPointerCapture(e.pointerId);
  const r = grid.getBoundingClientRect();
  gStart = {x: e.clientX - r.left, y: e.clientY - r.top, t: Date.now()};
});
grid.addEventListener("pointerup", (e) => {
  if (!gStart) return;
  const r = grid.getBoundingClientRect();
  const sc = grid.width / r.width;
  const px = (e.clientX - r.left), py = (e.clientY - r.top);
  const g = classify(px - gStart.x, py - gStart.y, Date.now() - gStart.t);
  gStart = null;
  if (g === "left")  { layer = (layer + GRIDD - 1) % GRIDD; refreshBuild(); return; }
  if (g === "right") { layer = (layer + 1) % GRIDD; refreshBuild(); return; }
  if (g === "up")    { kind = (kind + 1) % KINDN; refreshBuild(); return; }
  if (g === "down")  { kind = (kind + KINDN - 1) % KINDN; refreshBuild(); return; }
  // a tap: which cell?
  const pad = 8, sq = Math.floor((grid.width - 2 * pad) / GRIDW);
  const cx = Math.floor((px * sc - pad) / sq);
  const cyTop = Math.floor((py * sc - pad) / sq);
  const cy = GRIDH - 1 - cyTop;
  if (cx < 0 || cx >= GRIDW || cy < 0 || cy >= GRIDH) return;
  const i = cx + GRIDW * cy + GRIDW * GRIDH * layer;
  setCell(i, design[i] === kind ? 0 : kind);
});

// ---------------------------------------------------------------------------
// The course.
const stage = document.getElementById("stage");
const sx = stage.getContext("2d");
let held = {up:false, down:false, left:false, right:false, scoop:false, brake:false};
let padL = {x:0, y:0, on:false, id:-1}, padR = {x:0, y:0, on:false, id:-1};

function stickAxis(r, p) {                    // RequestProject/Rig/Touch.lean
  const rr = Math.max(1, r);
  let raw = Math.trunc(p * 1000 / rr);
  if (raw > 1000) raw = 1000;
  if (raw < -1000) raw = -1000;
  if (raw > -DEADZONE && raw < DEADZONE) return 0;
  return raw;
}
function keyAxis(neg, pos) { return (pos ? 1000 : 0) - (neg ? 1000 : 0); }
function axes() {
  const r = 66;
  let st = padL.on ? stickAxis(r, padL.x) : keyAxis(held.left, held.right);
  let th = padR.on ? stickAxis(r, -padR.y) : keyAxis(held.down, held.up);
  return {th: th, st: st};
}
function bindPad(el, knob, st) {
  const move = (e) => {
    const r = el.getBoundingClientRect();
    const dx = e.clientX - (r.left + r.width / 2), dy = e.clientY - (r.top + r.height / 2);
    const lim = r.width / 2;
    const d = Math.hypot(dx, dy) || 1;
    const k = Math.min(1, lim / d);
    st.x = Math.round(dx * (r.width ? 132 / r.width : 1));
    st.y = Math.round(dy * (r.width ? 132 / r.width : 1));
    knob.style.transform = "translate(" + (dx * k) + "px," + (dy * k) + "px)";
  };
  el.addEventListener("pointerdown", (e) => {
    el.setPointerCapture(e.pointerId); st.on = true; st.id = e.pointerId; move(e);
    e.preventDefault();
  });
  el.addEventListener("pointermove", (e) => { if (st.on && st.id === e.pointerId) move(e); });
  const off = (e) => {
    if (st.id !== e.pointerId) return;
    st.on = false; st.x = 0; st.y = 0; knob.style.transform = "translate(0,0)";
  };
  el.addEventListener("pointerup", off);
  el.addEventListener("pointercancel", off);
}
function bindHold(el, name) {
  el.addEventListener("pointerdown", (e) => { held[name] = true; el.classList.add("on"); e.preventDefault(); });
  const off = () => { held[name] = false; el.classList.remove("on"); };
  el.addEventListener("pointerup", off);
  el.addEventListener("pointerleave", off);
  el.addEventListener("pointercancel", off);
}
const KEYMAP = {ArrowUp:"up", ArrowDown:"down", ArrowLeft:"left", ArrowRight:"right",
                w:"up", s:"down", a:"left", d:"right", W:"up", S:"down", A:"left", D:"right",
                " ":"scoop", Shift:"brake"};
addEventListener("keydown", (e) => { const k = KEYMAP[e.key]; if (k) { held[k] = true; e.preventDefault(); } });
addEventListener("keyup", (e) => { const k = KEYMAP[e.key]; if (k) { held[k] = false; e.preventDefault(); } });

function state() {
  const g = [];
  for (let j = 0; j < 7; j++) g.push(Number(W.get(BigInt(j))));
  return {pos:g[0], lane:g[1], vel:g[2], fuel:g[3], load:g[4], score:g[5], ticks:g[6]};
}
function step() {
  const a = axes();
  W.tick(BigInt(a.th), BigInt(a.st), BigInt(held.scoop ? 1 : 0), BigInt(held.brake ? 1 : 0));
}
function drawStage() {
  const s = state(), st = stats();
  const w = stage.width, h = stage.height;
  sx.clearRect(0, 0, w, h);
  sx.fillStyle = "#0d1017"; sx.fillRect(0, 0, w, h);
  // the track: a ribbon seen from above, scrolling under the machine
  const mmPerPx = 26;
  const y0 = h / 2;
  const laneToY = (mm) => y0 + mm / (2 * LANEMAX) * (h - 60);
  sx.fillStyle = "#171b23";
  sx.fillRect(0, laneToY(-LANEMAX), w, laneToY(LANEMAX) - laneToY(-LANEMAX));
  // the pickup zone and the line
  const posToX = (mm) => w / 3 + (mm - s.pos) / mmPerPx;
  sx.fillStyle = "#2a2410";
  sx.fillRect(posToX(ZONELO), laneToY(-ZONELANE), (ZONEHI - ZONELO) / mmPerPx,
              laneToY(ZONELANE) - laneToY(-ZONELANE));
  sx.strokeStyle = "#3a414f";
  sx.setLineDash([8, 10]);
  sx.beginPath(); sx.moveTo(0, y0); sx.lineTo(w, y0); sx.stroke();
  sx.setLineDash([]);
  for (const line of [0, TRACK]) {
    sx.strokeStyle = "#e8ecf4"; sx.lineWidth = 3;
    sx.beginPath(); sx.moveTo(posToX(line), laneToY(-LANEMAX)); sx.lineTo(posToX(line), laneToY(LANEMAX)); sx.stroke();
  }
  // bales in the zone
  sx.fillStyle = "#c9a227";
  for (let k = 0; k < 5; k++) {
    const mm = ZONELO + k * (ZONEHI - ZONELO) / 4;
    sx.fillRect(posToX(mm) - 5, laneToY(0) - 5, 10, 10);
  }
  // the machine, drawn from its own blocks, seen from above
  const cx = w / 3, cy = laneToY(s.lane);
  sx.save();
  sx.translate(cx, cy);
  const cell = 7;
  for (let i = 0; i < GRIDN; i++) {
    if (design[i] === 0) continue;
    const r = i % (GRIDW * GRIDH), z = Math.floor(i / (GRIDW * GRIDH));
    const bx = r % GRIDW, by = Math.floor(r / GRIDW);
    sx.fillStyle = KINDS[design[i]].col;
    sx.globalAlpha = 0.35 + 0.65 * (by / GRIDH);
    sx.fillRect((bx - GRIDW / 2) * cell, (z - GRIDD / 2) * cell * 2, cell - 1, cell * 2 - 1);
  }
  sx.globalAlpha = 1;
  sx.restore();
  // the head-up figures
  document.getElementById("hSpeed").textContent = (s.vel * 3.6 / 1000).toFixed(1) + " km/h";
  document.getElementById("hLoad").textContent = s.load + " / " + st[3] + " kg";
  document.getElementById("hFuel").textContent = s.fuel + " ml";
  document.getElementById("hScore").textContent = s.score;
  const lap = (100 * s.pos / TRACK).toFixed(0);
  document.getElementById("driveNote").textContent =
    "Lap " + lap + "% — " + (s.fuel > 0 ? "engine running" : "out of fuel") +
    " — " + (s.ticks / TICKHZ).toFixed(1) + " s";
}
function loop() {
  if (mode === "drive") drawStage();
  requestAnimationFrame(loop);
}

// ---------------------------------------------------------------------------
// Wiring.
function setMode(m) {
  mode = m;
  document.getElementById("paneBuild").className = "pane" + (m === "build" ? " on" : "");
  document.getElementById("paneDrive").className = "pane" + (m === "drive" ? " on" : "");
  document.getElementById("tabBuild").className = m === "build" ? "on" : "";
  document.getElementById("tabDrive").className = m === "drive" ? "on" : "";
  if (m === "drive") {
    pushDesign();
    W.reset();
    if (timer) clearInterval(timer);
    timer = setInterval(step, 1000 / TICKHZ);
  } else if (timer) { clearInterval(timer); timer = null; }
}
function start(mod) {
  W = mod.instance.exports;
  bindPad(document.getElementById("padL"), document.getElementById("knobL"), padL);
  bindPad(document.getElementById("padR"), document.getElementById("knobR"), padR);
  bindHold(document.getElementById("bScoop"), "scoop");
  bindHold(document.getElementById("bBrake"), "brake");
  document.getElementById("tabBuild").onclick = () => setMode("build");
  document.getElementById("tabDrive").onclick = () => setMode("drive");
  document.getElementById("restart").onclick = () => { pushDesign(); W.reset(); };
  document.getElementById("copy").onclick = () => {
    const ta = document.getElementById("code");
    ta.select();
    navigator.clipboard ? navigator.clipboard.writeText(ta.value) : document.execCommand("copy");
    document.getElementById("shareNote").textContent = "Copied. Send it to anybody with this page.";
  };
  document.getElementById("load").onclick = () => {
    const cells = decodeDesign(document.getElementById("code").value);
    const note = document.getElementById("shareNote");
    if (!cells) { note.textContent = "That is not a code: check the length and the last character."; return; }
    design = cells.slice(0, GRIDN);
    pushDesign();
    note.textContent = "Loaded.";
    refreshBuild();
  };
  document.getElementById("clear").onclick = () => {
    design = new Array(GRIDN).fill(0);
    pushDesign(); refreshBuild();
  };
  const row = document.getElementById("stockRow");
  for (const d of STOCK) {
    const b = document.createElement("button");
    b.textContent = d.name;
    b.onclick = () => { design = d.cells.slice(); pushDesign(); refreshBuild(); };
    row.appendChild(b);
  }
  design = STOCK[0].cells.slice();
  pushDesign();
  refreshBuild();
  loop();
}
"####

/-- The loader: the payload, the keystream, and the instantiation. -/
def loaderJs : String :=
  "\n// ---- the module, masked and in base64 ----\n" ++
  "const RIG_KEY = " ++ toString rigKey ++ ";\n" ++
  "const PAYLOAD = \"" ++ rigPayload ++ "\";\n" ++
  r####"
// Undo the mask and the base64: the bytes of the module.  This is
// RequestProject/Web/Base64.lean's keystream, and recoverBytes_payloadOf says
// it returns exactly the bytes the extractor put in.
function moduleBytes(seed) {
  const raw = atob(PAYLOAD);
  const out = new Uint8Array(raw.length);
  let s = BigInt(seed);
  for (let i = 0; i < raw.length; i++) {
    out[i] = raw.charCodeAt(i) ^ Number((s / 65536n) % 256n);
    s = (1103515245n * s + 12345n) % 4294967296n;
  }
  return out;
}

if (typeof document !== "undefined" && document.getElementById("app")) {
  WebAssembly.instantiate(moduleBytes(RIG_KEY).buffer).then(function (res) {
    start(res);
    document.getElementById("foot").textContent =
      "One file: the rule book travelled in " + PAYLOAD.length +
      " characters of base64, masked with the keystream of seed " + RIG_KEY +
      ". Everything the page computes about a machine is computed by that module.";
  });
}
</script>
</body>
</html>
"####

/-- **The page.** -/
def rigPage : String := headHtml ++ constsJs ++ uiJs ++ loaderJs

end Rig
end LifeTrac
