/-
Emit `replicator.html`: the animated replication films, exactly as Lean renders them.

Run from the project root with

    lake env lean --run scripts/emit_replicator.lean

Everything the page animates — every SVG frame, every ASCII frame, every crate
count, every frame count — is computed here by the Lean functions of
`RequestProject/ReplicatorRender.lean`.  The page only steps through them.
-/
import RequestProject.ReplicatorRender

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

/-- One machine's whole data block. -/
def machineJson (key title : String) (cs : CardSet) : String :=
  let frames := (film cs).map (frameSvg title)
  let ascii := (film cs).map (frameArt title)
  let boxes := (deckBoxes cs).map (fun b =>
    "{\"part\":" ++ jstr b.part.name ++ ",\"count\":" ++ jnum b.count ++
    ",\"glyph\":" ++ jstr (String.singleton b.part.glyph) ++ "}")
  let cards := cs.map (fun c =>
    "{\"name\":" ++ jstr c.name ++ ",\"tier\":" ++ jnum c.tier ++
    ",\"press\":" ++ (if c.press then "true" else "false") ++
    ",\"needs\":" ++ jarr (c.needs.map jstr) ++
    ",\"raw\":" ++ jarr (c.raw.map (fun m => jstr (matName m))) ++ "}")
  "{\"key\":" ++ jstr key ++
  ",\"title\":" ++ jstr title ++
  ",\"cycles\":" ++ jnum (order cs).length ++
  ",\"frameCount\":" ++ jnum (film cs).length ++
  ",\"accepted\":" ++ (if checkEntry cs then "true" else "false") ++
  ",\"emitsDeck\":" ++ (if emit (cs.map build) == cs then "true" else "false") ++
  ",\"leftover\":" ++
      (match assembleDeck (deckBOM cs) cs with
       | some s => if Stock.eqOn s Stock.empty then "0" else "-1"
       | none => "-1") ++
  ",\"boxes\":" ++ jarr boxes ++
  ",\"cards\":" ++ jarr cards ++
  ",\"svg\":" ++ jarr (frames.map jstr) ++
  ",\"ascii\":" ++ jarr (ascii.map jstr) ++ "}"

def dataJson : String :=
  jarr [ machineJson "clay" "clay press" monogram,
         machineJson "clayworks" "clay workshop" workshop,
         machineJson "pipe" "pipe press" pipeMonogram,
         machineJson "pipeworks" "pipe works" pipeWorks ]

/-! ## The page -/

def head : String := "<!DOCTYPE html>
<html lang='en'><head><meta charset='utf-8'>
<title>The replicator — fabricate, assemble, copy</title>
<style>
 :root { --ink:#1b1b1b; --paper:#f6f1e7; --clay:#b5651d; --pipe:#3d6b8e; --line:#c9bda8; }
 body { margin:0; background:var(--paper); color:var(--ink);
        font-family:'Iosevka','DejaVu Sans Mono',monospace; }
 header { padding:18px 24px 6px; border-bottom:1px solid var(--line); }
 h1 { margin:0; font-size:20px; letter-spacing:.5px; }
 .sub { font-size:13px; opacity:.75; margin-top:4px; }
 main { padding:16px 24px 60px; max-width:1000px; }
 .tabs { display:flex; gap:8px; margin:14px 0; flex-wrap:wrap; }
 .tabs button { font:inherit; padding:6px 12px; border:1px solid var(--line);
                background:#fff; cursor:pointer; border-radius:3px; }
 .tabs button.on { background:var(--ink); color:var(--paper); }
 .stage { border:1px solid var(--line); background:#fffdf8; border-radius:4px; padding:8px; }
 svg { width:100%; height:auto; display:block; }
 .controls { display:flex; gap:10px; align-items:center; margin:10px 0; flex-wrap:wrap; }
 .controls button { font:inherit; padding:5px 10px; border:1px solid var(--line);
                    background:#fff; cursor:pointer; border-radius:3px; }
 input[type=range] { flex:1; min-width:220px; }
 .readout { font-size:13px; opacity:.8; }
 pre { background:#fffdf8; border:1px solid var(--line); padding:10px; overflow:auto;
       font-size:12px; line-height:1.25; border-radius:4px; }
 table { border-collapse:collapse; font-size:13px; margin:6px 0 14px; }
 td,th { border:1px solid var(--line); padding:3px 9px; text-align:left; }
 .cols { display:flex; gap:24px; flex-wrap:wrap; }
 .body { fill:#fff; stroke:#8a7f6b; }
 .slot { stroke:#8a7f6b; }
 .slot.empty { fill:#efe9dc; }
 .slot.filled { fill:var(--clay); }
 .crate { fill:#fdf6e6; stroke:#8a7f6b; }
 .tablet { fill:#e8dcc2; stroke:#8a7f6b; }
 text { font-family:inherit; fill:var(--ink); }
 .caption { font-size:15px; }
 .label { font-size:12px; }
 .small { font-size:11px; }
 .count { font-size:12px; font-weight:bold; }
 .pipe .slot.filled { fill:var(--pipe); }
 .note { font-size:13px; line-height:1.5; }
 code { background:#efe9dc; padding:1px 4px; border-radius:2px; }
</style></head><body>
<header>
 <h1>The replicator</h1>
 <div class='sub'>fabricate the parts &middot; open the boxes &middot; assemble the copy &middot;
   let the copy print the deck it was built from</div>
</header><main>
<div class='tabs' id='tabs'></div>
<div class='controls'>
 <button id='play'>&#9654; play</button>
 <button id='back'>&#9664; step</button>
 <button id='fwd'>step &#9654;</button>
 <input type='range' id='scrub' min='0' value='0'>
 <span class='readout' id='readout'></span>
</div>
<div class='stage' id='stage'></div>
<div class='controls'>
 <label><input type='checkbox' id='ascii'> show the same frame as ASCII</label>
</div>
<pre id='asciiOut' style='display:none'></pre>
<div class='cols'>
 <div><h3>Boxes of parts</h3><div id='boxes'></div></div>
 <div><h3>The deck</h3><div id='cards'></div></div>
 <div><h3>Checks</h3><div id='checks'></div></div>
</div>
<h3>What the pictures are</h3>
<div class='note'>
Every frame on this page is a value computed by the Lean development in
<code>RequestProject/ReplicatorRender.lean</code> and printed into this file; the page
only steps through the list. What is proved there, about the frames themselves:
<ul>
<li><b>one cycle, one part</b> — between consecutive fabrication frames exactly one part
appears, the next one in the fabrication order (<code>film_fab_step</code>);</li>
<li><b>assembly conserves parts</b> — in every assembly frame, what is still in the boxes
plus what is already installed is exactly the bill of materials
(<code>film_asm_conserves</code>);</li>
<li><b>the elevation is honest</b> — at assembly frame <i>j</i> the copy shows exactly the
<i>j</i> parts that frame says are installed (<code>film_asm_slots</code>), and the crates
drawn hold exactly the parts on the floor (<code>boxStrip_faithful</code>);</li>
<li><b>the copy is complete</b> — nothing is left over when the last part goes in
(<code>film_asm_complete</code>), and the last frame has two machines standing with the whole
deck printed (<code>film_last</code>);</li>
<li><b>the loop closes</b> — the deck the copy prints is the deck that built it, for every
generation (<code>generation_eq</code>), so every copy calls for the same boxes
(<code>deckBOM_generation</code>).</li>
</ul>
The drawing itself is SVG text: nothing about a browser's rendering is verified, only the
frame data that the text is built from.
</div>
<script>
"

def tail : String := "
const tabs = document.getElementById('tabs');
const stage = document.getElementById('stage');
const scrub = document.getElementById('scrub');
const readout = document.getElementById('readout');
const asciiBox = document.getElementById('ascii');
const asciiOut = document.getElementById('asciiOut');
let cur = 0, frame = 0, timer = null;

function esc(s){ return s.replace(/&/g,'&amp;').replace(/</g,'&lt;'); }

function drawTabs(){
  tabs.innerHTML = '';
  DATA.forEach((m,i) => {
    const b = document.createElement('button');
    b.textContent = m.title;
    if (i === cur) b.className = 'on';
    b.onclick = () => { cur = i; frame = 0; stop(); render(); };
    tabs.appendChild(b);
  });
}

function render(){
  const m = DATA[cur];
  scrub.max = m.frameCount - 1;
  scrub.value = frame;
  const cls = m.key.startsWith('pipe') ? 'pipe' : 'clay';
  stage.innerHTML = \"<svg class='\" + cls + \"' viewBox='0 0 660 330'>\" + m.svg[frame] + '</svg>';
  readout.textContent = 'frame ' + (frame+1) + ' / ' + m.frameCount +
    '  ·  ' + m.cycles + ' fabrication cycles  ·  ' +
    m.boxes.reduce((a,b) => a + b.count, 0) + ' parts';
  asciiOut.style.display = asciiBox.checked ? 'block' : 'none';
  asciiOut.textContent = m.ascii[frame];
  document.getElementById('boxes').innerHTML =
    '<table><tr><th>part</th><th>count</th><th>glyph</th></tr>' +
    m.boxes.map(b => '<tr><td>' + esc(b.part) + '</td><td>' + b.count + '</td><td>' +
      esc(b.glyph) + '</td></tr>').join('') + '</table>';
  document.getElementById('cards').innerHTML =
    '<table><tr><th>machine</th><th>tier</th><th>press</th><th>needs</th></tr>' +
    m.cards.map(c => '<tr><td>' + esc(c.name) + '</td><td>' + c.tier + '</td><td>' +
      (c.press ? 'yes' : '—') + '</td><td>' + esc(c.needs.join(', ') || '—') +
      '</td></tr>').join('') + '</table>';
  document.getElementById('checks').innerHTML =
    '<table>' +
    '<tr><td>judge accepts the deck</td><td>' + (m.accepted ? 'true' : 'false') + '</td></tr>' +
    '<tr><td>press prints the deck</td><td>' + (m.emitsDeck ? 'true' : 'false') + '</td></tr>' +
    '<tr><td>parts left over</td><td>' + m.leftover + '</td></tr>' +
    '<tr><td>frames</td><td>' + m.frameCount + '</td></tr>' +
    '</table>';
  drawTabs();
}

function stop(){ if (timer) { clearInterval(timer); timer = null; }
  document.getElementById('play').innerHTML = '&#9654; play'; }

document.getElementById('play').onclick = () => {
  if (timer) { stop(); return; }
  document.getElementById('play').innerHTML = '&#10073;&#10073; pause';
  timer = setInterval(() => {
    frame = (frame + 1) % DATA[cur].frameCount;
    render();
  }, 260);
};
document.getElementById('fwd').onclick = () => {
  stop(); frame = Math.min(frame + 1, DATA[cur].frameCount - 1); render(); };
document.getElementById('back').onclick = () => {
  stop(); frame = Math.max(frame - 1, 0); render(); };
scrub.oninput = () => { stop(); frame = Number(scrub.value); render(); };
asciiBox.onchange = render;
render();
</script></main></body></html>
"

def main : IO Unit := do
  let page := head ++ "const DATA = " ++ dataJson ++ ";\n" ++ tail
  IO.FS.writeFile "replicator.html" page
  IO.println s!"wrote replicator.html ({page.length} characters)"
  IO.println s!"films: {(film monogram).length}, {(film workshop).length}, \
{(film pipeMonogram).length}, {(film pipeWorks).length} frames"
