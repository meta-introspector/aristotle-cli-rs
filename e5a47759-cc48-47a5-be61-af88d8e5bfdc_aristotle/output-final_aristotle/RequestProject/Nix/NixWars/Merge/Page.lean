import RequestProject.Nix.NixWars.Merge.Hall
import RequestProject.Nix.NixWars.Arcade3D

/-!
# The merged arcade as a page: `www/voxel-arcade.html`

One room, fifteen cabinets, one purse.  The page carries nothing but tables
emitted from Lean —

* `HALL.games`: for each cabinet its field names, the state it opens in, its
  compiled command table (the very table `Machine.lean` proves computes that
  game's own step function), the scoring rule with the field *indices* the rule
  reads (`fieldIndex_correct`), the rate at which its points buy shards, what it
  asks at the door, and the scene that draws it;
* `HALL.floor`: where each cabinet stands in the hall, which is the floor plan
  `Merge/Hall.lean` proves keeps the cabinets apart;
* `GOLDEN`: the whole worked session of `Merge/World.lean`, world by world — the
  purse, the bank, the total and which doors are open after every single move —
  the save vector, the merge of two purses, and the cube counts of the hall.

— and a small interpreter for those tables.  `www/voxel-arcade-selftest.mjs`
runs the page's own script headless and checks it against every one of those
Lean-computed values.
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

namespace NixWars

namespace Merge

namespace Page

open Scene3D

/-! ## The tables -/

/-- One scoring term as JSON: the field index the rule reads, its name and its
weight. -/
def termJson (names : List String) (t : String × Nat) : String :=
  "[" ++ toString (fieldIndex names t.1) ++ ",\"" ++ t.1 ++ "\"," ++ toString t.2 ++ "]"

/-- A scoring rule as JSON. -/
def ruleJson (names : List String) (r : ScoreRule) : String :=
  "{\"base\":" ++ toString r.base ++
    ",\"credits\":[" ++ String.intercalate "," (r.credits.map (termJson names)) ++
    "],\"debits\":[" ++ String.intercalate "," (r.debits.map (termJson names)) ++ "]}"

/-- One cabinet's command table as JSON: a list, in the order the world plays
them by index. -/
def cmdsJson (d : Wasm.DoorIR) : String :=
  "[" ++ String.intercalate "," (d.table.map (fun p =>
    "{\"name\":\"" ++ p.1 ++ "\",\"prog\":" ++ progToJson p.2 ++ "}")) ++ "]"

/-- One cabinet as JSON. -/
def cabinetJson (i : Nat) (c : Cabinet) : String :=
  let scene := (doorScenes[i]?).map (·.2.2) |>.getD []
  "{\"name\":\"" ++ c.name ++ "\",\"fields\":" ++ stringsToJson c.names ++
    ",\"init\":" ++ natsToJson c.init ++
    ",\"cmds\":" ++ cmdsJson c.door ++
    ",\"rule\":" ++ ruleJson c.names c.rule ++
    ",\"rate\":" ++ toString c.rate ++
    ",\"gate\":" ++ toString (gateOf i) ++
    ",\"scene\":[" ++ String.intercalate "," (scene.map Arcade3D.gadgetJson) ++ "]}"

/-- Every cabinet of the merged arcade. -/
def gamesJson : String :=
  "[" ++ String.intercalate ",\n" ((List.range numGames).map (fun i =>
    match cabinets[i]? with
    | some c => cabinetJson i c
    | none => "null")) ++ "]"

/-- The hall as JSON. -/
def hallJson : String :=
  "{\"arena\":" ++ toString arena ++ ",\"cols\":" ++ toString Hall.cols ++
    ",\"boardZ\":" ++ toString Hall.boardZ ++ ",\"width\":" ++ toString Hall.hallWidth ++
    ",\"bound\":" ++ toString Hall.hallBound ++
    ",\"sessionFields\":" ++ toString sessionFields ++
    ",\"numGames\":" ++ toString numGames ++
    ",\"games\":" ++ gamesJson ++ "}"

/-! ## The golden values -/

/-- The worked session of `Merge/World.lean`. -/
def demoMoves : List (Nat × Nat × Nat) := dashSession ++ marketSession

/-- One world as JSON: the purse, the bank, the spend, the total and the doors
that are open. -/
def worldJson (w : World) : String :=
  "{\"purse\":" ++ natsToJson w.purse ++ ",\"bank\":" ++ toString w.bank ++
    ",\"spent\":" ++ toString w.spent ++ ",\"total\":" ++ toString (purseTotal w.purse) ++
    ",\"open\":[" ++ String.intercalate ","
      ((List.range numGames).map (fun i => if unlocked w i then "1" else "0")) ++
    "],\"states\":[" ++ String.intercalate "," (w.states.map natsToJson) ++ "]}"

/-- The whole session, world by world. -/
def traceJson : String :=
  "[" ++ String.intercalate ",\n" ((List.range (demoMoves.length + 1)).map (fun n =>
    worldJson (run initialWorld (demoMoves.take n)))) ++ "]"

/-- The moves themselves. -/
def movesJson : String :=
  "[" ++ String.intercalate "," (demoMoves.map (fun m =>
    "[" ++ toString m.1 ++ "," ++ toString m.2.1 ++ "," ++ toString m.2.2 ++ "]")) ++ "]"

/-- Two purses that were earned apart, and what they come to when merged. -/
def purseA : List Nat := [3, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

/-- The other player's purse. -/
def purseB : List Nat := [0, 2, 48, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

/-- The golden block. -/
def goldenJson : String :=
  "{\"moves\":" ++ movesJson ++
    ",\"trace\":" ++ traceJson ++
    ",\"save\":" ++ natsToJson (encodeWorld afterMarket) ++
    ",\"purseA\":" ++ natsToJson purseA ++
    ",\"purseB\":" ++ natsToJson purseB ++
    ",\"merged\":" ++ natsToJson (mergePurse purseA purseB) ++
    ",\"mergedTotal\":" ++ toString (purseTotal (mergePurse purseA purseB)) ++
    ",\"openingCubes\":" ++ toString (Hall.hallVoxels initialWorld).length ++
    ",\"demoCubes\":" ++ toString (Hall.hallVoxels afterMarket).length ++
    ",\"spendBank\":" ++ toString (spend afterMarket 40).bank ++
    ",\"spendSpent\":" ++ toString (spend afterMarket 40).spent ++ "}"

/-! ## The page -/

/-- The data block. -/
def pageData : String :=
  "const HALL = " ++ hallJson ++ ";\n" ++
  "const GOLDEN = " ++ goldenJson ++ ";\n" ++
  "const MINTOUCH = " ++ toString Mobile.minTouch ++ ";\n"

/-- The interpreter: the expression language, the merged world, and the hall.
Every rule of the merged game lives in this one function block, and each is a
transcription of a Lean definition of `Merge/Score.lean`, `Merge/World.lean` and
`Merge/Hall.lean`. -/
def pageModel : String := r##"
// --- the expression language of Machine.lean ---------------------------------
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
const SF = HALL.sessionFields;
// --- Merge/World.lean: stepping one cabinet ----------------------------------
function stepState(i, st, k, arg) {
  const g = HALL.games[i];
  if (!g || !g.cmds[k]) return st.slice();
  const own = st.slice(SF);
  return st.slice(0, SF).concat(g.cmds[k].prog.map(e => ev(e, own, arg)));
}
// --- Merge/Score.lean: what a state is worth ---------------------------------
function ruleScore(rule, st) {
  let v = rule.base;
  for (const t of rule.credits) v += t[2] * (st[t[0]] || 0);
  for (const t of rule.debits)  v -= t[2] * (st[t[0]] || 0);
  return Math.max(0, v);
}
function scoreOf(i, st) {
  const g = HALL.games[i];
  if (!g) return 0;
  return Math.max(0, ruleScore(g.rule, st) - ruleScore(g.rule, g.init));
}
function purseTotal(purse) {
  let t = 0;
  for (let i = 0; i < HALL.games.length; i++) t += HALL.games[i].rate * (purse[i] || 0);
  return t;
}
function unlocked(w, i) { return HALL.games[i].gate <= purseTotal(w.purse); }
function initialWorld() {
  return { states: HALL.games.map(g => g.init.slice()),
           purse: HALL.games.map(() => 0), bank: 0, spent: 0 };
}
function play(w, i, k, arg) {
  if (!HALL.games[i] || !unlocked(w, i)) return w;
  const st = stepState(i, w.states[i], k, arg);
  const v = scoreOf(i, st);
  const old = w.purse[i];
  const states = w.states.slice(); states[i] = st;
  const purse = w.purse.slice(); purse[i] = Math.max(old, v);
  return { states: states, purse: purse,
           bank: w.bank + HALL.games[i].rate * (Math.max(old, v) - old), spent: w.spent };
}
function spend(w, cost) {
  if (cost > w.bank) return w;
  return { states: w.states, purse: w.purse, bank: w.bank - cost, spent: w.spent + cost };
}
function mergePurse(a, b) {
  const n = Math.min(a.length, b.length), out = [];
  for (let i = 0; i < n; i++) out.push(Math.max(a[i], b[i]));
  return out;
}
// --- Merge/World.lean: one save ----------------------------------------------
function encodeWorld(w) {
  let out = [];
  for (const st of w.states) out = out.concat(st);
  return out.concat(w.purse).concat([w.bank, w.spent]);
}
function decodeWorld(v) {
  const states = [];
  let at = 0;
  for (const g of HALL.games) {
    if (at + g.init.length > v.length) return null;
    states.push(v.slice(at, at + g.init.length));
    at += g.init.length;
  }
  const rest = v.slice(at);
  if (rest.length !== HALL.numGames + 2) return null;
  return { states: states, purse: rest.slice(0, HALL.numGames),
           bank: rest[HALL.numGames], spent: rest[HALL.numGames + 1] };
}
// --- Merge/Hall.lean: the room ------------------------------------------------
function blockX(i) { return HALL.arena * (i % HALL.cols); }
function blockZ(i) { return HALL.arena * Math.floor(i / HALL.cols); }
function clampTo(cap, v) { return Math.min(v, cap); }
function gadgetVoxels(st, g) {
  if (g[0] === "bar") {
    const out = [], h = clampTo(g[2], st[g[1]] || 0);
    for (let k = 0; k < h; k++) out.push({ x: g[3], y: k, z: g[4], c: g[5] });
    return out;
  }
  return [{ x: clampTo(HALL.arena - 1, st[g[1]] || 0), y: clampTo(HALL.arena - 1, st[g[2]] || 0),
            z: clampTo(HALL.arena - 1, st[g[3]] || 0), c: g[4], size: 1.4 }];
}
function cabinetVoxels(i, st) {
  const out = [];
  for (const g of HALL.games[i].scene)
    for (const v of gadgetVoxels(st, g))
      out.push({ x: v.x + blockX(i), y: v.y, z: v.z + blockZ(i), c: v.c, size: v.size });
  return out;
}
function scoreboardVoxels(w) {
  const out = [];
  for (let i = 0; i < HALL.numGames; i++)
    for (let h = 0; h < Math.min(w.purse[i], HALL.arena); h++)
      out.push({ x: i, y: h, z: HALL.boardZ, c: 1 });
  for (let h = 0; h < Math.min(w.bank, HALL.arena); h++)
    out.push({ x: HALL.numGames, y: h, z: HALL.boardZ, c: 2 });
  return out;
}
function hallVoxels(w) {
  let out = [];
  for (let i = 0; i < HALL.numGames; i++) out = out.concat(cabinetVoxels(i, w.states[i]));
  return out.concat(scoreboardVoxels(w));
}
function sameVec(a, b) { return a.length === b.length && a.every((v, i) => v === b[i]); }
"##

/-- The checks, shared by the page and the headless self-test. -/
def pageChecks : String := r##"
function mergedChecks(check) {
  check("fifteen cabinets in the hall", HALL.games.length === 15);
  check("every cabinet has a scene, a rule, a rate and a gate",
    HALL.games.every(g => g.scene.length > 0 && g.rule && g.rate > 0 && g.gate >= 0));
  // the compiled tables are written for the game's own fields
  check("every command writes exactly the game's own fields",
    HALL.games.every(g => g.cmds.every(c => c.prog.length === g.fields.length)));
  check("every state vector is the three session fields and the game's own",
    HALL.games.every(g => g.init.length === HALL.sessionFields + g.fields.length));
  // the scoring rules read the fields they name
  check("every scoring rule reads the field it names",
    HALL.games.every(g => g.rule.credits.concat(g.rule.debits).every(
      t => g.fields[t[0] - HALL.sessionFields] === t[1])));
  check("every cabinet opens at nothing scored",
    HALL.games.every((g, i) => scoreOf(i, g.init) === 0));
  // the worked session, world by world, against Lean
  let w = initialWorld();
  let bad = [];
  const cmp = (n, w) => {
    const g = GOLDEN.trace[n];
    if (!sameVec(w.purse, g.purse)) bad.push("purse@" + n);
    if (w.bank !== g.bank) bad.push("bank@" + n);
    if (purseTotal(w.purse) !== g.total) bad.push("total@" + n);
    for (let i = 0; i < HALL.numGames; i++)
      if ((unlocked(w, i) ? 1 : 0) !== g.open[i]) bad.push("open" + i + "@" + n);
    for (let i = 0; i < HALL.numGames; i++)
      if (!sameVec(w.states[i], g.states[i])) bad.push("state" + i + "@" + n);
  };
  cmp(0, w);
  GOLDEN.moves.forEach((m, n) => { w = play(w, m[0], m[1], m[2]); cmp(n + 1, w); });
  check("the whole session agrees with Lean, move by move ("
    + (GOLDEN.moves.length + 1) + " worlds)", bad.length === 0);
  if (bad.length) check("  disagreements: " + bad.slice(0, 12).join(" "), false);
  // the merged points, and what they open
  const afterDash = GOLDEN.trace[12], afterMarket = GOLDEN.trace[GOLDEN.trace.length - 1];
  check("twelve ticks of dash are worth 25 shards", afterDash.total === 25);
  check("dash alone does not open Red Shard", afterDash.open[3] === 0);
  check("dash and the market together are worth 73", afterMarket.total === 73);
  check("and they open Red Shard", afterMarket.open[3] === 1);
  check("the dash cabinet is where the dash left it",
    sameVec(afterDash.states[1], afterMarket.states[1]));
  check("the market never touched any other cabinet",
    afterDash.states.every((s, i) => i === 2 || sameVec(s, afterMarket.states[i])));
  // a locked cabinet cannot be played
  const cold = initialWorld();
  check("a locked cabinet cannot be played", play(cold, 14, 0, 1) === cold);
  // points never fall, whatever is played
  let fell = false, w2 = initialWorld(), prev = 0;
  for (let n = 0; n < 60; n++) {
    w2 = play(w2, n % 15, n % 3, n % 7);
    if (purseTotal(w2.purse) < prev) fell = true;
    prev = purseTotal(w2.purse);
  }
  check("sixty moves across all fifteen cabinets, the total never falls", !fell);
  // the books balance
  let balanced = true;
  let w3 = initialWorld();
  GOLDEN.moves.forEach(m => {
    w3 = play(w3, m[0], m[1], m[2]);
    if (w3.bank + w3.spent !== purseTotal(w3.purse)) balanced = false;
  });
  const s = spend(w3, 40);
  if (s.bank + s.spent !== purseTotal(s.purse)) balanced = false;
  check("nothing is minted and nothing evaporates: bank + spent = the purse", balanced);
  check("spending forty leaves " + GOLDEN.spendBank + " in hand and "
    + GOLDEN.spendSpent + " on the counter",
    s.bank === GOLDEN.spendBank && s.spent === GOLDEN.spendSpent);
  check("spending more than the bank does nothing", spend(w3, 10000) === w3);
  // one save carries the lot
  check("the save vector is the one Lean wrote", sameVec(encodeWorld(w3), GOLDEN.save));
  const back = decodeWorld(encodeWorld(w3));
  check("the save reads back exactly", back !== null && sameVec(encodeWorld(back), GOLDEN.save));
  // two purses merge
  const m = mergePurse(GOLDEN.purseA, GOLDEN.purseB);
  check("two purses merge to the better record of each game", sameVec(m, GOLDEN.merged));
  check("merging is commutative", sameVec(m, mergePurse(GOLDEN.purseB, GOLDEN.purseA)));
  check("merging is idempotent", sameVec(m, mergePurse(m, m)));
  check("the merged purse is worth " + GOLDEN.mergedTotal, purseTotal(m) === GOLDEN.mergedTotal);
  check("merging never loses a record",
    m.every((v, i) => v >= GOLDEN.purseA[i] && v >= GOLDEN.purseB[i]));
  // the hall
  check("the opening hall draws " + GOLDEN.openingCubes + " cubes",
    hallVoxels(initialWorld()).length === GOLDEN.openingCubes);
  let wd = initialWorld();
  GOLDEN.moves.forEach(mv => { wd = play(wd, mv[0], mv[1], mv[2]); });
  check("after the session it draws " + GOLDEN.demoCubes,
    hallVoxels(wd).length === GOLDEN.demoCubes);
  check("the hall never draws more than " + HALL.bound + " cubes",
    hallVoxels(wd).length <= HALL.bound);
  let outside = false, overlap = false, boardClash = false;
  for (let n = 0; n < 40; n++) wd = play(wd, n % 15, n % 4, n % 5);
  const cells = new Map();
  for (let i = 0; i < HALL.numGames; i++)
    for (const v of cabinetVoxels(i, wd.states[i])) {
      if (!(v.x < HALL.width && v.y < HALL.arena && v.z < HALL.boardZ)) outside = true;
      const key = v.x + ":" + v.z;
      if (cells.has(key) && cells.get(key) !== i) overlap = true;
      cells.set(key, i);
    }
  for (const v of scoreboardVoxels(wd)) if (v.z !== HALL.boardZ) boardClash = true;
  check("every cabinet stays inside the room", !outside);
  check("no two cabinets ever share a floor tile", !overlap);
  check("the scoreboard stands behind every cabinet", !boardClash);
}
"##

/-- Head and frame. -/
def pageHead : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NixWars &mdash; the merged arcade</title>
<style>
"##

/-- Body. -/
def pageBody : String := r##"</style>
</head>
<body>
<div id="stage">
  <canvas id="view"></canvas>
  <div class="hud" id="hud"></div>
</div>
<div class="wrap">
  <h1>THE MERGED ARCADE</h1>
  <p class="small">All fifteen games in one voxel hall, and one score between them. Every
  cabinet keeps its own state while you play the others; every point earned anywhere is a shard
  in the same purse; and a cabinet only opens when the merged total reaches what it asks at the
  door. Drag to orbit, pinch to zoom, pick a cabinet and play.</p>
  <div class="row">
    <label for="door">cabinet</label>
    <select id="door"></select>
    <button id="reset">RESET ALL</button>
    <button id="save">SAVE</button>
    <button id="load">LOAD</button>
  </div>
  <div class="row">
    <label for="arg">argument</label>
    <input id="arg" type="range" min="0" max="100" value="0" step="1">
    <span id="argv" class="ok">0</span>
  </div>
  <div class="pad" id="pad"></div>
  <h2>THE PURSE</h2>
  <table id="purse"><tbody></tbody></table>
  <h2>THIS CABINET</h2>
  <table id="state"><tbody></tbody></table>
  <h2>SAVE</h2>
  <textarea id="savebox" rows="3" style="width:100%"></textarea>
  <h2>SELF-CHECK</h2>
  <pre id="log"></pre>
  <p class="small">Other rooms: <a href="index.html">the main menu</a>,
  <a href="arcade-3d.html">one cabinet at a time in 3D</a>,
  <a href="fly.html">fly the voxel world</a>, <a href="nixwars.html">the board</a>,
  <a href="bbs.html">the BBS</a>.</p>
</div>
<script>
"##

/-- The page's own script. -/
def pageScript : String := r##"
let world = initialWorld();
let door = 0;
let arg = 0;
const cam = { yaw: 0.9, pitch: 0.7, dist: 110, target: [32, 4, 32], fov: 1.0,
  minDist: 10, maxDist: 400 };
const canvas = document.getElementById("view");
const R = makeGL(canvas);

function floorLines() {
  const out = [];
  for (let i = 0; i <= HALL.cols; i++) {
    out.push({ a: [i * HALL.arena, 0, 0], b: [i * HALL.arena, 0, HALL.boardZ], c: 12 });
    out.push({ a: [0, 0, i * HALL.arena], b: [HALL.width, 0, i * HALL.arena], c: 12 });
  }
  return out.concat(boxLines(blockX(door), 0, blockZ(door),
    blockX(door) + HALL.arena, HALL.arena, blockZ(door) + HALL.arena, 9));
}
function redraw() {
  if (R) R.draw(hallVoxels(world), floorLines(), cam);
  const g = HALL.games[door];
  document.getElementById("hud").innerHTML =
    "<b>" + g.name.toUpperCase() + "</b>  " + (unlocked(world, door) ? "open" : "LOCKED (needs "
      + g.gate + ")") + "  &mdash;  purse " + purseTotal(world.purse) + " shards, bank "
      + world.bank + ", spent " + world.spent;
  document.querySelector("#purse tbody").innerHTML = HALL.games.map((gg, i) =>
    "<tr><td class=\"l\">" + gg.name + "</td><td>" + world.purse[i] + "</td><td>&times;"
    + gg.rate + "</td><td>" + gg.rate * world.purse[i] + "</td><td class=\"l\">"
    + (unlocked(world, i) ? "open" : "needs " + gg.gate) + "</td></tr>").join("")
    + "<tr><td class=\"l\"><b>total</b></td><td></td><td></td><td><b>"
    + purseTotal(world.purse) + "</b></td><td></td></tr>";
  const st = world.states[door];
  document.querySelector("#state tbody").innerHTML = st.map((v, i) =>
    "<tr><td class=\"l\">" + i + "</td><td class=\"l\">" +
    (i < HALL.sessionFields ? ["caller", "shard", "game"][i]
      : (g.fields[i - HALL.sessionFields] || "?")) +
    "</td><td>" + v + "</td></tr>").join("");
}
function buildPad() {
  const pad = document.getElementById("pad");
  pad.innerHTML = "";
  HALL.games[door].cmds.forEach((c, k) => {
    const b = document.createElement("button");
    b.textContent = c.name.toUpperCase();
    b.style.minWidth = MINTOUCH + "px";
    b.style.minHeight = MINTOUCH + "px";
    b.addEventListener("click", () => { world = play(world, door, k, arg); redraw(); });
    pad.appendChild(b);
  });
}
const sel = document.getElementById("door");
HALL.games.forEach((g, i) => {
  const o = document.createElement("option");
  o.value = String(i); o.textContent = g.name;
  if (i === door) o.selected = true;
  sel.appendChild(o);
});
sel.addEventListener("change", () => { door = Number(sel.value); buildPad(); redraw(); });
document.getElementById("reset").addEventListener("click", () => {
  world = initialWorld(); redraw();
});
document.getElementById("save").addEventListener("click", () => {
  document.getElementById("savebox").value = encodeWorld(world).join(",");
});
document.getElementById("load").addEventListener("click", () => {
  const v = document.getElementById("savebox").value.split(",").map(Number);
  const w = decodeWorld(v);
  if (w) { world = w; redraw(); }
});
const argEl = document.getElementById("arg");
argEl.addEventListener("input", () => {
  arg = Number(argEl.value);
  document.getElementById("argv").textContent = argEl.value;
});
if (R) attachOrbit(canvas, cam, redraw);

const log = [];
let allOk = true;
mergedChecks((what, cond) => {
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
def mergedPage : String :=
  pageHead ++ Gl.mobileCss ++ pageBody ++
  pageData ++ Gl.matrixJs ++ Gl.rendererJs ++ Gl.orbitJs ++ pageModel ++
  pageChecks ++ pageScript ++ "\n</script>\n</body>\n</html>\n"

/-- The headless self-test. -/
def mergedSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Merge/Page.lean. Run: node www/voxel-arcade-selftest.mjs\n" ++
  pageData ++ pageModel ++ pageChecks ++ r##"
let fails = 0, n = 0;
mergedChecks((what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
});
console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the merged arcade and its self-test. -/
def writeMergedArcade : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/voxel-arcade.html" mergedPage
  IO.FS.writeFile "www/voxel-arcade-selftest.mjs" mergedSelfTest
  IO.println s!"merged arcade: page {mergedPage.length} bytes, self-test {mergedSelfTest.length} bytes"

#eval writeMergedArcade

end Page

end Merge

end NixWars
