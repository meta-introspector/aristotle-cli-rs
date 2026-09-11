import RequestProject.Nix.NixWars.Freight

/-!
# Emitting the control layer

The classifier, the direction tables and the autopilot plans of
`RequestProject.NixWars.Controls` are printed here as JSON and as the small
script that drives them in the page. As everywhere else in this project the
page carries no hand-written game rules: the direction tables are printed from
the Lean tables, and the autopilot replays a plan that Lean computed from a
proved policy, command by command, through the same WebAssembly module the
buttons use.

`gestureVectors` are golden values: displacements classified here, in Lean, for
the headless harness to check the page's classifier against.
-/

namespace NixWars
namespace Controls

/-! ## Printing the tables -/

/-- The name of a direction, as the page spells it. -/
def dirName : Dir → String
  | .n => "n" | .ne => "ne" | .e => "e" | .se => "se"
  | .s => "s" | .sw => "sw" | .w => "w" | .nw => "nw"

/-- A command as the page sends it: a tag and an argument. -/
abbrev Wire := String × Nat

/-- One command as JSON. -/
def wireJson (c : Wire) : String := "[\"" ++ c.1 ++ "\"," ++ toString c.2 ++ "]"

/-- A direction table as JSON. -/
def dirTableJson (f : Dir → Wire) : String :=
  "{" ++ String.intercalate ","
    (allDirs.map (fun d => "\"" ++ dirName d ++ "\":" ++ wireJson (f d))) ++ "}"

/-- A plan as JSON. -/
def planJson {α : Type} (f : α → Wire) (p : List α) : String :=
  "[" ++ String.intercalate "," (p.map (fun c => wireJson (f c))) ++ "]"

/-- Monster Cubes commands on the wire. -/
def qbertWire : QbertCmd → Wire
  | .dl => ("dl", 0) | .dr => ("dr", 0) | .ul => ("ul", 0) | .ur => ("ur", 0)

/-- Shard Invaders commands on the wire. -/
def invadersWire : InvadersCmd → Wire
  | .left => ("left", 0) | .right => ("right", 0)
  | .fire => ("fire", 0) | .tick => ("tick", 0)

/-- NixWars commands on the wire. -/
def shipWire : ShipCmd → Wire
  | .warp d => ("warp", d)
  | .scan => ("scan", 0)
  | .status => ("status", 0)
  | .jnav => ("jnav", 0)
  | .unlock => ("unlock", 0)
  | .quit => ("quit", 0)

/-- Frontier Run commands on the wire. -/
def frontierWire : FrontierCmd → Wire
  | .turnTo h => ("turn", h)
  | .thrust => ("thrust", 0)
  | .brake => ("brake", 0)
  | .fly => ("fly", 0)
  | .dock => ("dock", 0)

/-- The freight run's commands on the wire. -/
def convoyWire : ConvoyCmd → Wire
  | .warp d => ("warp", d)
  | .drop => ("drop", 0)
  | .scan => ("scan", 0)

/-! ## The autopilot plans

Each plan is computed here by unrolling a policy that has been proved to do
what it claims: `shipAuto_arrives`, `qbertAuto_clears`, `invaders_learned_clears`
and `convoyTour_delivers`. -/

/-- The ship's autopilot plan: two hundred and seventy jumps to Sgr A*. -/
def shipAutoPlan : List ShipCmd := pilot nixWars shipAuto initialShip 270

/-- The cabinet's autopilot plan: eleven hops that clear the pyramid. -/
def qbertPlan : List QbertCmd := qbertAutoPlan

/-- The gun's plan: the trained agent of `Learn`. -/
def invadersPlan : List InvadersCmd := invadersLearned

/-! ## Golden gesture vectors -/

/-- Displacements the harness classifies, in pixels. -/
def gestureSamples : List (Int × Int) :=
  [(0, -40), (40, -40), (40, 0), (40, 40), (0, 40), (-40, 40), (-40, 0), (-40, -40),
   (0, -3), (2, 2), (0, 0), (7, 0), (100, -10), (-9, 60), (30, -12), (-30, 13),
   (12, -30), (-13, 31), (300, 299), (-1, -300)]

/-- The dead zone, in pixels: a thumb that moves less than this has not
swiped. -/
def deadZone : Nat := 8

/-- The half-width of the joystick's gate, in pixels. -/
def gateRadius : Nat := 48

/-- The classification of each sample, computed in Lean. -/
def gestureVectorsJson : String :=
  "[" ++ String.intercalate ","
    (gestureSamples.map (fun v =>
      let d : Delta := ⟨v.1, v.2⟩
      let name := match classify deadZone d with
        | none => "\"\""
        | some dir => "\"" ++ dirName dir ++ "\""
      "[" ++ toString v.1 ++ "," ++ toString v.2 ++ "," ++ name ++ "]")) ++ "]"

/-- A list of natural numbers as JSON. -/
def natListJson (l : List Nat) : String :=
  "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- Where the gun's trained plan ends. -/
def invadersPlanEnd : Invaders := shardInvaders.run initialInvaders invadersPlan

/-- Everything the page needs to drive the controls: the dead zone, the gate,
the four direction tables, the autopilot plans with the states Lean says they
end in, and the golden gesture vectors. -/
def controlsJson : String :=
  "{\"dead\":" ++ toString deadZone ++
  ",\"gate\":" ++ toString gateRadius ++
  ",\"dirs\":{" ++
    "\"qbert\":" ++ dirTableJson (fun d => qbertWire (qbertOfDir d)) ++
    ",\"invaders\":" ++ dirTableJson (fun d => invadersWire (invadersOfDir d)) ++
    ",\"nixwars\":" ++ dirTableJson (fun d => shipWire (shipOfDir d)) ++
    ",\"frontier\":" ++ dirTableJson (fun d => frontierWire (frontierOfDir d)) ++
  "},\"plans\":{" ++
    "\"nixwars\":{\"plan\":" ++ planJson shipWire shipAutoPlan ++
      ",\"end\":" ++ natListJson (shipSerialize (autoRun nixWars shipAuto initialShip 270)) ++ "}" ++
    ",\"qbert\":{\"plan\":" ++ planJson qbertWire qbertPlan ++
      ",\"end\":" ++ natListJson (qbertSerialize (autoRun monsterCubes qbertAuto initialQbert 11)) ++
      "}" ++
    ",\"invaders\":{\"plan\":" ++ planJson invadersWire invadersPlan ++
      ",\"end\":" ++ natListJson (invadersSerialize invadersPlanEnd) ++ "}" ++
  "},\"gestures\":" ++ gestureVectorsJson ++ "}"

/-! ## The script

`ctrlOctant` and `ctrlGesture` are the page's copy of `octant` and `classify`:
integer arithmetic, no square roots, the same factor-two diagonal band. The
harness checks them against `gestureVectors`. -/

def controlsJs : String := r#"
// ---- the controls: swipe, mouse, joystick, autopilot ----
// ctrlOctant mirrors NixWars.Controls.octant and ctrlGesture mirrors
// NixWars.Controls.classify; CTRL.gestures are the classifications Lean
// computed for the same displacements, and the harness checks them.
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
// the knob, clamped into its square gate (NixWars.Controls.knob)
function ctrlKnob(t) { return Math.max(-CTRL.gate, Math.min(CTRL.gate, t)); }

// A direction becomes a command of whichever cabinet is on: from the emitted
// table if the cabinet has one, otherwise round the cabinet's own commands.
function ctrlCommand(dir) {
  const table = CTRL.dirs[door];
  if (table && table[dir]) return table[dir];
  const tags = Object.keys(DOORS[door].prog);
  const order = { n: 0, e: 1, s: 2, w: 3, ne: 1, se: 2, sw: 3, nw: 0 };
  return [tags[order[dir] % tags.length], 0];
}
function steer(dir) {
  if (!dir) return;
  const [tag, arg] = ctrlCommand(dir);
  lastGesture = dir;
  send(tag, arg);
}

// ---- pointer: one path for touch and mouse (Controls.mouse_eq_swipe) ----
let dragFrom = null, lastGesture = null;
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

// ---- the on-screen joystick ----
let stickHeld = null, stickTimer = null;
function stickCentre() {
  const gate = document.getElementById("stickgate");
  if (!gate || !gate.getBoundingClientRect) return { x: 0, y: 0 };
  const r = gate.getBoundingClientRect();
  return { x: r.left + r.width / 2, y: r.top + r.height / 2 };
}
function stickDraw(dx, dy) {
  const k = document.getElementById("stickknob");
  if (!k) return;
  k.style.transform = "translate(" + ctrlKnob(dx) + "px," + ctrlKnob(dy) + "px)";
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
    stickTimer = setInterval(() => { if (stickHeld) steer(stickHeld); }, 260);
}
function stickEnd() {
  stickHeld = null;
  stickDraw(0, 0);
  const label = document.getElementById("stickdir");
  if (label) label.textContent = "--";
  if (stickTimer !== null) { clearInterval(stickTimer); stickTimer = null; }
}

// ---- autopilot ----
// The plan is not computed here: CTRL.plans[door].plan is the plan Lean
// unrolled from a proved policy, and CTRL.plans[door].end is the state Lean
// says it ends in. The page just plays it, through the same wasm module the
// buttons use.
let autoTimer = null, autoAt = 0;
function autoPlan() { return (CTRL.plans[door] || {}).plan || null; }
function autoStop() {
  if (autoTimer !== null) { clearInterval(autoTimer); autoTimer = null; }
  const b = document.getElementById("autobtn");
  if (b) b.textContent = "AUTOPILOT";
  render("autopilot off", 0);
}
function autoTick() {
  const plan = autoPlan();
  if (!plan || autoAt >= plan.length) { autoStop(); return; }
  const [tag, arg] = plan[autoAt++];
  send(tag, arg);
}
function autoStart() {
  const plan = autoPlan();
  if (!plan) { render("no autopilot for this cabinet", 0); return; }
  autoAt = 0;
  reset();
  const b = document.getElementById("autobtn");
  if (b) b.textContent = "DISENGAGE";
  if (typeof setInterval === "function") autoTimer = setInterval(autoTick, 40);
}
function autoToggle() { if (autoTimer === null) autoStart(); else autoStop(); }
// Flying the whole plan in one go, for the harness and for the impatient.
function autoAll() {
  const plan = autoPlan();
  if (!plan) return null;
  reset();
  for (const [tag, arg] of plan) send(tag, arg);
  return session.slice(3);
}
// the page's classifier against the vectors Lean computed
function ctrlSelfTest() {
  let ok = 0;
  for (const [dx, dy, want] of CTRL.gestures)
    if ((ctrlGesture(dx, dy) || "") === want) ok++;
  return { ok: ok, total: CTRL.gestures.length };
}
// ---- the stick is yours to set ----
// classify takes the dead zone as a parameter and every theorem about it is
// for every dead zone (Controls.octant_scale, Controls.classify_neg), so
// moving these two sliders cannot make the classifier wrong.
function stickSet(which, v) {
  const n = Math.max(0, Math.min(160, Math.round(Number(v) || 0)));
  CTRL[which] = n;
  const lab = document.getElementById(which === "dead" ? "deadval" : "gateval");
  if (lab) lab.textContent = n + "px";
  const box = document.getElementById(which === "dead" ? "deadrange" : "gaterange");
  if (box) box.value = n;
  if (which === "gate") {
    const gate = document.getElementById("stickgate");
    if (gate && gate.style) {
      gate.style.width = (2 * n + 24) + "px";
      gate.style.height = (2 * n + 24) + "px";
    }
  }
  try {
    localStorage.setItem("nixwars.stick",
      JSON.stringify({ dead: CTRL.dead, gate: CTRL.gate }));
  } catch (err) { /* no storage: this session only */ }
  return n;
}
function stickLoad() {
  let j = null;
  try { j = JSON.parse(localStorage.getItem("nixwars.stick") || "null"); } catch (err) {}
  stickSet("dead", j && typeof j.dead === "number" ? j.dead : CTRL.dead);
  stickSet("gate", j && typeof j.gate === "number" ? j.gate : CTRL.gate);
}
function ctrlInit() {
  stickLoad();
  ctrlBind(document.getElementById("term"));
  ctrlBind(document.getElementById("view3d"));
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
}
"#

/-- The joystick, the thumb buttons and the autopilot switch, as markup. -/
def controlsHtml : String := r#"
<h2>CONTROLS</h2>
<div class="ctrlrow">
  <div id="stickgate" class="gate" title="drag the knob; swipe the terminal; or use the D-pad">
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
    <div class="small">dead zone <span id="deadval">8px</span>
      <input id="deadrange" type="range" min="0" max="60" value="8"
             oninput="stickSet('dead', this.value)"></div>
    <div class="small">stick travel <span id="gateval">48px</span>
      <input id="gaterange" type="range" min="20" max="120" value="48"
             oninput="stickSet('gate', this.value)"></div>
    <div class="small">Set the thumb to your own hand: the classifier takes the
    dead zone as a parameter and every theorem about it &mdash; scale
    invariance, antisymmetry &mdash; holds for every setting, so no slider can
    make it wrong. Kept in this browser.</div>
  </div>
  <div class="pad">
    <div><button id="autobtn" onclick="autoToggle()">AUTOPILOT</button></div>
    <div><button onclick="autoAll()">AUTOPILOT &mdash; ALL AT ONCE</button></div>
    <div class="small">Swipe or drag the terminal, push the knob, or thumb the
    D-pad: all three go through one classifier, proved in Lean to be
    scale-invariant (a long flick and a short nudge are the same command) and
    antisymmetric (the opposite push is the opposite command). AUTOPILOT
    replays a plan Lean computed from a proved policy &mdash; the ship reaches
    Sgr A* on a full tank, the pyramid clears without a fall &mdash; through
    the same WebAssembly module the buttons use.</div>
  </div>
</div>
"#

/-- The styling for the joystick. -/
def controlsCss : String := r#"
.ctrlrow { display:flex; flex-wrap:wrap; gap:14px; align-items:center; margin:8px 0; }
.gate { width:120px; height:120px; border:1px solid #2f7a3c; border-radius:12px;
        background:#04140a; position:relative; touch-action:none; flex:none; }
.knob { width:44px; height:44px; border-radius:50%; background:#1d5f2c;
        border:1px solid #8fffa5; position:absolute; left:38px; top:38px;
        transform:translate(0,0); pointer-events:none; }
.pad div { display:flex; gap:4px; margin-bottom:4px; align-items:center; }
.pad input[type=range] { width:9rem; }
.pad button { min-width:44px; min-height:40px; }
.dirlabel { opacity:0.7; }
"#

end Controls
end NixWars
