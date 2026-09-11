import RequestProject.Nix.NixWars.BlackHole
import RequestProject.Nix.NixWars.Gl

/-!
# The gravity-well cabinet: `www/blackhole.html`

The experiment of `RequestProject/NixWars/BlackHole.lean`, standing on the
arcade floor as a page. Seven cabinets carry the *same* cartridge — a walker
going once round the ring of 71 shards — and differ only in how deep in the
well of the hole at the centre they are hung. The radii, the periods and the
room frame in the page are the numbers Lean computed (`depths`,
`sunkPeriods`, `frame`); nothing about the schedule is written by hand.

The page also measures the visitor: a reaction test in ticks of the room
clock, read against `Masters`, which tells them which of the seven cabinets
they are expert at. Slow hands are expert deep in the well; fast hands are
expert out in flat space. That is why the floor needs the whole spread.
-/

namespace NixWars

namespace BlackHole

/-- The cabinet roster as JSON: radius, period, and the depth below the flat
rate, straight out of the Lean model. -/
def cabsJson : String :=
  let rows := depths.map (fun r =>
    "{\"r\":" ++ toString r ++ ",\"p\":" ++ toString (sgrA.period 1 r) ++ "}")
  "[" ++ String.intercalate "," rows ++ "]"

/-- The room frame, as the page needs it. -/
def frameLit : String := toString (frame sunkPeriods)

/-- The horizon radius, as the page needs it. -/
def horizonLit : String := toString sgrA.rs

/-- The page. -/
def blackHolePage : String :=
  r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>THE GRAVITY WELL — NixWars</title>
<style>
html, body { margin: 0; background: #050a06; color: #bfffd0;
  font-family: ui-monospace, Menlo, Consolas, monospace; }
h1 { margin: 0; font-size: 18px; letter-spacing: 0.4em; color: #8fffa5; }
header { padding: 18px 22px; border-bottom: 1px solid #16351d; }
header p { margin: 8px 0 0; font-size: 12px; color: #5f9c6f; max-width: 78ch;
  line-height: 1.5; }
a { color: #8fffa5; }
main { padding: 18px 22px 32px; }
#bar { font-size: 11.5px; letter-spacing: 0.14em; color: #5f9c6f;
  margin-bottom: 12px; }
#bar b { color: #d7ffe2; font-weight: normal; }
.cab { border: 1px solid #1e5c2c; border-radius: 6px; margin-bottom: 10px;
  background: linear-gradient(180deg, #0a1a0e 0%, #071008 100%); padding: 9px 11px; }
.cab .hd { font-size: 11.5px; letter-spacing: 0.14em; color: #d7ffe2; }
.cab .hd span { color: #6fbc82; }
.cab .scr { font-size: 12px; color: #8fffa5; background: #020602;
  border: 1px solid #143a1c; margin-top: 6px; padding: 5px 6px;
  white-space: pre; overflow-x: auto; }
.deep { color: #ffd27f; }
button { background: #0d2a14; color: #8fffa5; border: 1px solid #2aa843;
  font: inherit; letter-spacing: 0.18em; padding: 6px 16px; cursor: pointer; }
button:hover { background: #14401f; }
#test { margin-top: 18px; border-top: 1px solid #16351d; padding-top: 14px; }
#lamp { display: inline-block; min-width: 12ch; text-align: center;
  border: 1px solid #143a1c; padding: 6px 10px; margin-left: 10px;
  background: #020602; color: #4f8a5e; letter-spacing: 0.2em; }
#lamp.now { background: #2aa843; color: #041006; }
#verdict { font-size: 12px; color: #6fbc82; margin-top: 10px; line-height: 1.6; }
footer { padding: 4px 22px 30px; font-size: 11px; color: #4f8a5e;
  line-height: 1.6; }
@media (max-width: 700px) {
  header, main, footer { padding-left: 12px; padding-right: 12px; }
  h1 { font-size: 15px; letter-spacing: 0.22em; }
}
"## ++ Gl.responsiveCss ++ r##"</style>
</head>
<body>
<header>
<h1>THE GRAVITY WELL</h1>
<p>Door 1's scanner reports <em>Sgr A*</em> at the centre of the ring of 71
shards. This is the experiment behind that line. Seven cabinets run the same
cartridge — one walker, once round the ring — and differ only in how far they
hang above the horizon. Deeper is slower: a step that costs one tick of the
room clock out in flat space costs <em>r/(r&minus;r<sub>s</sub>)</em> ticks at
radius <em>r</em>. Nothing on the screens is a different game; the trace is
the same trace, reached at different times. The radii, periods and the room
frame below were computed in Lean, and the claims made about them are
theorems there.</p>
</header>
<main>
<div id="bar"></div>
<div id="floor"></div>

<div id="test">
<button id="go">REACTION TEST</button><span id="lamp">WAIT</span>
<div id="verdict">Press the button, then press it again the moment the lamp
turns. Your reaction, in ticks of the room clock, decides which of the seven
cabinets you can hold: you are expert at a cabinet whose step is at least as
long as your reaction.</div>
</div>
</main>
<footer>
Model and proofs: <span style="color:#6fbc82">RequestProject/NixWars/BlackHole.lean</span>.
The experiment run and recorded: <a href="well-video.html">THE FILM</a>.
Back to <a href="arcade.html">THE ARCADE ROOM</a>.
</footer>
<script>
const CABS = "##
  ++ cabsJson ++ r##";
const FRAME = "## ++ frameLit ++ r##";
const RS = "## ++ horizonLit ++ r##";
const RING = 71;              // the shard ring the walker goes round
const MS = 25;                // milliseconds to one tick of the room clock

// the cartridge: one walker, one shard forward per step of its own clock
function stateAfter(n) { return n % RING; }
// how many steps a cabinet of period p has taken by tick t (0 = frozen)
function stepsOf(p, t) { return p === 0 ? 0 : Math.floor(t / p); }

let t = 0;
const floor = document.getElementById('floor');
for (const c of CABS) {
  const d = document.createElement('div');
  d.className = 'cab';
  d.innerHTML = '<div class="hd">r = ' + c.r + ' <span>(' + (c.r - RS) +
    ' above the horizon)</span> &middot; period ' + c.p +
    ' tick' + (c.p === 1 ? '' : 's') + ' per step</div>' +
    '<div class="scr" id="scr' + c.r + '"></div>';
  floor.appendChild(d);
}

function draw() {
  const bar = document.getElementById('bar');
  bar.innerHTML = 'room clock <b>' + t + '</b> &middot; frame <b>' + FRAME +
    '</b> &middot; ' + (t % FRAME === 0
      ? '<span class="deep">FRAME BOUNDARY: every cabinet on a step</span>'
      : (FRAME - (t % FRAME)) + ' ticks to the boundary');
  for (const c of CABS) {
    const n = stepsOf(c.p, t), at = stateAfter(n);
    let row = '';
    for (let i = 0; i < RING; i++) row += (i === at ? '#' : '.');
    document.getElementById('scr' + c.r).textContent =
      row + '  step ' + n + ' @ shard ' + at;
  }
}
draw();
setInterval(() => { t++; draw(); }, MS);

// --- the reaction test ---
const go = document.getElementById('go'), lamp = document.getElementById('lamp');
let armed = false, lit = 0, timer = null;
go.addEventListener('click', () => {
  if (armed) {                                   // second press: read it off
    if (lit === 0) { lamp.textContent = 'TOO SOON'; armed = false; return; }
    const ticks = Math.max(1, Math.round((performance.now() - lit) / MS));
    lamp.className = ''; lamp.textContent = ticks + ' TICKS';
    const can = CABS.filter(c => c.p >= ticks), no = CABS.filter(c => c.p < ticks);
    document.getElementById('verdict').innerHTML =
      'Reaction ' + ticks + ' ticks. Expert at ' +
      (can.length ? can.map(c => 'r=' + c.r + ' (period ' + c.p + ')').join(', ')
                  : 'nothing on this floor — sink a cabinet deeper') +
      '. Too fast for you: ' +
      (no.length ? no.map(c => 'r=' + c.r + ' (period ' + c.p + ')').join(', ')
                 : 'nothing — you hold the whole floor') + '.';
    armed = false; lit = 0;
    return;
  }
  armed = true; lit = 0;
  lamp.className = ''; lamp.textContent = 'WAIT';
  if (timer) clearTimeout(timer);
  timer = setTimeout(() => {
    if (!armed) return;
    lamp.className = 'now'; lamp.textContent = 'NOW';
    lit = performance.now();
  }, 900 + Math.floor(Math.random() * 2200));
});
</script>
</body>
</html>
"##

/-- Write the gravity-well page. -/
def writeBlackHolePage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/blackhole.html" blackHolePage

#eval writeBlackHolePage

end BlackHole

end NixWars
