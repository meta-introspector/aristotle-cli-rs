/-
Emit `voxels.html`: the machine's body built out of its parts, cube by cube, seen
in three dimensions.

Run from the project root with

    lake env lean --run scripts/emit_voxels.lean

Every cube on the page — its position, its colour, the slot it belongs to, the order
the cubes are painted in, the size of the viewport — is computed here by the Lean
functions of `RequestProject/PartVoxel.lean` and `RequestProject/VoxelView.lean`.
The page only turns the view and hides the cubes that have not been fitted yet.
-/
import RequestProject.VoxelView

open Replicate SelfCopy

/-! ## JSON helpers -/

private def jsonEsc (s : String) : String :=
  String.join (s.toList.map fun c =>
    match c with
    | '"'  => "\\\""
    | '\\' => "\\\\"
    | '\n' => "\\n"
    | '\r' => "\\r"
    | '\t' => "\\t"
    | c    => if c.toNat < 32 then "" else String.singleton c)

private def jstr (s : String) : String := "\"" ++ jsonEsc s ++ "\""

private def jarr (xs : List String) : String := "[" ++ String.intercalate "," xs ++ "]"

private def jnum (n : Nat) : String := toString n

/-! ## One machine's data block -/

def viewJson (cs : CardSet) (k : Nat) : String :=
  let s := viewScene cs k
  "{\"w\":" ++ jnum (viewWidth s) ++ ",\"h\":" ++ jnum (viewHeight s) ++
  ",\"svg\":" ++ jstr (String.join (bodyView cs k)) ++ "}"

def machineJson (key title : String) (cs : CardSet) : String :=
  let parts := (deckBoxes cs).map (fun b =>
    "{\"name\":" ++ jstr b.part.name ++ ",\"count\":" ++ jnum b.count ++
    ",\"size\":" ++ jnum b.part.size ++
    ",\"cubes\":" ++ jnum (b.count * b.part.size) ++
    ",\"color\":" ++ jstr (topHex b.part) ++ "}")
  let slotParts := (order cs).map (fun p => jstr p.name)
  let slotSizes := (order cs).map (fun p => jnum p.size)
  "{\"key\":" ++ jstr key ++
  ",\"title\":" ++ jstr title ++
  ",\"slots\":" ++ jnum (order cs).length ++
  ",\"cubes\":" ++ jnum (Model.voxelCount (bodyModel cs)) ++
  ",\"bomCubes\":" ++ jnum ((Part.all.map (fun p => deckBOM cs p * p.size)).sum) ++
  ",\"extent\":" ++ jnum (bodyExtent cs) ++
  ",\"parts\":" ++ jarr parts ++
  ",\"slotParts\":" ++ jarr slotParts ++
  ",\"slotSizes\":" ++ jarr slotSizes ++
  ",\"views\":" ++ jarr ((List.range 4).map (viewJson cs)) ++ "}"

def dataJson : String :=
  jarr [ machineJson "clay" "clay press" monogram,
         machineJson "clayworks" "clay workshop" workshop,
         machineJson "pipe" "pipe press" pipeMonogram,
         machineJson "pipeworks" "pipe works" pipeWorks ]

/-! ## The page -/

def head : String := "<!DOCTYPE html>
<html lang='en'><head><meta charset='utf-8'>
<meta name='viewport' content='width=device-width, initial-scale=1'>
<title>The body of the machine, in voxels</title>
<style>
 :root { --ink:#1b1b1b; --paper:#f6f1e7; --line:#c9bda8; }
 body { margin:0; background:var(--paper); color:var(--ink);
        font-family:'Iosevka','DejaVu Sans Mono',monospace; }
 header { padding:18px 24px 6px; border-bottom:1px solid var(--line); }
 h1 { margin:0; font-size:20px; letter-spacing:.5px; }
 h3 { font-size:14px; margin:14px 0 6px; }
 .sub { font-size:13px; opacity:.75; margin-top:4px; }
 main { padding:16px 24px 60px; max-width:1000px; }
 .tabs { display:flex; gap:8px; margin:14px 0; flex-wrap:wrap; }
 button { font:inherit; padding:6px 12px; border:1px solid var(--line);
          background:#fff; cursor:pointer; border-radius:3px; }
 button.on { background:var(--ink); color:var(--paper); }
 .stage { border:1px solid var(--line); background:#fffdf8; border-radius:4px;
          padding:8px; text-align:center; }
 svg { width:100%; max-width:620px; height:auto; }
 .controls { display:flex; gap:10px; align-items:center; margin:10px 0; flex-wrap:wrap; }
 input[type=range] { flex:1; min-width:220px; }
 .readout { font-size:13px; opacity:.8; }
 table { border-collapse:collapse; font-size:13px; margin:6px 0 14px; }
 td,th { border:1px solid var(--line); padding:3px 9px; text-align:left; }
 .swatch { display:inline-block; width:11px; height:11px; border:1px solid #8a7f6b;
           vertical-align:-1px; margin-right:5px; }
 .cols { display:flex; gap:24px; flex-wrap:wrap; }
 .note { font-size:13px; line-height:1.55; max-width:70ch; }
 code { background:#efe9dc; padding:1px 4px; border-radius:2px; }
 .hidden { display:none; }
</style></head><body>
<header>
 <h1>The body of the machine</h1>
 <div class='sub'>every part is a cluster of cubes &middot; the bill of materials is laid
   out on a lattice &middot; turn it, and watch it go together one part at a time</div>
 <div class='sub'>the flat film of the same replication is in
   <a href='replicator.html'>replicator.html</a></div>
</header><main>
<div class='tabs' id='tabs'></div>
<div class='controls'>
 <button id='left'>&#8635; turn left</button>
 <button id='right'>turn right &#8634;</button>
 <button id='play'>&#9654; build it</button>
 <button id='all'>whole body</button>
</div>
<div class='controls'>
 <label style='font-size:13px'>parts fitted</label>
 <input type='range' id='scrub' min='0' value='0'>
 <span class='readout' id='readout'></span>
</div>
<div class='stage' id='stage'></div>
<div class='cols'>
 <div><h3>What it is made of</h3><div id='parts'></div></div>
 <div><h3>Counts</h3><div id='counts'></div></div>
</div>
<h3>What the picture is</h3>
<div class='note'>
Each cube you see belongs to one part, and each part was fitted into one slot of a
lattice four voxels apart in every direction. The geometry is a value computed by the
Lean development in <code>RequestProject/PartVoxel.lean</code> and
<code>RequestProject/VoxelView.lean</code>; the page only turns it and hides the cubes
whose part has not been fitted yet. What is proved there:
<ul>
<li><b>the body is the bill of materials</b> — it holds exactly the parts the deck calls
for (<code>bodyModel_countPart</code>), and its cube count is the bill weighted by the
size of each part (<code>bodyModel_voxelCount</code>);</li>
<li><b>it does not self-intersect</b> — no two parts share a cube
(<code>bodyModel_cells_nodup</code>), because distinct slots are four voxels apart and
no part reaches further than three (<code>slot_cells_disjoint</code>);</li>
<li><b>one part per step</b> — fitting the next part adds exactly that part's own cubes
and disturbs nothing already built (<code>buildModel_cells_succ</code>), matching the
assembly film step for step (<code>buildModel_installed</code>), and the cubes shown at
step <i>j</i> are exactly the finished body's cubes whose part was fitted in the first
<i>j</i> steps (<code>scene_filter_slot</code>) — which is why hiding cubes is an honest
way to play the build back;</li>
<li><b>the drawing is complete and correctly ordered</b> — one drawing per cube, none
dropped or duplicated (<code>cubeSvgs_length</code>, <code>drawOrder_perm</code>), painted
back to front (<code>drawOrder_sorted</code>), and no cube ever hides one drawn after it
(<code>painter_correct</code>), because two cubes share a screen point only when one is
directly behind the other along the line of sight (<code>sameScreen_ray</code>);</li>
<li><b>the turns are turns</b> — a quarter-turn keeps the cubes distinct
(<code>viewScene_nodup</code>) and four of them bring the view back
(<code>viewScene_four</code>);</li>
<li><b>every copy has the same body</b> — generation <i>n</i> of the machine is laid out
exactly like the original (<code>bodyModel_generation</code>).</li>
</ul>
The SVG text is only text: nothing about a browser's rendering is verified, only the
geometry it is built from.
</div>
<script>
"

def tail : String := "
const tabs = document.getElementById('tabs');
const stage = document.getElementById('stage');
const scrub = document.getElementById('scrub');
const readout = document.getElementById('readout');
let cur = 0, turn = 0, step = 0, timer = null;

function esc(s){ return s.replace(/&/g,'&amp;').replace(/</g,'&lt;'); }

function drawTabs(){
  tabs.innerHTML = '';
  DATA.forEach((m,i) => {
    const b = document.createElement('button');
    b.textContent = m.title;
    if (i === cur) b.className = 'on';
    b.onclick = () => { cur = i; step = DATA[i].slots; stop(); render(); };
    tabs.appendChild(b);
  });
}

function render(){
  const m = DATA[cur];
  const v = m.views[turn % 4];
  scrub.max = m.slots;
  scrub.value = step;
  stage.innerHTML = \"<svg viewBox='0 0 \" + v.w + ' ' + v.h + \"'>\" + v.svg + '</svg>';
  let shown = 0;
  stage.querySelectorAll('g.c').forEach(g => {
    const cls = [...g.classList].find(c => /^s[0-9]+$/.test(c));
    const slot = Number(cls.slice(1));
    if (slot < step) { shown++; } else { g.classList.add('hidden'); }
  });
  const fitted = m.slotParts.slice(0, step);
  readout.textContent = step + ' / ' + m.slots + ' parts  ·  ' + shown + ' / ' +
    m.cubes + ' cubes  ·  turn ' + (turn % 4) * 90 + '\\u00b0' +
    (step > 0 ? '  ·  last fitted: ' + fitted[fitted.length - 1] : '');
  document.getElementById('parts').innerHTML =
    '<table><tr><th>part</th><th>count</th><th>cubes each</th><th>cubes</th></tr>' +
    m.parts.map(p => '<tr><td><span class=\"swatch\" style=\"background:' + p.color +
      '\"></span>' + esc(p.name) + '</td><td>' + p.count + '</td><td>' + p.size +
      '</td><td>' + p.cubes + '</td></tr>').join('') + '</table>';
  document.getElementById('counts').innerHTML =
    '<table>' +
    '<tr><td>parts in the body</td><td>' + m.slots + '</td></tr>' +
    '<tr><td>cubes in the body</td><td>' + m.cubes + '</td></tr>' +
    '<tr><td>cubes from the bill of materials</td><td>' + m.bomCubes + '</td></tr>' +
    '<tr><td>body fits in a box of side</td><td>' + (m.extent + 1) + '</td></tr>' +
    '</table>';
  drawTabs();
}

function stop(){ if (timer) { clearInterval(timer); timer = null; }
  document.getElementById('play').innerHTML = '&#9654; build it'; }

document.getElementById('left').onclick = () => { turn = (turn + 3) % 4; render(); };
document.getElementById('right').onclick = () => { turn = (turn + 1) % 4; render(); };
document.getElementById('all').onclick = () => {
  stop(); step = DATA[cur].slots; render(); };
document.getElementById('play').onclick = () => {
  if (timer) { stop(); return; }
  step = 0; render();
  document.getElementById('play').innerHTML = '&#10073;&#10073; pause';
  timer = setInterval(() => {
    step = step + 1;
    if (step > DATA[cur].slots) { step = DATA[cur].slots; stop(); }
    render();
  }, 320);
};
scrub.oninput = () => { stop(); step = Number(scrub.value); render(); };
step = DATA[0].slots;
render();
</script></main></body></html>
"

def main : IO Unit := do
  let page := head ++ "const DATA = " ++ dataJson ++ ";\n" ++ tail
  IO.FS.writeFile "voxels.html" page
  IO.println s!"wrote voxels.html ({page.length} characters)"
  IO.println s!"cubes: {Model.voxelCount (bodyModel monogram)}, \
{Model.voxelCount (bodyModel workshop)}, {Model.voxelCount (bodyModel pipeMonogram)}, \
{Model.voxelCount (bodyModel pipeWorks)}"
