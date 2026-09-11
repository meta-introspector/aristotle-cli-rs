import RequestProject.Gvcs.Wasm.Compile

/-!
# The browser shell

The WebAssembly module of `RequestProject/Wasm/Compile.lean` is the game; this
file is the page it is played on.  Everything the page shows — the catalogue of
materials with their prices and units, the assemblies on the workbench, the
crops in the field planner, the screen graph — is generated here out of the
same Lean data the module was compiled from, so the labels on the buttons and
the numbers behind them cannot drift apart.

The shell itself is deliberately thin: it reads the position out of the
module's linear memory, greys a control out exactly when the module's `enabled`
says so, and sends every click through `commit`, which is the event loop of
`UI.lean`.  The undo stack lives in the shell (it is a stack of copies of the
state region of the memory), as `UI.lean`'s `past` does.
-/

namespace LifeTrac
namespace Web

open Build Material Runtime Wasm

/-! ## Labels -/

/-- What the market calls a material. -/
def matLabel : Material → String
  | steelTube4 => "4″ square steel tube"
  | steelTube3 => "3″ square steel tube"
  | steelTube2 => "2″ square steel tube"
  | steelPlate6 => "6 mm steel plate"
  | steelPlate12 => "12 mm steel plate"
  | roundBar50 => "50 mm round bar"
  | boltM12 => "M12 bolt"
  | nutM12 => "M12 nut"
  | weldWire => "MIG welding wire"
  | hose => "hydraulic hose"
  | fitting => "hose end fitting"
  | fluid => "hydraulic fluid"
  | gearPump => "gear pump"
  | wheelMotor => "hydraulic wheel motor"
  | cylinder => "hydraulic cylinder"
  | controlValve => "spool control valve"
  | engine => "engine"
  | fuelTank => "fuel tank"
  | hydraulicTank => "hydraulic reservoir"
  | wheelHub => "wheel hub"
  | tire => "tire on rim"
  | seat => "operator seat"
  | paint => "paint"
  | electricalKit => "electrical kit"

/-- What the workbench calls an assembly. -/
def partLabel : RPart → String
  | .frame => "frame"
  | .wheelModule => "wheel module"
  | .powerUnit => "power unit"
  | .controlStation => "control station"
  | .loader => "loader"
  | .finishing => "finishing"
  | .lifeTrac => "LifeTrac (whole machine)"

/-- What the field planner calls a crop. -/
def cropLabel : RCrop → String
  | .wheat => "wheat"

/-! ## The data tables, as JavaScript -/

/-- A rendering of a micro-unit integer as a decimal string. -/
def showMicro (n : Int) : String :=
  let neg := n < 0
  let a := n.natAbs
  let whole := a / 1000000
  let frac := a % 1000000
  let fracStr := (toString (1000000 + frac)).drop 1
  let fracStr := fracStr.dropEndWhile (· = '0')
  let body := if fracStr.isEmpty then toString whole else toString whole ++ "." ++ fracStr
  if neg then "-" ++ body else body

/-- The material catalogue as a JavaScript array. -/
def materialsJs : String :=
  "const MAT = [\n" ++
  String.intercalate ",\n" (allM.map (fun m =>
    "  {i:" ++ toString (idxM m) ++ ", name:\"" ++ matLabel m ++ "\", unit:\"" ++
      m.unitName ++ "\", price:" ++ showMicro (costM m) ++ ", salvage:" ++
      showMicro (salvageM m) ++ "}")) ++ "\n];\n"

/-- The workbench menu as a JavaScript array. -/
def partsJs : String :=
  "const PART = [\n" ++
  String.intercalate ",\n" (allP.map (fun a =>
    "  {i:" ++ toString (idxP a) ++ ", name:\"" ++ partLabel a ++ "\", cost:" ++
      showMicro a.cost ++ ", days:" ++ showMicro a.days ++ "}")) ++ "\n];\n"

/-- The field planner's crops as a JavaScript array. -/
def cropsJs : String :=
  "const CROP = [\n" ++
  String.intercalate ",\n" (allC.map (fun c =>
    "  {i:" ++ toString (idxC c) ++ ", name:\"" ++ cropLabel c ++ "\", seed:" ++
      showMicro c.seed ++ ", revenue:" ++ showMicro c.revenue ++ ", fuel:" ++
      showMicro c.fuelHa ++ ", days:" ++ showMicro c.daysHa ++ "}")) ++ "\n];\n"

/-- The addresses the shell reads the position from. -/
def layoutJs : String :=
  "const ADDR = {cash:" ++ toString (CASH / 8) ++ ", fuel:" ++ toString (FUEL / 8) ++
  ", day:" ++ toString (DAY / 8) ++ ", hect:" ++ toString (HECT / 8) ++
  ", screen:" ++ toString (SCREEN / 8) ++ ", stock:" ++ toString (STOCK / 8) ++
  ", built:" ++ toString (BUILT / 8) ++ "};\n" ++
  "const SCALE = 1000000n;\n" ++
  "const FUELPRICE = " ++ showMicro fuelPriceM ++ ";\n"

/-! ## The page -/

/-- The page down to the opening `<script>`: style sheet and the empty
elements the shell fills in. -/
def htmlHead : String := r####"<!DOCTYPE html>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,viewport-fit=cover">
<title>LifeTrac — a game compiled from its proofs</title>
<style>
 body { background:#141210; color:#e8e2d8; font:15px/1.45 "Iowan Old Style",Georgia,serif;
        margin:0; padding:0 }
 #wrap { max-width:900px; margin:0 auto; padding:18px }
 h1 { font-size:20px; letter-spacing:.06em; text-transform:uppercase; margin:0 0 4px }
 h2 { font-size:17px; margin:18px 0 6px; border-bottom:1px solid #3a352d; padding-bottom:3px }
 #hud { display:flex; gap:18px; flex-wrap:wrap; background:#1e1b17; border:1px solid #3a352d;
        padding:8px 12px; margin:10px 0; font-variant-numeric:tabular-nums }
 #hud div span { color:#c8a24a; font-weight:bold }
 button { font:inherit; background:#2b2721; color:#e8e2d8; border:1px solid #554d40;
          padding:4px 10px; margin:2px; cursor:pointer }
 button:hover:enabled { background:#3b352c }
 button:disabled { opacity:.35; cursor:not-allowed }
 table { border-collapse:collapse; width:100% }
 td,th { padding:3px 6px; border-bottom:1px solid #2a2620; text-align:left;
         font-variant-numeric:tabular-nums }
 th { color:#9a9184; font-weight:normal; font-size:13px }
 input { width:5em; font:inherit; background:#100e0c; color:#e8e2d8;
         border:1px solid #554d40; padding:2px 4px }
 .num { text-align:right }
 #log { max-height:220px; overflow:auto; font-size:13px; color:#b8b0a2 }
 .note { color:#9a9184; font-size:13px }
 nav button { min-width:120px }
 /* on a phone: one column, targets big enough for a thumb, tables that fit */
 @media (max-width:700px) {
  #wrap { padding:12px }
  button { padding:9px 13px; min-height:40px; font-size:15px }
  nav button { min-width:0; flex:1 1 42% }
  nav { display:flex; flex-wrap:wrap; gap:6px }
  #hud { gap:10px; font-size:14px }
  table { font-size:13px }
  td,th { padding:5px 4px }
  input { width:4.5em; padding:6px 4px; font-size:16px }
  #log { max-height:180px }
 }
</style>
<div id="wrap">
<h1>LifeTrac</h1>
<div class="note">The rule book of this game is a WebAssembly module compiled
out of a Lean development and proved to agree with it, move for move.</div>
<div id="hud"></div>
<nav id="nav"></nav>
<div id="screen"></div>
<h2>Log</h2>
<div id="log"></div>
</div>
<script>
"####

/-- The event loop and the drawing routines: everything the page does once the
module is running.  It is shared by the two builds of the page. -/
def htmlDraw : String := r####"
const SCREENS = ["Title","Yard","Market","Workbench","Field planner","Ledger","Help"];
const KIND = {buy:0, order:1, sell:2, fabricate:3, refuel:4, farm:5};
let M = null, mem = null, log = [], past = [];

function cell(i) { return mem[i]; }
function snapshot() { return Array.from(mem.slice(0, ADDR.built + 8)); }
function restore(s) { for (let i = 0; i < s.length; i++) mem[i] = s[i]; }
function micro(x) { return Number(x) / 1e6; }
function money(x) { return micro(x).toLocaleString(undefined,
  {minimumFractionDigits:2, maximumFractionDigits:2}); }

function netWorth() { return Number(M.netWorth()) / 1e12; }

function hud() {
  const h = document.getElementById("hud");
  h.innerHTML =
    '<div>cash <span>' + money(cell(ADDR.cash)) + '</span></div>' +
    '<div>fuel <span>' + micro(cell(ADDR.fuel)).toFixed(0) + ' L</span></div>' +
    '<div>day <span>' + micro(cell(ADDR.day)).toFixed(3) + '</span></div>' +
    '<div>farmed <span>' + micro(cell(ADDR.hect)).toFixed(0) + ' ha</span></div>' +
    '<div>net worth <span>' + netWorth().toLocaleString(undefined,
        {minimumFractionDigits:2, maximumFractionDigits:2}) + '</span></div>' +
    '<div>machine <span>' + (cell(ADDR.built + 6) > 0n ? "yes" : "no") + '</span></div>' +
    '<div>screen <span>' + SCREENS[Number(cell(ADDR.screen))] + '</span></div>';
}

function describe(k, i, a) {
  if (k === KIND.buy) return "buy " + a + " " + MAT[i].unit + " of " + MAT[i].name;
  if (k === KIND.order) return "order the bill of materials of the " + PART[i].name;
  if (k === KIND.sell) return "sell " + a + " " + MAT[i].unit + " of " + MAT[i].name;
  if (k === KIND.fabricate) return "fabricate the " + PART[i].name;
  if (k === KIND.refuel) return "refuel " + a + " L";
  return "work " + a + " ha of " + CROP[i].name;
}

function commit(k, i, a) {
  const before = snapshot();
  const ok = M.commit(BigInt(k), BigInt(i), BigInt(a));
  if (ok) { past.push(before); log.push(describe(k, i, a)); }
  draw();
  return ok;
}

function undo() {
  if (past.length === 0) return;
  restore(past.pop()); log.pop(); draw();
}

function nav(s) { M.nav(BigInt(s)); draw(); }
function back() { M.back(); draw(); }

function btn(label, enabled, fn) {
  const b = document.createElement("button");
  b.textContent = label; b.disabled = !enabled; b.onclick = fn;
  return b;
}

function qty(id) {
  const v = document.getElementById(id);
  const n = v ? parseInt(v.value, 10) : 0;
  return Number.isFinite(n) ? n : 0;
}

function drawNav() {
  const n = document.getElementById("nav");
  n.innerHTML = "";
  const s = Number(cell(ADDR.screen));
  const kids = {0:[1,6], 1:[2,3,4,5], 2:[], 3:[], 4:[], 5:[], 6:[]}[s];
  for (const k of kids) n.appendChild(btn(SCREENS[k], true, () => nav(k)));
  if (s !== 0) n.appendChild(btn("← back", true, back));
  n.appendChild(btn("undo", past.length > 0, undo));
}

function row(cells) {
  const tr = document.createElement("tr");
  for (const c of cells) {
    const td = document.createElement("td");
    if (typeof c === "string" || typeof c === "number") td.textContent = c;
    else td.appendChild(c);
    tr.appendChild(td);
  }
  return tr;
}

function table(head) {
  const t = document.createElement("table");
  const tr = document.createElement("tr");
  for (const h of head) { const th = document.createElement("th"); th.textContent = h;
                          tr.appendChild(th); }
  t.appendChild(tr);
  return t;
}

function drawScreen() {
  const d = document.getElementById("screen");
  d.innerHTML = "";
  const s = Number(cell(ADDR.screen));
  const h2 = document.createElement("h2");
  h2.textContent = SCREENS[s];
  d.appendChild(h2);
  if (s === 0) {
    const p = document.createElement("div");
    p.className = "note";
    p.textContent = "A homesteader with 15 000 in the bank, an empty shed and " +
      "20 hectares. Build a LifeTrac and put the land into wheat. Open the yard to begin.";
    d.appendChild(p);
  } else if (s === 1) {
    const p = document.createElement("div");
    let owned = [];
    for (const q of PART) if (cell(ADDR.built + q.i) > 0n)
      owned.push(Number(cell(ADDR.built + q.i)) + " × " + q.name);
    p.innerHTML = owned.length ? ("In the yard: " + owned.join(", ") + ".")
                               : "The yard is empty.";
    d.appendChild(p);
  } else if (s === 2) {
    const t = table(["material", "unit", "price", "salvage", "on the shelf", "", ""]);
    for (const m of MAT) {
      const inp = document.createElement("input");
      inp.id = "q" + m.i; inp.value = "1";
      const buy = btn("buy", M.enabled(0n, BigInt(m.i), 1n) !== 0n,
        () => commit(KIND.buy, m.i, qty("q" + m.i)));
      const sell = btn("sell", M.enabled(2n, BigInt(m.i), 1n) !== 0n,
        () => commit(KIND.sell, m.i, qty("q" + m.i)));
      t.appendChild(row([m.name, m.unit, m.price.toFixed(2), m.salvage.toFixed(2),
        micro(cell(ADDR.stock + m.i)).toString(), inp,
        (() => { const sp = document.createElement("span");
                 sp.appendChild(buy); sp.appendChild(sell); return sp; })()]));
    }
    d.appendChild(t);
    const t2 = table(["order desk", "material cost", "", ""]);
    for (const q of PART)
      t2.appendChild(row([q.name, q.cost.toFixed(2),
        btn("order", M.enabled(1n, BigInt(q.i), 0n) !== 0n,
            () => commit(KIND.order, q.i, 0))]));
    d.appendChild(t2);
    const t3 = table(["fuel", "price/L", "", ""]);
    const finp = document.createElement("input");
    finp.id = "qfuel"; finp.value = "400";
    t3.appendChild(row(["diesel", FUELPRICE.toFixed(2), finp,
      btn("refuel", M.enabled(4n, 0n, 1n) !== 0n,
          () => commit(KIND.refuel, 0, qty("qfuel")))]));
    d.appendChild(t3);
  } else if (s === 3) {
    const t = table(["assembly", "days to build", "built", ""]);
    for (const q of PART)
      t.appendChild(row([q.name, q.days.toFixed(3),
        Number(cell(ADDR.built + q.i)).toString(),
        btn("fabricate", M.enabled(3n, BigInt(q.i), 0n) !== 0n,
            () => commit(KIND.fabricate, q.i, 0))]));
    d.appendChild(t);
  } else if (s === 4) {
    const t = table(["crop", "seed/ha", "revenue/ha", "fuel/ha", "days/ha", "ha", ""]);
    for (const c of CROP) {
      const inp = document.createElement("input");
      inp.id = "a" + c.i; inp.value = "20";
      t.appendChild(row([c.name, c.seed.toFixed(2), c.revenue.toFixed(2),
        c.fuel.toFixed(1), c.days.toFixed(5), inp,
        btn("work the field", M.enabled(5n, BigInt(c.i), 1n) !== 0n,
            () => commit(KIND.farm, c.i, qty("a" + c.i)))]));
    }
    d.appendChild(t);
  } else if (s === 5) {
    const t = table(["item", "value"]);
    t.appendChild(row(["cash", money(cell(ADDR.cash))]));
    let shelf = 0;
    for (const m of MAT) shelf += micro(cell(ADDR.stock + m.i)) * m.price;
    t.appendChild(row(["material on the shelf", shelf.toFixed(2)]));
    t.appendChild(row(["fuel in the tank", (micro(cell(ADDR.fuel)) * FUELPRICE).toFixed(2)]));
    let built = 0;
    for (const q of PART) built += Number(cell(ADDR.built + q.i)) * q.cost;
    t.appendChild(row(["machines built", built.toFixed(2)]));
    t.appendChild(row(["net worth", netWorth().toFixed(2)]));
    d.appendChild(t);
  } else {
    const p = document.createElement("div");
    p.className = "note";
    p.innerHTML =
      "Every price, bill of materials, labour figure and crop yield on these " +
      "screens comes from the Lean development this page was generated from. " +
      "A button is live exactly when the rule book accepts the move behind it; " +
      "the WebAssembly module decides that, and the decision is proved to be " +
      "the rule book's own.";
    d.appendChild(p);
  }
}

function drawLog() {
  const l = document.getElementById("log");
  l.innerHTML = log.length
    ? log.map((x, i) => (i + 1) + ". " + x).join("<br>")
    : "<span class='note'>nothing done yet</span>";
}

function draw() { hud(); drawNav(); drawScreen(); drawLog(); }
"####

/-- How the two-file build gets the module: it fetches it. -/
def htmlFetchLoader : String := r####"
WebAssembly.instantiateStreaming
  ? WebAssembly.instantiateStreaming(fetch("lifetrac.wasm")).then(start)
  : fetch("lifetrac.wasm").then(r => r.arrayBuffer())
      .then(b => WebAssembly.instantiate(b)).then(start);
"####

/-- What to do once the module is instantiated. -/
def htmlStart : String := r####"
function start(res) {
  M = res.instance.exports;
  mem = new BigInt64Array(M.mem.buffer);
  draw();
}
</script>
"####

/-- The whole page. -/
def indexHtml : String :=
  htmlHead ++ materialsJs ++ partsJs ++ cropsJs ++ layoutJs ++ htmlDraw ++
    htmlFetchLoader ++ htmlStart

end Web
end LifeTrac
