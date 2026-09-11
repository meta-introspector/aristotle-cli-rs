import RequestProject.Nix.NixWars.Monster.Moonshine

/-!
# The paths between the worlds, as a page: `www/moonshine.html`

`Moonshine.lean` says what a path between irrep worlds is — a word in "divide by
`p`" and "multiply by `p`" — and which worlds the q-expansion of `J` calls for.
This file draws it.

Everything the page knows is emitted from Lean:

* `DIMS`: the first seven irreducible character degrees of the Monster, each with
  the factorisation `dimFactors` records and Lean checks (`dimFactors_correct`);
* `BRIDGES`: for each consecutive pair, the canonical path Lean computes —
  what you divide out, what you multiply in, and what the two worlds share;
* `LADDER`: the path the game walks, `÷47 ×41 ×31 ×4`, with the box it starts in
  and the box it arrives in;
* `QEXP`: the coefficients of `J` and the multiplicities that build them out of
  the dimensions.

The page's script is a transcription of `runPath`, `bridge`, `walk` and
`combine`, and `www/moonshine-selftest.mjs` runs it headless against every
Lean-computed value.
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

namespace NixWars

namespace Monster

namespace MoonshinePage

open Moonshine

/-! ## The data the page carries -/

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

/-- The factorisation of each dimension in `monsterDims`, in the same order. -/
def dimFactors : List (List Nat) :=
  [[],
   [47, 59, 71],
   [2, 2, 31, 41, 59, 71],
   [2, 13, 13, 29, 31, 47, 59],
   [2, 2, 7, 11, 23, 29, 31, 41, 71],
   [13, 13, 23, 29, 41, 59, 71],
   [2, 3, 11, 19, 29, 41, 47, 59, 71]]

/-- The factorisations really are factorisations of the dimensions. -/
theorem dimFactors_correct : dimFactors.map List.prod = monsterDims := by decide

/-- One dimension, as JSON: the number and its primes. -/
def dimJson (d : Nat × List Nat) : String :=
  "{\"dim\":" ++ toString d.1 ++ ",\"factors\":" ++ nats d.2 ++ "}"

/-- The dimensions with their factorisations, as JSON. -/
def dimsJson : String :=
  "[" ++ String.intercalate ",\n" ((monsterDims.zip dimFactors).map dimJson) ++ "]"

/-- The canonical path between two dimensions, as JSON: what is divided out, what
is multiplied in, and what the two worlds share. -/
def bridgeJson (ab : Nat × Nat) : String :=
  let g := Nat.gcd ab.1 ab.2
  "{\"from\":" ++ toString ab.1 ++ ",\"to\":" ++ toString ab.2 ++
    ",\"div\":" ++ toString (ab.1 / g) ++ ",\"mul\":" ++ toString (ab.2 / g) ++
    ",\"shared\":" ++ toString g ++
    ",\"run\":" ++ toString (runPath (bridge ab.1 ab.2) ab.1) ++ "}"

/-- The canonical paths along the ladder of dimensions, as JSON. -/
def bridgesJson : String :=
  "[" ++ String.intercalate ",\n"
    ((monsterDims.zip monsterDims.tail).map bridgeJson) ++ "]"

/-- One move of a path, as JSON. -/
def stepJson : Step → String
  | Step.mul p => "[\"mul\"," ++ toString p ++ "]"
  | Step.div p => "[\"div\"," ++ toString p ++ "]"

/-- The path the game walks, with the box at each end. -/
def ladderJson : String :=
  "{\"steps\":[" ++ String.intercalate "," (ladder.map stepJson) ++ "]" ++
    ",\"fromAxes\":" ++ nats Irrep.irrep3.axes ++
    ",\"fromSize\":" ++ toString Irrep.irrep3.size ++
    ",\"toAxes\":" ++ nats irrepNext.axes ++
    ",\"toSize\":" ++ toString irrepNext.size ++
    ",\"back\":[" ++ String.intercalate "," ((invPath ladder).map stepJson) ++ "]}"

/-- The q-expansion of `J`: the coefficients and the multiplicities that build
them out of the dimensions. -/
def qexpJson : String :=
  "{\"coeffs\":" ++ nats jCoeffs ++ ",\"mults\":" ++ natss headMults ++
    ",\"totals\":" ++ nats (headMults.map combine) ++ "}"

/-- The tables, as a script. -/
def pageData : String :=
  "const DIMS = " ++ dimsJson ++ ";\n" ++
  "const BRIDGES = " ++ bridgesJson ++ ";\n" ++
  "const LADDER = " ++ ladderJson ++ ";\n" ++
  "const QEXP = " ++ qexpJson ++ ";\n"

/-! ## The model: a transcription of `Moonshine.lean` -/

/-- Paths, canonical paths and the action on boxes, in JavaScript. -/
def pageModel : String := r##"
// one move on a number of cells  (Step.run)
function stepRun(s, n) { return s[0] === "mul" ? s[1] * n : Math.floor(n / s[1]); }
// a whole path  (runPath)
function runPath(P, n) { return P.reduce((m, s) => stepRun(s, m), n); }
// the path that undoes a path  (invPath)
function invPath(P) {
  return P.map(s => [s[0] === "mul" ? "div" : "mul", s[1]]).slice().reverse();
}
function gcd(a, b) { while (b) { const t = a % b; a = b; b = t; } return a; }
// the canonical path from a world of a cells to a world of b cells  (bridge)
function bridge(a, b) {
  const g = gcd(a, b);
  return [["div", a / g], ["mul", b / g]];
}
// one move on a box  (Step.onIrrep)
function stepOnAxes(s, axes) {
  if (s[0] === "mul") return [s[1]].concat(axes);
  const out = axes.slice(), i = out.indexOf(s[1]);
  if (i >= 0) out.splice(i, 1);
  return out;
}
// a whole path on a box  (walk)
function walk(P, axes) { return P.reduce((A, s) => stepOnAxes(s, A), axes); }
function sizeOf(axes) { return axes.reduce((a, b) => a * b, 1); }
// the dimension of a graded piece  (combine)
function combine(mult, dims) {
  return mult.reduce((s, m, i) => s + m * dims[i], 0);
}
function pathText(P) {
  return P.map(s => (s[0] === "mul" ? "\u00d7" : "\u00f7") + s[1]).join(" ");
}
"##

/-- The checks the page and the self-test both run. -/
def pageChecks : String := r##"
function moonshineChecks(t) {
  const dims = DIMS.map(d => d.dim);
  for (const d of DIMS)
    t(d.dim + " = " + d.factors.join(" x "),
      d.factors.reduce((a, b) => a * b, 1) === d.dim);
  for (const b of BRIDGES) {
    const P = bridge(b.from, b.to);
    t(b.from + " -> " + b.to + " by " + pathText(P),
      P[0][1] === b.div && P[1][1] === b.mul);
    t("that path really lands on " + b.to, runPath(P, b.from) === b.to && b.run === b.to);
    t("the two worlds share " + b.shared, gcd(b.from, b.to) === b.shared);
    t("what is divided out and what is multiplied in are coprime",
      gcd(b.div, b.mul) === 1);
    t("reading the path backwards returns to " + b.from,
      runPath(P.concat(invPath(P)), b.from) === b.from);
  }
  t("the game's path is " + pathText(LADDER.steps),
    JSON.stringify(LADDER.steps) === JSON.stringify([["div",47],["mul",41],["mul",31],["mul",4]]));
  t("it carries " + LADDER.fromSize + " to " + LADDER.toSize,
    runPath(LADDER.steps, LADDER.fromSize) === LADDER.toSize);
  t("it carries the box [" + LADDER.fromAxes + "] to [" + LADDER.toAxes + "]",
    JSON.stringify(walk(LADDER.steps, LADDER.fromAxes)) === JSON.stringify(LADDER.toAxes));
  t("the box it arrives in has " + LADDER.toSize + " cells",
    sizeOf(LADDER.toAxes) === LADDER.toSize && sizeOf(LADDER.toAxes) === dims[2]);
  t("the new axes are pairwise coprime, so every cell is a different can",
    LADDER.toAxes.every((p, i) => LADDER.toAxes.every((q, j) => i === j || gcd(p, q) === 1)));
  t("walking it back returns to the box we started in",
    JSON.stringify(walk(LADDER.steps.concat(LADDER.back), LADDER.fromAxes).slice().sort())
      === JSON.stringify(LADDER.fromAxes.slice().sort()));
  t("the two worlds of the game share 71 x 59 = 4189",
    gcd(LADDER.fromSize, LADDER.toSize) === 4189);
  QEXP.coeffs.forEach((c, i) => {
    t("q^" + (i + 1) + " coefficient " + c + " is a sum of irreducibles",
      combine(QEXP.mults[i], dims) === c && QEXP.totals[i] === c);
  });
  t("21493760 = 1 + 196883 + 21296876, the point and the two worlds",
    1 + LADDER.fromSize + LADDER.toSize === QEXP.coeffs[1]);
}
"##

/-! ## The page -/

/-- The head and the body of the page. -/
def pageHead : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NixWars &mdash; the paths between the worlds</title>
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
  border-radius: .3rem; padding: .3rem .6rem; margin: 0 .3rem .35rem 0; cursor: pointer;
  min-width: 44px; min-height: 44px; }
button:hover { background: #16283c; }
select { font: inherit; background: #0b1726; color: #cfe6ff;
  border: 1px solid #21456b; border-radius: .3rem; padding: .25rem .4rem; }
pre { white-space: pre-wrap; color: #9fc4e4; }
.ok { color: #6ef2c0; } .bad { color: #ff8f8f; }
.row { margin: .4rem 0; }
.big { color: #ffd479; }
table { border-collapse: collapse; font-size: .85rem; }
td, th { border-bottom: 1px solid #16283c; padding: .15rem .5rem; text-align: left; }
</style>
</head>
<body>
<div class="wrap">
<h1>THE PATHS BETWEEN THE WORLDS</h1>
<p class="sub">Each world of the game is a box of cells cut by primes, and the number of
cells is the dimension of an irreducible representation of the Monster. To go from one world
to the next you divide some axes out and multiply others in: from
71&nbsp;&times;&nbsp;59&nbsp;&times;&nbsp;47&nbsp;=&nbsp;196&nbsp;883 you divide by 47 and
multiply by 41, 31 and 4, keeping the shared 71&nbsp;&times;&nbsp;59&nbsp;=&nbsp;4189, and you
arrive at 21&nbsp;296&nbsp;876. Those words of divides and multiplies compose, and the worlds
they join are the ones the q-expansion of <em>J</em> calls for &mdash; which is the
connection between the geometry of the game and the Monster.</p>
<p class="sub"><a href="index.html">&larr; the lobby</a> &middot;
<a href="irrep-world.html">the projected world</a> &middot;
<a href="voxel-world.html">the voxel map</a></p>

<h2>THE WORLDS</h2>
<div id="worlds"></div>

<h2>THE PATHS ALONG THE LADDER</h2>
<div id="paths"></div>

<h2>ANY TWO WORLDS</h2>
<div class="row">from <select id="src"></select> to <select id="dst"></select>
<button id="go">FIND THE PATH</button></div>
<div class="row big" id="found"></div>

<h2>THE PATH THE GAME WALKS</h2>
<div class="row" id="ladder"></div>

<h2>THE Q-EXPANSION</h2>
<p class="sub">J(q) = q<sup>&minus;1</sup> + 196884&nbsp;q + 21493760&nbsp;q<sup>2</sup> +
864299970&nbsp;q<sup>3</sup> + &hellip; &mdash; each coefficient a sum of the dimensions
above, each dimension a world, each world one path from the next.</p>
<div id="qexp"></div>

<h2>WHAT LEAN CHECKED</h2>
<pre id="log"></pre>
</div>
<script>
"##

/-- The page's own script: the tables drawn, and the checks run in the browser. -/
def pageScript : String := r##"
const dims = DIMS.map(d => d.dim);

function table(rows, head) {
  let h = "<table><tr>" + head.map(x => "<th>" + x + "</th>").join("") + "</tr>";
  for (const r of rows) h += "<tr>" + r.map(x => "<td>" + x + "</td>").join("") + "</tr>";
  return h + "</table>";
}

document.getElementById("worlds").innerHTML =
  table(DIMS.map(d => [d.dim, d.factors.length ? d.factors.join(" x ") : "1",
    d.factors.length + " axes"]), ["cells", "axes", "dimension"]);

document.getElementById("paths").innerHTML =
  table(BRIDGES.map(b => [b.from, "\u00f7" + b.div, "\u00d7" + b.mul, b.shared, b.to]),
    ["from", "divide out", "multiply in", "shared", "to"]);

const src = document.getElementById("src"), dst = document.getElementById("dst");
for (const d of dims) {
  src.insertAdjacentHTML("beforeend", "<option>" + d + "</option>");
  dst.insertAdjacentHTML("beforeend", "<option>" + d + "</option>");
}
src.selectedIndex = 1; dst.selectedIndex = 2;
function findPath() {
  const a = Number(src.value), b = Number(dst.value), P = bridge(a, b);
  document.getElementById("found").textContent =
    a + "  " + pathText(P) + "  = " + runPath(P, a) +
    "   (shared " + gcd(a, b) + ", and back again by " + pathText(invPath(P)) + ")";
}
document.getElementById("go").addEventListener("click", findPath);
findPath();

document.getElementById("ladder").textContent =
  "[" + LADDER.fromAxes.join(" x ") + "] = " + LADDER.fromSize + "   " +
  pathText(LADDER.steps) + "   [" + LADDER.toAxes.join(" x ") + "] = " + LADDER.toSize;

document.getElementById("qexp").innerHTML =
  table(QEXP.coeffs.map((c, i) => [
    "q^" + (i + 1), c,
    QEXP.mults[i].map((m, j) => m ? m + " x " + dims[j] : null)
      .filter(x => x).join("  +  ")]), ["grade", "coefficient", "irreducibles"]);

const log = [];
let allOk = true;
moonshineChecks((what, cond) => {
  if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what);
});
document.getElementById("log").innerHTML =
  "<span class=\"" + (allOk ? "ok" : "bad") + "\">" +
  (allOk ? "all checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");
"##

/-- The whole page. -/
def moonshinePage : String :=
  pageHead ++ pageData ++ pageModel ++ pageChecks ++ pageScript ++
    "\n</script>\n</body>\n</html>\n"

/-- The headless self-test. -/
def moonshineSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Monster/MoonshinePage.lean. " ++
    "Run: node www/moonshine-selftest.mjs\n" ++
  pageData ++ pageModel ++ pageChecks ++ r##"
let fails = 0, n = 0;
moonshineChecks((what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
});
console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the paths page and its self-test. -/
def writeMoonshine : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/moonshine.html" moonshinePage
  IO.FS.writeFile "www/moonshine-selftest.mjs" moonshineSelfTest
  IO.println s!"moonshine: page {moonshinePage.length} bytes, \
    self-test {moonshineSelfTest.length} bytes"

#eval writeMoonshine

end MoonshinePage

end Monster

end NixWars
