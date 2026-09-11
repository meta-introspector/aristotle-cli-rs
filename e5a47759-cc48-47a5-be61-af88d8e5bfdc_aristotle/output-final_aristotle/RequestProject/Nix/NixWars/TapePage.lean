import RequestProject.Nix.NixWars.Universe
import RequestProject.Nix.NixWars.WasmBinary

/-!
# The tape room: `www/tape.html`

The room where a game is *recorded*. Pick a door, press commands, and the page
writes them down as a tape; the tape is a code, the code is in the address bar,
and the address bar is the whole game. Paste someone else's code and you are
playing their game, turn by turn, from the same start.

Everything the page knows comes from Lean:

* the fifteen doors, their commands, their starting vectors and what winning
  means (`Agents.agentCards`);
* the recorded lesson of each door — how to play it — as a code
  (`Tape.lesson`, `Tape.code`), with the winning vector Lean proves it reaches;
* the address of every tape in the `71 × 59 × 47` grid (`Universe.place`), and
  the catalog those addresses file it under (`Universe.catalog`);
* the WebAssembly module that actually plays it (`Wasm.wasmBytes`).

`www/tape-selftest.mjs` runs the same checks headless: it lifts the module out
of the page, decodes every lesson code, replays it, and compares the result
with the vector Lean computed.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace TapePage

open Agents

/-! ## The data the page carries -/

/-- The commands of a door, in the order the module exports them. -/
def doorCmds (c : Card) : List String :=
  match Tape.doorIdx? c.door with
  | none => []
  | some i =>
    match Tape.doorAt? i with
    | none => []
    | some d => d.table.map Prod.fst

/-- Where a door sits on the board. -/
def doorIndex (c : Card) : Nat := (Tape.doorIdx? c.door).getD 0

/-- The lesson tape of a door, as numbers. -/
def lessonNats (c : Card) : List Nat := ((Tape.lesson c).map Tape.toNats).getD []

/-- The lesson tape of a door, as a pasteable code. -/
def lessonCode (c : Card) : String :=
  match Tape.lesson c with
  | none => ""
  | some p => Tape.code p

/-- The lesson tape of a door, as a whole link. -/
def lessonLink (c : Card) : String :=
  match Tape.lesson c with
  | none => ""
  | some p => Tape.link p

/-- A place in the grid, as JSON. -/
def placeJson (xs : List Nat) : String :=
  let p := Universe.place xs
  "[" ++ toString p.1 ++ "," ++ toString p.2.1 ++ "," ++ toString p.2.2 ++ "]"

/-- One door, as JSON. -/
def doorJson (c : Card) : String :=
  "{\"i\":" ++ toString (doorIndex c) ++
  ",\"name\":\"" ++ c.door ++ "\",\"no\":" ++ toString c.doorNo ++
  ",\"marquee\":\"" ++ c.marquee ++ "\",\"goal\":\"" ++ c.goal ++
  "\",\"fields\":" ++ jsonStrings c.fields ++
  ",\"cmds\":" ++ jsonStrings (doorCmds c) ++
  ",\"start\":" ++ jsonNats c.start ++
  ",\"finish\":" ++ jsonNats c.finish ++
  ",\"turns\":" ++ toString c.moves.length ++
  ",\"code\":\"" ++ lessonCode c ++ "\"" ++
  ",\"link\":\"" ++ lessonLink c ++ "\"" ++
  ",\"place\":" ++ placeJson (lessonNats c) ++ "}"

/-- The doors, as JSON. -/
def doorsJson : String :=
  "[" ++ String.intercalate ",\n" (agentCards.map doorJson) ++ "]"

/-- One catalog item, as JSON: its level, its name, its place in the grid and
what it holds. -/
def itemJson (i : Universe.Item) : String :=
  "{\"level\":" ++ toString i.level ++ ",\"name\":\"" ++ i.name ++
  "\",\"place\":" ++ placeJson i.body ++
  ",\"parts\":" ++ jsonStrings i.parts ++ "}"

/-- The catalog, as JSON. -/
def catalogJson : String :=
  "[" ++ String.intercalate ",\n" (Universe.catalog.map itemJson) ++ "]"

/-! ## The page -/

/-- The tape room. -/
def tapePage : String :=
  r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NixWars &mdash; the tape room</title>
<style>
:root { color-scheme: dark; }
body { margin: 0; background: #04070d; color: #cfe6ff;
  font: 15px/1.5 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
.wrap { max-width: 62rem; margin: 0 auto; padding: 1.1rem 1rem 4rem; }
h1 { font-size: 1.3rem; letter-spacing: .18em; margin: .2rem 0 .1rem; color: #eaf6ff; }
h2 { font-size: .95rem; letter-spacing: .16em; color: #ffd479; margin: 1.5rem 0 .5rem; }
p.sub { color: #7fa6c8; margin: 0 0 1rem; }
a { color: #6ef2c0; }
button { font: inherit; background: #0b1726; color: #cfe6ff; border: 1px solid #21456b;
  border-radius: .3rem; padding: .3rem .6rem; margin: 0 .3rem .35rem 0; cursor: pointer; }
button:hover { background: #16283c; }
button.on { border-color: #6ef2c0; color: #6ef2c0; }
input, select, textarea { font: inherit; background: #071120; color: #cfe6ff;
  border: 1px solid #21456b; border-radius: .3rem; padding: .25rem .4rem; }
textarea { width: 100%; height: 4.5rem; }
.row { display: flex; flex-wrap: wrap; gap: .4rem; align-items: center; margin: .3rem 0; }
.box { border: 1px solid #16283c; border-radius: .4rem; padding: .6rem .7rem; margin: .5rem 0; }
pre { margin: .2rem 0; white-space: pre-wrap; word-break: break-all; }
.tape { color: #6ef2c0; }
.dim { color: #7fa6c8; }
.big { color: #ffd479; font-size: 1.05rem; }
table { border-collapse: collapse; width: 100%; font-size: 13px; }
td, th { border-top: 1px solid #16283c; padding: .25rem .35rem; text-align: left; }
th { color: #7fa6c8; font-weight: 400; }
.ok { color: #6ef2c0; } .bad { color: #ff7b7b; }
</style>
</head>
<body>
<div class="wrap">
<h1>THE TAPE ROOM</h1>
<p class="sub">A game here is a door and the commands you sent to it. That is the
<em>tape</em>, and the tape is a code: it lives in the address bar, so the link you copy
is the game you played. Paste a code to replay someone else's game, one turn at a time.
Nothing is stored anywhere but this page &mdash; the shelf, the pocket and the catalog
below are your own browser.</p>

<div class="box">
<div class="row"><span class="dim">door</span> <select id="door"></select>
<span id="marquee" class="big"></span></div>
<div class="row dim" id="goal"></div>
<div class="row" id="cmds"></div>
<div class="row"><span class="dim">argument</span> <input id="arg" type="number" value="0"
  min="0" style="width:6rem"></div>
</div>

<div class="box">
<div class="row">
<button id="first">&#9198; start</button>
<button id="back">&#9664; back</button>
<button id="fwd">&#9654; forward</button>
<button id="last">&#9197; end</button>
<button id="lesson">how to play</button>
<button id="clear">clear</button>
</div>
<div class="row"><span class="dim">turn</span> <span id="turn" class="big"></span></div>
<pre class="tape" id="strip"></pre>
<pre id="state"></pre>
<div class="row dim">place in the 71 &times; 59 &times; 47 grid: <span id="place" class="big"></span></div>
</div>

<h2>SHARE</h2>
<div class="box">
<div class="row"><span class="dim">code</span></div>
<textarea id="code" spellcheck="false"></textarea>
<div class="row">
<button id="load">play this code</button>
<button id="copycode">copy code</button>
<button id="copylink">copy link</button>
</div>
<div class="row dim" id="says"></div>
</div>

<h2>KEEP IT</h2>
<div class="box">
<div class="row">
<button id="shelf">save to the shelf</button>
<button id="pocket">put in the pocket</button>
<button id="file">file in the catalog</button>
</div>
<div class="row dim">the shelf is <code>localStorage</code>, the pocket is a cookie, and the
catalog files a tape under its own address in the grid &mdash; content, not location.</div>
<div id="saved"></div>
</div>

<h2>THE CATALOG</h2>
<p class="sub">Everything the board holds, filed by level and by address. A catalog only
holds the level below it, so nothing contains itself &mdash; and no two items share a cell
of the grid. Both are proved in <code>RequestProject/NixWars/Universe.lean</code>.</p>
<div class="box"><table id="cat"><tbody></tbody></table></div>

<h2>SELF-CHECK</h2>
<pre id="log"></pre>
<p class="dim">Emitted by <code>RequestProject/NixWars/TapePage.lean</code>. The module that
plays the tapes is the one Lean compiled and proved; the lesson codes and the addresses are
Lean's own. <a href="index.html">back to the main menu</a></p>
</div>
<script>
const DOORS = "##
  ++ doorsJson ++ r##";
const CATALOG = "##
  ++ catalogJson ++ r##";
const WASM = "##
  ++ Wasm.wasmBytesJs ++ r##";

// ---- the codec, exactly as NixWars.Tape.codeCodec ----
// A tape is the numbers [door, cmd, arg, cmd, arg, ...]; each number is written
// in base 64 least significant digit first and closed by a separator.
const ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.";
const SEP = 64;
function encodeNats(ns) {
  let s = "";
  for (let n of ns) {
    if (n < 64) s += ALPHA[n];
    else { while (n >= 64) { s += ALPHA[n % 64]; n = Math.floor(n / 64); } s += ALPHA[n]; }
    s += ALPHA[SEP];
  }
  return s;
}
function decodeNats(txt) {
  const out = [];
  let cur = [];
  for (const ch of txt) {
    const s = ALPHA.indexOf(ch);
    if (s < 0) return null;
    if (s === SEP) { let v = 0; for (let i = cur.length - 1; i >= 0; i--) v = v * 64 + cur[i];
                     out.push(v); cur = []; }
    else cur.push(s);
  }
  return out;                       // an unterminated tail is dropped, as in Lean
}
function codeOfTape(t) {
  const ns = [t.door];
  for (const m of t.moves) { ns.push(m[0]); ns.push(m[1]); }
  return encodeNats(ns);
}
function tapeOfCode(code) {
  const ns = decodeNats(code.trim());
  if (!ns || ns.length === 0 || (ns.length - 1) % 2 !== 0) return null;
  if (!doorByIndex(ns[0])) return null;
  const moves = [];
  for (let i = 1; i < ns.length; i += 2) moves.push([ns[i], ns[i + 1]]);
  return { door: ns[0], moves: moves };
}
function natsOfTape(t) {
  const ns = [t.door];
  for (const m of t.moves) { ns.push(m[0]); ns.push(m[1]); }
  return ns;
}

// ---- the address: NixWars.Universe.place ----
function place(ns) {
  const f = m => { let a = 0; for (let i = ns.length - 1; i >= 0; i--) a = (ns[i] + 71 * a) % m;
                   return a; };
  return [f(71), f(59), f(47)];
}
const showPlace = p => p[0] + ":" + p[1] + ":" + p[2];

// ---- the module ----
let W = null, WERR = null;
try { W = new WebAssembly.Instance(new WebAssembly.Module(new Uint8Array(WASM)), {}).exports; }
catch (e) { WERR = String(e); }

function doorByIndex(i) { return DOORS.find(d => d.i === i) || null; }

function replay(t, upto) {
  const d = doorByIndex(t.door);
  if (!d || !W) return null;
  let st = d.start.slice();
  const n = (upto === undefined) ? t.moves.length : upto;
  for (let k = 0; k < n; k++) {
    const tag = d.cmds[t.moves[k][0]];
    if (tag === undefined) return null;
    st = Array.from(W[d.name + "_" + tag](t.moves[k][1], ...st));
  }
  return st;
}

// ---- the page's own state: one tape and how far along it we are ----
let tape = { door: DOORS[0].i, moves: [] };
let pos = 0;

const $ = id => document.getElementById(id);
const say = s => { $("says").textContent = s; };

function shown() { return { door: tape.door, moves: tape.moves.slice(0, pos) }; }

function pushHash() {
  const code = codeOfTape(shown());
  if (location.hash.slice(1) !== code) location.hash = code;
}

function render() {
  const d = doorByIndex(tape.door);
  $("marquee").textContent = "door " + d.no + " \u00b7 " + d.marquee;
  $("goal").textContent = d.goal;
  $("door").value = String(d.i);

  const btns = [];
  d.cmds.forEach((c, j) => btns.push('<button data-cmd="' + j + '">' + c + '</button>'));
  $("cmds").innerHTML = btns.join("");
  for (const b of $("cmds").querySelectorAll("button"))
    b.onclick = () => send(Number(b.dataset.cmd), Number($("arg").value) || 0);

  $("turn").textContent = pos + " / " + tape.moves.length;
  const strip = tape.moves.map((m, k) =>
    (k === pos - 1 ? "[" : " ") + (d.cmds[m[0]] || "?") + (m[1] ? " " + m[1] : "") +
    (k === pos - 1 ? "]" : " "));
  $("strip").textContent = strip.length ? strip.join("\u00b7") : "(no turns yet)";

  const st = replay(shown());
  $("state").textContent = st
    ? d.fields.map((f, i) => f + "=" + st[i]).join("  ")
    : "(cannot replay: " + (WERR || "bad tape") + ")";
  $("place").textContent = showPlace(place(natsOfTape(shown())));
  $("code").value = codeOfTape(shown());
  pushHash();
}

function send(cmd, arg) {
  tape.moves = tape.moves.slice(0, pos);      // a new command forks the tape here
  tape.moves.push([cmd, arg]);
  pos = tape.moves.length;
  render();
}

function loadCode(code, quiet) {
  const t = tapeOfCode(code);
  if (!t) { if (!quiet) say("that is not a tape code"); return false; }
  tape = t; pos = t.moves.length;
  render();
  if (!quiet) say("loaded " + t.moves.length + " turns of door " + doorByIndex(t.door).name);
  return true;
}

$("door").innerHTML = DOORS.map(d =>
  '<option value="' + d.i + '">' + d.no + " " + d.marquee + "</option>").join("");
$("door").onchange = () => { tape = { door: Number($("door").value), moves: [] }; pos = 0;
                             render(); };
$("first").onclick = () => { pos = 0; render(); };
$("back").onclick = () => { if (pos > 0) pos--; render(); };
$("fwd").onclick = () => { if (pos < tape.moves.length) pos++; render(); };
$("last").onclick = () => { pos = tape.moves.length; render(); };
$("clear").onclick = () => { tape = { door: tape.door, moves: [] }; pos = 0; render();
                             say("cleared"); };
$("lesson").onclick = () => {
  const d = doorByIndex(tape.door);
  loadCode(d.code, true); pos = 0; render();
  say("this is the line Lean proves wins door " + d.no + ": " + d.turns +
      " turns \u2014 press forward to watch it");
};
$("load").onclick = () => loadCode($("code").value);
$("copycode").onclick = () => { navigator.clipboard && navigator.clipboard.writeText(
  $("code").value); say("code copied"); };
$("copylink").onclick = () => { const url = location.origin + location.pathname + "#" +
  codeOfTape(shown()); navigator.clipboard && navigator.clipboard.writeText(url);
  say("link copied: " + url); };

// ---- the shelf, the pocket and the catalog ----
const SHELF = "nixwars.tape.shelf";
function shelfList() { try { return JSON.parse(localStorage.getItem(SHELF) || "[]"); }
                       catch (e) { return []; } }
function showSaved() {
  const rows = shelfList().map(s =>
    '<tr><td>' + s.door + '</td><td>' + s.turns + ' turns</td><td>' + s.place +
    '</td><td><a href="#' + s.code + '">open</a></td></tr>');
  const pocket = (document.cookie.match(/(?:^|; )nixwars_tape=([^;]*)/) || [])[1];
  $("saved").innerHTML =
    (rows.length ? "<table><tbody>" + rows.join("") + "</tbody></table>" :
      '<p class="dim">the shelf is empty</p>') +
    (pocket ? '<p class="dim">in the pocket: <a href="#' + decodeURIComponent(pocket) +
      '">a tape of ' + (tapeOfCode(decodeURIComponent(pocket)) || { moves: [] }).moves.length +
      " turns</a></p>" : "");
}
$("shelf").onclick = () => {
  const t = shown(), code = codeOfTape(t);
  const l = shelfList().filter(s => s.code !== code);
  l.unshift({ code: code, door: doorByIndex(t.door).name, turns: t.moves.length,
              place: showPlace(place(natsOfTape(t))) });
  try { localStorage.setItem(SHELF, JSON.stringify(l.slice(0, 32))); say("saved to the shelf"); }
  catch (e) { say("no room on the shelf: " + e); }
  showSaved();
};
$("pocket").onclick = () => {
  document.cookie = "nixwars_tape=" + encodeURIComponent(codeOfTape(shown())) +
    ";path=/;max-age=31536000;SameSite=Lax";
  say("in the pocket"); showSaved();
};
$("file").onclick = () => {
  const t = shown(), addr = showPlace(place(natsOfTape(t)));
  try { localStorage.setItem("nixwars.cat." + addr, codeOfTape(t));
        say("filed under cat://" + addr + " \u2014 fetch it by address, not by name"); }
  catch (e) { say("cannot file: " + e); }
};

$("cat").querySelector("tbody").innerHTML =
  '<tr><th>level</th><th>name</th><th>address</th><th>holds</th></tr>' +
  CATALOG.map(i => '<tr><td>' + i.level + '</td><td>' + i.name + '</td><td>' +
    showPlace(i.place) + '</td><td class="dim">' +
    (i.parts.length ? i.parts.length + " item" + (i.parts.length > 1 ? "s" : "") : "\u2014") +
    '</td></tr>').join("");

// ---- the page checks itself ----
const log = [];
let allOk = true;
function check(what, cond) { if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what); }

check("the module is here", W !== null);
check("fifteen doors", DOORS.length === 15);
let wins = 0, trips = 0, places = 0;
for (const d of DOORS) {
  const t = tapeOfCode(d.code);
  if (t && codeOfTape(t) === d.code) trips++;
  if (t && showPlace(place(natsOfTape(t))) === showPlace(d.place)) places++;
  const end = t && replay(t);
  if (end && end.length === d.finish.length && end.every((x, i) => x === d.finish[i])) wins++;
}
check("every lesson code reads back as the tape it was made from", trips === DOORS.length);
check("every lesson replays to the winning vector Lean computed", wins === DOORS.length);
check("every lesson sits where Lean says it does in the grid", places === DOORS.length);
// turn by turn is the same game: replaying a prefix is stepping that far
let stepOk = true;
{
  const d = DOORS[2], t = tapeOfCode(d.code);
  let st = d.start.slice();
  for (let k = 0; k < t.moves.length; k++) {
    st = Array.from(W[d.name + "_" + d.cmds[t.moves[k][0]]](t.moves[k][1], ...st));
    const pre = replay({ door: t.door, moves: t.moves.slice(0, k + 1) });
    if (!pre || pre.some((x, i) => x !== st[i])) stepOk = false;
  }
}
check("playing turn by turn is playing the whole tape", stepOk);
check("no two items of the catalog share a cell of the grid",
  new Set(CATALOG.map(i => showPlace(i.place))).size === CATALOG.length);
check("a catalog only holds the level below it", CATALOG.every(i =>
  i.parts.every(n => (CATALOG.find(j => j.name === n) || {}).level === i.level - 1)));
$("log").innerHTML = '<span class="' + (allOk ? "ok" : "bad") + '">' +
  (allOk ? "all checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");

// ---- open whatever the address bar says ----
function fromHash() {
  const h = location.hash.slice(1);
  if (h) { if (!loadCode(h, true)) render(); }
  else render();
}
window.addEventListener("hashchange", fromHash);
fromHash();
showSaved();
</script>
</body>
</html>
"##

/-! ## The headless harness -/

/-- `www/tape-selftest.mjs`: the same checks, without a browser. -/
def tapeSelfTest : String :=
  "// Emitted by RequestProject/NixWars/TapePage.lean. Run: node www/tape-selftest.mjs\n" ++
  "//\n" ++
  "// Lifts the WebAssembly module out of www/tape.html, decodes every lesson code\n" ++
  "// the page carries, replays it on the module, and compares the result with the\n" ++
  "// vector Lean computed. Nothing here trusts the page's own script.\n" ++
  "import fs from \"node:fs\";\n" ++
  r##"
const here = u => new URL("./" + u, import.meta.url);
let fails = 0, n = 0;
const check = (what, ok, extra) => { n++; if (!ok) fails++;
  console.log((ok ? "ok   " : "FAIL ") + what + (extra ? "   " + extra : "")); };
const same = (a, b) => a.length === b.length && a.every((x, i) => x === b[i]);

const html = fs.readFileSync(here("tape.html"), "utf8");
const grab = name => {
  const m = html.match(new RegExp("const " + name + " = ([\\s\\S]*?);\\n"));
  if (!m) { console.log("FAIL the page has no " + name); process.exit(1); }
  return JSON.parse(m[1]);
};
const DOORS = grab("DOORS"), CATALOG = grab("CATALOG"), WASM = grab("WASM");

const bytes = Uint8Array.from(WASM);
check("the page carries the board module",
  bytes[0] === 0 && bytes[1] === 0x61 && bytes[2] === 0x73 && bytes[3] === 0x6d,
  bytes.length + " bytes");
check("it is byte-for-byte www/nixwars.wasm",
  same([...bytes], [...new Uint8Array(fs.readFileSync(here("nixwars.wasm")))]));
const W = new WebAssembly.Instance(new WebAssembly.Module(bytes), {}).exports;

const ALPHA = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_.";
const SEP = 64;
function encodeNats(ns) {
  let s = "";
  for (let x of ns) {
    if (x < 64) s += ALPHA[x];
    else { while (x >= 64) { s += ALPHA[x % 64]; x = Math.floor(x / 64); } s += ALPHA[x]; }
    s += ALPHA[SEP];
  }
  return s;
}
function decodeNats(txt) {
  const out = []; let cur = [];
  for (const ch of txt) {
    const s = ALPHA.indexOf(ch);
    if (s < 0) return null;
    if (s === SEP) { let v = 0; for (let i = cur.length - 1; i >= 0; i--) v = v * 64 + cur[i];
                     out.push(v); cur = []; }
    else cur.push(s);
  }
  return out;
}
const natsOfTape = t => [t.door].concat(...t.moves);
const codeOfTape = t => encodeNats(natsOfTape(t));
function tapeOfCode(code) {
  const ns = decodeNats(code);
  if (!ns || !ns.length || (ns.length - 1) % 2) return null;
  const moves = [];
  for (let i = 1; i < ns.length; i += 2) moves.push([ns[i], ns[i + 1]]);
  return { door: ns[0], moves: moves };
}
function place(ns) {
  const f = m => { let a = 0; for (let i = ns.length - 1; i >= 0; i--) a = (ns[i] + 71 * a) % m;
                   return a; };
  return [f(71), f(59), f(47)];
}
const play = (d, t, upto) => {
  let st = d.start.slice();
  const k = upto === undefined ? t.moves.length : upto;
  for (let i = 0; i < k; i++)
    st = Array.from(W[d.name + "_" + d.cmds[t.moves[i][0]]](t.moves[i][1], ...st));
  return st;
};

check("fifteen doors", DOORS.length === 15, DOORS.length + " doors");
for (const d of DOORS) {
  const t = tapeOfCode(d.code);
  check("door " + d.no + " " + d.marquee + ": the code reads back as its tape",
    t !== null && codeOfTape(t) === d.code && t.door === d.i &&
    t.moves.length === d.turns);
  check("door " + d.no + ": replaying the code reaches the vector Lean computed",
    same(play(d, t), d.finish), d.turns + " turns");
  check("door " + d.no + ": the tape is where Lean says it is in the grid",
    same(place(natsOfTape(t)), d.place), d.place.join(":"));
  // turn by turn: every prefix of the tape is the game after that many turns
  let st = d.start.slice(), byTurn = true;
  for (let k = 0; k < t.moves.length; k++) {
    st = Array.from(W[d.name + "_" + d.cmds[t.moves[k][0]]](t.moves[k][1], ...st));
    if (!same(play(d, t, k + 1), st)) byTurn = false;
    // and the prefix has a code of its own, which is what the address bar holds
    const pre = { door: t.door, moves: t.moves.slice(0, k + 1) };
    if (codeOfTape(tapeOfCode(codeOfTape(pre))) !== codeOfTape(pre)) byTurn = false;
  }
  check("door " + d.no + ": playing it turn by turn is playing the whole tape", byTurn);
}

check("the catalog holds every door and every tape", CATALOG.length === 2 * DOORS.length + 2);
check("no two items of the catalog share a cell of the grid",
  new Set(CATALOG.map(i => i.place.join(":"))).size === CATALOG.length);
check("a catalog only holds the level below it", CATALOG.every(i =>
  i.parts.every(nm => (CATALOG.find(j => j.name === nm) || {}).level === i.level - 1)));
check("the doors of the catalog are the doors of the board",
  CATALOG.filter(i => i.level === 1).length === DOORS.length);

console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the tape room and its harness. -/
def writeTapePage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/tape.html" tapePage
  IO.FS.writeFile "www/tape-selftest.mjs" tapeSelfTest

#eval writeTapePage

end TapePage
end NixWars
