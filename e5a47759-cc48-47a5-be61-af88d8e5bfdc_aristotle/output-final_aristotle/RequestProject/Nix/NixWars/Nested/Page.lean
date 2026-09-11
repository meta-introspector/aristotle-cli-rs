import RequestProject.Nix.NixWars.Nested.Demo
import RequestProject.Nix.NixWars.Arcade3D

/-!
# The nest as a page: `www/nested-worlds.html`

One room, three worlds, one inside the other.  The page carries nothing but
tables emitted from Lean —

* `NEST`: the three worlds of `Nested/Demo.lean`, each with its accounts, its
  shelf, its house and its clock, and the cabinet of the world above that it
  stands in;
* `GOLDEN`: the worked session, tower by tower — every account, every shelf and
  every journal line after each keypress — the deep play, the cash-out, the
  player's worth on both sides of the counter, the origins and scales of the
  three boxes, and the cube counts of the whole picture;

— and a small interpreter for those tables, which is a transcription of
`Nested/Db.lean`, `Nested/Tower.lean` and `Nested/Space.lean`.  Playing the
trading cabinet on this page settles a transaction against the world's database
and moves the cubes that the database is drawn as; walking into the cabinet
takes you down a level, into a world that works exactly the same way.

`www/nested-selftest.mjs` runs the page's own script headless and checks it
against every one of the Lean-computed values.
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 2000000

namespace NixWars

namespace Nested

namespace Page

open Scene3D
open Demo

/-! ## The tables -/

/-- One account as JSON. -/
def acctJson (a : Account) : String :=
  "{\"owner\":" ++ toString a.owner ++ ",\"credits\":" ++ toString a.credits ++
    ",\"held\":" ++ toString a.held ++ "}"

/-- One journal line as JSON. -/
def entryJson (e : Entry) : String :=
  "[" ++ toString e.owner ++ "," ++ toString e.kind ++ "," ++ toString e.price ++ "," ++
    toString e.clock ++ "]"

/-- One world's database as JSON. -/
def dbJson (db : Db) : String :=
  "{\"accounts\":[" ++ String.intercalate "," (db.accounts.map acctJson) ++
    "],\"float\":" ++ toString db.float ++ ",\"house\":" ++ toString db.house ++
    ",\"clock\":" ++ toString db.clock ++
    ",\"journal\":[" ++ String.intercalate "," (db.journal.map entryJson) ++ "]}"

/-- One world of the nest as JSON. -/
def levelJson (l : Level) : String :=
  "{\"slot\":" ++ toString l.slot ++ ",\"db\":" ++ dbJson l.db ++ "}"

/-- A whole nest as JSON. -/
def towerJson (t : Tower) : String :=
  "{\"levels\":[" ++ String.intercalate ",\n" (t.levels.map levelJson) ++ "]}"

/-- The nest, its constants and the prices its clocks quote. -/
def nestJson : String :=
  "{\"arena\":" ++ toString arena ++ ",\"cellSide\":" ++ toString cellSide ++
    ",\"cells\":" ++ toString cells ++ ",\"miniRate\":" ++ toString miniRate ++
    ",\"caller\":1,\"start\":" ++ towerJson nest ++ "}"

/-- The nest after the first `n` keypresses of the worked session. -/
def afterN (n : Nat) : Tower :=
  ((session.take n).map (txOf 1)).foldl (fun t tx => playAt t 1 tx) nest

/-- The session, tower by tower. -/
def traceJson : String :=
  "[" ++ String.intercalate ",\n"
    ((List.range (session.length + 1)).map (fun n => towerJson (afterN n))) ++ "]"

/-- Where the three boxes stand, and how big their cubes are. -/
def originsJson : String :=
  "[" ++ String.intercalate ","
    ((List.range nest.depth).map (fun k =>
      "[" ++ toString (originX nest k) ++ "," ++ toString (originZ nest k) ++ "," ++
        toString (unit nest k) ++ "]")) ++ "]"

/-- The commands of the worked session, by name. -/
def sessionJson : String :=
  "[" ++ String.intercalate "," (session.map (fun c =>
    match c with
    | .buy => "\"buy\""
    | .sell => "\"sell\""
    | .hold => "\"hold\"")) ++ "]"

/-- Everything Lean computed about the worked nest. -/
def goldenJson : String :=
  "{\"session\":" ++ sessionJson ++
    ",\"trace\":" ++ traceJson ++
    ",\"afterDeep\":" ++ towerJson afterDeep ++
    ",\"afterCash\":" ++ towerJson afterCash ++
    ",\"worthStart\":" ++ toString (playerWorth nest 1) ++
    ",\"worthDeep\":" ++ toString (playerWorth afterDeep 1) ++
    ",\"worthCash\":" ++ toString (playerWorth afterCash 1) ++
    ",\"origins\":" ++ originsJson ++
    ",\"cubesStart\":" ++ toString (nestVoxels nest).length ++
    ",\"cubesCash\":" ++ toString (nestVoxels afterCash).length ++
    ",\"picture\":" ++ toString (arena * unit nest 0) ++ "}"

/-! ## The page -/

/-- The data block. -/
def pageData : String :=
  "const NEST = " ++ nestJson ++ ";\n" ++
  "const GOLDEN = " ++ goldenJson ++ ";\n" ++
  "const MINTOUCH = " ++ toString Mobile.minTouch ++ ";\n"

/-- The interpreter: the database of `Nested/Db.lean`, the nest of
`Nested/Tower.lean` and the floor plan of `Nested/Space.lean`, transcribed. -/
def pageModel : String := r##"
// --- Nested/Db.lean: the real database ---------------------------------------
function shardPrice(t) { const m = t % 3; return m === 0 ? 47 : (m === 1 ? 59 : 71); }
function findAcct(db, o) { for (const a of db.accounts) if (a.owner === o) return a; return null; }
function cloneDb(db) {
  return { accounts: db.accounts.map(a => ({ owner: a.owner, credits: a.credits, held: a.held })),
           float: db.float, house: db.house, clock: db.clock,
           journal: db.journal.map(e => e.slice()) };
}
function legal(db, kind, o) {
  const a = findAcct(db, o);
  if (!a) return false;
  const p = shardPrice(db.clock);
  if (kind === 0) return p <= a.credits && db.float >= 1;
  if (kind === 1) return a.held >= 1 && p <= db.house;
  return true;
}
function applyTx(db, kind, o) {
  if (!legal(db, kind, o)) return db;
  const p = shardPrice(db.clock), d = cloneDb(db), a = findAcct(d, o);
  if (kind === 0) { a.credits -= p; a.held += 1; d.float -= 1; d.house += p; }
  else if (kind === 1) { a.credits += p; a.held -= 1; d.float += 1; d.house -= p; }
  d.journal.push([o, kind, p, db.clock]);
  d.clock += 1;
  return d;
}
function view(db, o) {
  const a = findAcct(db, o);
  return { credits: a ? a.credits : 0, held: a ? a.held : 0,
           price: shardPrice(db.clock), turn: db.clock };
}
function totalCredits(db) { return db.accounts.reduce((s, a) => s + a.credits, 0) + db.house; }
function totalShards(db) { return db.accounts.reduce((s, a) => s + a.held, 0) + db.float; }
// --- Nested/Tower.lean: the nest ---------------------------------------------
function playAt(t, k, kind, o) {
  if (!t.levels[k]) return t;
  const ls = t.levels.slice();
  ls[k] = { slot: ls[k].slot, db: applyTx(ls[k].db, kind, o) };
  return { levels: ls };
}
function canCash(t, k, o, n) {
  const O = t.levels[k], I = t.levels[k + 1];
  if (!O || !I) return false;
  const ai = findAcct(I.db, o), ao = findAcct(O.db, o);
  if (!ai || !ao) return false;
  return n * NEST.miniRate <= ai.held && n <= O.db.float;
}
function cashOut(t, k, o, n) {
  if (!canCash(t, k, o, n)) return t;
  const ls = t.levels.slice();
  const od = cloneDb(ls[k].db);
  findAcct(od, o).held += n; od.float -= n;
  ls[k] = { slot: ls[k].slot, db: od };
  const id = cloneDb(ls[k + 1].db);
  findAcct(id, o).held -= n * NEST.miniRate; id.float += n * NEST.miniRate;
  ls[k + 1] = { slot: ls[k + 1].slot, db: id };
  return { levels: ls };
}
function heldAt(t, k, o) {
  const l = t.levels[k];
  if (!l) return 0;
  const a = findAcct(l.db, o);
  return a ? a.held : 0;
}
function playerWorth(t, o) {
  let s = 0;
  const d = t.levels.length;
  for (let k = 0; k < d; k++) s += heldAt(t, k, o) * Math.pow(NEST.miniRate, d - 1 - k);
  return s;
}
// --- Nested/Space.lean: where the worlds stand -------------------------------
function unitOf(t, k) { return Math.pow(NEST.cellSide, t.levels.length - 1 - k); }
function originOf(t, k) {
  let x = 0, z = 0;
  for (let j = 1; j <= k; j++) {
    const s = t.levels[j] ? t.levels[j].slot : 0, u = unitOf(t, j - 1);
    x += u * (NEST.cellSide * (s % NEST.cells));
    z += u * (NEST.cellSide * Math.floor(s / NEST.cells));
  }
  return [x, z];
}
function dbVoxels(db) {
  const out = [];
  for (let i = 0; i < NEST.arena; i++) {
    const a = db.accounts[i], h = Math.min(a ? a.held : 0, NEST.arena);
    for (let y = 0; y < h; y++) out.push({ x: i, y: y, z: 0, c: 3 });
  }
  const f = Math.min(db.float, NEST.arena);
  for (let y = 0; y < f; y++) out.push({ x: NEST.arena - 1, y: y, z: NEST.arena - 1, c: 4 });
  return out;
}
function nestVoxels(t) {
  const out = [];
  for (let k = 0; k < t.levels.length; k++) {
    const o = originOf(t, k), u = unitOf(t, k);
    for (const v of dbVoxels(t.levels[k].db))
      out.push({ x: o[0] + u * v.x, y: u * v.y, z: o[1] + u * v.z, c: v.c, size: u });
  }
  return out;
}
function sameTower(a, b) { return JSON.stringify(a) === JSON.stringify(b); }
function startTower() { return JSON.parse(JSON.stringify(NEST.start)); }
const CMDS = ["buy", "sell", "hold"];
"##

/-- The checks, shared by the page and the headless self-test. -/
def pageChecks : String := r##"
function nestedChecks(check) {
  const O = NEST.caller;
  check("three worlds, one inside the other", NEST.start.levels.length === 3);
  check("each world stands in a cabinet of the one above",
    NEST.start.levels.every(l => l.slot < NEST.arena));
  // where they stand
  const org = NEST.start.levels.map((l, k) => originOf(NEST.start, k).concat([unitOf(NEST.start, k)]));
  check("the three boxes stand where Lean puts them",
    JSON.stringify(org) === JSON.stringify(GOLDEN.origins));
  check("each world inside a cabinet is a quarter of the size of its host",
    org[0][2] === NEST.cellSide * org[1][2] && org[1][2] === NEST.cellSide * org[2][2]);
  // the session, tower by tower, against Lean
  let t = startTower();
  const bad = [];
  if (!sameTower(t, GOLDEN.trace[0])) bad.push("start");
  GOLDEN.session.forEach((c, n) => {
    t = playAt(t, 1, CMDS.indexOf(c), O);
    if (!sameTower(t, GOLDEN.trace[n + 1])) bad.push(c + "@" + (n + 1));
  });
  check("the whole session in the miniature world agrees with Lean, keypress by keypress",
    bad.length === 0);
  if (bad.length) check("  disagreements: " + bad.join(" "), false);
  // playing inside the cabinet did not touch the world outside
  check("playing in the world inside the cabinet did not touch the world outside",
    JSON.stringify(t.levels[0]) === JSON.stringify(NEST.start.levels[0]));
  check("nor did it touch the world inside it",
    JSON.stringify(t.levels[2]) === JSON.stringify(NEST.start.levels[2]));
  // the audit trail
  check("its journal is one line per settled trade, at the prices its clock quoted",
    JSON.stringify(t.levels[1].db.journal) ===
      JSON.stringify(GOLDEN.trace[GOLDEN.trace.length - 1].levels[1].db.journal));
  // the game inside the game
  const deep = playAt(t, 2, 0, O);
  check("a buy in the world inside that one lands where Lean says",
    sameTower(deep, GOLDEN.afterDeep));
  check("and leaves the two worlds above it exactly as they were",
    JSON.stringify(deep.levels[0]) === JSON.stringify(t.levels[0]) &&
    JSON.stringify(deep.levels[1]) === JSON.stringify(t.levels[1]));
  // cashing out
  check("four shards in the little world can be cashed for one in the big one",
    canCash(deep, 0, O, 1));
  const cash = cashOut(deep, 0, O, 1);
  check("the cash-out lands where Lean says", sameTower(cash, GOLDEN.afterCash));
  check("the shard came off the big world's own shelf",
    cash.levels[0].db.float + 1 === deep.levels[0].db.float);
  check("and the four went back on the little world's shelf",
    cash.levels[1].db.float === deep.levels[1].db.float + NEST.miniRate);
  check("cashing out more than you hold does nothing",
    sameTower(cashOut(deep, 0, O, 99), deep));
  // no money pump
  check("the player is worth " + GOLDEN.worthStart + " at the start",
    playerWorth(startTower(), O) === GOLDEN.worthStart);
  check("and " + GOLDEN.worthDeep + " after the session", playerWorth(deep, O) === GOLDEN.worthDeep);
  check("and exactly the same after cashing out — nesting worlds is not a money pump",
    playerWorth(cash, O) === GOLDEN.worthCash && GOLDEN.worthCash === GOLDEN.worthDeep);
  // the books balance at every level, whatever is played
  let bal = true, w = startTower();
  const before = w.levels.map(l => [totalCredits(l.db), totalShards(l.db)]);
  for (let n = 0; n < 30; n++) w = playAt(w, n % 3, n % 3, O);
  w.levels.forEach((l, k) => {
    if (totalCredits(l.db) !== before[k][0] || totalShards(l.db) !== before[k][1]) bal = false;
  });
  check("thirty keypresses across all three worlds: no credit and no shard is minted", bal);
  // a refused trade changes nothing
  const poor = startTower();
  poor.levels[1].db.accounts[0].credits = 3;
  check("a trade the book refuses changes nothing at all",
    sameTower(playAt(poor, 1, 0, O), poor));
  const empty = startTower();
  empty.levels[1].db.float = 0;
  check("and a market with an empty shelf sells nothing",
    sameTower(playAt(empty, 1, 0, O), empty));
  // the picture
  check("the opening nest draws " + GOLDEN.cubesStart + " cubes",
    nestVoxels(startTower()).length === GOLDEN.cubesStart);
  check("after the session and the cash-out it draws " + GOLDEN.cubesCash,
    nestVoxels(cash).length === GOLDEN.cubesCash);
  let outside = false;
  for (const v of nestVoxels(cash))
    if (!(v.x < GOLDEN.picture && v.y < GOLDEN.picture && v.z < GOLDEN.picture)) outside = true;
  check("every cube of every world is inside the outermost world", !outside);
  // the little world is drawn inside the cabinet it stands in
  let strayed = false, trespassed = false;
  for (let k = 1; k < cash.levels.length; k++) {
    const s = cash.levels[k].slot, u = unitOf(cash, k - 1), o = originOf(cash, k - 1);
    const cx = o[0] + u * (NEST.cellSide * (s % NEST.cells));
    const cz = o[1] + u * (NEST.cellSide * Math.floor(s / NEST.cells));
    const side = NEST.cellSide * u;
    const inner = nestVoxels({ levels: cash.levels.slice(k) });
    for (const v of dbVoxels(cash.levels[k].db)) {
      const uu = unitOf(cash, k), oo = originOf(cash, k);
      const x = oo[0] + uu * v.x, z = oo[1] + uu * v.z, y = uu * v.y;
      if (!(cx <= x && x < cx + side && z >= cz && z < cz + side && y < side)) strayed = true;
      for (let s2 = 0; s2 < NEST.arena; s2++) {
        if (s2 === s) continue;
        const ox2 = o[0] + u * (NEST.cellSide * (s2 % NEST.cells));
        const oz2 = o[1] + u * (NEST.cellSide * Math.floor(s2 / NEST.cells));
        if (ox2 <= x && x < ox2 + side && oz2 <= z && z < oz2 + side) trespassed = true;
      }
    }
    if (inner.length === 0) strayed = true;
  }
  check("the miniature world is drawn inside the cabinet it stands in", !strayed);
  check("and never over another cabinet of the room it stands in", !trespassed);
}
"##

/-- Head. -/
def pageHead : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NixWars &mdash; nested worlds</title>
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
  <h1>NESTED WORLDS</h1>
  <p class="small">The trading game is not a game about trading: it is a window on the world's
  own database. Every shard you buy comes off that world's shelf and every credit you pay goes
  to its house, and the cubes you see are that database drawn. Standing in one of the cabinets
  of this world is another whole world, with its own accounts, its own market and its own
  cabinets &mdash; a game inside the game, drawn at a quarter of the size inside the cabinet it
  stands in. Four shards in the little world cash out for one shard in the big one, and that
  exchange leaves you worth exactly what you were worth. Drag to orbit, pinch to zoom.</p>
  <div class="row">
    <label for="level">world</label>
    <select id="level"></select>
    <button id="enter">ENTER THE CABINET</button>
    <button id="leave">LEAVE</button>
    <button id="reset">RESET</button>
  </div>
  <div class="pad" id="pad"></div>
  <div class="row">
    <button id="cash">CASH OUT 1 SHARD FROM THE WORLD INSIDE</button>
  </div>
  <h2>THIS WORLD</h2>
  <table id="screen"><tbody></tbody></table>
  <h2>THE NEST</h2>
  <table id="nest"><tbody></tbody></table>
  <h2>THE JOURNAL OF THIS WORLD</h2>
  <pre id="journal"></pre>
  <h2>SELF-CHECK</h2>
  <pre id="log"></pre>
  <p class="small">Other rooms: <a href="index.html">the main menu</a>,
  <a href="voxel-arcade.html">all fifteen cabinets in one hall</a>,
  <a href="frontier-voxel.html">the market you fly to</a>,
  <a href="nixwars.html">the board</a>, <a href="bbs.html">the BBS</a>.</p>
</div>
<script>
"##

/-- The page's own script. -/
def pageScript : String := r##"
let nest = startTower();
let here = 0;
const O = NEST.caller;
const cam = { yaw: 0.9, pitch: 0.7, dist: 420, target: [128, 20, 128], fov: 1.0,
  minDist: 20, maxDist: 1200 };
const canvas = document.getElementById("view");
const R = makeGL(canvas);

function boxOf(k) {
  const o = originOf(nest, k), u = unitOf(nest, k), s = NEST.arena * u;
  return boxLines(o[0], 0, o[1], o[0] + s, s, o[1] + s, k === here ? 9 : 12);
}
function frame() {
  let out = [];
  for (let k = 0; k < nest.levels.length; k++) out = out.concat(boxOf(k));
  return out;
}
function redraw() {
  if (R) R.draw(nestVoxels(nest), frame(), cam);
  const db = nest.levels[here].db, v = view(db, O);
  document.getElementById("hud").innerHTML =
    "<b>WORLD " + here + "</b> &mdash; " + v.credits + " credits, " + v.held +
    " shards, quote " + v.price + " at tick " + v.turn + "  &mdash;  worth across the nest: " +
    playerWorth(nest, O) + " (innermost unit)";
  document.querySelector("#screen tbody").innerHTML =
    "<tr><td class=\"l\">credits</td><td>" + v.credits + "</td></tr>" +
    "<tr><td class=\"l\">shards held</td><td>" + v.held + "</td></tr>" +
    "<tr><td class=\"l\">quote</td><td>" + v.price + "</td></tr>" +
    "<tr><td class=\"l\">clock</td><td>" + v.turn + "</td></tr>" +
    "<tr><td class=\"l\">on the shelf</td><td>" + db.float + "</td></tr>" +
    "<tr><td class=\"l\">the house</td><td>" + db.house + "</td></tr>";
  document.querySelector("#nest tbody").innerHTML = nest.levels.map((l, k) => {
    const o = originOf(nest, k), u = unitOf(nest, k);
    return "<tr><td class=\"l\">world " + k + (k === here ? " (here)" : "") +
      "</td><td class=\"l\">in cabinet " + (k === 0 ? "&mdash;" : l.slot) +
      "</td><td>" + heldAt(nest, k, O) + " shards</td><td>&times;" +
      Math.pow(NEST.miniRate, nest.levels.length - 1 - k) +
      "</td><td class=\"l\">at (" + o[0] + "," + o[1] + "), cube " + u + "</td></tr>";
  }).join("") + "<tr><td class=\"l\"><b>worth</b></td><td></td><td></td><td><b>" +
    playerWorth(nest, O) + "</b></td><td></td></tr>";
  document.getElementById("journal").textContent =
    db.journal.length === 0 ? "  (nothing traded here yet)"
      : db.journal.map(e => "  caller " + e[0] + "  " + CMDS[e[1]].toUpperCase() +
          "  at " + e[2] + "  on tick " + e[3]).join("\n");
}
function buildPad() {
  const pad = document.getElementById("pad");
  pad.innerHTML = "";
  CMDS.forEach((c, k) => {
    const b = document.createElement("button");
    b.textContent = c.toUpperCase();
    b.style.minWidth = MINTOUCH + "px";
    b.style.minHeight = MINTOUCH + "px";
    b.addEventListener("click", () => { nest = playAt(nest, here, k, O); redraw(); });
    pad.appendChild(b);
  });
}
const sel = document.getElementById("level");
function buildLevels() {
  sel.innerHTML = "";
  nest.levels.forEach((l, k) => {
    const o = document.createElement("option");
    o.value = String(k);
    o.textContent = "world " + k + (k === 0 ? "" : " (inside cabinet " + l.slot + ")");
    if (k === here) o.selected = true;
    sel.appendChild(o);
  });
}
sel.addEventListener("change", () => { here = Number(sel.value); redraw(); });
document.getElementById("enter").addEventListener("click", () => {
  if (here + 1 < nest.levels.length) { here += 1; buildLevels(); redraw(); }
});
document.getElementById("leave").addEventListener("click", () => {
  if (here > 0) { here -= 1; buildLevels(); redraw(); }
});
document.getElementById("reset").addEventListener("click", () => {
  nest = startTower(); here = 0; buildLevels(); redraw();
});
document.getElementById("cash").addEventListener("click", () => {
  nest = cashOut(nest, here, O, 1); redraw();
});
if (R) attachOrbit(canvas, cam, redraw);

const log = [];
let allOk = true;
nestedChecks((what, cond) => {
  if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what);
});
document.getElementById("log").innerHTML =
  "<span class=\"" + (allOk ? "ok" : "bad") + "\">" +
  (allOk ? "all checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");

buildLevels();
buildPad();
redraw();
if (!R) document.getElementById("hud").innerHTML =
  "this browser has no WebGL &mdash; the worlds below still trade";
"##

/-- The whole page. -/
def nestedPage : String :=
  pageHead ++ Gl.mobileCss ++ pageBody ++
  pageData ++ Gl.matrixJs ++ Gl.rendererJs ++ Gl.orbitJs ++ pageModel ++
  pageChecks ++ pageScript ++ "\n</script>\n</body>\n</html>\n"

/-- The headless self-test. -/
def nestedSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Nested/Page.lean. Run: node www/nested-selftest.mjs\n" ++
  pageData ++ pageModel ++ pageChecks ++ r##"
let fails = 0, n = 0;
nestedChecks((what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
});
console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the nested worlds page and its self-test. -/
def writeNestedWorlds : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/nested-worlds.html" nestedPage
  IO.FS.writeFile "www/nested-selftest.mjs" nestedSelfTest
  IO.println s!"nested worlds: page {nestedPage.length} bytes, self-test {nestedSelfTest.length} bytes"

#eval writeNestedWorlds

end Page

end Nested

end NixWars
