import RequestProject.Nix.NixWars.Cans
import RequestProject.Nix.NixWars.Gl

/-!
# The can opener: `www/cans.html`

The page that makes `Cans.lean` something you can look at. The whole world —
the board's fifteen cabinets and every field of their state, the 194 rows of
the Monster's table with the divisor of `|M|` each one names, the opening
position of *Foundation and Empire*, and a can of brainrot — is emitted into
the page as one nested can, and the page is a ship parked inside it.

Everything inside the can you are in stands on the shelves of a
`16 × 16 × 16` arena, one cube each, at the place `Cans.slot` gives it. Fly
into a cube and you are inside that can, with *its* contents on the shelves.
Fly out and you are back. The panel beside the arena is `Cans.examine`: the
label, the value, and the list of what can be flown into next.

The page checks itself against the numbers Lean computed — how many cans there
are, how deep they go, where the first eighteen slots are — and says so on its
face.
-/

namespace NixWars

namespace Cans

/-! ## The world as JSON -/

/-- A string as JSON. -/
def jstr (s : String) : String := Id.run do
  let mut out := "\""
  for c in s.toList do
    if c = '"' then out := out ++ "\\\""
    else if c = '\\' then out := out ++ "\\\\"
    else if c = '\n' then out := out ++ "\\n"
    else out := out.push c
  return out ++ "\""

/-- A can as JSON: label, value (a decimal string, since a row of the Monster's
table names a number no JavaScript number can hold), and what is inside. -/
def canJson : Can → String
  | .can l v inside =>
      "{\"l\":" ++ jstr l ++ ",\"v\":" ++ jstr (toString v) ++ ",\"i\":[" ++
        String.intercalate "," (inside.map canJson) ++ "]}"

/-- Where the first `n` things inside a can stand, for the page to check its
own arithmetic against. -/
def slotsJson (n : Nat) : String :=
  "[" ++ String.intercalate ","
    ((List.range n).map (fun k =>
      "[" ++ toString (slot k).x ++ "," ++ toString (slot k).y ++ "," ++
        toString (slot k).z ++ "]")) ++ "]"

/-- What Lean says about the world, for the page and the harness to check
themselves against. -/
def goldenJson : String :=
  "{\"cans\":" ++ toString (parts nixwarsWorld).length ++
  ",\"depth\":" ++ toString (depth nixwarsWorld) ++
  ",\"arena\":" ++ toString Scene3D.arena ++
  ",\"shelfRoom\":" ++ toString shelfRoom ++
  ",\"top\":[" ++ String.intercalate ","
      (nixwarsWorld.inside.map (fun c => jstr c.label)) ++ "]" ++
  ",\"topCounts\":[" ++ String.intercalate ","
      (nixwarsWorld.inside.map (fun c => toString c.inside.length)) ++ "]" ++
  ",\"doors\":[" ++ String.intercalate ","
      (boardCan.inside.map (fun c => jstr c.label)) ++ "]" ++
  ",\"frontierFields\":[" ++ String.intercalate ","
      (((follow nixwarsWorld [0, 13]).map (fun c => c.inside.map Can.label)).getD []
        |>.map jstr) ++ "]" ++
  ",\"slots\":" ++ slotsJson 18 ++
  ",\"rowZero\":" ++ canJson ((follow nixwarsWorld [1, 0]).getD (brainrot "?" 0)) ++ "}"

/-! ## The page -/

/-- The page. -/
def cansPage : String :=
  r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>NixWars &mdash; the can opener</title>
<style>
:root { color-scheme: dark; }
body { margin: 0; background: #05070d; color: #c8d6e5;
  font-family: ui-monospace, SFMono-Regular, Menlo, monospace; }
main { max-width: 64rem; margin: 0 auto; padding: 1.1rem; }
h1 { font-size: 1.3rem; color: #7ee787; margin: 0 0 .2rem 0; }
h2 { font-size: 1rem; color: #79c0ff; margin: 1.4rem 0 .4rem 0; }
p { line-height: 1.55; }
a { color: #79c0ff; }
code { color: #ffa657; }
canvas { background: #05070d; border: 1px solid #1f2a3a; width: 100%; height: 62vh;
  min-height: 20rem; display: block; touch-action: none; }
.bar { display: flex; gap: .6rem; align-items: center; flex-wrap: wrap; margin: .5rem 0; }
button { background: #16233a; color: #c8d6e5; border: 1px solid #26364f; border-radius: 3px;
  padding: .3rem .8rem; font: inherit; cursor: pointer; }
button:hover { background: #1d2f4d; }
button:disabled { color: #4b5a70; cursor: not-allowed; }
.cols { display: flex; gap: 1rem; flex-wrap: wrap; }
.col { flex: 1 1 22rem; min-width: 18rem; }
.panel { border: 1px solid #1f2a3a; background: #080d16; padding: .6rem .9rem; }
.lede { border: 1px solid #1f2a3a; border-left: 3px solid #7ee787; padding: .1rem .9rem;
  background: #080d16; }
.crumb { color: #8b949e; font-size: .85rem; word-break: break-word; }
.crumb b { color: #7ee787; font-weight: normal; }
.list { max-height: 22rem; overflow: auto; }
.item { padding: .18rem .3rem; border-bottom: 1px solid #131c2b; cursor: pointer;
  display: flex; gap: .6rem; justify-content: space-between; }
.item:hover { background: #10203a; }
.item .n { color: #79c0ff; }
.item .v { color: #ffa657; }
.leaf { color: #8b949e; }
.stat { color: #7ee787; }
.bad { color: #ff7b72; }
.note { color: #8b949e; font-size: .85rem; }
table { border-collapse: collapse; width: 100%; font-size: .82rem; }
th, td { border: 1px solid #1f2a3a; padding: .18rem .4rem; text-align: left; }
th { color: #79c0ff; font-weight: normal; }
#log { white-space: pre-wrap; font-size: .8rem; color: #8b949e; }
details { border: 1px solid #1f2a3a; padding: .3rem .8rem; background: #080d16; }
summary { cursor: pointer; color: #79c0ff; }
"## ++ Gl.mobileCss ++ r##"</style>
</head>
<body>
<main>
<h1>The can opener</h1>
<div class="lede">
<p><b>Everything in this world is a can:</b> a label, a value, and whatever is
inside it. A can with nothing inside is the bottom of the world &mdash; a
number in a labelled tin. A can with cans inside it is a cabinet, a table, a
galaxy, a world.</p>
<p><b>You are parked inside one.</b> Every thing in the can you are in stands
on a shelf of the box around you, one cube each. Click a cube &mdash; or a line
in the list &mdash; and you fly into that can, and <em>its</em> contents are on
the shelves. FLY OUT takes you back. Nothing in the world is out of reach this
way: that is what <code>Cans.reach</code> proves, and
<code>Cans.drawn_iff_enterable</code> says the cubes you can see are exactly
the things you can fly into.</p>
</div>

<div class="bar">
  <button id="out">FLY OUT</button>
  <button id="home">BACK TO THE WORLD</button>
  <button id="spin">TURN</button>
  <span id="where" class="crumb"></span>
</div>

<canvas id="view"></canvas>

<div class="cols" style="margin-top:1rem">
  <div class="col panel">
    <h2 style="margin-top:.2rem">EXAMINE</h2>
    <div id="look"></div>
  </div>
  <div class="col panel">
    <h2 style="margin-top:.2rem">WHAT YOU CAN FLY INTO</h2>
    <div id="list" class="list"></div>
  </div>
</div>

<h2>What is proved about this</h2>
<table id="proofs"></table>

<h2>Does the page add up?</h2>
<details><summary>the page's own check against the Lean numbers</summary>
<p id="log"></p>
</details>

<p class="note">Emitted from <code>RequestProject/NixWars/CansPage.lean</code>;
the cans, the flights and the shelves are
<code>RequestProject/NixWars/Cans.lean</code>, and the arena is the same
<code>16 &times; 16 &times; 16</code> box as
<code>RequestProject/NixWars/Scene3D.lean</code>. Elsewhere:
<a href="fly.html">the voxel flight</a>, <a href="voxel-world.html">the map</a>,
<a href="arcade-3d.html">the arcade in 3D</a>, <a href="nixwars.html">NixWars</a>.</p>

<script>
"## ++ Gl.matrixJs ++ Gl.rendererJs ++ Gl.orbitJs ++ r##"

// ---------------------------------------------------------------- the world
const WORLD = "## ++ canJson nixwarsWorld ++ r##";
const GOLD = "## ++ goldenJson ++ r##";
const ARENA = GOLD.arena;

// where the kth thing inside a can stands: Cans.slot, transcribed
function slot(k) {
  return { x: k % 16, y: Math.floor(k / 256) % 16, z: Math.floor(k / 16) % 16, c: k % 16 };
}

// Cans.follow: fly in, step by step
function follow(c, path) {
  for (const k of path) {
    if (!c || !c.i || k >= c.i.length) return null;
    c = c.i[k];
  }
  return c || null;
}

// Cans.parts, counted
function countCans(c) {
  let n = 1;
  for (const d of c.i) n += countCans(d);
  return n;
}
function depthOf(c) {
  let m = 0;
  for (const d of c.i) m = Math.max(m, depthOf(d));
  return 1 + m;
}

let PATH = [];
const here = () => follow(WORLD, PATH);

// ---------------------------------------------------------------- the arena
const canvas = document.getElementById("view");
const R = makeGL(canvas);
const cam = { target: [8, 4, 8], yaw: 0.9, pitch: 0.55, dist: 34, fov: 1.0,
              minDist: 4, maxDist: 200 };
let SPIN = null;

function cubesHere() {
  const c = here(), out = [];
  if (!c) return out;
  for (let k = 0; k < c.i.length; k++) {
    const s = slot(k);
    out.push({ x: s.x, y: s.y, z: s.z, c: s.c, size: 0.78, k: k });
  }
  return out;
}

function shelfLines() {
  const c = here();
  const n = c ? c.i.length : 0;
  const hi = Math.max(1, Math.min(16, Math.ceil(n / 256)));
  return boxLines(0, 0, 0, 16, hi, 16, 8);
}

function render() {
  if (!R) return;
  R.draw(cubesHere(), shelfLines(), cam);
}

// the same matrix the renderer uses, so that a click can be answered
function screenOf(p) {
  const aspect = canvas.width / Math.max(1, canvas.height);
  const mvp = m4mul(m4persp(cam.fov, aspect, 0.1, 4000),
                    m4look(camEye(cam), cam.target, [0, 1, 0]));
  const x = p[0], y = p[1], z = p[2];
  const cx = mvp[0]*x + mvp[4]*y + mvp[8]*z + mvp[12];
  const cy = mvp[1]*x + mvp[5]*y + mvp[9]*z + mvp[13];
  const cw = mvp[3]*x + mvp[7]*y + mvp[11]*z + mvp[15];
  if (cw <= 0) return null;
  return [(cx / cw * 0.5 + 0.5) * canvas.clientWidth,
          (0.5 - cy / cw * 0.5) * canvas.clientHeight];
}

function pick(px, py) {
  let best = null, bestd = 40 * 40;
  for (const cu of cubesHere()) {
    const s = screenOf([cu.x + 0.39, cu.y + 0.39, cu.z + 0.39]);
    if (!s) continue;
    const dx = s[0] - px, dy = s[1] - py, dd = dx * dx + dy * dy;
    if (dd < bestd) { bestd = dd; best = cu.k; }
  }
  return best;
}

// --------------------------------------------------------------- the panels
const esc = (s) => String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;");
const commas = (s) => s.replace(/\B(?=(\d{3})+(?!\d))/g, "\u2009");
const shortNum = (s) => s.length <= 24 ? commas(s)
  : commas(s.slice(0, 12)) + "\u2026" + s.slice(-4) + " (" + s.length + " digits)";

function drawWhere() {
  const parts = ["<b>" + esc(WORLD.l) + "</b>"];
  let c = WORLD;
  for (const k of PATH) { c = c.i[k]; parts.push("<b>" + esc(c.l) + "</b>"); }
  document.getElementById("where").innerHTML =
    parts.join(" &rsaquo; ") + " &nbsp; <span class='note'>flight [" + PATH.join(", ") + "]</span>";
  document.getElementById("out").disabled = PATH.length === 0;
  document.getElementById("home").disabled = PATH.length === 0;
}

function drawLook() {
  const c = here();
  const out = [];
  out.push("<p><b class='stat'>" + esc(c.l) + "</b></p>");
  out.push("<table><tr><th>the label</th><td>" + esc(c.l) + "</td></tr>" +
           "<tr><th>the value in it</th><td class='v'>" + shortNum(c.v) + "</td></tr>" +
           "<tr><th>things inside</th><td>" + c.i.length + "</td></tr>" +
           "<tr><th>the flight that got here</th><td>[" + PATH.join(", ") + "]</td></tr>" +
           "<tr><th>cans from here down</th><td>" + countCans(c) + "</td></tr>" +
           "<tr><th>how deep it goes</th><td>" + depthOf(c) + "</td></tr></table>");
  if (c.i.length === 0) {
    out.push("<p class='note'>Nothing inside: this is the bottom of the world, a " +
             "value in a labelled tin. A can of brainrot, and there is no deeper " +
             "thing to fly into (<code>Cans.exists_brainrot</code>).</p>");
  } else {
    out.push("<p class='note'>Each of those " + c.i.length + " things is standing on its " +
             "own cube of the " + ARENA + " &times; " + ARENA + " &times; " + ARENA +
             " box around you, at the place <code>Cans.slot</code> gives it, and no two " +
             "share a cube.</p>");
  }
  document.getElementById("look").innerHTML = out.join("");
}

function drawList() {
  const c = here(), out = [];
  if (c.i.length === 0) {
    out.push("<p class='note'>Nothing. Fly out.</p>");
  } else {
    for (let k = 0; k < c.i.length; k++) {
      const d = c.i[k], s = slot(k);
      out.push("<div class='item' data-k='" + k + "'>" +
               "<span class='n'>" + k + " &nbsp;" + esc(d.l) + "</span>" +
               "<span class='v'>" + shortNum(d.v) +
               (d.i.length ? " &nbsp;<span class='n'>(" + d.i.length + " inside)</span>"
                           : " <span class='leaf'>&middot;</span>") +
               " &nbsp;<span class='note'>cube " + s.x + "," + s.y + "," + s.z + "</span></span>" +
               "</div>");
    }
  }
  const box = document.getElementById("list");
  box.innerHTML = out.join("");
  for (const el of box.querySelectorAll(".item")) {
    el.addEventListener("click", () => flyInto(Number(el.getAttribute("data-k"))));
  }
}

function refresh() {
  drawWhere();
  drawLook();
  drawList();
  render();
}

function flyInto(k) {
  const c = here();
  if (k === null || k === undefined || k >= c.i.length) return;
  PATH = PATH.concat([k]);
  refresh();
}
function flyOut() { if (PATH.length) { PATH = PATH.slice(0, -1); refresh(); } }

document.getElementById("out").addEventListener("click", flyOut);
document.getElementById("home").addEventListener("click", () => { PATH = []; refresh(); });
document.getElementById("spin").addEventListener("click", () => {
  if (SPIN) { clearInterval(SPIN); SPIN = null; return; }
  SPIN = setInterval(() => { cam.yaw += 0.012; render(); }, 40);
});

let DOWN = null;
canvas.addEventListener("pointerdown", (e) => { DOWN = { x: e.clientX, y: e.clientY }; });
canvas.addEventListener("pointerup", (e) => {
  if (!DOWN) return;
  const moved = Math.hypot(e.clientX - DOWN.x, e.clientY - DOWN.y);
  DOWN = null;
  if (moved > 6) return;               // that was a drag of the camera
  const r = canvas.getBoundingClientRect();
  const k = pick(e.clientX - r.left, e.clientY - r.top);
  if (k !== null) flyInto(k);
});
if (R) attachOrbit(canvas, cam, render);
window.addEventListener("resize", render);

// --------------------------------------------------------------- what is proved
{
  const items = [
    ["Cans.reach", "every can anywhere in the world is at the end of some flight"],
    ["Cans.follow_mem_parts", "and a flight can only arrive at something that was really there"],
    ["Cans.drawn_iff_enterable", "the cubes you can see are exactly the things you can fly into"],
    ["Cans.shelf_covers", "nothing inside a can is left off its shelves"],
    ["Cans.shelf_in_arena", "and nothing is drawn outside the 16 x 16 x 16 box"],
    ["Cans.slots_distinct", "no two things are given the same cube"],
    ["Cans.enter_isSome_iff_lt_doors", "examining a can counts exactly what can be flown into"],
    ["Cans.enter_size_lt", "flying in always makes what is left strictly smaller"],
    ["Cans.exists_brainrot", "so every flight ends at a value in a labelled tin"],
    ["Cans.follow_length_add_depth_le", "and no flight is longer than the world is deep"],
    ["Cans.doorCans_match_scenes", "a cabinet's can holds exactly the fields its 3D scene draws"],
    ["Cans.world_surfaceable", "all of which holds of this world, the one in this page"]
  ];
  const out = ["<tr><th>theorem</th><th>what it says</th></tr>"];
  for (const it of items) out.push("<tr><td><code>" + it[0] + "</code></td><td>" + it[1] + "</td></tr>");
  document.getElementById("proofs").innerHTML = out.join("");
}

// --------------------------------------------------------------- the self-check
{
  const log = [];
  let ok = true;
  const check = (what, cond) => { if (!cond) ok = false; log.push((cond ? "  ok   " : "  FAIL ") + what); };

  check("the world holds " + GOLD.cans + " cans, as Lean counted", countCans(WORLD) === GOLD.cans);
  check("and goes " + GOLD.depth + " deep", depthOf(WORLD) === GOLD.depth);
  check("the four things in the world are the ones Lean named",
    WORLD.i.map((c) => c.l).join("|") === GOLD.top.join("|"));
  check("with the counts Lean gave them",
    WORLD.i.map((c) => c.i.length).join(",") === GOLD.topCounts.join(","));
  check("the board holds the fifteen cabinets",
    follow(WORLD, [0]).i.map((c) => c.l).join("|") === GOLD.doors.join("|"));
  check("the Frontier Run's cabinet holds the fields Lean says it does",
    follow(WORLD, [0, 13]).i.map((c) => c.l).join("|") === GOLD.frontierFields.join("|"));
  check("the ship's own x, y and z are three flights in",
    [3, 4, 5].map((k) => follow(WORLD, [0, 13, k]).l).join(",") === "x,y,z");
  check("the page puts the first " + GOLD.slots.length + " things where Lean puts them",
    GOLD.slots.every((s, k) => {
      const t = slot(k);
      return t.x === s[0] && t.y === s[1] && t.z === s[2];
    }));
  check("the first row of the Monster's table is the can Lean emitted",
    JSON.stringify(follow(WORLD, [1, 0])) === JSON.stringify(GOLD.rowZero));

  // every can is reachable, and everything inside every can is drawn in the arena
  let seen = 0, offShelf = 0, escaped = 0, clash = 0;
  const walk = (c, path) => {
    seen++;
    if (follow(WORLD, path) !== c) offShelf++;
    const used = new Set();
    for (let k = 0; k < c.i.length; k++) {
      const s = slot(k);
      if (s.x >= ARENA || s.y >= ARENA || s.z >= ARENA) escaped++;
      const key = s.x + "," + s.y + "," + s.z;
      if (used.has(key)) clash++;
      used.add(key);
      walk(c.i[k], path.concat([k]));
    }
  };
  walk(WORLD, []);
  check("every one of the " + seen + " cans is at the end of its own flight", offShelf === 0);
  check("every thing in every can is drawn inside the arena", escaped === 0);
  check("and no two things in a can share a cube", clash === 0);
  check("no can holds more than an arena's worth of things (" + GOLD.shelfRoom + ")",
    (function () {
      let bad = 0;
      const w = (c) => { if (c.i.length > GOLD.shelfRoom) bad++; c.i.forEach(w); };
      w(WORLD);
      return bad === 0;
    })());

  document.getElementById("log").textContent =
    (ok ? "all " + log.length + " checks pass" : "CHECKS FAILED") + "\n" + log.join("\n");
}

refresh();
</script>
</main>
</body>
</html>
"##

/-- Write the page and the golden values. -/
def writeCansPage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/cans.html" cansPage
  IO.FS.writeFile "www/cans-golden.json" goldenJson
  IO.println s!"cans: page {cansPage.length} bytes, {(parts nixwarsWorld).length} cans"

#eval writeCansPage

end Cans

end NixWars
