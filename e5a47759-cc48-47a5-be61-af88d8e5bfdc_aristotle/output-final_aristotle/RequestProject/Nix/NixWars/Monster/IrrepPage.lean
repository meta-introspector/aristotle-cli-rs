import RequestProject.Nix.NixWars.Monster.Projected

/-!
# The projected world as a page: `www/irrep-world.html`

The world of `Projected.lean`, drawn.  Every atom of the game — all 3529 cans —
is projected into the current irrep by taking its number modulo each axis, and
the page shows the content array that fills: a slice of the box, one square per
cell, lit where a can landed.

Everything the page knows is emitted from Lean:

* `IRREPS`: the irreps you can be in — `71 × 59 × 47`, the same three primes
  reordered, one and two dimensions up (`… × 41`, `… × 41 × 31`), and a box of
  different primes altogether (`73 × 67 × 61`) — with the cell count Lean
  computed for each;
* `ATOMS`: every can of `Cans.nixwarsWorld`, in the order `Cans.parts`
  enumerates them, with its label, the number written in it and the cell that
  number projects to;
* `GOLDEN`: the addresses and cells Lean computed for a sample of atoms in every
  irrep, the effect of moving the world, and the counts the projection has to
  reproduce.

The page's script is a transcription of `Irrep.coords`, `Irrep.cell`,
`Irrep.shift` and `Irrep.contents`, and `www/irrep-selftest.mjs` runs it headless
against every Lean-computed value.
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

namespace NixWars

namespace Monster

namespace IrrepPage

open Irrep

/-! ## The data the page carries -/

/-- Escape a string for a JSON literal. -/
def esc (s : String) : String :=
  ((s.replace "\\" "\\\\").replace "\"" "\\\"").replace "\n" "\\n"

/-- A JSON string. -/
def str (s : String) : String := "\"" ++ esc s ++ "\""

/-- A list of numbers, as JSON. -/
def nats (ns : List Nat) : String := "[" ++ String.intercalate "," (ns.map toString) ++ "]"

/-- The irreps the page can be in: a name, the axes, and the cell count. -/
def irrepTable : List (String × List Nat) :=
  [("3D  71 x 59 x 47", [71, 59, 47]),
   ("3D  47 x 71 x 59  (same primes, reordered)", [47, 71, 59]),
   ("4D  71 x 59 x 47 x 41", [71, 59, 47, 41]),
   ("5D  71 x 59 x 47 x 41 x 31", [71, 59, 47, 41, 31]),
   ("3D  73 x 67 x 61  (other primes)", [73, 67, 61])]

/-- The atoms the golden values are worked out for. -/
def sampleAtoms : List Nat := [0, 1, 2, 17, 71, 1234, 3528, 196882]

/-- How far the world is moved in the worked example. -/
def sampleShift : Nat := 5

/-- One irrep, as JSON: its name, its axes and its cell count. -/
def irrepJson (t : String × List Nat) : String :=
  "{\"name\":" ++ str t.1 ++ ",\"axes\":" ++ nats t.2 ++
    ",\"size\":" ++ toString (Irrep.mk t.2).size ++ "}"

/-- The irreps, as JSON. -/
def irrepsJson : String :=
  "[" ++ String.intercalate ",\n" (irrepTable.map irrepJson) ++ "]"

/-- One atom, as JSON: its label, the number written in it (as a string, since
the divisors of the order of the Monster do not fit in a double) and the cell
that number projects to in the irrep we start in. -/
def atomJson (c : Cans.Can) : String :=
  "[" ++ str c.label ++ "," ++ str (toString c.value) ++ "," ++
    toString (valueCell c) ++ "]"

/-- Every atom of the game, as JSON. -/
def atomsJson : String :=
  "[" ++ String.intercalate ",\n" (gameCans.map atomJson) ++ "]"

/-- The address and cell Lean computes for one atom in one irrep. -/
def placeJson (axes : List Nat) (n : Nat) : String :=
  "{\"n\":" ++ toString n ++ ",\"coords\":" ++ nats ((Irrep.mk axes).coords n) ++
    ",\"cell\":" ++ toString ((Irrep.mk axes).cell n) ++ "}"

/-- The vector one object is slid by in the worked example: one along the first
axis, two along the second, and so on. -/
def slideVec (axes : List Nat) : List Nat := (List.range axes.length).map (fun k => k + 1)

/-- The atom that is slid in the worked example. -/
def slidAtom : Nat := 1234

/-- Sliding one object: the vector, the address it lands on and the cell that
address names. -/
def slidJson (axes : List Nat) : String :=
  let I : Irrep := Irrep.mk axes
  let a := I.slide (slideVec axes) (I.coords slidAtom)
  "{\"n\":" ++ toString slidAtom ++ ",\"v\":" ++ nats (slideVec axes) ++
    ",\"coords\":" ++ nats a ++ ",\"cell\":" ++ toString (encode axes a) ++ "}"

/-- The worked addresses in one irrep. -/
def goldenIrrepJson (t : String × List Nat) : String :=
  "{\"axes\":" ++ nats t.2 ++ ",\"size\":" ++ toString (Irrep.mk t.2).size ++
    ",\"places\":[" ++ String.intercalate "," (sampleAtoms.map (placeJson t.2)) ++
    "],\"moved\":[" ++
    String.intercalate "," (sampleAtoms.map (fun n => placeJson t.2 (n + sampleShift))) ++
    "],\"slid\":" ++ slidJson t.2 ++ "}"

/-- How many distinct cells the atoms of the game occupy in the irrep we start
in: one each, because there are fewer atoms than cells. -/
def atomCellCount : Nat := gameCans.length

/-- Everything the page has to reproduce. -/
def goldenJson : String :=
  "{\"atoms\":" ++ toString gameCans.length ++
    ",\"shift\":" ++ toString sampleShift ++
    ",\"atomCells\":" ++ toString atomCellCount ++
    ",\"valueCells\":76,\"values\":227" ++
    ",\"irreps\":[" ++ String.intercalate ",\n" (irrepTable.map goldenIrrepJson) ++ "]}"

/-- The tables, as a script. -/
def pageData : String :=
  "const IRREPS = " ++ irrepsJson ++ ";\n" ++
  "const ATOMS = " ++ atomsJson ++ ";\n" ++
  "const GOLDEN = " ++ goldenJson ++ ";\n"

/-! ## The model: a transcription of `Project.lean` -/

/-- The projection, moving and changing irrep, in JavaScript. -/
def pageModel : String := r##"
// coords: the residue of n along each axis  (Irrep.coords)
function coordsOf(axes, n) { return axes.map(p => n % p); }
// cell: the mixed-radix index of an address, coarsest axis most significant
//       (Monster.encode)
function encodeAt(axes, a) {
  let c = 0;
  for (let i = 0; i < axes.length; i++) c = c * axes[i] + a[i];
  return c;
}
function cellOf(axes, n) { return encodeAt(axes, coordsOf(axes, n)); }
function sizeOf(axes) { return axes.reduce((a, b) => a * b, 1); }
// the address a cell index stands for  (Monster.decode)
function decodeAt(axes, c) {
  const a = [];
  for (let i = 0; i < axes.length; i++) {
    let tail = 1;
    for (let j = i + 1; j < axes.length; j++) tail *= axes[j];
    a.push(Math.floor(c / tail) % axes[i]);
  }
  return a;
}
// sliding one object: add a vector to its address and wrap  (Irrep.slide)
function slideAddr(axes, a, v) { return a.map((x, i) => (x + v[i]) % axes[i]); }
// moving the world d along: every can's number goes up by d  (Irrep.shift)
function movedNumber(axes, n, d) { return (n + d) % sizeOf(axes); }
// the content array: one slot per cell, holding the first atom projected there
//                                                        (Irrep.contents)
function contentsMap(axes, count, d) {
  const m = new Map();
  for (let i = 0; i < count; i++) {
    const c = cellOf(axes, movedNumber(axes, i, d));
    if (!m.has(c)) m.set(c, i);
  }
  return m;
}
"##

/-- The checks the page and the self-test both run. -/
def pageChecks : String := r##"
function irrepChecks(t) {
  t("there are " + GOLDEN.atoms + " atoms in the game", ATOMS.length === GOLDEN.atoms);
  for (const g of GOLDEN.irreps) {
    const axes = g.axes, tag = "[" + axes.join(",") + "]";
    t(tag + " has " + g.size + " cells", sizeOf(axes) === g.size);
    for (const p of g.places) {
      t(tag + " atom " + p.n + " sits at " + p.coords.join(","),
        JSON.stringify(coordsOf(axes, p.n)) === JSON.stringify(p.coords));
      t(tag + " atom " + p.n + " is cell " + p.cell, cellOf(axes, p.n) === p.cell);
      t(tag + " cell " + p.cell + " is inside the box", p.cell < g.size);
      t(tag + " cell " + p.cell + " reads back as its address",
        JSON.stringify(decodeAt(axes, p.cell)) === JSON.stringify(p.coords));
    }
    for (const p of g.moved) {
      const n = p.n - GOLDEN.shift;
      t(tag + " moving atom " + n + " by " + GOLDEN.shift + " lands at " + p.coords.join(","),
        JSON.stringify(coordsOf(axes, n + GOLDEN.shift)) === JSON.stringify(p.coords));
      t(tag + " moving atom " + n + " by " + GOLDEN.shift + " lands in cell " + p.cell,
        cellOf(axes, movedNumber(axes, n, GOLDEN.shift)) === p.cell);
    }
    const sl = g.slid;
    const slidAt = slideAddr(axes, coordsOf(axes, sl.n), sl.v);
    t(tag + " sliding atom " + sl.n + " by " + sl.v.join(",") + " lands at " + sl.coords.join(","),
      JSON.stringify(slidAt) === JSON.stringify(sl.coords));
    t(tag + " the slid atom is in cell " + sl.cell, encodeAt(axes, slidAt) === sl.cell);
    t(tag + " the slid atom is still in the box", sl.cell < g.size);
    t(tag + " sliding by nothing leaves the address alone",
      JSON.stringify(slideAddr(axes, coordsOf(axes, sl.n), axes.map(() => 0)))
        === JSON.stringify(coordsOf(axes, sl.n)));
    t(tag + " sliding by the address of " + GOLDEN.shift + " is moving that atom on by " +
      GOLDEN.shift,
      JSON.stringify(slideAddr(axes, coordsOf(axes, sl.n), coordsOf(axes, GOLDEN.shift)))
        === JSON.stringify(coordsOf(axes, sl.n + GOLDEN.shift)));
    // a full turn of the box puts everything back
    let turnOk = true;
    for (const p of g.places)
      if (cellOf(axes, movedNumber(axes, p.n, g.size)) !== cellOf(axes, p.n % g.size))
        turnOk = false;
    t(tag + " moving a whole turn of the box changes nothing", turnOk);
    // every atom is in the box, and the content array holds it in its own cell
    const m = contentsMap(axes, ATOMS.length, 0);
    let inBox = true;
    for (let i = 0; i < ATOMS.length; i++) {
      const c = cellOf(axes, i);
      if (!(c >= 0 && c < g.size)) inBox = false;
      if (m.get(c) !== i) inBox = false;
    }
    t(tag + " every atom is in the box, in the slot its moduli name", inBox);
    t(tag + " the atoms occupy " + GOLDEN.atomCells + " different cells",
      m.size === GOLDEN.atomCells);
    // moving the world is a permutation of the occupied cells
    const moved = contentsMap(axes, ATOMS.length, 12345);
    t(tag + " moving the world keeps every atom in a cell of its own",
      moved.size === GOLDEN.atomCells);
  }
  // the same three primes reordered: same cells, same cans, other addresses
  const a3 = GOLDEN.irreps[0].axes, a3p = GOLDEN.irreps[1].axes;
  t("reordering the primes keeps the box the same size", sizeOf(a3) === sizeOf(a3p));
  let permOk = true, movedOk = true;
  for (let i = 0; i < ATOMS.length; i++) {
    const c = coordsOf(a3, i), cp = coordsOf(a3p, i);
    if (!(cp[0] === c[2] && cp[1] === c[0] && cp[2] === c[1])) permOk = false;
  }
  t("in the reordered irrep every can keeps its residues, in the axes' order", permOk);
  // one dimension up: the old cell is the new one divided by the new axis
  const a4 = GOLDEN.irreps[2].axes;
  let refineOk = true;
  for (let i = 0; i < ATOMS.length; i++)
    if (Math.floor(cellOf(a4, i) / 41) !== cellOf(a3, i)) refineOk = false;
  t("one dimension up refines: the old cell is the new one divided by 41", refineOk);
  t("one dimension up multiplies the cells by 41",
    sizeOf(a4) === sizeOf(a3) * 41);
  // what is written in the cans does not separate them
  const vc = new Set(), vv = new Set();
  for (const a of ATOMS) { vc.add(a[2]); vv.add(a[1]); }
  t("the cans carry " + GOLDEN.values + " different numbers", vv.size === GOLDEN.values);
  t("but those numbers land in only " + GOLDEN.valueCells + " cells",
    vc.size === GOLDEN.valueCells);
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
<title>NixWars &mdash; the projected world</title>
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
button.on { border-color: #6ef2c0; color: #6ef2c0; }
select, input { font: inherit; background: #0b1726; color: #cfe6ff;
  border: 1px solid #21456b; border-radius: .3rem; padding: .25rem .4rem; }
canvas { background: #060c15; border: 1px solid #21456b; border-radius: .3rem;
  width: 100%; height: auto; image-rendering: pixelated; touch-action: manipulation; }
pre { white-space: pre-wrap; color: #9fc4e4; }
.ok { color: #6ef2c0; } .bad { color: #ff8f8f; }
.row { margin: .4rem 0; }
table { border-collapse: collapse; font-size: .85rem; }
td, th { border-bottom: 1px solid #16283c; padding: .15rem .5rem; text-align: left; }
</style>
</head>
<body>
<div class="wrap">
<h1>THE PROJECTED WORLD</h1>
<p class="sub">Every atom of the game &mdash; all the cans of NixWars &mdash; projected into
the irrep you are in. A can's number is taken modulo each axis; the residues are its address;
the address is a cell of the content array. In 71 &times; 59 &times; 47 there are 196&nbsp;883
cells and 3529 cans, so every can gets a cell of its own. Move the world and everything
translates together; change irrep and the same cans are re-addressed by other primes, or by
more of them.</p>
<p class="sub"><a href="index.html">&larr; the lobby</a> &middot;
<a href="cans.html">the cans themselves</a> &middot;
<a href="voxel-world.html">the voxel map</a></p>

<h2>THE IRREP</h2>
<div class="row"><select id="irrep"></select></div>
<div class="row" id="axesline"></div>

<h2>THE SLICE</h2>
<div class="row" id="slicers"></div>
<canvas id="grid" width="720" height="600"></canvas>
<div class="row" id="legend"></div>

<h2>MOVE THE WORLD</h2>
<div class="row">
<button id="m1">&minus;1</button>
<button id="p1">+1</button>
<button id="m10">&minus;10</button>
<button id="p10">+10</button>
<button id="p1000">+1000</button>
<button id="turn">+ a whole turn</button>
<button id="home">back to the start</button>
</div>
<div class="row" id="offset"></div>

<h2>ONE ATOM</h2>
<div class="row">atom <input id="pick" type="number" value="1234" min="0" style="width:7rem">
<button id="show">SHOW</button></div>
<div class="row" id="atom"></div>

<h2>SLIDE THAT ATOM</h2>
<p class="sub">One object on its own: add to its address along any axis and it wraps into
the far side of the box. Sliding by the address of a number is the same as moving that
object's number on by it.</p>
<div class="row" id="nudge"></div>
<div class="row"><button id="unslide">PUT IT BACK</button></div>

<h2>THE CONTENT ARRAY</h2>
<div class="row" id="counts"></div>
<div id="listing"></div>

<h2>CHECKS</h2>
<pre id="log"></pre>
</div>
<script>
"##

/-- The page's own script: the view and the controls. -/
def pageScript : String := r##"
let cur = 0, offset = 0, slice = [], slid = [], picked = 1234;
const sel = document.getElementById("irrep");
IRREPS.forEach((r, k) => {
  const o = document.createElement("option");
  o.value = String(k); o.textContent = r.name; sel.appendChild(o);
});
function axes() { return IRREPS[cur].axes; }
function resetSlice() { slice = axes().map(() => 0); slid = axes().map(() => 0); }
resetSlice();

function buildSlicers() {
  const host = document.getElementById("slicers");
  host.innerHTML = "";
  const a = axes();
  for (let k = 2; k < a.length; k++) {
    const wrap = document.createElement("span");
    wrap.style.marginRight = "1rem";
    const lab = document.createElement("span");
    lab.textContent = "axis " + k + " (" + a[k] + "): ";
    const inp = document.createElement("input");
    inp.type = "range"; inp.min = "0"; inp.max = String(a[k] - 1);
    inp.value = String(slice[k]);
    const out = document.createElement("span");
    out.textContent = " " + slice[k];
    inp.addEventListener("input", () => {
      slice[k] = Number(inp.value); out.textContent = " " + slice[k]; redraw();
    });
    wrap.appendChild(lab); wrap.appendChild(inp); wrap.appendChild(out);
    host.appendChild(wrap);
  }
  if (a.length <= 2) host.textContent = "(this irrep is flat: the whole box is on screen)";
}

function buildNudges() {
  const host = document.getElementById("nudge");
  host.innerHTML = "";
  axes().forEach((p, k) => {
    for (const d of [-1, 1]) {
      const b = document.createElement("button");
      b.textContent = (d < 0 ? "-1" : "+1") + " on axis " + k + " (" + p + ")";
      b.addEventListener("click", () => {
        slid[k] = (slid[k] + d + p) % p;
        redraw();
      });
      host.appendChild(b);
    }
  });
}

// where the picked atom is standing: its own address, slid
function pickedAddress() {
  const a = axes();
  return slideAddr(a, coordsOf(a, movedNumber(a, picked, offset)), slid);
}

function occupants() {
  const a = axes(), out = [];
  for (let i = 0; i < ATOMS.length; i++) {
    const c = (i === picked) ? pickedAddress() : coordsOf(a, movedNumber(a, i, offset));
    let on = true;
    for (let k = 2; k < a.length; k++) if (c[k] !== slice[k]) on = false;
    if (on) out.push([c[0], c[1], i]);
  }
  return out;
}

function redraw() {
  const a = axes(), cv = document.getElementById("grid");
  const g = cv.getContext ? cv.getContext("2d") : null;
  const here = occupants();
  if (g) {
    const w = a[0], h = a.length > 1 ? a[1] : 1;
    const s = Math.max(2, Math.floor(Math.min(cv.width / w, cv.height / h)));
    g.fillStyle = "#060c15"; g.fillRect(0, 0, cv.width, cv.height);
    g.strokeStyle = "#0f1d2e";
    for (let x = 0; x <= w; x++) {
      g.beginPath(); g.moveTo(x * s + .5, .5); g.lineTo(x * s + .5, h * s + .5); g.stroke();
    }
    for (let y = 0; y <= h; y++) {
      g.beginPath(); g.moveTo(.5, y * s + .5); g.lineTo(w * s + .5, y * s + .5); g.stroke();
    }
    for (const [x, y, i] of here) {
      g.fillStyle = (i === picked) ? "#ffd479" : "#6ef2c0";
      g.fillRect(x * s + 1, y * s + 1, s - 1, s - 1);
    }
  }
  document.getElementById("axesline").textContent =
    "axes " + a.join(" x ") + "  =  " + sizeOf(a) + " cells, " + ATOMS.length +
    " atoms, " + (sizeOf(a) - ATOMS.length) + " cells still empty";
  document.getElementById("legend").textContent =
    here.length + " atoms on this slice (" +
    (a.length > 2 ? "axes 2.. fixed at " + slice.slice(2).join(",") : "the whole box") +
    "); across is axis 0, down is axis 1";
  document.getElementById("offset").textContent =
    "the world has been moved " + offset + " along; can k is now the number " +
    "(k + " + offset + ") mod " + sizeOf(a);
  const m = contentsMap(a, ATOMS.length, offset);
  document.getElementById("counts").textContent =
    m.size + " of " + sizeOf(a) + " slots are filled, one atom each";
  showAtom();
  listing(m);
}

function showAtom() {
  const a = axes(), n = movedNumber(a, picked, offset);
  const row = ATOMS[picked];
  const at = pickedAddress();
  document.getElementById("atom").innerHTML = row === undefined
    ? "there is no atom " + picked
    : "atom " + picked + " &mdash; <b>" + row[0] + "</b>, holding " + row[1] +
      "<br>number now " + n + ", address " + coordsOf(a, n).join(", ") +
      ", cell " + cellOf(a, n) +
      "<br>slid by " + slid.join(", ") + ": address " + at.join(", ") +
      ", cell " + encodeAt(a, at) +
      "<br>the number written in it projects to cell " + row[2] + " of 71 x 59 x 47";
}

function listing(m) {
  const a = axes(), rows = [];
  for (let i = 0; i < 12 && i < ATOMS.length; i++) {
    const n = movedNumber(a, i, offset);
    rows.push("<tr><td>" + i + "</td><td>" + ATOMS[i][0] + "</td><td>" +
      coordsOf(a, n).join(",") + "</td><td>" + cellOf(a, n) + "</td></tr>");
  }
  document.getElementById("listing").innerHTML =
    "<table><tr><th>atom</th><th>label</th><th>address</th><th>cell</th></tr>" +
    rows.join("") + "</table>";
}

sel.addEventListener("change", () => {
  cur = Number(sel.value); resetSlice(); buildSlicers(); buildNudges(); redraw();
});
document.getElementById("unslide").addEventListener("click", () => {
  slid = axes().map(() => 0); redraw();
});
function move(d) {
  const s = sizeOf(axes());
  offset = ((offset + d) % s + s) % s;
  redraw();
}
document.getElementById("m1").addEventListener("click", () => move(-1));
document.getElementById("p1").addEventListener("click", () => move(1));
document.getElementById("m10").addEventListener("click", () => move(-10));
document.getElementById("p10").addEventListener("click", () => move(10));
document.getElementById("p1000").addEventListener("click", () => move(1000));
document.getElementById("turn").addEventListener("click", () => move(sizeOf(axes())));
document.getElementById("home").addEventListener("click", () => { offset = 0; redraw(); });
document.getElementById("show").addEventListener("click", () => {
  picked = Math.max(0, Number(document.getElementById("pick").value) | 0);
  redraw();
});

const log = [];
let allOk = true;
irrepChecks((what, cond) => {
  if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what);
});
document.getElementById("log").innerHTML =
  "<span class=\"" + (allOk ? "ok" : "bad") + "\">" +
  (allOk ? "all checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");

buildSlicers();
buildNudges();
redraw();
"##

/-- The whole page. -/
def irrepPage : String :=
  pageHead ++ pageData ++ pageModel ++ pageChecks ++ pageScript ++
    "\n</script>\n</body>\n</html>\n"

/-- The headless self-test. -/
def irrepSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Monster/IrrepPage.lean. " ++
    "Run: node www/irrep-selftest.mjs\n" ++
  pageData ++ pageModel ++ pageChecks ++ r##"
let fails = 0, n = 0;
irrepChecks((what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
});
console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the projected world page and its self-test. -/
def writeIrrepWorld : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/irrep-world.html" irrepPage
  IO.FS.writeFile "www/irrep-selftest.mjs" irrepSelfTest
  IO.println s!"irrep world: page {irrepPage.length} bytes, self-test {irrepSelfTest.length} bytes"

#eval writeIrrepWorld

end IrrepPage

end Monster

end NixWars
