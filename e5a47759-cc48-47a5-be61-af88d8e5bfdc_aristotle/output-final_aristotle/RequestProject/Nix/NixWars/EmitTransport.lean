import RequestProject.Nix.NixWars.ControlsJs
import RequestProject.Nix.NixWars.KeymapJs

/-!
# The demo: transporting the arcade games across the galaxy

`www/transport.html` is the recording of the freight run of
`RequestProject.NixWars.Freight`: the whole arcade -- twenty-two cabinets --
carried from Sol across twenty-nine thousand light-years and installed, one to a
shard, on twenty-two different shards of the DMZ.

The page holds no rules. Every frame it shows is a frame of `convoyTape`, the
tape Lean recorded while the freighter's autopilot flew `convoyTour`, and the
tape is proved faithful to the game (`convoyTape_getLast`). The page's job is
to draw it and to let a thumb walk it: the same swipe, mouse and joystick
classifier as the board, and the same autopilot button.

`www/demo/transport-tape.json` is the same tape as data, for the recorder in
`video/make_transport_demo.py`.
-/

namespace NixWars
namespace Transport

open Controls

/-! ## The data -/

/-- A string as a JSON string literal (the marquees are plain ASCII). -/
def jsonStr (s : String) : String :=
  "\"" ++ String.join (s.toList.map (fun c =>
    if c == '"' then "\\\"" else if c == '\\' then "\\\\" else String.singleton c)) ++ "\""

/-- A list of natural numbers as JSON. -/
def natsJson (l : List Nat) : String :=
  "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- The manifest, by marquee: what is actually in the hold. -/
def cargoJson : String :=
  "[" ++ String.intercalate "," (arcadeFloor.map (fun c => jsonStr c.marquee)) ++ "]"

/-- The pages the cabinets are installed as, so a stop can be walked into. -/
def cargoHrefJson : String :=
  "[" ++ String.intercalate "," (arcadeFloor.map (fun c => jsonStr c.href)) ++ "]"

/-- One frame of the tape: the freighter's payload, exactly as it goes on the
wire (`convoySerialize`). -/
def frameJson (s : Convoy) : String := natsJson (convoySerialize s)

/-- The whole recorded run. -/
def tapeJson : String :=
  "[" ++ String.intercalate "," (convoyTape.map frameJson) ++ "]"

/-- The plan the autopilot flew, command by command. -/
def planJson : String := Controls.planJson convoyWire convoyTour

/-- Everything the demo page needs. -/
def transportJson : String :=
  "{\"cargo\":" ++ cargoJson ++
  ",\"hrefs\":" ++ cargoHrefJson ++
  ",\"stops\":" ++ natsJson convoyStops ++
  ",\"leg\":" ++ toString convoyLeg ++
  ",\"total\":" ++ toString (20 * convoyLeg) ++
  ",\"sgra\":" ++ toString sgrADistance ++
  ",\"fuel0\":" ++ toString initialConvoy.fuel ++
  ",\"plan\":" ++ planJson ++
  ",\"tape\":" ++ tapeJson ++ "}"

/-! ## The data for the recorder

The recorded demo has two reels: the controls driving a cabinet, and the
freight run. Both are Lean tapes. -/

/-- The pyramid, frame by frame, under its autopilot. -/
def qbertTapeJson : String :=
  "[" ++ String.intercalate ","
    ((Controls.pilotTape monsterCubes Controls.qbertAuto initialQbert 11).map
      (fun s => natsJson (qbertSerialize s))) ++ "]"

/-- The swipe that issues each hop of that plan, and the hop it issues. -/
def qbertPlanJson : String :=
  "[" ++ String.intercalate ","
    (Controls.qbertAutoPlan.map (fun c =>
      "[" ++ jsonStr (Controls.dirName (Controls.dirOfQbertCmd c)) ++ "," ++
        jsonStr (Controls.qbertWire c).1 ++ "]")) ++ "]"

/-- The ship under its autopilot, sampled every tenth jump. -/
def shipTapeJson : String :=
  "[" ++ String.intercalate ","
    (((List.range 28).map (fun k =>
      Controls.autoRun nixWars Controls.shipAuto initialShip (10 * k))).map
        (fun s => natsJson (shipSerialize s))) ++ "]"

/-- Everything the recorder needs for the controls reel. -/
def controlsDemoJson : String :=
  "{\"dead\":" ++ toString Controls.deadZone ++
  ",\"gate\":" ++ toString Controls.gateRadius ++
  ",\"gestures\":" ++ Controls.gestureVectorsJson ++
  ",\"qbertTape\":" ++ qbertTapeJson ++
  ",\"qbertPlan\":" ++ qbertPlanJson ++
  ",\"shipTape\":" ++ shipTapeJson ++ "}"

/-! ## The page -/

def head : String := r#"<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>THE FREIGHT RUN :: ARCADE GAMES ACROSS THE GALAXY</title>
<style>
:root { color-scheme: dark; }
body { background:#0b0f0b; color:#3cff5a; font-family:ui-monospace,Menlo,Consolas,monospace;
       margin:0; padding:1rem; font-size:14px; }
h1 { font-size:1.1rem; letter-spacing:.2em; border-bottom:1px solid #1d4d24; padding-bottom:.4rem; }
h2 { font-size:.8rem; letter-spacing:.18em; color:#8fffa5; margin:1.2rem 0 .3rem; }
pre { background:#060806; border:1px solid #1d4d24; padding:.6rem; overflow-x:auto;
      white-space:pre-wrap; margin:0; }
button { background:#0b190d; color:#3cff5a; border:1px solid #2f7a3a; padding:.35rem .7rem;
         font-family:inherit; cursor:pointer; margin:.15rem .2rem .15rem 0; }
button:hover { background:#14361a; }
.small { color:#2aa843; font-size:.75rem; }
.grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(320px,1fr)); gap:1rem; }
#map { border:1px solid #1d4d24; background:#040704; touch-action:none; max-width:100%; }
"#

def head2 : String := r#"</style>
</head>
<body>
<h1>THE FREIGHT RUN &mdash; ARCADE GAMES ACROSS THE GALAXY</h1>
<p class="small">Twenty-two cabinets leave Sol in the hold of one freighter and
are installed, one to a shard, on twenty-two shards of the 71-shard DMZ. Every
frame below is a frame of the tape Lean recorded while the freighter's
autopilot flew the run: the manifest is conserved (nothing is lost, duplicated
or conjured), a cabinet is only ever unloaded at a stop, and the run ends with
an empty hold and fourteen units of fuel left. Walk the tape with a swipe, a
drag, the knob or the D-pad &mdash; or press AUTOPILOT and watch it fly.</p>
<script>
"#

def script : String := r##"
// ---- the recorded run ----
// TAPE[i] is convoySerialize of frame i of NixWars.convoyTape:
//   [dist, fuel, turn, holdCount, ...hold, ...installed]
let at = 0;
const TAPE = T.tape, PLAN = T.plan;
function frame(i) {
  const f = TAPE[Math.max(0, Math.min(TAPE.length - 1, i))];
  const n = f[3];
  return { dist: f[0], fuel: f[1], turn: f[2],
           hold: f.slice(4, 4 + n), landed: f.slice(4 + n) };
}
function bar(done, total, width) {
  const k = total === 0 ? width : Math.round(width * done / total);
  return "[" + "=".repeat(k) + ">" + ".".repeat(Math.max(0, width - k)) + "]";
}
function drawMap() {
  const c = document.getElementById("map");
  if (!c || !c.getContext) return;
  const g = c.getContext("2d"), w = c.width, h = c.height;
  const f = frame(at), done = f.landed.length;
  g.fillStyle = "#040704"; g.fillRect(0, 0, w, h);
  const cw = Math.floor(w / T.stops.length);
  for (let i = 0; i < T.stops.length; i++) {
    const x = i * cw + Math.floor(cw / 2), y = Math.floor(h / 2);
    const installed = i < done;
    g.fillStyle = installed ? "#8fffa5" : "#1d4d24";
    g.fillRect(x - 3, y - 3, 7, 7);
    g.fillStyle = installed ? "#2aa843" : "#12331a";
    g.font = "9px monospace";
    g.fillText(String(T.stops[i]), x - 6, y + 18);
  }
  // the freighter, between the last stop made and the next
  const px = Math.min(w - 6, done * cw + Math.floor(cw / 2) +
    Math.round(cw * (T.leg - f.dist) / T.leg));
  g.fillStyle = "#ffd34d";
  g.fillRect(px - 4, Math.floor(h / 2) - 10, 9, 4);
}
function render() {
  const f = frame(at), done = f.landed.length;
  const flown = done * T.leg + (T.leg - f.dist);
  const lines = [];
  lines.push("FRAME " + at + " / " + (TAPE.length - 1) +
             "   TURN " + f.turn + "   FUEL " + f.fuel + " / " + T.fuel0);
  lines.push("STOP  " + Math.min(done + 1, T.stops.length) + " / " + T.stops.length +
             "   SHARD " + T.stops[Math.min(done, T.stops.length - 1)] +
             "   NEXT STOP IN " + f.dist + " LY");
  lines.push("");
  lines.push("SOL " + bar(flown, T.total, 30) + " SGR A*   " + flown + " / " + T.total + " LY");
  lines.push("");
  lines.push("HOLD (" + f.hold.length + ")      " +
             (f.hold.map(i => T.cargo[i]).join(", ") || "-- empty --"));
  lines.push("INSTALLED (" + done + ") " +
             (f.landed.map(i => T.cargo[i]).slice().reverse().join(", ") || "-- none yet --"));
  lines.push("");
  lines.push("MANIFEST    " + (f.hold.length + done) + " cabinets, always" +
             (f.hold.length + done === T.cargo.length ? "  (conserved)" : "  (LOST ONE!)"));
  const cmd = at === 0 ? "--" : (PLAN[at - 1][0] + " " + PLAN[at - 1][1]);
  lines.push("LAST COMMAND " + cmd);
  document.getElementById("term").textContent = lines.join("\n");
  const cab = document.getElementById("cabinet");
  if (cab) {
    const i = done === 0 ? f.hold[0] : f.landed[0];
    cab.innerHTML = done === 0
      ? "NEXT OUT OF THE HOLD: " + T.cargo[i]
      : "JUST INSTALLED ON SHARD " + T.stops[done - 1] + ": <a style=\"color:#8fffa5\" href=\"" +
        T.hrefs[i] + "\">" + T.cargo[i] + "</a>";
  }
  drawMap();
}
function goTo(i) { at = Math.max(0, Math.min(TAPE.length - 1, i)); render(); }
function stepBy(d) { goTo(at + d); }

// ---- the controls: the classifier emitted from NixWars.Controls ----
function ctrlOctant(dx, dy) {
  const a = Math.abs(dx), b = Math.abs(dy);
  if (2 * b <= a) return dx > 0 ? "e" : "w";
  if (2 * a <= b) return dy < 0 ? "n" : "s";
  if (dx > 0) return dy < 0 ? "ne" : "se";
  return dy < 0 ? "nw" : "sw";
}
function ctrlGesture(dx, dy) {
  return (dx * dx + dy * dy <= CTRL.dead * CTRL.dead) ? null : ctrlOctant(dx, dy);
}
function ctrlKnob(t) { return Math.max(-CTRL.gate, Math.min(CTRL.gate, t)); }
// east walks the tape forward, west back, north jumps to the next stop, south
// to the previous one.
function steer(dir) {
  if (dir === "e" || dir === "ne" || dir === "se") stepBy(1);
  else if (dir === "w" || dir === "nw" || dir === "sw") stepBy(-1);
  else if (dir === "n") stepBy(2);
  else if (dir === "s") stepBy(-2);
}
let dragFrom = null;
function ctrlPoint(e) {
  const t = (e.touches && e.touches[0]) || (e.changedTouches && e.changedTouches[0]) || e;
  return { x: t.clientX || 0, y: t.clientY || 0 };
}
function ctrlDown(e) { dragFrom = ctrlPoint(e); }
function ctrlUp(e) {
  if (!dragFrom) return;
  const p = ctrlPoint(e), dir = ctrlGesture(p.x - dragFrom.x, p.y - dragFrom.y);
  dragFrom = null;
  if (dir) { if (e.preventDefault) e.preventDefault(); steer(dir); }
}
function ctrlBind(el) {
  if (!el || !el.addEventListener) return;
  el.addEventListener("touchstart", ctrlDown, { passive: true });
  el.addEventListener("touchend", ctrlUp, { passive: false });
  el.addEventListener("mousedown", ctrlDown);
  el.addEventListener("mouseup", ctrlUp);
}
// ---- mouse navigation: click a stop on the map (NixWars.Controls.cellIndex) ----
function cellIndex(cols, w, h, x, y) {
  return Math.floor(y / h) * cols + Math.floor(x / w);
}
function mapClick(e) {
  const c = document.getElementById("map");
  if (!c || !c.getBoundingClientRect) return;
  const r = c.getBoundingClientRect();
  const x = Math.round((e.clientX - r.left) * c.width / r.width);
  const cw = Math.floor(c.width / T.stops.length);
  const i = Math.min(T.stops.length - 1, cellIndex(T.stops.length, cw, c.height, x, 0));
  goTo(2 * (i + 1));            // two commands a stop: warp, then drop
}
// ---- the joystick ----
let stickHeld = null, stickTimer = null;
function stickCentre() {
  const gate = document.getElementById("stickgate");
  if (!gate || !gate.getBoundingClientRect) return { x: 0, y: 0 };
  const r = gate.getBoundingClientRect();
  return { x: r.left + r.width / 2, y: r.top + r.height / 2 };
}
function stickDraw(dx, dy) {
  const k = document.getElementById("stickknob");
  if (k) k.style.transform = "translate(" + ctrlKnob(dx) + "px," + ctrlKnob(dy) + "px)";
}
function stickMove(e) {
  const c = stickCentre(), p = ctrlPoint(e);
  const dx = p.x - c.x, dy = p.y - c.y;
  stickDraw(dx, dy);
  stickHeld = ctrlGesture(dx, dy);
  const label = document.getElementById("stickdir");
  if (label) label.textContent = stickHeld ? stickHeld.toUpperCase() : "--";
}
function stickStart(e) {
  if (e.preventDefault) e.preventDefault();
  stickMove(e);
  if (stickHeld) steer(stickHeld);
  if (stickTimer === null && typeof setInterval === "function")
    stickTimer = setInterval(() => { if (stickHeld) steer(stickHeld); }, 200);
}
function stickEnd() {
  stickHeld = null;
  stickDraw(0, 0);
  const label = document.getElementById("stickdir");
  if (label) label.textContent = "--";
  if (stickTimer !== null) { clearInterval(stickTimer); stickTimer = null; }
}
// ---- autopilot: play the recorded run ----
let autoTimer = null;
function autoStop() {
  if (autoTimer !== null) { clearInterval(autoTimer); autoTimer = null; }
  const b = document.getElementById("autobtn");
  if (b) b.textContent = "AUTOPILOT";
}
function autoStart() {
  goTo(0);
  const b = document.getElementById("autobtn");
  if (b) b.textContent = "DISENGAGE";
  if (typeof setInterval !== "function") return;
  autoTimer = setInterval(() => {
    if (at >= TAPE.length - 1) { autoStop(); return; }
    stepBy(1);
  }, 260);
}
function autoToggle() { if (autoTimer === null) autoStart(); else autoStop(); }
// the tape, checked here the way Lean states it
function demoSelfTest() {
  const out = [];
  const last = frame(TAPE.length - 1);
  out.push(["the hold is empty at the end", last.hold.length === 0]);
  out.push(["every cabinet was installed", last.landed.length === T.cargo.length]);
  out.push(["no cabinet was installed twice",
            new Set(last.landed).size === last.landed.length]);
  out.push(["the manifest is conserved",
            TAPE.every(f => f[3] + (f.length - 4 - f[3]) === T.cargo.length)]);
  out.push(["a cabinet only leaves the hold at a stop",
            TAPE.every((f, i) => i === 0 || f[3] === TAPE[i - 1][3] || TAPE[i - 1][0] === 0)]);
  out.push(["fuel is never conjured",
            TAPE.every((f, i) => i === 0 || f[1] <= TAPE[i - 1][1])]);
  out.push(["the run ends with fuel to spare", last.fuel === 14]);
  return out;
}
function init() {
  ctrlBind(document.getElementById("term"));
  const map = document.getElementById("map");
  if (map && map.addEventListener) map.addEventListener("click", mapClick);
  const gate = document.getElementById("stickgate");
  if (gate && gate.addEventListener) {
    gate.addEventListener("touchstart", stickStart, { passive: false });
    gate.addEventListener("touchmove", stickMove, { passive: false });
    gate.addEventListener("touchend", stickEnd);
    gate.addEventListener("mousedown", stickStart);
    gate.addEventListener("mousemove", (e) => { if (stickHeld !== null) stickMove(e); });
    gate.addEventListener("mouseup", stickEnd);
    gate.addEventListener("mouseleave", stickEnd);
  }
  if (typeof window !== "undefined" && window.addEventListener)
    window.addEventListener("keydown", (e) => {
      const k = (e.key || "").toLowerCase();
      if (k === "arrowright" || k === "d") { e.preventDefault(); stepBy(1); }
      else if (k === "arrowleft" || k === "a") { e.preventDefault(); stepBy(-1); }
      else if (k === " ") { e.preventDefault(); autoToggle(); }
    });
  const pre = document.getElementById("selftest");
  if (pre) pre.textContent = demoSelfTest()
    .map(([name, ok]) => (ok ? "ok   " : "FAIL ") + name).join("\n");
  render();
}
"##

def body : String := r#"</script>

<h2>THE RUN</h2>
<pre id="term"></pre>
<div id="cabinet" class="small" style="margin:.5rem 0"></div>

<h2>THE ROUTE &mdash; click a stop</h2>
<canvas id="map" width="720" height="90"></canvas>

<div>
  <button onclick="stepBy(-1)">&laquo; BACK</button>
  <button onclick="stepBy(1)">FORWARD &raquo;</button>
  <button onclick="goTo(0)">REWIND</button>
  <button onclick="goTo(1000)">END</button>
</div>
"#

/-- The joystick, the D-pad and the autopilot switch for the demo. -/
def pad : String := r#"
<h2>CONTROLS</h2>
<div class="ctrlrow">
  <div id="stickgate" class="gate" title="push the knob; or swipe the tape">
    <div id="stickknob" class="knob"></div>
  </div>
  <div class="pad">
    <div>
      <button onclick="steer('nw')">&#8598;</button>
      <button onclick="steer('n')">&#8593;</button>
      <button onclick="steer('ne')">&#8599;</button>
    </div>
    <div>
      <button onclick="steer('w')">&#8592;</button>
      <button id="stickdir" class="dirlabel">--</button>
      <button onclick="steer('e')">&#8594;</button>
    </div>
    <div>
      <button onclick="steer('sw')">&#8601;</button>
      <button onclick="steer('s')">&#8595;</button>
      <button onclick="steer('se')">&#8600;</button>
    </div>
  </div>
  <div class="pad">
    <div><button id="autobtn" onclick="autoToggle()">AUTOPILOT</button></div>
    <div class="small">East walks the tape on, west walks it back, north and
    south jump a stop; a click on the route goes straight there. Swipe, drag
    and knob all go through the one classifier proved in Lean, and AUTOPILOT
    plays the run the freighter's own autopilot flew.</div>
  </div>
</div>
"#

def tail : String := r#"
<h2>THE RECORDING</h2>
<p class="small">The same two tapes, cut into a reel by
<code>video/make_transport_demo.py</code> and checked back through their file
formats by <code>video/verify_transport_demo.py</code>. Nothing in the
recorder knows any rules either: every frame is drawn from the Lean tape.</p>
<div class="grid">
  <div><img src="demo/demo-controls.gif" alt="the controls, and the pyramid
    cleared by its autopilot" style="width:100%;image-rendering:pixelated;
    border:1px solid #1d4d24"></div>
  <div><img src="demo/demo-freight.gif" alt="the freight run, stop by stop"
    style="width:100%;image-rendering:pixelated;border:1px solid #1d4d24"></div>
  <div><img src="demo/demo-ship.gif" alt="the ship's autopilot reaching Sgr A*"
    style="width:100%;image-rendering:pixelated;border:1px solid #1d4d24"></div>
</div>
<p class="small">The whole demo in one file:
<a href="demo/demo-full.gif" style="color:#8fffa5">demo-full.gif</a>; stills:
<a href="demo/demo-title.png" style="color:#8fffa5">title</a>,
<a href="demo/demo-controls.png" style="color:#8fffa5">controls</a>,
<a href="demo/demo-freight.png" style="color:#8fffa5">the run</a>,
<a href="demo/demo-arrival.png" style="color:#8fffa5">delivered</a>.</p>

<h2>THE TAPE, CHECKED</h2>
<pre id="selftest"></pre>
<p class="small">These are the properties proved in
RequestProject/NixWars/Freight.lean &mdash; conservation of the manifest
(<code>convoy_manifest_perm</code>), no duplication
(<code>convoy_manifest_nodup</code>), unloading only at a stop
(<code>convoy_drop_needs_arrival</code>), fuel never conjured
(<code>convoy_fuel_le</code>) and the delivery of the whole arcade
(<code>convoyTour_delivers</code>) &mdash; re-checked here against the recorded
tape. The controls are the ones proved in
RequestProject/NixWars/Controls.lean. Back to
<a href="arcade.html" style="color:#8fffa5">THE ARCADE ROOM</a> or
<a href="nixwars.html" style="color:#8fffa5">THE BOARD</a>.</p>

<script>init();</script>
</body>
</html>
"#

/-- The demo page. -/
def page : String :=
  head ++ Controls.controlsCss ++ Keys.mobileCss ++ head2 ++
  "const T = " ++ transportJson ++ ";\n" ++
  "const CTRL = {dead:" ++ toString Controls.deadZone ++ ",gate:" ++
    toString Controls.gateRadius ++ "};\n" ++
  script ++ body ++ pad ++ tail

/-- Write the demo page and the tape as data for the recorder. -/
def writeTransport : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.createDirAll "www/demo"
  IO.FS.writeFile "www/transport.html" page
  IO.FS.writeFile "www/demo/transport-tape.json" transportJson
  IO.FS.writeFile "www/demo/controls-tape.json" controlsDemoJson

#eval writeTransport

end Transport
end NixWars
