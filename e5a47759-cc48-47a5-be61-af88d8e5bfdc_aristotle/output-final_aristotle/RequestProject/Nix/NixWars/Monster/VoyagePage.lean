import RequestProject.Nix.NixWars.Monster.VoyageGame

/-!
# Flying the irrep worlds, as a page: `www/fly-worlds.html`

`Voyage.lean` models the game as a ship in the irrep worlds — an address in a
box of prime axes, flown one cell at a time, and carried between boxes by the
divide/multiply moves of `Moonshine.lean`.  This file lets you fly it.

Everything the page knows is emitted from Lean:

* `WORLDS`: the boxes you can be in, with their axes and their cell counts;
* `SAMPLES`: cans of the first world with the address and the cell Lean computes
  for each, so the page's arithmetic is checked against the kernel's;
* `TOUR`: the worked flight `tour3` and where Lean says it lands;
* `LADDER`: the game's own `÷47 ×41 ×31 ×4` with the ship Lean says it carries
  `voyager` to;
* `ROUTES`: worked flight plans, Lean's own `route` command for command, with
  the ship each one lands on and how long `route_length` says it is.

The page's script is a transcription of `up`, `down`, `moveAt`, `step`, `run`,
`strip`, `build` and `route`, plus the mixed-radix `encode` of `World.lean`;
`www/fly-worlds-selftest.mjs` runs it headless against every Lean-computed
value above.
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

namespace NixWars

namespace Monster

namespace VoyagePage

open Moonshine

/-! ## The data the page carries -/

/-- Escape a string for a JSON literal. -/
def esc (s : String) : String :=
  ((s.replace "\\" "\\\\").replace "\"" "\\\"").replace "\n" "\\n"

/-- A JSON string. -/
def str (s : String) : String := "\"" ++ esc s ++ "\""

/-- A list of numbers, as JSON. -/
def nats (ns : List Nat) : String := "[" ++ String.intercalate "," (ns.map toString) ++ "]"

/-- One command, as JSON. -/
def cmdJson : Voyage.Cmd → String
  | Voyage.Cmd.fwd i => "[\"f\"," ++ toString i ++ "]"
  | Voyage.Cmd.back i => "[\"b\"," ++ toString i ++ "]"
  | Voyage.Cmd.warp p => "[\"w\"," ++ toString p ++ "]"
  | Voyage.Cmd.drop p => "[\"d\"," ++ toString p ++ "]"

/-- A list of commands, as JSON. -/
def cmds (cs : List Voyage.Cmd) : String :=
  "[" ++ String.intercalate "," (cs.map cmdJson) ++ "]"

/-- A ship, as JSON. -/
def shipJson (S : Voyage.Ship) : String :=
  "{\"axes\":" ++ nats S.world.axes ++ ",\"addr\":" ++ nats S.addr ++
    ",\"size\":" ++ toString S.world.size ++ ",\"cell\":" ++ toString S.cell ++ "}"

/-- The worlds the page offers, with the axes of each. -/
def worlds : List (String × Irrep) :=
  [("71 × 59 × 47", Irrep.irrep3),
   ("47 × 71 × 59", Irrep.irrep3'),
   ("73 × 67 × 61", Irrep.irrepOther),
   ("71 × 59 × 47 × 41", Irrep.irrep4),
   ("4 × 31 × 41 × 71 × 59", irrepNext)]

/-- One world, as JSON. -/
def worldJson (w : String × Irrep) : String :=
  "{\"name\":" ++ str w.1 ++ ",\"axes\":" ++ nats w.2.axes ++
    ",\"size\":" ++ toString w.2.size ++ ",\"dim\":" ++ toString w.2.dim ++ "}"

/-- The worlds, as JSON. -/
def worldsJson : String :=
  "[" ++ String.intercalate ",\n" (worlds.map worldJson) ++ "]"

/-- The cans of the first world the page checks its arithmetic on. -/
def sampleCans : List Nat := [0, 1, 47, 1000, 4188, 196882]

/-- One can, with the address and the cell Lean computes for it. -/
def sampleJson (n : Nat) : String :=
  "{\"can\":" ++ toString n ++ ",\"addr\":" ++ nats (Irrep.irrep3.coords n) ++
    ",\"cell\":" ++ toString (Irrep.irrep3.cell n) ++ "}"

/-- The sample cans, as JSON. -/
def samplesJson : String :=
  "[" ++ String.intercalate ",\n" (sampleCans.map sampleJson) ++ "]"

/-- The worked tour inside the first world. -/
def tourJson : String :=
  "{\"from\":" ++ shipJson Voyage.start3 ++ ",\"cmds\":" ++ cmds Voyage.tour3 ++
    ",\"to\":" ++ shipJson (Voyage.run Voyage.tour3 Voyage.start3) ++ "}"

/-- One move of a path, as JSON. -/
def stepJson : Step → String
  | Step.mul p => "[\"mul\"," ++ toString p ++ "]"
  | Step.div p => "[\"div\"," ++ toString p ++ "]"

/-- The game's own path, with the ship at each end of it. -/
def ladderJson : String :=
  "{\"steps\":[" ++ String.intercalate "," (ladder.map stepJson) ++ "]" ++
    ",\"cmds\":" ++ cmds (Voyage.plan ladder) ++
    ",\"from\":" ++ shipJson Voyage.voyager ++
    ",\"to\":" ++ shipJson (Voyage.travel ladder Voyage.voyager) ++
    ",\"back\":[" ++ String.intercalate "," ((invPath ladder).map stepJson) ++ "]}"

/-- The worked flight plans: where from, where to, and Lean's own `route`. -/
def sampleRoutes : List (String × Voyage.Ship × Voyage.Ship) :=
  [("across the first world", Voyage.start3, ⟨Irrep.irrep3, [2, 3, 4]⟩),
   ("into the world next door", Voyage.start3, ⟨irrepNext, [1, 2, 0, 0, 1]⟩),
   ("out to the other primes", ⟨irrepNext, [1, 2, 0, 0, 1]⟩, ⟨Irrep.irrepOther, [1, 1, 1]⟩),
   ("one dimension up", ⟨Irrep.irrep3, [2, 3, 4]⟩, ⟨Irrep.irrep4, [1, 0, 2, 3]⟩)]

/-- One flight plan, as JSON. -/
def routeJson (r : String × Voyage.Ship × Voyage.Ship) : String :=
  "{\"name\":" ++ str r.1 ++ ",\"from\":" ++ shipJson r.2.1 ++
    ",\"to\":" ++ shipJson r.2.2 ++ ",\"cmds\":" ++ cmds (Voyage.route r.2.1 r.2.2) ++
    ",\"length\":" ++ toString (Voyage.route r.2.1 r.2.2).length ++
    ",\"lands\":" ++ shipJson (Voyage.run (Voyage.route r.2.1 r.2.2) r.2.1) ++ "}"

/-- The flight plans, as JSON. -/
def routesJson : String :=
  "[" ++ String.intercalate ",\n" (sampleRoutes.map routeJson) ++ "]"

/-- The atoms of the game the page offers to fly to: the first sixteen cans of
`Cans.nixwarsWorld`, numbered by their place in the world. -/
def sampleAtoms : List (Nat × Cans.Can) := Irrep.gameAtoms.take 16

/-- One atom, as JSON: its number, its label, the address its number projects to
and the cell of the first world it sits in. -/
def atomJson (a : Nat × Cans.Can) : String :=
  "{\"atom\":" ++ toString a.1 ++ ",\"label\":" ++ str a.2.label ++
    ",\"addr\":" ++ nats (Voyage.atomShip a.1).addr ++
    ",\"cell\":" ++ toString (Voyage.atomShip a.1).cell ++
    ",\"plan\":" ++ toString (Voyage.route Voyage.start3 (Voyage.atomShip a.1)).length ++ "}"

/-- The atoms, as JSON. -/
def atomsJson : String :=
  "[" ++ String.intercalate ",\n" (sampleAtoms.map atomJson) ++ "]"

/-- The tables, as a script. -/
def pageData : String :=
  "const WORLDS = " ++ worldsJson ++ ";\n" ++
  "const SAMPLES = " ++ samplesJson ++ ";\n" ++
  "const TOUR = " ++ tourJson ++ ";\n" ++
  "const LADDER = " ++ ladderJson ++ ";\n" ++
  "const ROUTES = " ++ routesJson ++ ";\n" ++
  "const ATOMS = " ++ atomsJson ++ ";\n"

/-! ## The model: a transcription of `Voyage.lean` -/

/-- The flight model, in JavaScript. -/
def pageModel : String := r##"
// one cell forward and one cell back along an axis of length p  (up, down)
function up(x, p) { return (x + 1) % p; }
function down(x, p) { return (x + (p - 1)) % p; }
// change the coordinate at index i, off the end nothing happens  (moveAt)
function moveAt(f, axes, addr, i) {
  if (i >= axes.length || i >= addr.length) return addr.slice();
  const a = addr.slice();
  a[i] = f(addr[i], axes[i]);
  return a;
}
// playing one command  (step)
function step(c, S) {
  const axes = S.axes, addr = S.addr;
  if (c[0] === "f") return { axes: axes.slice(), addr: moveAt(up, axes, addr, c[1]) };
  if (c[0] === "b") return { axes: axes.slice(), addr: moveAt(down, axes, addr, c[1]) };
  if (c[0] === "w") {
    if (c[1] <= 0) return { axes: axes.slice(), addr: addr.slice() };
    return { axes: [c[1]].concat(axes), addr: [0].concat(addr) };
  }
  // "d": divide the axis out, taking its coordinate with it
  const i = axes.indexOf(c[1]);
  if (i < 0) return { axes: axes.slice(), addr: addr.slice() };
  const A = axes.slice(), B = addr.slice();
  A.splice(i, 1); B.splice(i, 1);
  return { axes: A, addr: B };
}
// playing a list of commands  (run)
function run(cs, S) { return cs.reduce((T, c) => step(c, T), S); }
// the cell an address names  (encode)
function cellOf(axes, addr) {
  let n = 0;
  for (let i = 0; i < axes.length; i++) {
    let tail = 1;
    for (let j = i + 1; j < axes.length; j++) tail *= axes[j];
    n += (addr[i] || 0) * tail;
  }
  return n;
}
function sizeOf(axes) { return axes.reduce((a, b) => a * b, 1); }
// the address of the can numbered n  (Irrep.coords)
function coordsOf(axes, n) { return axes.map(p => n % p); }
// the can a cell holds, by the Chinese remainder theorem  (Irrep.lift)
function canAt(axes, addr) {
  let n = 0, m = 1;
  for (let i = 0; i < axes.length; i++) {
    const p = axes[i], want = addr[i] % p;
    while (n % p !== want) n += m;   // m is the product of the axes done so far
    m *= p;
  }
  return n;
}
// the flight plan  (strip, build, route)
function strip(axes) { return axes.map(p => ["d", p]); }
function build(axes, addr) {
  if (axes.length === 0) return [];
  const rest = build(axes.slice(1), addr.slice(1));
  const climb = [];
  for (let k = 0; k < (addr[0] || 0); k++) climb.push(["f", 0]);
  return rest.concat([["w", axes[0]]]).concat(climb);
}
function route(S, T) { return strip(S.axes).concat(build(T.axes, T.addr)); }
// a path of Moonshine.lean, flown  (cmdOfStep, plan)
function plan(P) { return P.map(s => [s[0] === "mul" ? "w" : "d", s[1]]); }
function pathText(P) {
  return P.map(s => (s[0] === "mul" ? "\u00d7" : "\u00f7") + s[1]).join(" ");
}
function cmdText(c) {
  if (c[0] === "f") return "fwd " + c[1];
  if (c[0] === "b") return "back " + c[1];
  if (c[0] === "w") return "\u00d7" + c[1];
  return "\u00f7" + c[1];
}
function sameShip(S, T) {
  return S.axes.length === T.axes.length && S.addr.length === T.addr.length &&
    S.axes.every((p, i) => p === T.axes[i]) && S.addr.every((x, i) => x === T.addr[i]);
}
"##

/-- The checks, shared by the page and the headless harness. -/
def pageChecks : String := r##"
function voyageChecks(check) {
  for (const w of WORLDS) {
    check("size of " + w.name, sizeOf(w.axes) === w.size);
    check("dim of " + w.name, w.axes.length === w.dim);
    // every axis is a circle: forward then back is where you were
    const addr = w.axes.map((p, i) => (i * 7 + 3) % p);
    for (let i = 0; i < w.axes.length; i++) {
      const S = { axes: w.axes, addr: addr };
      check("axis " + i + " of " + w.name + " is a circle",
        sameShip(step(["b", i], step(["f", i], S)), S));
    }
    // warping in and dropping back out returns the ship
    const S0 = { axes: w.axes, addr: addr };
    check("warp then drop returns in " + w.name,
      sameShip(step(["d", 13], step(["w", 13], S0)), S0));
  }
  for (const s of SAMPLES) {
    const axes = WORLDS[0].axes;
    check("address of can " + s.can, coordsOf(axes, s.can).join() === s.addr.join());
    check("cell of can " + s.can, cellOf(axes, s.addr) === s.cell);
    check("can at cell " + s.cell, canAt(axes, s.addr) === s.can);
  }
  const tourEnd = run(TOUR.cmds, { axes: TOUR.from.axes, addr: TOUR.from.addr });
  check("the tour lands where Lean says", sameShip(tourEnd, TOUR.to));
  check("the tour's cell", cellOf(tourEnd.axes, tourEnd.addr) === TOUR.to.cell);
  const flown = run(LADDER.cmds, { axes: LADDER.from.axes, addr: LADDER.from.addr });
  check("the ladder lands where Lean says", sameShip(flown, LADDER.to));
  check("the ladder's world has as many cells as Lean says",
    sizeOf(flown.axes) === LADDER.to.size);
  check("the ladder's steps are its commands",
    JSON.stringify(plan(LADDER.steps)) === JSON.stringify(LADDER.cmds));
  for (const r of ROUTES) {
    const S = { axes: r.from.axes, addr: r.from.addr };
    const T = { axes: r.to.axes, addr: r.to.addr };
    check(r.name + ": the page plans Lean's flight",
      JSON.stringify(route(S, T)) === JSON.stringify(r.cmds));
    check(r.name + ": the flight lands on the target", sameShip(run(r.cmds, S), T));
    check(r.name + ": as long as Lean says", r.cmds.length === r.length);
    check(r.name + ": one command per axis dropped, per axis built, per cell flown",
      r.length === S.axes.length + T.axes.length + T.addr.reduce((a, b) => a + b, 0));
  }
  // the things in the game, and the flight to each of them
  const first = WORLDS[0].axes;
  for (const a of ATOMS) {
    check("atom " + a.atom + " is addressed by its residues",
      coordsOf(first, a.atom).join() === a.addr.join());
    check("atom " + a.atom + " sits in the cell Lean says",
      cellOf(first, a.addr) === a.cell);
    check("the ship on atom " + a.atom + " is sitting on it",
      canAt(first, a.addr) === a.atom);
    const S = { axes: first, addr: first.map(() => 0) };
    const T = { axes: first, addr: a.addr };
    check("fly to atom " + a.atom, sameShip(run(route(S, T), S), T));
    check("the flight to atom " + a.atom + " is as long as Lean says",
      route(S, T).length === a.plan);
  }
  // and the general claim, tried on every pair of worlds the page offers
  for (const a of WORLDS) for (const b of WORLDS) {
    const S = { axes: a.axes, addr: a.axes.map((p, i) => (i * 5 + 1) % p) };
    const T = { axes: b.axes, addr: b.axes.map((p, i) => (i * 3 + 2) % p) };
    check("fly " + a.name + " to " + b.name, sameShip(run(route(S, T), S), T));
  }
}
"##

/-! ## The page -/

/-- Everything before the emitted data. -/
def pageHead : String := r#"<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>NIXWARS :: FLYING THE IRREP WORLDS</title>
<style>
:root { color-scheme: dark; }
body { background:#05070a; color:#7fe0ff; font-family:ui-monospace,Menlo,Consolas,monospace;
       margin:0; padding:1rem; font-size:14px; }
h1 { font-size:1.05rem; letter-spacing:.2em; border-bottom:1px solid #16465c; padding-bottom:.4rem; }
h2 { font-size:.8rem; letter-spacing:.18em; color:#bdf0ff; margin:1.1rem 0 .3rem; }
canvas { background:#010306; border:1px solid #16465c; width:100%; max-width:640px; display:block; }
pre { background:#010306; border:1px solid #16465c; padding:.6rem; overflow-x:auto;
      white-space:pre-wrap; margin:0; }
button { background:#06212e; color:#7fe0ff; border:1px solid #24798f; padding:.3rem .6rem;
         font-family:inherit; cursor:pointer; margin:.15rem .2rem .15rem 0; }
button:hover { background:#0b3547; }
input, select { background:#010306; color:#7fe0ff; border:1px solid #24798f; padding:.25rem;
        font-family:inherit; }
.grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(320px,1fr)); gap:1rem; }
.small { color:#4aa6c2; font-size:.75rem; }
.ok { color:#5dff9a; } .bad { color:#ff6f6f; }
table { border-collapse:collapse; font-size:.75rem; }
td, th { border:1px solid #16465c; padding:.15rem .4rem; text-align:right; }
th { color:#bdf0ff; }
</style>
</head>
<body>
<h1>FLYING THE IRREP WORLDS</h1>
<p class="small">The game is a ship in a box of cells cut by primes.  Flying one
cell along an axis wraps at the end &mdash; every axis is a circle &mdash; and the
two moves of the paths page are flown too: <b>&times;p</b> drops you into the
finer world with one more axis, at the origin of it, and <b>&divide;p</b> takes
that axis away again.  Everything below is the model of
<code>RequestProject/NixWars/Monster/Voyage.lean</code>, transcribed; the tables
it is checked against are emitted from Lean.</p>

<div class="grid">
<div>
<h2>THE VIEW</h2>
<canvas id="view" width="640" height="420"></canvas>
<p class="small">The cells around the ship along the three axes you are looking
down.  W / S fly forward and back along the axis the nose points down, A / D
choose that axis, and 1&hellip;9 point it straight at an axis.  Z / X / C choose
the three axes drawn.</p>
<div id="pad"></div>
</div>

<div>
<h2>WHERE YOU ARE</h2>
<pre id="hud"></pre>
<h2>THE WORLD NEXT DOOR</h2>
<div id="warps"></div>
<p class="small">Multiplying an axis in puts you at its origin; dividing one out
leaves it behind.  The pair is proved inverse (<code>drop_warp</code>).</p>
<h2>AUTOPILOT</h2>
<div>
  <label>fly to can <input id="cannum" value="4189" size="10"></label>
</div>
<div id="auto"></div>
<p class="small">The flight plan is Lean's <code>route</code>: strip the axes of
the world you are in, build the axes of the world you want, then fly out along
each of them.  <code>route_flies</code> proves it always lands.</p>
<pre id="plan"></pre>
<h2>THINGS IN THE GAME</h2>
<div id="atoms"></div>
<p class="small">Sixteen of the 3529 cans of the world, each in the cell its own
number picks out.  No two of them share a cell, and the flight to each of them
is proved to land (<code>route_to_atom</code>, <code>atomShip_inj</code>).</p>
<h2>WORKED FLIGHTS FROM LEAN</h2>
<div id="worked"></div>
<h2>CHECKS</h2>
<pre id="log"></pre>
</div>
</div>
<script>
"#

/-- The page's own script: drawing, the keyboard and the autopilot. -/
def pageScript : String := r##"
const cv = document.getElementById("view");
const cx = cv.getContext ? cv.getContext("2d") : null;
let S = { axes: WORLDS[0].axes.slice(), addr: WORLDS[0].axes.map(() => 0) };
let nose = 0, view = [0, 1, 2], flight = [], timer = null;

function clamp(i) {
  return S.axes.length === 0 ? 0 : ((i % S.axes.length) + S.axes.length) % S.axes.length;
}

function project(dx, dy, dz) {
  // a plain isometric projection, z into the screen
  const s = 46 / (1 + 0.22 * (dz + 3));
  return [cv.width / 2 + (dx - dy) * s, cv.height / 2 + (dx + dy) * s * 0.55 - dz * s * 0.9];
}

function draw() {
  if (!cx) return;
  cx.fillStyle = "#010306"; cx.fillRect(0, 0, cv.width, cv.height);
  const R = 3, cells = [];
  for (let dz = -R; dz <= R; dz++)
    for (let dy = -R; dy <= R; dy++)
      for (let dx = -R; dx <= R; dx++) {
        if (Math.abs(dx) + Math.abs(dy) + Math.abs(dz) > R + 2) continue;
        cells.push([dx, dy, dz]);
      }
  cells.sort((a, b) => (b[2] - a[2]) || (b[0] + b[1] - a[0] - a[1]));
  for (const c of cells) {
    const dx = c[0], dy = c[1], dz = c[2];
    const xy = project(dx, dy, dz);
    const d = Math.abs(dx) + Math.abs(dy) + Math.abs(dz);
    const here = d === 0;
    cx.beginPath();
    cx.arc(xy[0], xy[1], here ? 9 : Math.max(1.2, 5 - 0.55 * d), 0, 6.2832);
    cx.fillStyle = here ? "#5dff9a" : "rgba(127,224,255," + (0.85 - 0.1 * d).toFixed(3) + ")";
    cx.fill();
  }
  cx.font = "12px ui-monospace,monospace";
  const names = ["x", "y", "z"];
  for (let k = 0; k < 3; k++) {
    const i = view[k], p = S.axes[i];
    const xy = project(k === 0 ? 3.6 : 0, k === 1 ? 3.6 : 0, k === 2 ? 3.6 : 0);
    cx.fillStyle = i === nose ? "#5dff9a" : "#bdf0ff";
    cx.fillText(names[k] + ": axis " + i + (p === undefined ? " \u2014" : " (" + p + ")"),
      xy[0] - 20, xy[1]);
  }
  cx.fillStyle = "#4aa6c2";
  cx.fillText("cell " + cellOf(S.axes, S.addr) + " of " + sizeOf(S.axes), 10, 18);
  cx.fillText("nose on axis " + nose + (S.axes[nose] ? " of " + S.axes[nose] : ""), 10, 34);
}

function hud() {
  const can = S.axes.length ? canAt(S.axes, S.addr) : 0;
  document.getElementById("hud").textContent =
    "world   " + (S.axes.length ? S.axes.join(" \u00d7 ") : "(the single cell)") + "\n" +
    "cells   " + sizeOf(S.axes) + "\n" +
    "address [" + S.addr.join(", ") + "]\n" +
    "cell    " + cellOf(S.axes, S.addr) + "\n" +
    "can     " + can + "\n" +
    "nose    axis " + nose;
}

function refresh() { draw(); hud(); }

function play(c) { S = step(c, S); nose = clamp(nose); refresh(); }

function stopFlight() { if (timer) { clearInterval(timer); timer = null; } }

function fly(cs) {
  stopFlight();
  flight = cs.slice();
  document.getElementById("plan").textContent =
    cs.length + " commands: " + cs.map(cmdText).join("  ");
  timer = setInterval(() => {
    if (flight.length === 0) { stopFlight(); return; }
    S = step(flight.shift(), S);
    nose = clamp(nose);
    refresh();
  }, 30);
}

// a button that works the same in the page and under a stubbed DOM
function button(box, label, fn) {
  const b = document.createElement("button");
  b.textContent = label;
  b.addEventListener("click", fn);
  box.appendChild(b);
  return b;
}

function warpButtons() {
  const box = document.getElementById("warps");
  box.innerHTML = "";
  for (const p of [2, 3, 4, 5, 7, 11, 13, 31, 41]) button(box, "\u00d7" + p, () => play(["w", p]));
  for (const p of S.axes) button(box, "\u00f7" + p, () => play(["d", p]));
  for (const w of WORLDS)
    button(box, w.name, () => fly(route(S, { axes: w.axes, addr: w.axes.map(() => 0) })));
  button(box, "FLY \u00f747 \u00d741 \u00d731 \u00d74", () => fly(LADDER.cmds));
}

function padButtons() {
  const box = document.getElementById("pad");
  box.innerHTML = "";
  button(box, "\u25c0 axis", () => { nose = clamp(nose - 1); refresh(); });
  button(box, "axis \u25b6", () => { nose = clamp(nose + 1); refresh(); });
  button(box, "FORWARD", () => play(["f", nose]));
  button(box, "BACK", () => play(["b", nose]));
  button(box, "view x", () => { view[0] = clamp(view[0] + 1); refresh(); });
  button(box, "view y", () => { view[1] = clamp(view[1] + 1); refresh(); });
  button(box, "view z", () => { view[2] = clamp(view[2] + 1); refresh(); });
}

function atomTable() {
  const first = WORLDS[0].axes;
  const box = document.getElementById("atoms");
  box.innerHTML = "<table><tr><th>atom</th><th style=\"text-align:left\">label</th>" +
    "<th>address</th><th>cell</th><th>commands</th></tr>" +
    ATOMS.map(a => "<tr><td>" + a.atom + "</td><td style=\"text-align:left\">" + a.label +
      "</td><td>" + a.addr.join(", ") + "</td><td>" + a.cell + "</td><td>" +
      a.plan + "</td></tr>").join("") + "</table>";
  const pad = document.createElement("div");
  box.appendChild(pad);
  for (const a of ATOMS)
    button(pad, "FLY TO " + a.atom,
      () => fly(route(S, { axes: first.slice(), addr: coordsOf(first, a.atom) })));
}

function workedTable() {
  const box = document.getElementById("worked");
  box.innerHTML = "<table><tr><th style=\"text-align:left\">flight</th><th>from</th>" +
    "<th>to</th><th>commands</th></tr>" +
    ROUTES.map(r => "<tr><td style=\"text-align:left\">" + r.name + "</td><td>" +
      r.from.axes.join("\u00d7") + "</td><td>" + r.to.axes.join("\u00d7") + "</td><td>" +
      r.length + "</td></tr>").join("") + "</table>";
  const pad = document.createElement("div");
  box.appendChild(pad);
  for (const r of ROUTES)
    button(pad, "FLY: " + r.name, () => {
      S = { axes: r.from.axes.slice(), addr: r.from.addr.slice() };
      nose = clamp(nose);
      refresh();
      fly(r.cmds);
    });
}

function autopilotButtons() {
  const box = document.getElementById("auto");
  box.innerHTML = "";
  button(box, "PLOT AND FLY", () => {
    const n = Math.max(0, Math.floor(+document.getElementById("cannum").value || 0));
    fly(route(S, { axes: S.axes.slice(), addr: coordsOf(S.axes, n) }));
  });
  button(box, "FLY HOME", () =>
    fly(route(S, { axes: WORLDS[0].axes.slice(), addr: WORLDS[0].axes.map(() => 0) })));
  button(box, "STOP", stopFlight);
}

window.addEventListener("keydown", ev => {
  const k = (ev.key || "").toLowerCase();
  if (k === "w") play(["f", nose]);
  else if (k === "s") play(["b", nose]);
  else if (k === "a") { nose = clamp(nose - 1); refresh(); }
  else if (k === "d") { nose = clamp(nose + 1); refresh(); }
  else if (k === "z") { view[0] = clamp(view[0] + 1); refresh(); }
  else if (k === "x") { view[1] = clamp(view[1] + 1); refresh(); }
  else if (k === "c") { view[2] = clamp(view[2] + 1); refresh(); }
  else if (k >= "1" && k <= "9") { nose = clamp(+k - 1); refresh(); }
  else return;
  ev.preventDefault();
});

warpButtons();
padButtons();
atomTable();
workedTable();
autopilotButtons();
refresh();

const log = [];
let allOk = true;
voyageChecks((what, cond) => {
  if (!cond) allOk = false;
  log.push((cond ? "ok   " : "FAIL ") + what);
});
document.getElementById("log").innerHTML =
  "<span class=\"" + (allOk ? "ok" : "bad") + "\">" +
  (allOk ? "all checks pass (" + log.length + ")" : "CHECKS FAILED") + "</span>\n" +
  log.join("\n");
"##

/-- The whole page. -/
def voyagePage : String :=
  pageHead ++ pageData ++ pageModel ++ pageChecks ++ pageScript ++
    "\n</script>\n</body>\n</html>\n"

/-- The headless self-test. -/
def voyageSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Monster/VoyagePage.lean. " ++
    "Run: node www/fly-worlds-selftest.mjs\n" ++
  pageData ++ pageModel ++ pageChecks ++ r##"
let fails = 0, n = 0;
voyageChecks((what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
});
console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the flight page and its self-test. -/
def writeVoyage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/fly-worlds.html" voyagePage
  IO.FS.writeFile "www/fly-worlds-selftest.mjs" voyageSelfTest
  IO.println s!"fly-worlds: page {voyagePage.length} bytes, \
    self-test {voyageSelfTest.length} bytes"

#eval writeVoyage

end VoyagePage

end Monster

end NixWars
