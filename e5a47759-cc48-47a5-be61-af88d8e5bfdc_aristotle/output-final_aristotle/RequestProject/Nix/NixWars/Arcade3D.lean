import RequestProject.Nix.NixWars.Scene3D
import RequestProject.Nix.NixWars.Mobile
import RequestProject.Nix.NixWars.Gl

/-!
# The arcade in three dimensions: `www/arcade-3d.html`

Every one of the fifteen doors, playable, rendered in WebGL, on a phone.

The page carries three Lean-emitted tables and nothing else:

* `DOORS` — the doors themselves, exactly as `www/nixwars.html` carries them:
  field names, the state each starts in, and the compiled transition table that
  `Machine.lean` proves computes the game's own step function.  The page steps a
  cabinet by evaluating those expressions, so the 3D room plays the same games
  the 2D board does, by construction;
* `SCENES` — the scenes of `Scene3D.lean`: how a state vector becomes voxels.
  Proved there to stay inside the `16 × 16 × 16` arena and to draw every field
  of every door;
* `GOLDEN` — the state each door reaches from its opening position under every
  one of its commands, for three different arguments, computed in Lean.  The
  page replays all of them through its own evaluator before it lets anyone
  play, and prints the result.

Controls are the pad of `Mobile.lean`: every button at least `44 × 44`, one
finger orbits the camera, two pinch it.  `www/arcade3d-selftest.mjs` runs the
same checks headless.
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

namespace NixWars

namespace Arcade3D

/-! ## Emitting the scenes -/

/-- A gadget as JSON. -/
def gadgetJson : Scene3D.Gadget → String
  | .bar f cap col row colour =>
      "[\"bar\"," ++ toString f ++ "," ++ toString cap ++ "," ++ toString col ++ "," ++
        toString row ++ "," ++ toString colour ++ "]"
  | .cube fx fy fz colour =>
      "[\"cube\"," ++ toString fx ++ "," ++ toString fy ++ "," ++ toString fz ++ "," ++
        toString colour ++ "]"

/-- The scenes of all fifteen doors, as JSON. -/
def scenesJson : String :=
  "{" ++ String.intercalate ",\n" (Scene3D.doorScenes.map (fun p =>
    "\"" ++ p.1 ++ "\":{\"n\":" ++ toString p.2.1 ++ ",\"gadgets\":[" ++
      String.intercalate "," (p.2.2.map gadgetJson) ++ "]}")) ++ "}"

/-! ## The golden vectors -/

/-- The arguments every command is checked on. -/
def goldenArgs : List Nat := [0, 1, 7]

/-- One door's opening position and compiled table. -/
structure Cabinet where
  /-- The door's name on the board. -/
  name : String
  /-- The state it opens in. -/
  init : List Nat
  /-- Its compiled command table. -/
  door : Wasm.DoorIR

/-- The fifteen cabinets of the room. -/
def cabinets : List Cabinet :=
  [ ⟨"nixwars", sessionSerialize initialSession, Wasm.nixWarsIR⟩,
    ⟨"dash", gsSerialize initialDashSession, Wasm.dashIR⟩,
    ⟨"market", gsSerialize initialMarketSession, Wasm.marketIR⟩,
    ⟨"lord", gsSerialize initialLordSession, Wasm.lordIR⟩,
    ⟨"hunt", gsSerialize initialHuntSession, Wasm.huntIR⟩,
    ⟨"zx81", gsSerialize initialZx81Session, Wasm.zx81IR⟩,
    ⟨"frens", gsSerialize initialLobbySession, Wasm.lobbyIR⟩,
    ⟨"tycoon", gsSerialize initialTycoonSession, Wasm.tycoonIR⟩,
    ⟨"meme", gsSerialize initialMemeSession, Wasm.memeIR⟩,
    ⟨"hyper", gsSerialize initialHyperSession, Wasm.hyperIR⟩,
    ⟨"oracle", gsSerialize initialOracleSession, Wasm.oracleIR⟩,
    ⟨"vote", gsSerialize initialVoteSession, Wasm.voteIR⟩,
    ⟨"qbert", gsSerialize initialQbertSession, Wasm.qbertIR⟩,
    ⟨"frontier", gsSerialize initialFrontierSession, Wasm.frontierIR⟩,
    ⟨"invaders", gsSerialize initialInvadersSession, Wasm.invadersIR⟩ ]

/-- The room holds every door of the board. -/
theorem cabinets_length : cabinets.length = 15 := by decide

/-- Every cabinet has a scene, and the scene is built for the length of that
cabinet's own state vector. -/
theorem cabinets_match_scenes :
    cabinets.map (fun c => (c.name, c.init.length)) =
      Scene3D.doorScenes.map (fun p => (p.1, p.2.1)) := by decide

/-- The state a door reaches from its opening position, for one command and one
argument. -/
def goldenState (c : Cabinet) (tag : String) (arg : Nat) : List Nat :=
  match c.door.table.find? (fun p => p.1 == tag) with
  | some p => runIR p.2 c.init arg
  | none => c.init

/-- The golden vectors of one cabinet. -/
def cabinetGoldenJson (c : Cabinet) : String :=
  "\"" ++ c.name ++ "\":{" ++ String.intercalate "," (c.door.table.map (fun p =>
    "\"" ++ p.1 ++ "\":[" ++ String.intercalate "," (goldenArgs.map (fun a =>
      natsToJson (goldenState c p.1 a))) ++ "]")) ++ "}"

/-- Every cabinet's golden vectors. -/
def goldenJson : String :=
  "{" ++ String.intercalate ",\n" (cabinets.map cabinetGoldenJson) ++ "}"

/-- How many cubes each cabinet's opening position draws, computed in Lean. -/
def openingVoxelsJson : String :=
  "{" ++ String.intercalate "," (List.zipWith (fun (c : Cabinet) (p : String × Nat × List Scene3D.Gadget) =>
    "\"" ++ c.name ++ "\":" ++ toString (Scene3D.sceneVoxels p.2.2 c.init).length)
    cabinets Scene3D.doorScenes) ++ "}"

/-! ## The page -/

/-- The data block. -/
def arcade3dData : String :=
  "const DOORS = " ++ doorsJson ++ ";\n" ++
  "const SCENES = " ++ scenesJson ++ ";\n" ++
  "const GOLDEN = " ++ goldenJson ++ ";\n" ++
  "const GOLDEN_ARGS = " ++ natsToJson goldenArgs ++ ";\n" ++
  "const OPENING_VOXELS = " ++ openingVoxelsJson ++ ";\n" ++
  "const ARENA = " ++ toString Scene3D.arena ++ ";\n" ++
  "const MINTOUCH = " ++ toString Mobile.minTouch ++ ";\n"

/-- The evaluator and the renderer of scenes: the two functions the page runs
the games and draws them with. -/
def arcade3dModel : String := r##"
// the emitted expression language of Machine.lean
function ev(e, st, arg) {
  switch (e[0]) {
    case "lit":  return e[1];
    case "fld":  return st[e[1]] || 0;
    case "arg":  return arg;
    case "add":  return ev(e[1], st, arg) + ev(e[2], st, arg);
    case "mul":  return ev(e[1], st, arg) * ev(e[2], st, arg);
    case "sub":  return Math.max(0, ev(e[1], st, arg) - ev(e[2], st, arg));  // truncated, as on Nat
    case "div":  return Math.floor(ev(e[1], st, arg) / ev(e[2], st, arg));
    case "le":   return ev(e[1], st, arg) <= ev(e[2], st, arg) ? 1 : 0;
    case "cond": return ev(e[1], st, arg) !== 0 ? ev(e[2], st, arg) : ev(e[3], st, arg);
  }
  throw new Error("bad expression");
}
function stepDoor(door, st, tag, arg) {
  return DOORS[door].prog[tag].map(e => ev(e, st, arg));
}
// the scene language of Scene3D.lean
function clampTo(cap, v) { return Math.min(v, cap); }
function gadgetVoxels(st, g) {
  if (g[0] === "bar") {
    const out = [], h = clampTo(g[2], st[g[1]] || 0);
    for (let k = 0; k < h; k++) out.push({ x: g[3], y: k, z: g[4], c: g[5] });
    return out;
  }
  return [{ x: clampTo(ARENA - 1, st[g[1]] || 0), y: clampTo(ARENA - 1, st[g[2]] || 0),
            z: clampTo(ARENA - 1, st[g[3]] || 0), c: g[4], size: 1.4 }];
}
function sceneVoxels(door, st) {
  const out = [];
  for (const g of SCENES[door].gadgets) for (const v of gadgetVoxels(st, g)) out.push(v);
  return out;
}
function sameVec(a, b) { return a.length === b.length && a.every((v, i) => v === b[i]); }
"##

/-- The checks, shared by the page and the headless self-test. -/
def arcade3dChecks : String := r##"
function arcadeChecks(check) {
  const names = Object.keys(DOORS);
  check("fifteen doors in the room", names.length === 15);
  check("every door has a scene", names.every(n => SCENES[n] !== undefined));
  // the page's evaluator agrees with Lean, command by command, argument by argument
  let bad = [];
  for (const n of names) {
    for (const tag of Object.keys(DOORS[n].prog)) {
      GOLDEN_ARGS.forEach((a, i) => {
        const got = stepDoor(n, DOORS[n].init, tag, a);
        if (!sameVec(got, GOLDEN[n][tag][i])) bad.push(n + "." + tag + "(" + a + ")");
      });
    }
  }
  check("every command of every door matches the Lean state, on three arguments"
    + " (" + names.reduce((s, n) => s + Object.keys(DOORS[n].prog).length, 0) * GOLDEN_ARGS.length
    + " vectors)", bad.length === 0);
  if (bad.length) check("  disagreements: " + bad.join(" "), false);
  // the scenes draw the whole state and stay in the arena
  for (const n of names) {
    check(n + ": the scene is built for the door's own state vector",
      SCENES[n].n === DOORS[n].init.length);
    const fields = new Set();
    for (const g of SCENES[n].gadgets) {
      if (g[0] === "bar") fields.add(g[1]);
      else { fields.add(g[1]); fields.add(g[2]); fields.add(g[3]); }
    }
    let covered = true;
    for (let i = 0; i < DOORS[n].init.length; i++) if (!fields.has(i)) covered = false;
    check(n + ": every field of the state is drawn", covered);
    check(n + ": the opening position draws " + OPENING_VOXELS[n] + " cubes",
      sceneVoxels(n, DOORS[n].init).length === OPENING_VOXELS[n]);
  }
  // nothing escapes the arena, under play
  let escaped = false;
  for (const n of names) {
    let st = DOORS[n].init.slice();
    const tags = Object.keys(DOORS[n].prog);
    for (let i = 0; i < 60; i++) {
      st = stepDoor(n, st, tags[i % tags.length], [0, 1, 3, 9, 99][i % 5]);
      for (const v of sceneVoxels(n, st))
        if (!(v.x < ARENA && v.y < ARENA && v.z < ARENA)) escaped = true;
    }
  }
  check("sixty moves on every cabinet, nothing drawn outside the arena", !escaped);
}
"##

/-- Head and frame. -/
def arcade3dHead : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NixWars &mdash; the arcade in three dimensions</title>
<style>
"##

/-- Body. -/
def arcade3dBody : String := r##"</style>
</head>
<body>
<div id="stage">
  <canvas id="view"></canvas>
  <div class="hud" id="hud"></div>
</div>
<div class="wrap">
  <h1>THE ARCADE IN 3D</h1>
  <p class="small">All fifteen doors, in one file, in WebGL. Every cabinet is a state vector
  and a table of compiled expressions emitted from Lean; every cabinet is drawn as a skyline of
  voxels, one tower per field of that state, with a ship for the doors whose state is a
  position. Drag to orbit, pinch to zoom, tap a command.</p>
  <div class="row">
    <label for="door">cabinet</label>
    <select id="door"></select>
    <button id="reset">RESET</button>
    <button id="demo">DEMO</button>
  </div>
  <div class="row">
    <label for="arg">argument</label>
    <input id="arg" type="range" min="0" max="100" value="0" step="1">
    <span id="argv" class="ok">0</span>
  </div>
  <div class="pad" id="pad"></div>
  <h2>STATE</h2>
  <table id="state"><tbody></tbody></table>
  <h2>SELF-CHECK</h2>
  <pre id="log"></pre>
  <p class="small">Other rooms: <a href="index.html">the main menu</a>,
  <a href="fly.html">fly the voxel world</a>,
  <a href="arcade.html">the arcade</a>, <a href="nixwars.html">the board</a>,
  <a href="voxel-world.html">the map</a>,
  <a href="cans.html">the can opener</a>.</p>
</div>
<script>
"##

/-- The page's own script. -/
def arcade3dScript : String := r##"
let door = "frontier";
let st = DOORS[door].init.slice();
let arg = 0;
let demo = null;
const cam = { yaw: 0.8, pitch: 0.5, dist: 34, target: [8, 3, 8], fov: 1.0,
  minDist: 6, maxDist: 200 };
const canvas = document.getElementById("view");
const R = makeGL(canvas);

function floorLines() {
  const out = [];
  for (let i = 0; i <= ARENA; i += 4) {
    out.push({ a: [i, 0, 0], b: [i, 0, ARENA], c: 12 });
    out.push({ a: [0, 0, i], b: [ARENA, 0, i], c: 12 });
  }
  return out.concat(boxLines(0, 0, 0, ARENA, ARENA, ARENA, 8));
}
function redraw() {
  if (R) R.draw(sceneVoxels(door, st), floorLines(), cam);
  const fields = DOORS[door].fields;
  document.getElementById("hud").innerHTML =
    "<b>" + door.toUpperCase() + "</b>  " + st.length + " fields  " +
    sceneVoxels(door, st).length + " cubes";
  document.querySelector("#state tbody").innerHTML = st.map((v, i) =>
    "<tr><td class=\"l\">" + i + "</td><td class=\"l\">" +
    (i < 3 ? ["caller", "shard", "game"][i] : (fields[i - 3] || "?")) +
    "</td><td>" + v + "</td></tr>").join("");
}
function play(tag) {
  st = stepDoor(door, st, tag, arg);
  redraw();
}
function buildPad() {
  const pad = document.getElementById("pad");
  pad.innerHTML = "";
  for (const tag of Object.keys(DOORS[door].prog)) {
    const b = document.createElement("button");
    b.textContent = tag.toUpperCase();
    b.style.minWidth = MINTOUCH + "px";
    b.style.minHeight = MINTOUCH + "px";
    b.addEventListener("click", () => play(tag));
    pad.appendChild(b);
  }
}
const sel = document.getElementById("door");
for (const n of Object.keys(DOORS)) {
  const o = document.createElement("option");
  o.value = n; o.textContent = n;
  if (n === door) o.selected = true;
  sel.appendChild(o);
}
sel.addEventListener("change", () => {
  door = sel.value; st = DOORS[door].init.slice(); buildPad(); redraw();
});
document.getElementById("reset").addEventListener("click", () => {
  st = DOORS[door].init.slice(); redraw();
});
const argEl = document.getElementById("arg");
argEl.addEventListener("input", () => {
  arg = Number(argEl.value);
  document.getElementById("argv").textContent = argEl.value;
});
document.getElementById("demo").addEventListener("click", () => {
  if (demo) { clearInterval(demo); demo = null; return; }
  const tags = Object.keys(DOORS[door].prog);
  let i = 0;
  demo = setInterval(() => { play(tags[i++ % tags.length]); }, 500);
});
if (R) attachOrbit(canvas, cam, redraw);

const log = [];
let allOk = true;
arcadeChecks((what, cond) => {
  if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what);
});
document.getElementById("log").innerHTML =
  "<span class=\"" + (allOk ? "ok" : "bad") + "\">" +
  (allOk ? "all checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");

buildPad();
redraw();
if (!R) document.getElementById("hud").innerHTML =
  "this browser has no WebGL &mdash; the cabinets below still play";
"##

/-- The whole page. -/
def arcade3dPage : String :=
  arcade3dHead ++ Gl.mobileCss ++ arcade3dBody ++
  arcade3dData ++ Gl.matrixJs ++ Gl.rendererJs ++ Gl.orbitJs ++ arcade3dModel ++
  arcade3dChecks ++ arcade3dScript ++ "\n</script>\n</body>\n</html>\n"

/-- The headless self-test. -/
def arcade3dSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Arcade3D.lean. Run: node www/arcade3d-selftest.mjs\n" ++
  arcade3dData ++ arcade3dModel ++ arcade3dChecks ++ r##"
let fails = 0, n = 0;
arcadeChecks((what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
});
console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the room and its self-test. -/
def writeArcade3d : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/arcade-3d.html" arcade3dPage
  IO.FS.writeFile "www/arcade3d-selftest.mjs" arcade3dSelfTest

#eval writeArcade3d

end Arcade3D

end NixWars
