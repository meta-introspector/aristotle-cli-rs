import RequestProject.Nix.NixWars.Monster.Place
import RequestProject.Nix.NixWars.Gl

/-!
# The world as a static page: `www/voxel-world.html`

One self-contained file, no network dependencies, emitted from Lean during the
build.  Everything numeric in it comes from this development: the axes
(`worldAxes`), the cell count of every level (`cells`), the occupancy of every
level (`occupancy`), the table itself (`irrepRows`) and the number each row
names (`rowValue`, a divisor of `|M|` by `rowValue_dvd_monsterOrder`).  The
page recomputes the placement of all 194 rows in the browser and checks its own
arithmetic against the Lean-emitted occupancy figures — the check is displayed,
so a wrong page says so on its face.

The page is written to be *read*: it is a map, not a game, and it says so.
Every picture on it has a caption in plain words, and both pictures answer
questions — hover or tap a bright cell on the map, or a corner of the box, and
the page names the rows that live there, the primes that put them there and the
number each row stands for.

`www/voxel-selftest.mjs` rebuilds the whole model from `data/irreps_sum.tsv`
and checks the page against it, headless.
-/

namespace NixWars

namespace Monster

/-! ## The data block -/

/-- A JSON array of naturals. -/
def natListJson (l : List Nat) : String :=
  "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- A JSON array of naturals as decimal *strings*: the finest cell count, and
the number a row names, do not fit in a JavaScript number. -/
def natListJsonStr (l : List Nat) : String :=
  "[" ++ String.intercalate "," (l.map (fun n => "\"" ++ toString n ++ "\"")) ++ "]"

/-- The axes of the world, coarsest first. -/
def axesJson : String := natListJson worldAxes

/-- The cell counts of levels `0 … 15`. -/
def cellsJson : String := natListJsonStr ((List.range 16).map cells)

/-- The occupancy of levels `0 … 15`. -/
def occupancyJson : String := natListJson ((List.range 16).map occupancy)

/-- The table: `[index, [fifteen exponents], sum]` per row. -/
def rowsJson : String :=
  "[" ++ String.intercalate ",\n" (irrepRows.map (fun r =>
    "[" ++ toString r.idx ++ "," ++ natListJson r.exps ++ "," ++ toString r.rowSum ++ "]")) ++ "]"

/-- The number each row names — `∏ p ^ e`, a divisor of `|M|` — in the order
the rows are written. -/
def valuesJson : String := natListJsonStr (irrepRows.map rowValue)

/-- The fifteen primes, ascending, as the columns of the table run. -/
def primesJson : String := natListJson monsterPrimes

/-- The order of the Monster as a decimal string. -/
def monsterOrderStr : String := toString monsterOrder

/-! ## The page -/

/-- The head of the page: style, and the prose that says what is being looked
at before anything is drawn. -/
def voxelPageHead : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>NixWars &mdash; the voxel world of the Monster</title>
<style>
:root { color-scheme: dark; }
body { margin: 0; background: #05070d; color: #c8d6e5;
  font-family: ui-monospace, SFMono-Regular, Menlo, monospace; }
main { max-width: 62rem; margin: 0 auto; padding: 1.2rem; }
h1 { font-size: 1.35rem; color: #7ee787; margin: 0 0 .2rem 0; }
h2 { font-size: 1.05rem; color: #79c0ff; margin: 1.8rem 0 .4rem 0; }
h3 { font-size: .95rem; color: #c8d6e5; margin: 1rem 0 .3rem 0; }
p { line-height: 1.55; }
code { color: #ffa657; }
a { color: #79c0ff; }
canvas { background: #0a0f1a; border: 1px solid #1f2a3a; width: 100%; height: auto;
  image-rendering: pixelated; touch-action: none; }
.controls { display: flex; gap: .8rem; align-items: center; flex-wrap: wrap; margin: .6rem 0; }
input[type=range] { flex: 1 1 18rem; }
button { background: #16233a; color: #c8d6e5; border: 1px solid #26364f; border-radius: 3px;
  padding: .25rem .7rem; font: inherit; cursor: pointer; }
button:hover { background: #1d2f4d; }
table { border-collapse: collapse; width: 100%; font-size: .82rem; }
th, td { border: 1px solid #1f2a3a; padding: .18rem .4rem; text-align: right; }
th { color: #79c0ff; }
td.l, th.l { text-align: left; }
.stat { color: #7ee787; }
.bad { color: #ff7b72; }
#log { white-space: pre-wrap; font-size: .8rem; color: #8b949e; }
.lede { border: 1px solid #1f2a3a; border-left: 3px solid #7ee787; padding: .1rem .9rem;
  background: #080d16; }
.note { color: #8b949e; font-size: .85rem; }
.tag { font-size: .7rem; color: #05070d; background: #7ee787; border-radius: 3px;
  padding: .1rem .4rem; vertical-align: middle; letter-spacing: .05em; }
.pick { border: 1px solid #1f2a3a; background: #080d16; padding: .5rem .8rem; min-height: 5.5rem;
  font-size: .84rem; }
.pick b { color: #7ee787; font-weight: normal; }
.swatch { display: inline-block; width: .8rem; height: .8rem; vertical-align: -1px;
  border: 1px solid #26364f; }
.key { display: flex; gap: 1.2rem; flex-wrap: wrap; font-size: .82rem; color: #8b949e;
  margin: .4rem 0; }
details { border: 1px solid #1f2a3a; padding: .3rem .8rem; background: #080d16; }
summary { cursor: pointer; color: #79c0ff; }
"## ++ Gl.responsiveCss ++ r##"</style>
</head>
<body>
<main>
<h1>The voxel world <span class="tag">A MAP, NOT A GAME</span></h1>

<div class="lede">
<p><b>What this page is.</b> It is the map the NixWars games are played on, and
nothing here is played: there is no score, no opponent and nothing to lose. It
is a picture of one table of numbers. If you came for a game, the arcade is at
<a href="arcade.html">arcade.html</a> and the two-empire ledger game at
<a href="empire.html">empire.html</a>.</p>
<p><b>What is being pictured.</b> The Monster is the largest of the sporadic
finite simple groups. Its size is a 54-digit number, and only fifteen primes
divide it: 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 41, 47, 59 and 71. The table
<code>data/irreps_sum.tsv</code> has 194 rows &mdash; one per irreducible
character of the Monster &mdash; and each row is just fifteen small counts: how
many times each of those primes divides that row's own number. Every one of
those numbers divides the size of the Monster (Lean:
<code>rowValue_dvd_monsterOrder</code>).</p>
<p><b>How a row becomes a place.</b> Take the primes as the axes of a grid, the
largest first. A row's position along the 71 axis is its count of 71s, along
the 59 axis its count of 59s, and so on. Two axes give a grid of
71&nbsp;&times;&nbsp;59 boxes, three give
71&nbsp;&times;&nbsp;59&nbsp;&times;&nbsp;47&nbsp;=&nbsp;196&nbsp;883 boxes, and
each further prime cuts every box into finer slices. That is all a
&ldquo;voxel&rdquo; is here: one box of the grid, holding whichever rows have
those counts. The slider below adds one prime at a time and you watch the 194
rows separate.</p>
</div>
"##

/-- The interactive part: controls, canvases, tables, and the emitted data. -/
def voxelPageBody (axes cellsS occ rows values primes order : String) : String :=
  r##"<h2>1. The map: 194 rows, one prime at a time</h2>
<p>Every bright square is a box of the grid that at least one row lands in. Move
the slider and a new prime becomes an axis: boxes that held several rows split,
and the rows drift apart. At level&nbsp;0 there are no axes at all, so all 194
rows are in the one box that is the whole map; by level&nbsp;15 they have
separated as far as they ever can.</p>
<div class="controls">
  <label for="lvl">level (how many primes are axes)</label>
  <input id="lvl" type="range" min="0" max="15" value="3" step="1">
  <span id="lvlv" class="stat">3</span>
  <button id="play">run through the levels</button>
</div>
<canvas id="map" width="720" height="720"></canvas>
<div class="key">
  <span><span class="swatch" style="background:hsl(260,85%,55%)"></span>
        few prime factors in all</span>
  <span><span class="swatch" style="background:hsl(140,85%,55%)"></span>
        more</span>
  <span><span class="swatch" style="background:hsl(20,85%,55%)"></span>
        most (up to 56)</span>
  <span>a paler, larger square holds more rows at once</span>
  <span>faint lines are the grid of the current level, while it is still coarse
        enough to see</span>
</div>
<p id="stats"></p>
<h3>What is in a square</h3>
<p class="note">Point at a square (or tap it) and this panel names the rows in
it, the counts that put them there, and the number each row stands for.</p>
<div id="pick" class="pick">Point at a bright square above.</div>

<h2>2. The three coarsest primes: a cube of yes and no</h2>
<p>The three largest primes are 71, 59 and 47, and no row's number is divisible
by any of them more than once. So along each of those three axes a row sits at
0 or 1 &mdash; and the whole table, all 194 rows, sits in the eight
<em>corners</em> of the 71&nbsp;&times;&nbsp;59&nbsp;&times;&nbsp;47 grid,
leaving the other 196&nbsp;875 boxes empty. That is what the cube below is: not
an ornament, but three yes-or-no questions asked of every row at once. A ball
sits at each corner, its size the number of rows that answer that way. Drag the
cube to turn it; click a ball to see who is there.</p>
<div class="controls">
  <button id="spin">turn it</button>
  <span class="note">or drag the cube itself</span>
</div>
<canvas id="box" width="720" height="460"></canvas>
<p id="boxstats"></p>
<div id="cubepick" class="pick">Click a corner of the cube.</div>
<h3>The eight corners</h3>
<table id="corners"><thead><tr>
<th class="l">divisible by 71?</th><th class="l">by 59?</th><th class="l">by 47?</th>
<th>rows here</th><th class="l">for instance</th></tr></thead><tbody></tbody></table>

<h2>3. Every level, in numbers</h2>
<p>One line per level. <em>New axis</em> is the prime that level adds;
<em>boxes</em> is how many boxes the grid then has; <em>box size</em> is the
fraction of the map each box takes; <em>boxes used</em> is how many of them any
row lands in, and <em>rows per used box</em> how crowded those are. The last
column is the news: how many boxes the new prime split apart.</p>
<table id="levels"><thead><tr>
<th class="l">level</th><th>new axis</th><th>boxes</th><th>box size</th>
<th>boxes used</th><th>rows per used box</th><th>gained</th></tr></thead><tbody></tbody></table>
<p class="note">The last few lines gain nothing: at level&nbsp;15 the 194 rows
occupy 170 boxes, and 170 is exactly the number of different exponent vectors
in the table. The remaining crowding is rows that carry literally the same
fifteen counts, and no further prime can tell those apart.</p>

<h2>4. Does the page add up?</h2>
<p>The page recomputes every figure above from the table it carries and compares
it with the figures Lean computed during the build. If a single one disagreed,
the line below would say so.</p>
<details><summary>the arithmetic, line by line</summary>
<p id="log"></p>
</details>
<p>Emitted from <code>RequestProject/NixWars/Monster/Page.lean</code>; the world
is <code>World.lean</code>, the placement <code>Place.lean</code>, the table
<code>Irreps.lean</code>. To fly this world in WebGL, at three dimensions or at
fifteen, take <a href="fly.html">the voxel flight</a>; to fly into every thing
in the world, one labelled tin at a time, take
<a href="cans.html">the can opener</a>. Back to
<a href="arcade.html">the arcade room</a> or
<a href="nixwars.html">NixWars</a>.</p>
<script>
const AXES = "## ++ axes ++ r##";
const CELLS = "## ++ cellsS ++ r##".map(BigInt);
const OCC = "## ++ occ ++ r##";
const ROWS = "## ++ rows ++ r##";
const VALUES = "## ++ values ++ r##";
const PRIMES = "## ++ primes ++ r##";
const MORDER = "## ++ order ++ r##";

// --- the model, exactly as in Place.lean -------------------------------
// coordinates of a row: exponents read from the largest prime down, each
// reduced into its axis
const coordsOf = exps => exps.slice().reverse().map((e, i) => e % AXES[i]);
// mixed-radix index of an address, coarsest axis most significant
const encode = coords => {
  let n = 0n;
  for (let i = 0; i < coords.length; i++) n = n * BigInt(AXES[i]) + BigInt(coords[i]);
  return n;
};
const decode = (n, d) => {
  const out = new Array(d);
  for (let i = d - 1; i >= 0; i--) { const q = BigInt(AXES[i]); out[i] = Number(n % q); n = n / q; }
  return out;
};
const voxel = (exps, d) => encode(coordsOf(exps).slice(0, d));
const occupancy = d => new Set(ROWS.map(r => voxel(r[1], d).toString())).size;
const group = d => {
  const m = new Map();
  for (const r of ROWS) {
    const k = voxel(r[1], d).toString();
    if (!m.has(k)) m.set(k, []);
    m.get(k).push(r);
  }
  return m;
};

// --- saying what a row is ------------------------------------------------
const VAL = new Map(ROWS.map((r, i) => [r[0], VALUES[i]]));
const commas = s => s.replace(/\B(?=(\d{3})+(?!\d))/g, "\u2009");
// a 54-digit number is not worth printing in full
const shortNum = s => s.length <= 24 ? commas(s)
  : commas(s.slice(0, 12)) + "\u2026" + s.slice(-4) + " (" + s.length + " digits)";
const factorOf = exps => {
  const parts = [];
  for (let i = 0; i < PRIMES.length; i++) {
    if (exps[i] === 1) parts.push(String(PRIMES[i]));
    else if (exps[i] > 1) parts.push(PRIMES[i] + "^" + exps[i]);
  }
  return parts.length ? parts.join(" \u00b7 ") : "1";
};
const rowLine = r =>
  "<b>row " + r[0] + "</b> &nbsp; " + factorOf(r[1]) + " &nbsp;=&nbsp; " +
  shortNum(VAL.get(r[0])) + " &nbsp; <span class='note'>(" + r[2] +
  " prime factors counted with multiplicity)</span>";
const rowsPanel = (title, rs) => {
  const out = ["<p>" + title + "</p>"];
  const shown = rs.slice(0, 8);
  for (const r of shown) out.push("<div>" + rowLine(r) + "</div>");
  if (rs.length > shown.length)
    out.push("<div class='note'>&hellip; and " + (rs.length - shown.length) + " more</div>");
  return out.join("");
};

// --- the map: each level cuts the square along the next axis ------------
const SIZE = 720;
const rectOf = coords => {
  let x = 0, y = 0, w = SIZE, h = SIZE;
  for (let i = 0; i < coords.length; i++) {
    const q = AXES[i], c = coords[i];
    if (i % 2 === 0) { const cw = w / q; x += c * cw; w = cw; }
    else { const ch = h / q; y += c * ch; h = ch; }
  }
  return [x, y, w, h];
};
const hue = sum => 260 - Math.round(240 * Math.min(sum, 56) / 56);

const mapEl = document.getElementById('map');
const map = mapEl.getContext('2d');
let MARKS = [];       // what was drawn, so that a click can be answered
let LEVEL = 3;

const drawMap = d => {
  LEVEL = d;
  MARKS = [];
  map.fillStyle = '#0a0f1a';
  map.fillRect(0, 0, SIZE, SIZE);
  // grid lines, while the cells are still big enough to see
  let x = 0, y = 0, w = SIZE, h = SIZE;
  map.lineWidth = 1;
  for (let i = 0; i < d; i++) {
    const q = AXES[i];
    if (i % 2 === 0) w = w / q; else h = h / q;
    if (Math.min(w, h) < 3) break;
    map.strokeStyle = 'rgba(121,192,255,' + (0.30 / (i + 1)).toFixed(3) + ')';
    map.beginPath();
    for (let gx = 0; gx <= SIZE; gx += w) { map.moveTo(gx, 0); map.lineTo(gx, SIZE); }
    for (let gy = 0; gy <= SIZE; gy += h) { map.moveTo(0, gy); map.lineTo(SIZE, gy); }
    map.stroke();
  }
  // the rows
  const g = group(d);
  for (const [k, rs] of g) {
    const coords = coordsOf(rs[0][1]).slice(0, d);
    let [rx, ry, rw, rh] = rectOf(coords);
    const dw = Math.max(rw, 4), dh = Math.max(rh, 4);
    const sum = Math.max(...rs.map(r => r[2]));
    map.fillStyle = 'hsla(' + hue(sum) + ',85%,' + (35 + Math.min(rs.length, 8) * 4) + '%,0.92)';
    map.fillRect(rx, ry, dw, dh);
    MARKS.push({ x: rx, y: ry, w: dw, h: dh, rows: rs, coords: coords });
  }
  const cells = CELLS[d];
  const occN = occupancy(d);
  document.getElementById('stats').innerHTML =
    'Axes so far: <span class="stat">' + (d === 0 ? 'none' : AXES.slice(0, d).join(' \u00d7 ')) +
    '</span>. That is <span class="stat">' + commas(cells.toString()) +
    '</span> box' + (cells === 1n ? '' : 'es') + ', each one <span class="stat">1/' +
    commas(cells.toString()) + '</span> of the map, and the 194 rows land in <span class="stat">' +
    occN + '</span> of them' +
    (occN === 194 ? '' : ' \u2014 so ' + (194 - occN) + ' row' + (194 - occN === 1 ? ' shares' : 's share') +
     ' a box with another') +
    '. Lean computed <span class="stat">' + OCC[d] + '</span>' +
    (occN === OCC[d] ? ', and the page agrees.' : ' <span class="bad">MISMATCH</span>');
};

// what is under the pointer
const markAt = (px, py) => {
  let best = null, bestd = 1e9;
  for (const m of MARKS) {
    const dx = Math.max(m.x - px, 0, px - (m.x + m.w));
    const dy = Math.max(m.y - py, 0, py - (m.y + m.h));
    const dd = dx * dx + dy * dy;
    if (dd < bestd) { bestd = dd; best = m; }
  }
  return bestd <= 64 ? best : null;
};

const describeMark = m => {
  if (m === null) return "Point at a bright square above.";
  const where = m.coords.length === 0
    ? "the whole map, before any prime is an axis"
    : m.coords.map((c, i) => AXES[i] + ": " + c).join(", ");
  const head = "<p><b>box (" + where + ")</b> at level " + LEVEL + " &mdash; " +
    m.rows.length + " of the 194 rows" +
    (m.coords.length === 0 ? "" :
      ".<br><span class='note'>Read it as: these rows are divisible by " +
      (m.coords.every(c => c === 0)
        ? "none of " + AXES.slice(0, m.coords.length).join(", ")
        : m.coords.map((c, i) => c === 0 ? null : AXES[i] + (c > 1 ? " exactly " + c + " times" : ""))
            .filter(z => z !== null).join(", ") +
          (m.coords.some(c => c === 0)
            ? ", and by none of " + m.coords.map((c, i) => c === 0 ? AXES[i] : null)
                .filter(z => z !== null).join(", ") : "")) +
      ".</span>") + "</p>";
  return head + rowsPanel("", m.rows);
};

const pointOn = ev => {
  const r = mapEl.getBoundingClientRect();
  return [(ev.clientX - r.left) * SIZE / r.width, (ev.clientY - r.top) * SIZE / r.height];
};
let PINNED = false;
mapEl.addEventListener('pointermove', ev => {
  if (PINNED) return;
  const [px, py] = pointOn(ev);
  document.getElementById('pick').innerHTML = describeMark(markAt(px, py));
});
mapEl.addEventListener('pointerdown', ev => {
  const [px, py] = pointOn(ev);
  const m = markAt(px, py);
  PINNED = m !== null;
  document.getElementById('pick').innerHTML =
    describeMark(m) + (PINNED ? "<p class='note'>Pinned. Click the map again to let go.</p>" : "");
  if (!PINNED) PINNED = false;
});
mapEl.addEventListener('pointerleave', () => {
  if (!PINNED) document.getElementById('pick').innerHTML = "Point at a bright square above.";
});

// --- level 3 as a box you can turn --------------------------------------
const boxEl = document.getElementById('box');
const box = boxEl.getContext('2d');
const BW = 720, BH = 460;
let ROT = 0.6, SPIN = null, CORNERS = [];

const project = (u, v, w) => {
  const a = (u - 0.5) * 300, b = (v - 0.5) * 300, c = (w - 0.5) * 300;
  const ct = Math.cos(ROT), st = Math.sin(ROT);
  const X = a * ct - b * st, Y = a * st + b * ct;
  return [BW / 2 + X, BH / 2 + Y * 0.42 - c * 0.62, Y];
};

const drawBox = () => {
  box.fillStyle = '#0a0f1a';
  box.fillRect(0, 0, BW, BH);
  const corners = [[0,0,0],[1,0,0],[0,1,0],[0,0,1],[1,1,0],[1,0,1],[0,1,1],[1,1,1]];
  box.strokeStyle = '#26364f';
  box.lineWidth = 1;
  for (const c of corners) {
    for (let ax = 0; ax < 3; ax++) if (c[ax] === 0) {
      const d2 = c.slice(); d2[ax] = 1;
      const p = project(c[0], c[1], c[2]), q = project(d2[0], d2[1], d2[2]);
      box.beginPath(); box.moveTo(p[0], p[1]); box.lineTo(q[0], q[1]); box.stroke();
    }
  }
  // the axis labels, on the three edges out of the near corner
  box.font = '13px ui-monospace, monospace';
  box.fillStyle = '#8b949e';
  const lab = (u, v, w, t) => { const p = project(u, v, w); box.fillText(t, p[0] - 14, p[1] + 4); };
  lab(0.5, -0.16, 0, '71 \u2192');
  lab(-0.16, 0.5, 0, '59 \u2192');
  lab(-0.14, -0.14, 0.5, '47 \u2191');

  const g = group(3);
  CORNERS = [];
  const drawn = [];
  for (const [k, rs] of g) {
    const c = decode(BigInt(k), 3);
    const p = project(c[0], c[1], c[2]);
    drawn.push({ c: c, p: p, rs: rs, r: 6 + Math.min(rs.length, 40) * 0.45 });
  }
  drawn.sort((a, b) => a.p[2] - b.p[2]);
  for (const d of drawn) {
    box.fillStyle = 'hsla(' + hue(Math.max(...d.rs.map(r => r[2]))) + ',85%,55%,0.95)';
    box.beginPath(); box.arc(d.p[0], d.p[1], d.r, 0, 6.284); box.fill();
    box.fillStyle = '#c8d6e5';
    box.fillText(d.rs.length + (d.rs.length === 1 ? ' row' : ' rows'), d.p[0] + d.r + 5, d.p[1] + 4);
    CORNERS.push({ x: d.p[0], y: d.p[1], r: Math.max(d.r, 12), c: d.c, rs: d.rs });
  }
  document.getElementById('boxstats').innerHTML =
    'The 194 rows sit in <span class="stat">' + g.size + '</span> of the ' +
    '<span class="stat">196\u2009883</span> boxes of the 71 &times; 59 &times; 47 grid: ' +
    'its eight corners, because no row is divisible by 71, by 59 or by 47 more than once. ' +
    'The ball at a corner is as big as the number of rows standing there.';
};

const cornerAt = (px, py) => {
  for (const c of CORNERS) {
    const dx = px - c.x, dy = py - c.y;
    if (dx * dx + dy * dy <= (c.r + 8) * (c.r + 8)) return c;
  }
  return null;
};

const yesno = (c, i) => c === 1 ? 'divisible by ' + AXES[i] : 'not divisible by ' + AXES[i];

boxEl.addEventListener('pointerdown', ev => {
  const r = boxEl.getBoundingClientRect();
  const px = (ev.clientX - r.left) * BW / r.width, py = (ev.clientY - r.top) * BH / r.height;
  const c = cornerAt(px, py);
  if (c !== null) {
    document.getElementById('cubepick').innerHTML =
      rowsPanel("<b>corner (" + c.c.join(',') + ")</b> &mdash; " + c.rs.length +
                " rows: " + c.c.map((v, i) => yesno(v, i)).join(', ') + ".", c.rs);
  }
  DRAG = { x: ev.clientX, rot: ROT };
  boxEl.setPointerCapture(ev.pointerId);
});
let DRAG = null;
boxEl.addEventListener('pointermove', ev => {
  if (DRAG === null) return;
  ROT = DRAG.rot + (ev.clientX - DRAG.x) * 0.01;
  drawBox();
});
boxEl.addEventListener('pointerup', () => { DRAG = null; });
boxEl.addEventListener('pointercancel', () => { DRAG = null; });

document.getElementById('spin').addEventListener('click', () => {
  if (SPIN) { clearInterval(SPIN); SPIN = null; return; }
  SPIN = setInterval(() => { ROT += 0.03; drawBox(); }, 50);
});

// --- the eight corners, as a table ---------------------------------------
{
  const tbody = document.querySelector('#corners tbody');
  const g = group(3);
  const rowsOf = [...g.entries()].map(([k, rs]) => ({ c: decode(BigInt(k), 3), rs: rs }));
  rowsOf.sort((a, b) => b.rs.length - a.rs.length);
  for (const e of rowsOf) {
    const tr = document.createElement('tr');
    const yn = v => v === 1 ? '<span class="stat">yes</span>' : 'no';
    const ex = e.rs[0];
    tr.innerHTML = '<td class="l">' + yn(e.c[0]) + '</td><td class="l">' + yn(e.c[1]) +
      '</td><td class="l">' + yn(e.c[2]) + '</td><td>' + e.rs.length +
      '</td><td class="l">row ' + ex[0] + ': ' + factorOf(ex[1]) + '</td>';
    tbody.appendChild(tr);
  }
}

// --- the table of levels -------------------------------------------------
{
  const tbody = document.querySelector('#levels tbody');
  let prev = 0;
  for (let d = 0; d <= 15; d++) {
    const tr = document.createElement('tr');
    const occN = occupancy(d);
    const gained = d === 0 ? 0 : occN - prev;
    tr.innerHTML = '<td class="l">' + d + '</td><td>' + (d === 0 ? '&mdash;' : AXES[d-1]) +
      '</td><td>' + commas(CELLS[d].toString()) + '</td><td>1/' + commas(CELLS[d].toString()) +
      '</td><td>' + occN + '</td><td>' + (194 / occN).toFixed(2) + '</td><td>' +
      (d === 0 ? '&mdash;' : (gained === 0 ? '<span class="note">nothing</span>' : '+' + gained)) +
      '</td>';
    tbody.appendChild(tr);
    prev = occN;
  }
}

// --- the page checks itself ---------------------------------------------
const log = [];
let ok = true;
const check = (what, cond) => { if (!cond) ok = false; log.push((cond ? '  ok   ' : '  FAIL ') + what); };
for (let d = 0; d <= 15; d++) check('occupancy(' + d + ') = ' + OCC[d], occupancy(d) === OCC[d]);
check('cells are the products of the axes',
  CELLS.every((c, d) => c === AXES.slice(0, d).reduce((a, p) => a * BigInt(p), 1n)));
check('every row lands inside its level', ROWS.every(r =>
  [...Array(16).keys()].every(d => voxel(r[1], d) < CELLS[d])));
check('decode inverts encode', ROWS.every(r =>
  decode(voxel(r[1], 15), 15).join(',') === coordsOf(r[1]).join(',')));
check('a coarse voxel is the parent of the fine one', ROWS.every(r =>
  [...Array(15).keys()].every(d => voxel(r[1], d) === voxel(r[1], d + 1) / BigInt(AXES[d]))));
check('the table has 194 rows', ROWS.length === 194);
check('every row names a divisor of the order of the Monster', ROWS.every((r, i) => {
  let v = 1n;
  for (let j = 0; j < PRIMES.length; j++) v *= BigInt(PRIMES[j]) ** BigInt(r[1][j]);
  return v.toString() === VALUES[i] && BigInt(MORDER) % v === 0n;
}));
document.getElementById('log').textContent =
  (ok ? 'all ' + log.length + ' checks pass' : 'CHECKS FAILED') + '\n' + log.join('\n');

// --- controls ------------------------------------------------------------
const slider = document.getElementById('lvl');
const redraw = () => {
  document.getElementById('lvlv').textContent = slider.value;
  drawMap(Number(slider.value));
};
slider.addEventListener('input', () => { PINNED = false; redraw(); });
let timer = null;
document.getElementById('play').addEventListener('click', () => {
  if (timer) { clearInterval(timer); timer = null; return; }
  timer = setInterval(() => {
    slider.value = String((Number(slider.value) + 1) % 16);
    PINNED = false;
    redraw();
  }, 900);
});
redraw();
drawBox();
</script>
</main>
</body>
</html>
"##

/-- The whole page. -/
def voxelWorldPage : String :=
  voxelPageHead ++
    voxelPageBody axesJson cellsJson occupancyJson rowsJson valuesJson primesJson
      ("\"" ++ monsterOrderStr ++ "\"")

/-- Write the page. -/
def writeVoxelWorldPage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/voxel-world.html" voxelWorldPage

#eval writeVoxelWorldPage

end Monster

end NixWars
