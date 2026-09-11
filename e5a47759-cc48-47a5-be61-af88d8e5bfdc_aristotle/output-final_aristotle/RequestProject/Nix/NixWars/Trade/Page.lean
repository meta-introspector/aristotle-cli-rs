import RequestProject.Nix.NixWars.Trade.PageModel

/-!
# The merged room: `www/frontier-voxel.html`

The frontier run and the voxel view were two rooms; this is one room.  The
ship flies the Monster's level-3 grid — the `71 × 59 × 47` box of
`Voyage.lean` — and the eight ports of the market stand on the eight voxels
the character table occupies there, each drawn as a warehouse of stacked
cubes, one column per good, so that *the price board is the scenery*: a
column that empties is a price going up, and it goes up while you watch,
because production runs whenever the ship moves.

The room carries, all emitted from Lean and all checked in the browser before
anyone flies:

* **the market** — five goods, eight ports, a price read off the shelf, and
  the twelve-conversion production circuit drawn as a graph;
* **the flight** — heading, throttle, fuel, docking, buying and selling, with
  every command replayed against the Lean state vector;
* **the shipyard** — the seventeen parts, the six ships on the shelf and a
  customizer that scores a build and refuses an illegal one;
* **the registry** — ships as tokens: mint, list, buy, gift and swap, with the
  credits conserved;
* **the recorder** — every command is written to a tape which saves to a
  string, loads back, and carries a hash chain and a commitment;
* **the sync** — paste another player's tape and the room tells you whether it
  is your game further on, your game behind, or a fork, and at which move;
* **the controls** — arrow keys, numeric keypad, WASD with Z/X, mouse-look,
  mouse-fly, an on-screen joystick, an on-screen trackpad and the phone's own
  tilt, each one separately switchable, so a player can fly the way they like
  on the machine they have.

The model and the checks are written in `PageModel.lean`; this file is the
page they are carried in.

`www/frontier-voxel-selftest.mjs` runs the same checks headless.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Trade
namespace Page

/-! ## The page -/

/-- Head, style and body. -/
def headHtml : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NixWars &mdash; the voxel frontier</title>
<style>
"##

/-- The page's own stylesheet, on top of the shared one. -/
def pageCss : String := r##"
#stage { position: relative; height: 58vh; min-height: 260px; }
#view { width: 100%; height: 100%; display: block; touch-action: none; }
.hud { position: absolute; left: .6rem; top: .6rem; pointer-events: none;
  background: rgba(4,7,13,.6); padding: .3rem .5rem; border: 1px solid var(--line); }
.hud b { color: var(--cyan); }
#stick { position: absolute; right: .8rem; bottom: .8rem; width: 132px; height: 132px;
  border-radius: 50%; border: 1px solid var(--line); background: rgba(4,7,13,.5);
  display: none; touch-action: none; }
#knob { position: absolute; left: 44px; top: 44px; width: 44px; height: 44px;
  border-radius: 50%; background: #17384f; border: 1px solid var(--cyan); }
#trackpad { position: absolute; left: .8rem; bottom: .8rem; width: 132px; height: 92px;
  border: 1px dashed var(--line); background: rgba(4,7,13,.5); display: none;
  touch-action: none; color: var(--dim); font-size: 11px; text-align: center; }
table { border-collapse: collapse; width: 100%; font-size: 13px; }
th, td { border: 1px solid var(--line); padding: .18rem .35rem; text-align: right; }
th { color: var(--dim); font-weight: normal; }
td.l, th.l { text-align: left; }
td.here { background: #10202e; color: var(--cyan); }
.grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(15rem, 1fr)); gap: 1rem; }
.pad button { min-width: 44px; min-height: 44px; margin: 2px; }
.toggles label { display: inline-block; margin: .15rem .6rem .15rem 0; }
pre { white-space: pre-wrap; word-break: break-all; }
textarea { width: 100%; min-height: 4.5rem; background: #060a12; color: var(--ink);
  border: 1px solid var(--line); font: inherit; }
.ok { color: var(--green); } .bad { color: var(--red); } .warn { color: var(--amber); }
"##

/-- The body of the room. -/
def bodyHtml : String := r##"</style>
</head>
<body>
<div id="stage">
  <canvas id="view"></canvas>
  <div class="hud" id="hud"></div>
  <div id="stick"><div id="knob"></div></div>
  <div id="trackpad">trackpad</div>
</div>
<div class="wrap">
<h1>THE VOXEL FRONTIER</h1>
<p class="small">The frontier run and the voxel world, merged. The ship flies the
<b>71 &times; 59 &times; 47</b> grid &mdash; level three of the Monster's voxel world &mdash; and the
eight ports of the market stand on the eight voxels the character table occupies there. Every
port is drawn as its own warehouse: one column of cubes per good, so a column that empties is a
price going up. Production runs whenever you move, so the board never stands still.</p>

<h2>FLIGHT</h2>
<div class="pad" id="flightpad"></div>
<h2>MARKET AT THE PORT</h2>
<div class="pad" id="tradepad"></div>
<table id="portboard"><tbody></tbody></table>

<div class="grid">
<div>
<h2>THE PRICE BOARD</h2>
<table id="board"><tbody></tbody></table>
</div>
<div>
<h2>THE CIRCUIT</h2>
<pre id="circuit"></pre>
<h2>THE HOLD</h2>
<table id="hold"><tbody></tbody></table>
</div>
</div>

<h2>CONTROLS</h2>
<p class="small">Every scheme is separate, and every one can be switched off.</p>
<div class="toggles" id="toggles"></div>
<p class="small" id="tiltnote"></p>

<h2>THE SHIPYARD</h2>
<div class="grid">
<div>
<div class="row"><label for="stock">off the shelf</label><select id="stock"></select></div>
<div class="row"><label for="hull">hull</label><select id="hull"></select></div>
<div class="row"><label for="engine">engine</label><select id="engine"></select></div>
<div class="row"><label for="tank">tank</label><select id="tank"></select></div>
<div class="row"><label for="hold2">hold</label><select id="hold2"></select></div>
<div class="row"><label for="livery">livery</label><select id="livery"></select></div>
<div class="row"><label for="hue">hue</label><input id="hue" type="range" min="0" max="359"
  value="200"><span id="huev">200</span></div>
<div class="row"><button id="fly-this">FLY THIS BUILD</button>
  <button id="mint">MINT AS A TOKEN</button></div>
</div>
<div>
<pre id="buildstats"></pre>
</div>
</div>

<h2>THE REGISTRY</h2>
<div class="row"><label for="player">you are player</label><select id="player"></select>
  <span id="balances" class="small"></span></div>
<table id="tokens"><tbody></tbody></table>
<div class="row"><label for="ask">ask</label><input id="ask" type="number" value="300" min="1">
  <label for="tok">token</label><input id="tok" type="number" value="1" min="1">
  <label for="tok2">and</label><input id="tok2" type="number" value="2" min="1">
  <button id="do-list">LIST</button><button id="do-buy">BUY</button>
  <button id="do-gift">GIFT TO NEXT</button><button id="do-swap">SWAP</button></div>

<h2>THE TAPE</h2>
<p class="small">Every command you give is recorded. The tape saves to a string, loads back, and
carries a hash chain whose last link is the commitment of the game you played.</p>
<div class="row"><button id="save">SAVE</button><button id="load">LOAD</button>
  <button id="play-demo">REPLAY THE DEMO RUN</button><button id="rewind">REWIND</button></div>
<textarea id="tape"></textarea>
<pre id="tapeinfo"></pre>

<h2>UUCP SYNC</h2>
<p class="small">Paste another player's tape. The room replays it, checks its commitment and tells
you whether it is your game further on, your game behind, or a fork &mdash; and at which move.</p>
<textarea id="peer"></textarea>
<div class="row"><button id="compare">COMPARE</button><button id="takeit">FAST-FORWARD</button>
  <button id="mail">PUT IT IN THE UUCP BAG</button></div>
<pre id="syncinfo"></pre>

<h2>SELF-CHECK</h2>
<pre id="log"></pre>
<p class="small">Other rooms: <a href="index.html">the main menu</a>,
<a href="fly.html">fly the voxel world</a>, <a href="frontier.html">the frontier cabinet</a>,
<a href="voxel-world.html">the map</a>, <a href="cans.html">the can opener</a>,
<a href="arcade-3d.html">the arcade in 3D</a>.</p>
</div>
<script>
"##

/-- The room's own script: the scene, the controls and the panels. -/
def scriptJs : String := r##"
// ---- state --------------------------------------------------------------
let spec = decodeSpec(STOCK_SHIPS[3].name, STOCK_SHIPS[3].code);
let ship = newVoyage(spec);
let tape = { ship: encodeSpec(spec), cmds: [] };
let yard = emptyYard();
for (const sp of STOCK_SHIPS) yard = mint(yard, 0, sp);
let me = 0;
const cam = { yaw: 0.9, pitch: 0.55, dist: 150, target: [35, 20, 23], fov: 1.0,
  minDist: 12, maxDist: 600 };
const SCHEMES = [["arrows", "arrow keys"], ["keypad", "numeric keypad"],
  ["wasd", "WASD + Z/X"], ["mouselook", "mouse-look (drag to orbit)"],
  ["mousefly", "mouse-fly (drag to steer, click to fly)"],
  ["stick", "on-screen joystick"], ["trackpad", "on-screen trackpad"],
  ["tilt", "tilt the phone"]];
const on = { arrows: true, keypad: true, wasd: true, mouselook: true, mousefly: false,
  stick: false, trackpad: false, tilt: false };
const canvas = document.getElementById("view");
const R = makeGL(canvas);

// ---- the scene: the box, the ports as warehouses, the ship --------------
function portCubes() {
  const out = [];
  PORTS.forEach((p, i) => {
    const c = p.cell, st = warehouse(ship.econ, i);
    for (let g = 0; g < NUMGOODS; g++) {
      const h = Math.min(12, st[g] || 0);
      for (let k = 0; k < h; k++)
        out.push({ x: c[0] + g * 2, y: k * 1.2, z: c[2], c: g + 1, size: 1.1 });
    }
    out.push({ x: c[0], y: -2, z: c[2], c: p.out + 1, size: 2.2 });
  });
  return out;
}
function sceneCubes() {
  const out = portCubes();
  out.push({ x: ship.x, y: 2, z: ship.z, c: 6, size: 2.6 });
  return out;
}
function sceneLines() {
  const out = boxLines(0, 0, 0, BOX[0], BOX[1], BOX[2], 8);
  PORTS.forEach(p => out.push({ a: [p.cell[0], 0, p.cell[2]], b: [ship.x, 2, ship.z], c: 12 }));
  const nose = [voyAxis(0, ship.x, ship.hdg, 6), 2, voyAxis(2, ship.z, ship.hdg, 6)];
  out.push({ a: [ship.x, 2, ship.z], b: nose, c: 3 });
  return out;
}

// ---- panels -------------------------------------------------------------
const HDG = ["+X", "-X", "+Y", "-Y", "+Z", "-Z"];
function portName(i) { return i === null ? "&mdash;" : PORTS[i].name; }
function redraw() {
  if (R) R.draw(sceneCubes(), sceneLines(), cam);
  const i = dockedAt(ship);
  document.getElementById("hud").innerHTML =
    "<b>" + (i === null ? "FLYING" : "DOCKED " + PORTS[i].name) + "</b> " +
    "cell " + ship.x + "," + ship.y + "," + ship.z + " hdg " + HDG[ship.hdg] +
    " thr " + ship.speed + "/" + ship.maxSpeed + " fuel " + ship.fuel + "/" + ship.tankCap +
    " cr " + ship.credits + " hold " + holdUsed(ship) + "/" + ship.holdCap +
    " round " + ship.econ.round;
  // the board
  let h = "<tr><th class=\"l\">port</th>" + GOODS.map(g => "<th>" + g + "</th>").join("") +
    "<th>makes</th></tr>";
  PORTS.forEach((p, k) => {
    h += "<tr><td class=\"l" + (k === i ? " here" : "") + "\">" + p.name + "</td>" +
      GOODS.map((g, gi) => "<td" + (k === i ? " class=\"here\"" : "") + ">" +
        priceAt(ship.econ, k, gi) + "<span class=\"small\"> /" + stockAt(ship.econ, k, gi) +
        "</span></td>").join("") + "<td class=\"l\">" + GOODS[p.out] + "</td></tr>";
  });
  document.querySelector("#board tbody").innerHTML = h;
  // the port you are at
  let pb = "";
  if (i !== null) {
    pb = "<tr><th class=\"l\">good</th><th>price</th><th>on the shelf</th><th>in your hold</th>" +
      "</tr>" + GOODS.map((g, gi) =>
      "<tr><td class=\"l\">" + g + "</td><td>" + priceAt(ship.econ, i, gi) + "</td><td>" +
      stockAt(ship.econ, i, gi) + "</td><td>" + stockOf(ship.hold, gi) + "</td></tr>").join("");
  }
  document.querySelector("#portboard tbody").innerHTML = pb;
  document.querySelector("#hold tbody").innerHTML =
    GOODS.map((g, gi) => "<tr><td class=\"l\">" + g + "</td><td>" + stockOf(ship.hold, gi) +
      "</td><td>" + (i === null ? "&mdash;" : stockOf(ship.hold, gi) * priceAt(ship.econ, i, gi)) +
      "</td></tr>").join("") +
    "<tr><td class=\"l\">value here</td><td></td><td>" +
    (i === null ? "&mdash;" : cargoValue(ship.econ, i, ship.hold)) + "</td></tr>";
  drawTape();
}
function drawCircuit() {
  const lines = PORTS.map(p =>
    p.name.padEnd(10) + " " + p.inputs.map(g => GOODS[g]).join(" + ").padEnd(13) +
    " -> " + GOODS[p.out]);
  document.getElementById("circuit").textContent = lines.join("\n");
}
function drawTape() {
  const commit = logCommit(tape);
  document.getElementById("tapeinfo").textContent =
    tape.cmds.length + " moves recorded, " + logChain(tape).length + " hashes, commitment " +
    commit + "\nship " + tape.ship + " (" + spec.name + ")";
}
function drawYard() {
  document.getElementById("balances").textContent =
    " credits: " + yard.balances.map((b, k) => "p" + k + " " + b).join("  ");
  document.querySelector("#tokens tbody").innerHTML =
    "<tr><th>id</th><th class=\"l\">ship</th><th>owner</th><th>ask</th><th>fingerprint</th></tr>" +
    yard.tokens.map(t => "<tr><td>" + t.id + "</td><td class=\"l\">" + t.name + "</td><td>" +
      t.owner + "</td><td>" + (t.ask || "&mdash;") + "</td><td>" +
      hashNums(0, [t.code, 71]) + "</td></tr>").join("");
}

// ---- playing ------------------------------------------------------------
function give(cmd) {
  ship = step(ship, cmd);
  tape = { ship: tape.ship, cmds: tape.cmds.concat([cmd]) };
  redraw();
}
function buildFlightPad() {
  const pad = document.getElementById("flightpad");
  const btns = [["THRUST", 1], ["BRAKE", 2], ["FLY", 3], ["DOCK", 4], ["REFUEL", 5], ["WAIT", 6]]
    .concat(HDG.map((h, k) => ["HDG " + h, 10 + k]));
  pad.innerHTML = "";
  for (const [label, cmd] of btns) {
    const b = document.createElement("button");
    b.textContent = label;
    b.addEventListener("click", () => give(cmd));
    pad.appendChild(b);
  }
  const tp = document.getElementById("tradepad");
  tp.innerHTML = "";
  GOODS.forEach((g, gi) => {
    for (const [what, base] of [["BUY", 20], ["SELL", 30]]) {
      const b = document.createElement("button");
      b.textContent = what + " " + g;
      b.addEventListener("click", () => give(base + gi));
      tp.appendChild(b);
    }
  });
}

// ---- the controls, each one switchable ----------------------------------
function turnBy(d) { give(10 + ((ship.hdg + d + 6) % 6)); }
function showPads() {
  document.getElementById("stick").style.display = on.stick ? "block" : "none";
  document.getElementById("trackpad").style.display = on.trackpad ? "block" : "none";
}
function buildToggles() {
  const box = document.getElementById("toggles");
  box.innerHTML = "";
  for (const [key, label] of SCHEMES) {
    const l = document.createElement("label");
    const c = document.createElement("input");
    const t = document.createElement("span");
    c.type = "checkbox"; c.checked = on[key];
    t.textContent = " " + label;
    c.addEventListener("change", () => {
      on[key] = !!c.checked;
      showPads();
      if (key === "tilt" && c.checked) askTilt();
    });
    l.appendChild(c);
    l.appendChild(t);
    box.appendChild(l);
  }
}
window.addEventListener("keydown", (e) => {
  const k = e.key, c = e.code;
  let used = true;
  if (on.arrows && k === "ArrowUp") give(1);
  else if (on.arrows && k === "ArrowDown") give(2);
  else if (on.arrows && k === "ArrowLeft") turnBy(-1);
  else if (on.arrows && k === "ArrowRight") turnBy(1);
  else if (on.arrows && k === " ") give(3);
  else if (on.keypad && c.startsWith("Numpad") && c.length === 7 && c[6] >= "1" && c[6] <= "6")
    give(10 + (Number(c[6]) - 1));
  else if (on.keypad && c === "Numpad0") give(3);
  else if (on.keypad && c === "NumpadAdd") give(1);
  else if (on.keypad && c === "NumpadSubtract") give(2);
  else if (on.keypad && c === "NumpadEnter") give(4);
  else if (on.wasd && (k === "w" || k === "W")) give(1);
  else if (on.wasd && (k === "s" || k === "S")) give(2);
  else if (on.wasd && (k === "a" || k === "A")) turnBy(-1);
  else if (on.wasd && (k === "d" || k === "D")) turnBy(1);
  else if (on.wasd && (k === "z" || k === "Z")) give(14);
  else if (on.wasd && (k === "x" || k === "X")) give(15);
  else if (on.wasd && (k === "f" || k === "F")) give(3);
  else if (k === "Enter") give(4);
  else used = false;
  if (used) e.preventDefault();
});
// mouse-look is the shared orbit; mouse-fly steers the ship instead
let flyDrag = null;
canvas.addEventListener("pointerdown", (e) => {
  if (on.mousefly) flyDrag = { x: e.clientX, y: e.clientY, moved: false };
});
canvas.addEventListener("pointermove", (e) => {
  if (!on.mousefly || !flyDrag) return;
  const dx = e.clientX - flyDrag.x, dy = e.clientY - flyDrag.y;
  if (Math.abs(dx) > 40 || Math.abs(dy) > 40) {
    flyDrag = { x: e.clientX, y: e.clientY, moved: true };
    if (Math.abs(dx) > Math.abs(dy)) turnBy(dx > 0 ? 1 : -1);
    else give(dy > 0 ? 2 : 1);
  }
});
canvas.addEventListener("pointerup", () => {
  if (on.mousefly && flyDrag && !flyDrag.moved) give(3);
  flyDrag = null;
});
// the on-screen joystick
(function () {
  const stick = document.getElementById("stick"), knob = document.getElementById("knob");
  let base = null;
  const at = (e) => {
    const r = stick.getBoundingClientRect();
    return { x: e.clientX - r.left - r.width / 2, y: e.clientY - r.top - r.height / 2 };
  };
  stick.addEventListener("pointerdown", (e) => {
    stick.setPointerCapture(e.pointerId); base = at(e); e.preventDefault();
  });
  stick.addEventListener("pointermove", (e) => {
    if (!base) return;
    const p = at(e);
    knob.style.left = (44 + Math.max(-44, Math.min(44, p.x))) + "px";
    knob.style.top = (44 + Math.max(-44, Math.min(44, p.y))) + "px";
    if (Math.hypot(p.x - base.x, p.y - base.y) > 34) {
      const dx = p.x - base.x, dy = p.y - base.y;
      base = p;
      if (Math.abs(dx) > Math.abs(dy)) turnBy(dx > 0 ? 1 : -1);
      else give(dy > 0 ? 2 : 1);
    }
    e.preventDefault();
  });
  const up = () => { base = null; knob.style.left = "44px"; knob.style.top = "44px"; };
  stick.addEventListener("pointerup", (e) => { if (base) give(3); up(); });
  stick.addEventListener("pointercancel", up);
})();
// the on-screen trackpad: drags the camera without touching the scene
(function () {
  const pad = document.getElementById("trackpad");
  let last = null;
  pad.addEventListener("pointerdown", (e) => {
    pad.setPointerCapture(e.pointerId); last = { x: e.clientX, y: e.clientY }; e.preventDefault();
  });
  pad.addEventListener("pointermove", (e) => {
    if (!last) return;
    cam.yaw -= (e.clientX - last.x) * 0.012;
    cam.pitch = Math.max(-1.45, Math.min(1.45, cam.pitch + (e.clientY - last.y) * 0.012));
    last = { x: e.clientX, y: e.clientY };
    redraw(); e.preventDefault();
  });
  pad.addEventListener("pointerup", () => { last = null; });
})();
// the phone's own tilt
let tiltLast = 0;
function askTilt() {
  const D = window.DeviceOrientationEvent;
  if (D && typeof D.requestPermission === "function") D.requestPermission().catch(() => {});
  document.getElementById("tiltnote").textContent = D
    ? "tilt: lean left and right to turn, forward and back for the throttle, flat to fly"
    : "this device reports no orientation, so tilt does nothing here";
}
window.addEventListener("deviceorientation", (e) => {
  if (!on.tilt) return;
  const now = Date.now();
  if (now - tiltLast < 400) return;
  const g = e.gamma || 0, b = e.beta || 0;
  if (Math.abs(g) > 22) { turnBy(g > 0 ? 1 : -1); tiltLast = now; }
  else if (b < 20) { give(1); tiltLast = now; }
  else if (b > 60) { give(2); tiltLast = now; }
  else { give(3); tiltLast = now; }
});

// ---- the shipyard -------------------------------------------------------
function slotSelect(id, k) {
  const sel = document.getElementById(id);
  sel.innerHTML = "";
  slotParts(k).forEach((p, i) => {
    const o = document.createElement("option");
    o.value = String(i);
    o.textContent = p.name + " (" + p.mass + "kg, " + p.cost + "cr)";
    sel.appendChild(o);
  });
  sel.addEventListener("change", drawBuild);
  return sel;
}
function currentBuild() {
  return { name: "CUSTOM",
    hull: Number(document.getElementById("hull").value),
    engine: Number(document.getElementById("engine").value),
    tank: Number(document.getElementById("tank").value),
    hold: Number(document.getElementById("hold2").value),
    livery: Number(document.getElementById("livery").value),
    hue: Number(document.getElementById("hue").value) };
}
function drawBuild() {
  const b = currentBuild(), st = shipStats(b), ok = shipOk(b);
  document.getElementById("huev").textContent = b.hue;
  document.getElementById("buildstats").innerHTML =
    "throttle  " + st.maxSpeed + "\ntank      " + st.tank + "\nhold      " + st.hold +
    "\nmass      " + st.mass + " of " + slotPart(0, b.hull).frame + " the frame carries" +
    "\ncost      " + st.cost + " credits\nnumber    " + encodeSpec(b) +
    "\n\n<span class=\"" + (ok ? "ok" : "bad") + "\">" +
    (ok ? "a legal ship" : "NOT A LEGAL SHIP: too heavy for the hull, or no engine") +
    "</span>\n" + LEGAL_BUILDS + " of " + ALL_BUILDS + " builds are legal.";
}

// ---- wiring -------------------------------------------------------------
buildFlightPad();
buildToggles();
drawCircuit();
["hull", "engine", "tank", "hold2", "livery"].forEach((id, k) => slotSelect(id, k));
document.getElementById("hue").addEventListener("input", drawBuild);
const stockSel = document.getElementById("stock");
STOCK_SHIPS.forEach((s, i) => {
  const o = document.createElement("option");
  o.value = String(i); o.textContent = s.name;
  if (i === 3) o.selected = true;
  stockSel.appendChild(o);
});
stockSel.addEventListener("change", () => {
  const s = STOCK_SHIPS[Number(stockSel.value)];
  document.getElementById("hull").value = String(s.hull);
  document.getElementById("engine").value = String(s.engine);
  document.getElementById("tank").value = String(s.tank);
  document.getElementById("hold2").value = String(s.hold);
  document.getElementById("livery").value = String(s.livery);
  document.getElementById("hue").value = String(s.hue);
  drawBuild();
});
document.getElementById("fly-this").addEventListener("click", () => {
  const b = currentBuild();
  if (!shipOk(b)) return;
  spec = b; ship = newVoyage(b); tape = { ship: encodeSpec(b), cmds: [] };
  redraw();
});
document.getElementById("mint").addEventListener("click", () => {
  const b = currentBuild();
  yard = mint(yard, me, b);
  drawYard();
});
const playerSel = document.getElementById("player");
for (let k = 0; k < NUMPLAYERS; k++) {
  const o = document.createElement("option");
  o.value = String(k); o.textContent = String(k);
  playerSel.appendChild(o);
}
playerSel.addEventListener("change", () => { me = Number(playerSel.value); drawYard(); });
const tokNum = () => Number(document.getElementById("tok").value);
const tok2Num = () => Number(document.getElementById("tok2").value);
document.getElementById("do-list").addEventListener("click", () => {
  yard = listToken(yard, tokNum(), me, Number(document.getElementById("ask").value));
  drawYard();
});
document.getElementById("do-buy").addEventListener("click", () => {
  yard = buyToken(yard, tokNum(), me); drawYard();
});
document.getElementById("do-gift").addEventListener("click", () => {
  yard = giftToken(yard, tokNum(), me, (me + 1) % NUMPLAYERS); drawYard();
});
document.getElementById("do-swap").addEventListener("click", () => {
  yard = swapTokens(yard, tokNum(), tok2Num()); drawYard();
});
document.getElementById("save").addEventListener("click", () => {
  document.getElementById("tape").value = saveLog(tape);
});
document.getElementById("load").addEventListener("click", () => {
  const l = loadLog(document.getElementById("tape").value.trim());
  if (!l) { document.getElementById("tapeinfo").textContent = "that is not a saved game"; return; }
  tape = l; spec = decodeSpec("LOADED", l.ship); ship = logReplay(l); redraw();
});
document.getElementById("play-demo").addEventListener("click", () => {
  tape = { ship: DEMO_SHIP, cmds: DEMO_CMDS.slice() };
  spec = decodeSpec("RECORDED", DEMO_SHIP);
  ship = logReplay(tape);
  redraw();
});
document.getElementById("rewind").addEventListener("click", () => {
  ship = newVoyage(spec); tape = { ship: encodeSpec(spec), cmds: [] }; redraw();
});
document.getElementById("compare").addEventListener("click", () => {
  const peer = loadLog(document.getElementById("peer").value.trim());
  const out = document.getElementById("syncinfo");
  if (!peer) { out.textContent = "that is not a saved game"; return; }
  const r = syncLogs(tape, peer);
  const words = { inSync: "the same game", fastForward: "their game is mine, played on",
    ahead: "their game is behind mine", otherShip: "another ship altogether",
    fork: "a fork" };
  out.textContent = words[r.kind] + (r.kind === "fork" ? ", parting at move " + r.at : "") +
    "\ntheir commitment " + logCommit(peer) + "\nmine             " + logCommit(tape) +
    "\ntheir replay is " + (voyageOk(logReplay(peer)) ? "a legal game" : "NOT a legal game");
});
document.getElementById("takeit").addEventListener("click", () => {
  const peer = loadLog(document.getElementById("peer").value.trim());
  if (!peer) return;
  const r = syncLogs(tape, peer);
  if (r.kind !== "fastForward") {
    document.getElementById("syncinfo").textContent =
      "only a clean fast-forward is taken; this is " + r.kind;
    return;
  }
  tape = peer; ship = logReplay(peer); redraw();
});
document.getElementById("mail").addEventListener("click", () => {
  const route = uucpRoute(0, 5);
  document.getElementById("syncinfo").textContent =
    UUCP_PATH + "\nroute " + route.join(" -> ") + " (" + route.length + " hops)\n" +
    saveLog(tape);
});
if (R && on.mouselook) attachOrbit(canvas, cam, redraw);
document.getElementById("peer").value = DEMO_SAVED;
drawBuild();
drawYard();
redraw();

const log = [];
let allOk = true;
frontierChecks((what, cond) => {
  if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what);
});
document.getElementById("log").innerHTML =
  "<span class=\"" + (allOk ? "ok" : "bad") + "\">" +
  (allOk ? "all checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");
if (!R) document.getElementById("hud").innerHTML =
  "this browser has no WebGL &mdash; the frontier below still trades";
"##

/-- The whole page. -/
def frontierVoxelPage : String :=
  headHtml ++ Gl.mobileCss ++ pageCss ++ bodyHtml ++
  frontierVoxelData ++ Gl.matrixJs ++ Gl.rendererJs ++ Gl.orbitJs ++ modelJs ++ checksJs ++
  scriptJs ++ "\n</script>\n</body>\n</html>\n"

/-- The headless self-test: the same tables, the same model, the same
checks. -/
def frontierVoxelSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Trade/Page.lean. Run: node www/frontier-voxel-selftest.mjs\n"
    ++ frontierVoxelData ++ modelJs ++ checksJs ++ r##"
let fails = 0, n = 0;
frontierChecks((what, cond) => {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); }
  else console.log("ok   " + what);
});
console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the room and its self-test. -/
def writeFrontierVoxel : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/frontier-voxel.html" frontierVoxelPage
  IO.FS.writeFile "www/frontier-voxel-selftest.mjs" frontierVoxelSelfTest

#eval writeFrontierVoxel

end Page
end Trade
end NixWars
