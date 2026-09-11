import RequestProject.Nix.NixWars.Monster.Online
import RequestProject.Nix.NixWars.Monster.FlightMachine
import RequestProject.Nix.NixWars.Monster.FlyWasm
import RequestProject.Nix.NixWars.Emit
import RequestProject.Nix.NixWars.Monster.Page
import RequestProject.Nix.NixWars.Mobile
import RequestProject.Nix.NixWars.Gl

/-!
# Flying the world in the browser: `www/fly.html`

One self-contained WebGL page, emitted from Lean during the build, with no
network dependencies.  It flies the ship of `Monster/Flight.lean` through the
voxel world of `Monster/World.lean`:

* the world is drawn in 3D — the box of the three axes on screen, the 194
  irreducibles as landmark voxels, the station on the Monster's own voxel, the
  eight nodes of the online screen, and the ship;
* it is an `n`-dimensional flight: `DESCEND` adds an axis and `ASCEND` removes
  one, from the 71-cell line up to the fifteen-dimensional world of
  `1 618 964 990 108 856 390` cells, and any three of the axes in play can be
  put on screen while gauges show the rest;
* the frontier panel is the Frontier Run's instrument panel — heading, throttle,
  fuel, clamp, turn — over the cell index of the level;
* the online screen is `Monster/Online.lean`: eight nodes, their callsigns,
  their shards and the cell each is in, recomputed every tick;
* it is driven by thumb: the nine controls are laid out at the rectangles of
  `Mobile.lean`, one finger orbits the camera and two pinch it, and the same
  commands are on the keyboard for a desktop;
* it is flown by a WebAssembly module Lean emitted and proved correct — the
  bytes of `www/fly.wasm`, embedded in the page, with the table interpreter as
  a fallback for engines that have no wasm;
* it checks itself.  The page carries the flight Lean computed — the whole
  state trace of the course to the station in the 3D world, and the end of the
  fifteen-dimensional one — re-flies them in JavaScript, and prints whether its
  own transition function agrees with the Lean one, step by step.  It also
  re-derives the pad geometry, and checks that the eight nodes never share a
  cell over a full lap of the ring.

`www/fly-selftest.mjs` runs the same checks headless.
-/

set_option maxRecDepth 40000

namespace NixWars

namespace Monster

/-! ## Emitting the model -/

/-- A command, as the page names it. -/
def cmdName : Cmd → String
  | .aim a => "aim:" ++ toString a
  | .flip => "flip"
  | .thrust => "thrust"
  | .brake => "brake"
  | .fly => "fly"
  | .dock => "dock"
  | .descend => "descend"
  | .ascend => "ascend"

/-- A list of strings as a JSON array. -/
def strListJson (l : List String) : String :=
  "[" ++ String.intercalate "," (l.map (fun s => "\"" ++ s ++ "\"")) ++ "]"

/-- A ship as JSON. -/
def shipJson (s : Ship) : String :=
  "{\"dim\":" ++ toString s.dim ++ ",\"pos\":" ++ natListJson s.pos ++
  ",\"ax\":" ++ toString s.ax ++ ",\"fwd\":" ++ (if s.fwd then "1" else "0") ++
  ",\"speed\":" ++ toString s.speed ++ ",\"fuel\":" ++ toString s.fuel ++
  ",\"docked\":" ++ (if s.docked then "1" else "0") ++ ",\"turn\":" ++ toString s.turn ++ "}"

/-- The whole state trace of the course to the station of the level-`d` world:
the fresh ship and the ship after every command. -/
def flyTrace (d : Nat) : List Ship := List.scanl step (freshShip d) (courseToStation d)

/-- A trace as JSON. -/
def traceJson (d : Nat) : String :=
  "[" ++ String.intercalate ",\n" ((flyTrace d).map shipJson) ++ "]"

/-- A course as JSON. -/
def courseJson (d : Nat) : String := strListJson ((courseToStation d).map cmdName)

/-- A course that exercises every command, including the two that change the
number of dimensions. -/
def mixedCourse : List Cmd :=
  [.thrust, .fly, .descend, .aim 3, .fly, .flip, .fly, .thrust, .fly, .ascend, .aim 1, .fly,
   .descend, .descend, .aim 4, .thrust, .fly, .brake, .fly, .dock, .ascend, .fly, .flip, .fly]

/-- Its state trace from a fresh three-dimensional ship. -/
def mixedTraceJson : String :=
  "[" ++ String.intercalate ",\n" ((List.scanl step (freshShip 3) mixedCourse).map shipJson) ++ "]"

/-- The station's coordinates. -/
def stationJson : String := natListJson stationCoords

/-- The fifteen world coordinates of every irreducible: the landmarks. -/
def landmarksJson : String :=
  "[" ++ String.intercalate ",\n" (irrepRows.map (fun r => natListJson (coords r))) ++ "]"

/-- The online screen: node number, handle, callsign, role, shard. -/
def nodesJson : String :=
  "[" ++ String.intercalate ",\n" (onlineNodes.map (fun n =>
    "[" ++ toString n.num ++ ",\"" ++ n.handle ++ "\",\"" ++ n.callsign ++ "\",\"" ++
      n.role ++ "\"," ++ toString n.shard ++ "]")) ++ "]"

/-- The command a control on the pad sends. -/
def tapTag : Mobile.Tap → String
  | .axisDown => "axisDown"
  | .flip => "flip"
  | .axisUp => "axisUp"
  | .thrust => "thrust"
  | .fly => "fly"
  | .brake => "brake"
  | .ascend => "ascend"
  | .dock => "dock"
  | .descend => "descend"

/-- The pad: label, command, and the rectangle `Mobile.lean` lays it out at. -/
def padJson : String :=
  "[" ++ String.intercalate ",\n" (Mobile.allTaps.map (fun t =>
    let r := Mobile.tapRect t
    "[\"" ++ t.label ++ "\",\"" ++ tapTag t ++ "\"," ++ toString r.x ++ "," ++ toString r.y ++
      "," ++ toString r.w ++ "," ++ toString r.h ++ "]")) ++ "]"

/-- Everything the page is given, as one block of JavaScript constants. -/
def flyDataJs : String :=
  "const AXES = " ++ axesJson ++ ";\n" ++
  "const CELLS = " ++ cellsJson ++ ";\n" ++
  "const STATION = " ++ stationJson ++ ";\n" ++
  "const LANDMARKS = " ++ landmarksJson ++ ";\n" ++
  "const NODES = " ++ nodesJson ++ ";\n" ++
  "const PAD = " ++ padJson ++ ";\n" ++
  "const MINTOUCH = " ++ toString Mobile.minTouch ++ ";\n" ++
  "const VIEWPORT = [" ++ toString Mobile.viewportW ++ "," ++ toString Mobile.viewportH ++ "];\n" ++
  "const MAXTHROTTLE = " ++ toString maxThrottle ++ ";\n" ++
  "const TANK = " ++ toString shipTank ++ ";\n" ++
  "const COURSE3 = " ++ courseJson 3 ++ ";\n" ++
  "const TRACE3 = " ++ traceJson 3 ++ ";\n" ++
  "const COURSEMIX = " ++ strListJson (mixedCourse.map cmdName) ++ ";\n" ++
  "const TRACEMIX = " ++ mixedTraceJson ++ ";\n" ++
  "const COURSE15 = " ++ courseJson 15 ++ ";\n" ++
  "const FINAL15 = " ++ shipJson (run (freshShip 15) (courseToStation 15)) ++ ";\n" ++
  "const FIELDS = " ++ strListJson flightFieldNames ++ ";\n" ++
  "const FLIGHTTABLE = " ++
    tableToJson (flyTagsWithNames.map (fun p => (p.1, flightStepIR p.2))) ++ ";\n" ++
  "const FLYBOUND = " ++ toString flyBound ++ ";\n" ++
  "const FLYWASM = " ++ flyWasmBytesJs ++ ";\n"

/-! ## The flight, in JavaScript

The page flies the ship by evaluating `flightStepIR`, the table Lean emitted
and proved equal to `Monster.step` in `flightStepIR_correct`: the ship is
serialized into the padded state vector of `flightSerialize`, the program of
the command is evaluated field by field, and the vector is read back with
`flightDeserialize`, which `flightDeserialize_flightSerialize` proves returns
the ship it was made from.  So the rules the browser runs are the Lean ones,
not a transcription of them.

The page carries the same table compiled one step further: `www/fly.wasm`, the
module of `Monster/FlyWasm.lean`, is embedded in the page byte for byte, and
`wasm_fly_step_correct` proves that calling its `fly_<command>` export on the
serialized ship returns the serialized successor.  When the browser has a
WebAssembly engine the page flies with the module, and falls back to the table
interpreter otherwise; the self-test checks that the two agree.

The transcription is still here as `stepJs`, and the page checks all three
against each other as well as against the Lean traces; `www/fly-selftest.mjs`
runs the same checks headless. -/

/-- The model, for the page and for the self-test. -/
def flyModelJs : String := r##"
function axisLen(d, i) { return i < d ? AXES[i] : 1; }
function wrapFwd(p, c, k) { return (c + k) % p; }
function wrapBack(p, c, k) { return (c + (p - k % p)) % p; }
function stationPos(d) { return STATION.slice(0, d); }
function freshShip(d) {
  return { dim: d, pos: new Array(d).fill(0), ax: 0, fwd: 1, speed: 0,
           fuel: TANK, docked: 0, turn: 0 };
}
function clone(s) { return { dim: s.dim, pos: s.pos.slice(), ax: s.ax, fwd: s.fwd,
  speed: s.speed, fuel: s.fuel, docked: s.docked, turn: s.turn }; }
function atStation(s) {
  const t = stationPos(s.dim);
  return s.pos.length === t.length && s.pos.every((v, i) => v === t[i]);
}
function wrapDir(s) {
  const p = axisLen(s.dim, s.ax), c = s.pos[s.ax] === undefined ? 0 : s.pos[s.ax];
  return s.fwd ? wrapFwd(p, c, s.speed) : wrapBack(p, c, s.speed);
}
function stepJs(s0, cmd) {
  const s = clone(s0);
  s.turn = s0.turn + 1;
  if (cmd.startsWith("aim:")) {
    const a = Number(cmd.slice(4));
    if (a < s.dim) s.ax = a;
    return s;
  }
  switch (cmd) {
    case "flip": s.fwd = s.fwd ? 0 : 1; return s;
    case "thrust":
      if (!s.docked && s.speed < MAXTHROTTLE) s.speed = s.speed + 1;
      return s;
    case "brake": s.speed = Math.max(0, s.speed - 1); return s;
    case "fly":
      if (!s.docked && s.speed <= s.fuel) {
        if (s.ax < s.pos.length) s.pos[s.ax] = wrapDir(s0);
        s.fuel = s.fuel - s.speed;
      }
      return s;
    case "dock":
      if (s.docked) { s.docked = 0; return s; }
      if (atStation(s)) { s.docked = 1; s.speed = 0; s.fuel = TANK; }
      return s;
    case "descend":
      if (s.dim < 15) { s.dim = s.dim + 1; s.pos = s.pos.concat([0]); }
      return s;
    case "ascend":
      if (s.dim > 0) {
        s.ax = (s.ax + 1 < s.dim) ? s.ax : 0;
        s.dim = s.dim - 1;
        s.pos = s.pos.slice(0, s.pos.length - 1);
      }
      return s;
  }
  throw new Error("unknown command " + cmd);
}
// ---- evaluator for the emitted expressions (mirrors NixWars.Expr.eval) ----
function ev(e, st, arg) {
  switch (e[0]) {
    case "lit":  return e[1];
    case "fld":  return st[e[1]] || 0;
    case "arg":  return arg;
    case "add":  return ev(e[1],st,arg) + ev(e[2],st,arg);
    case "mul":  return ev(e[1],st,arg) * ev(e[2],st,arg);
    case "sub":  return Math.max(0, ev(e[1],st,arg) - ev(e[2],st,arg));   // truncated, as on Nat
    case "div":  return Math.floor(ev(e[1],st,arg) / ev(e[2],st,arg));
    case "le":   return ev(e[1],st,arg) <= ev(e[2],st,arg) ? 1 : 0;
    case "cond": return ev(e[1],st,arg) !== 0 ? ev(e[2],st,arg) : ev(e[3],st,arg);
  }
  throw new Error("bad expression");
}

// ---- the ship as the state vector of NixWars.Monster.flightSerialize ----
function serialize(s) {
  const st = [s.dim];
  for (let i = 0; i < 15; i++) st.push(s.pos[i] === undefined ? 0 : s.pos[i]);
  st.push(s.ax, s.fwd ? 1 : 0, s.speed, s.fuel, s.docked ? 1 : 0, s.turn);
  return st;
}
function deserialize(st) {
  return { dim: st[0], pos: st.slice(1, 1 + st[0]), ax: st[16], fwd: st[17] ? 1 : 0,
           speed: st[18], fuel: st[19], docked: st[20] ? 1 : 0, turn: st[21] };
}
function splitCmd(cmd) {
  return cmd.startsWith("aim:")
    ? ["aim", Number(cmd.slice(4))]
    : [cmd, 0];
}
// The flight itself: one command is one evaluation of the Lean-emitted table.
function step(s0, cmd) {
  const [tag, arg] = splitCmd(cmd);
  const prog = FLIGHTTABLE[tag];
  if (!prog) throw new Error("unknown command " + cmd);
  const st = serialize(s0);
  return deserialize(prog.map(e => ev(e, st, arg)));
}
function run(s, cmds) { return cmds.reduce(step, s); }

// ---- the WebAssembly module emitted by Lean ------------------------------
// FLYWASM is the byte-for-byte content of www/fly.wasm, produced by
// NixWars.Monster.flyWasmBytes: the same eight programs, compiled down to a
// stack machine. wasm_fly_step_correct proves that calling fly_<cmd> on
// (arg, ...state) returns the serialized successor state, provided every
// value stays at or below FLYBOUND — which fits, and is checked below.
let FEXPORTS = null, FERR = null;
try {
  FEXPORTS = new WebAssembly.Instance(
    new WebAssembly.Module(new Uint8Array(FLYWASM)), {}).exports;
} catch (err) { FERR = String(err); }
function flyFits(st, arg) {
  return arg <= FLYBOUND && st.every(x => x <= FLYBOUND);
}
function wasmStep(s0, cmd) {
  const [tag, arg] = splitCmd(cmd);
  const st = serialize(s0);
  return deserialize(Array.from(FEXPORTS["fly_" + tag](arg, ...st)));
}
// What the page actually flies with: the module when the browser has one and
// the state is inside the bound the proof asks for, the table otherwise.
function flyStep(s0, cmd) {
  const arg = splitCmd(cmd)[1];
  if (FEXPORTS && flyFits(serialize(s0), arg)) return wasmStep(s0, cmd);
  return step(s0, cmd);
}
function flyEngine() {
  return FEXPORTS ? "wasm (" + FLYWASM.length + " bytes, emitted by Lean)"
                  : "table (no wasm: " + FERR + ")";
}
function cellsAt(d) { let m = 1n; for (let i = 0; i < d; i++) m *= BigInt(AXES[i]); return m; }
function cellIndex(s) {
  let idx = 0n;
  for (let i = 0; i < s.dim; i++) {
    let m = 1n;
    for (let j = i + 1; j < s.dim; j++) m *= BigInt(AXES[j]);
    idx += BigInt(s.pos[i]) * m;
  }
  return idx;
}
function nodeCell(shard, t, d) {
  const pos = new Array(d).fill(0);
  if (d > 0) pos[0] = (shard + t) % 71;
  return cellIndex({ dim: d, pos: pos });
}
function sameShip(a, b) {
  return a.dim === b.dim && a.ax === b.ax && (a.fwd ? 1 : 0) === (b.fwd ? 1 : 0) &&
    a.speed === b.speed && a.fuel === b.fuel &&
    (a.docked ? 1 : 0) === (b.docked ? 1 : 0) && a.turn === b.turn &&
    a.pos.length === b.pos.length && a.pos.every((v, i) => v === b.pos[i]);
}
"##

/-- The checks the page runs on itself, shared with the headless self-test. -/
def flyChecksJs : String := r##"
function flyChecks(check) {
  // the transition function agrees with the one Lean computed, step by step
  let s = freshShip(3), ok3 = sameShip(s, TRACE3[0]);
  for (let i = 0; i < COURSE3.length; i++) {
    s = step(s, COURSE3[i]);
    if (!sameShip(s, TRACE3[i + 1])) ok3 = false;
  }
  check("the 3D course matches the Lean trace, all " + COURSE3.length + " commands", ok3);
  check("the 3D course docks at the station", s.docked === 1 && atStation(s));
  // … and so does the course that descends and ascends through the dimensions
  let m = freshShip(3), okm = sameShip(m, TRACEMIX[0]);
  for (let i = 0; i < COURSEMIX.length; i++) {
    m = step(m, COURSEMIX[i]);
    if (!sameShip(m, TRACEMIX[i + 1])) okm = false;
  }
  check("the mixed course matches the Lean trace, all " + COURSEMIX.length + " commands", okm);
  const s15 = run(freshShip(15), COURSE15);
  check("the 15D course matches the Lean end state", sameShip(s15, FINAL15));
  check("the 15D course docks at the station", s15.docked === 1 && atStation(s15));
  // the emitted table and the transcription of the model agree, command by command
  check("the table has a program for every command",
    FLIGHTTABLE !== undefined &&
      ["aim","flip","thrust","brake","fly","dock","descend","ascend"]
        .every(t => Array.isArray(FLIGHTTABLE[t]) && FLIGHTTABLE[t].length === FIELDS.length));
  const sweep = [];
  { let q = freshShip(3);
    for (let i = 0; i < 600; i++) {
      const cmd = ["fly", "thrust", "aim:" + (i % 15), "flip", "descend", "ascend", "dock",
                   "brake"][i % 8];
      sweep.push([q, cmd]);
      q = step(q, cmd);
    }
  }
  check("the emitted table and the model agree on " + sweep.length + " states",
    sweep.every(([q, cmd]) => sameShip(step(q, cmd), stepJs(q, cmd))));
  check("serializing and reading back is the identity on those states",
    sweep.every(([q]) => sameShip(deserialize(serialize(q)), q)));
  check("the vector has one field per name",
    FIELDS.length === 22 && serialize(freshShip(3)).length === FIELDS.length);
  // the WebAssembly module: it loads, it exports the eight commands, and it
  // steps the flight exactly as the table does
  check("the emitted WebAssembly module loads", FEXPORTS !== null);
  check("the module exports a function for every command",
    FEXPORTS !== null &&
      ["aim","flip","thrust","brake","fly","dock","descend","ascend"]
        .every(t => typeof FEXPORTS["fly_" + t] === "function"));
  check("every state of the sweep is inside the bound the proof assumes",
    sweep.every(([q, cmd]) => flyFits(serialize(q), splitCmd(cmd)[1])));
  check("the WebAssembly module and the Lean table agree on " + sweep.length + " states",
    FEXPORTS !== null &&
      sweep.every(([q, cmd]) => sameShip(wasmStep(q, cmd), step(q, cmd))));
  { let w = freshShip(3), okw = true;
    for (let i = 0; i < COURSE3.length; i++) {
      w = flyStep(w, COURSE3[i]);
      if (!sameShip(w, TRACE3[i + 1])) okw = false;
    }
    check("the engine the page flies with matches the Lean trace, all " +
      COURSE3.length + " commands", okw);
    check("the engine docks at the station", w.docked === 1 && atStation(w)); }
  // the world
  check("fifteen axes", AXES.length === 15);
  check("level 3 is 71 x 59 x 47 = 196883 cells", cellsAt(3) === 196883n);
  check("level 15 is 1618964990108856390 cells",
    cellsAt(15).toString() === "1618964990108856390");
  check("the cell counts are the products of the axes",
    CELLS.every((c, d) => BigInt(c) === cellsAt(d)));
  // the ship never leaves the world
  let t = freshShip(15), inside = true;
  for (let i = 0; i < 400; i++) {
    t = step(t, ["fly", "thrust", "aim:" + (i % 15), "flip", "descend", "ascend", "dock"][i % 7]);
    if (t.pos.length !== t.dim) inside = false;
    for (let j = 0; j < t.dim; j++) if (!(t.pos[j] < AXES[j])) inside = false;
    if (!(cellIndex(t) < cellsAt(t.dim))) inside = false;
  }
  check("400 mixed commands never leave the world", inside);
  // the landmarks are cells of the world
  check("all 194 irreducibles are cells of the world",
    LANDMARKS.length === 194 && LANDMARKS.every(c => c.length === 15 &&
      c.every((v, i) => v < AXES[i])));
  check("the station is a cell of the world",
    STATION.length === 15 && STATION.every((v, i) => v < AXES[i]));
  // the online screen
  let clash = false;
  for (let tick = 0; tick < 71; tick++) {
    const cells = NODES.map(n => nodeCell(n[4], tick, 3).toString());
    if (new Set(cells).size !== NODES.length) clash = true;
  }
  check("the eight nodes never share a cell, over a whole lap", !clash);
  check("eight nodes online", NODES.length === 8);
  // the pad
  check("every control is at least " + MINTOUCH + " CSS px",
    PAD.every(p => p[4] >= MINTOUCH && p[5] >= MINTOUCH));
  check("the pad fits a " + VIEWPORT[0] + "x" + VIEWPORT[1] + " viewport",
    PAD.every(p => p[2] + p[4] <= VIEWPORT[0] && p[3] + p[5] <= VIEWPORT[1]));
  let overlap = false;
  for (let i = 0; i < PAD.length; i++) for (let j = i + 1; j < PAD.length; j++) {
    const a = PAD[i], b = PAD[j];
    if (a[2] < b[2] + b[4] && b[2] < a[2] + a[4] && a[3] < b[3] + b[5] && b[3] < a[3] + a[5])
      overlap = true;
  }
  check("no two controls overlap", !overlap);
  check("nine controls", PAD.length === 9);
}
"##

/-! ## The page -/

/-- Head, style and the frame of the page. -/
def flyPageHead : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NixWars &mdash; flying the voxel world</title>
<style>
"##

/-- The body of the page: canvas, panels and the pad. -/
def flyPageBody : String := r##"</style>
</head>
<body>
<div id="stage">
  <canvas id="view"></canvas>
  <div class="hud" id="hud"></div>
</div>
<div class="wrap">
  <h1>FLY THE VOXEL WORLD</h1>
  <p class="small">The world is the stack of grids over the Monster's fifteen primes.
  <b>DESCEND</b> adds an axis, <b>ASCEND</b> takes one away: from the 71-cell ring to
  <code>1&nbsp;618&nbsp;964&nbsp;990&nbsp;108&nbsp;856&nbsp;390</code> cells. Drag to orbit,
  pinch to zoom, tap to fly. The station is the Monster's own voxel; the pale cubes are the
  194 irreducibles.</p>

  <div class="row">
    <label for="axX">on screen</label>
    <select id="axX"></select><select id="axY"></select><select id="axZ"></select>
    <button id="auto">AUTOPILOT</button>
    <button id="reset">RESET</button>
  </div>

  <div class="pad" id="pad"></div>

  <h2>FRONTIER PANEL</h2>
  <table id="panel"><tbody></tbody></table>

  <h2>COORDINATES</h2>
  <div id="coords" class="small"></div>

  <h2>WHO'S ONLINE</h2>
  <table id="online"><thead><tr><th class="l">node</th><th class="l">handle</th>
  <th class="l">callsign</th><th>shard</th><th>cell</th><th class="l">doing</th></tr></thead>
  <tbody></tbody></table>

  <h2>SELF-CHECK</h2>
  <pre id="log"></pre>
  <p class="small">Keyboard: <code>[</code> <code>]</code> axis, <code>f</code> flip,
  <code>w</code>/<code>s</code> throttle, <code>space</code> fly, <code>d</code> dock,
  <code>-</code>/<code>+</code> ascend and descend.
  Other rooms: <a href="index.html">the main menu</a>,
  <a href="voxel-world.html">the map</a>, <a href="cans.html">the can opener</a>,
  <a href="arcade-3d.html">the 3D arcade</a>,
  <a href="arcade.html">the arcade</a>.</p>
</div>
<script>
"##

/-- The page's own script: rendering, controls and the self-check. -/
def flyPageScript : String := r##"
// ---- state ---------------------------------------------------------------
let ship = freshShip(3);
let tick = 0;
let disp = [0, 1, 2];
let autopilot = null;
const cam = { yaw: 0.7, pitch: 0.55, dist: 90, target: [0, 0, 0], fov: 1.05,
  minDist: 6, maxDist: 900 };
const canvas = document.getElementById("view");
const R = makeGL(canvas);

// ---- the scene -----------------------------------------------------------
function coordOn(pos, k) {
  const i = disp[k];
  return (i !== undefined && i < pos.length) ? pos[i] : 0;
}
function extentOn(k) {
  const i = disp[k];
  return (i !== undefined && i < ship.dim) ? AXES[i] : 1;
}
function scene() {
  const cubes = [], lines = [];
  const ex = [extentOn(0), extentOn(1), extentOn(2)];
  for (const l of boxLines(0, 0, 0, ex[0], ex[1], ex[2], 8)) lines.push(l);
  // the 194 irreducibles
  const seen = new Set();
  for (const c of LANDMARKS) {
    const x = coordOn(c, 0), y = coordOn(c, 1), z = coordOn(c, 2);
    const key = x + "," + y + "," + z;
    if (seen.has(key)) continue;
    seen.add(key);
    cubes.push({ x: x, y: y, z: z, c: 7, size: 0.55 });
  }
  // the station
  cubes.push({ x: coordOn(STATION, 0), y: coordOn(STATION, 1), z: coordOn(STATION, 2),
    c: 6, size: 0.95 });
  // the other callers
  for (const n of NODES) {
    const pos = new Array(ship.dim).fill(0);
    if (ship.dim > 0) pos[0] = (n[4] + tick) % 71;
    cubes.push({ x: coordOn(pos, 0), y: coordOn(pos, 1), z: coordOn(pos, 2), c: 1, size: 0.8 });
  }
  // the ship, and its nose
  const sx = coordOn(ship.pos, 0), sy = coordOn(ship.pos, 1), sz = coordOn(ship.pos, 2);
  cubes.push({ x: sx, y: sy, z: sz, c: 0, size: 1.15 });
  const nose = [sx + 0.5, sy + 0.5, sz + 0.5];
  const d = ship.fwd ? 1 : -1, reach = 3 * (ship.speed + 1);
  const tip = nose.slice();
  const k = disp.indexOf(ship.ax);
  if (k >= 0) tip[k] += d * reach;
  lines.push({ a: nose, b: tip, c: 0 });
  cam.target = [sx + 0.5, sy + 0.5, sz + 0.5];
  return { cubes: cubes, lines: lines };
}
function redraw() {
  if (!R) return;
  const s = scene();
  R.draw(s.cubes, s.lines, cam);
  hud();
}

// ---- the instruments -----------------------------------------------------
const AXNAMES = AXES.map(p => "p=" + p);
function hud() {
  const idx = cellIndex(ship), tot = cellsAt(ship.dim);
  document.getElementById("hud").innerHTML =
    "LEVEL <b>" + ship.dim + "D</b>  CELL <b>" + idx.toString() + "</b> / " + tot.toString() +
    "<br>AXIS <b>" + (ship.ax < ship.dim ? AXNAMES[ship.ax] : "&mdash;") + "</b> " +
    (ship.fwd ? "+" : "-") + "  THROTTLE <b>" + ship.speed + "</b>/" + MAXTHROTTLE +
    "<br>FUEL <b>" + ship.fuel + "</b>  " + (ship.docked ? "<b>DOCKED</b>" : "FREE") +
    "  TURN " + ship.turn;
  const rows = [
    ["level", ship.dim + "D"],
    ["cells", tot.toString()],
    ["cell", cellIndex(ship).toString()],
    ["address", "(" + ship.pos.join(", ") + ")"],
    ["heading", (ship.ax < ship.dim ? AXNAMES[ship.ax] : "none") + (ship.fwd ? " forward" : " back")],
    ["throttle", ship.speed + " / " + MAXTHROTTLE],
    ["fuel", ship.fuel + " / " + TANK],
    ["clamp", ship.docked ? "docked" : "free"],
    ["station", "(" + stationPos(ship.dim).join(", ") + ")"],
    ["turn", String(ship.turn)],
    ["engine", flyEngine()]];
  document.querySelector("#panel tbody").innerHTML = rows.map(r =>
    "<tr><td class=\"l\">" + r[0] + "</td><td class=\"l\">" + r[1] + "</td></tr>").join("");
  document.getElementById("coords").innerHTML = ship.pos.map((v, i) =>
    "<div>" + (i === ship.ax ? "&gt; " : "&nbsp;&nbsp;") + AXNAMES[i] + " " +
    "<span class=\"ok\">" + v + "</span> / " + AXES[i] +
    " " + "\u2588".repeat(Math.round(12 * v / AXES[i])) + "</div>").join("");
  const tb = NODES.map(n =>
    "<tr><td class=\"l\">" + n[0] + "</td><td class=\"l\">" + n[1] + "</td><td class=\"l\">" +
    n[2] + "</td><td>" + n[4] + "</td><td>" + nodeCell(n[4], tick, ship.dim).toString() +
    "</td><td class=\"l\">" + n[3] + "</td></tr>").join("");
  document.querySelector("#online tbody").innerHTML = tb;
}

// ---- controls ------------------------------------------------------------
function send(tag) {
  let cmd = tag;
  if (tag === "axisUp") cmd = "aim:" + ((ship.ax + 1) % Math.max(ship.dim, 1));
  if (tag === "axisDown") cmd = "aim:" + (ship.ax === 0 ? ship.dim - 1 : ship.ax - 1);
  ship = flyStep(ship, cmd);
  if (ship.ax >= ship.dim) ship.ax = 0;
  disp = disp.map(i => (i < ship.dim ? i : 0));
  fillAxisPickers();
  redraw();
}
const padEl = document.getElementById("pad");
for (const p of PAD) {
  const b = document.createElement("button");
  b.textContent = p[0];
  b.style.minWidth = p[4] + "px";
  b.style.minHeight = p[5] + "px";
  b.addEventListener("click", () => send(p[1]));
  padEl.appendChild(b);
}
const KEYS = { "[": "axisDown", "]": "axisUp", "f": "flip", "w": "thrust", "s": "brake",
  " ": "fly", "d": "dock", "-": "ascend", "+": "descend", "=": "descend" };
window.addEventListener("keydown", (e) => {
  const t = KEYS[e.key];
  if (t) { send(t); e.preventDefault(); }
});
function fillAxisPickers() {
  ["axX", "axY", "axZ"].forEach((id, k) => {
    const sel = document.getElementById(id);
    const cur = disp[k];
    sel.innerHTML = "";
    for (let i = 0; i < ship.dim; i++) {
      const o = document.createElement("option");
      o.value = String(i);
      o.textContent = "axis " + i + " (" + AXES[i] + ")";
      if (i === cur) o.selected = true;
      sel.appendChild(o);
    }
    sel.onchange = () => { disp[k] = Number(sel.value); redraw(); };
  });
}
document.getElementById("reset").addEventListener("click", () => {
  ship = freshShip(3); tick = 0; disp = [0, 1, 2]; fillAxisPickers(); redraw();
});
document.getElementById("auto").addEventListener("click", () => {
  if (autopilot) { clearInterval(autopilot); autopilot = null; return; }
  const plan = (ship.dim === 15 ? COURSE15 : COURSE3).slice();
  ship = freshShip(ship.dim === 15 ? 15 : 3);
  let i = 0;
  autopilot = setInterval(() => {
    if (i >= plan.length) { clearInterval(autopilot); autopilot = null; return; }
    ship = flyStep(ship, plan[i++]);
    redraw();
  }, 140);
});
if (R) attachOrbit(canvas, cam, redraw);
setInterval(() => { tick = (tick + 1) % 71; redraw(); }, 700);

// ---- the page checks itself ---------------------------------------------
const log = [];
let allOk = true;
flyChecks((what, cond) => {
  if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what);
});
document.getElementById("log").innerHTML =
  "<span class=\"" + (allOk ? "ok" : "bad") + "\">" +
  (allOk ? "all checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");

fillAxisPickers();
if (!R) {
  document.getElementById("hud").innerHTML =
    "this browser has no WebGL &mdash; the instruments below still fly the ship";
}
redraw();
"##

/-- The whole page. -/
def flyPage : String :=
  flyPageHead ++ Gl.mobileCss ++ flyPageBody ++
  flyDataJs ++ Gl.matrixJs ++ Gl.rendererJs ++ Gl.orbitJs ++ flyModelJs ++ flyChecksJs ++
  flyPageScript ++ "\n</script>\n</body>\n</html>\n"

/-- The headless self-test: the same model and the same checks, run under
Node with no browser. -/
def flySelfTest : String :=
  "// Emitted by RequestProject/NixWars/Monster/FlyPage.lean. Run: node www/fly-selftest.mjs\n" ++
  flyDataJs ++ flyModelJs ++ flyChecksJs ++ r##"
import fs from "node:fs";
let fails = 0, n = 0;
flyChecks((what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
});
// the module on disk is the one the page carries
{
  const onDisk = [...fs.readFileSync(new URL("./fly.wasm", import.meta.url))];
  const same = onDisk.length === FLYWASM.length && onDisk.every((b, i) => b === FLYWASM[i]);
  n++;
  if (!same) { fails++; console.log("FAIL fly.wasm matches the bytes embedded in the page"); }
  else console.log("ok   fly.wasm matches the bytes embedded in the page (" +
    onDisk.length + " bytes)");
}
console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the page and its self-test. -/
def writeFlyPage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/fly.html" flyPage
  IO.FS.writeFile "www/fly-selftest.mjs" flySelfTest

#eval writeFlyPage

end Monster

end NixWars
