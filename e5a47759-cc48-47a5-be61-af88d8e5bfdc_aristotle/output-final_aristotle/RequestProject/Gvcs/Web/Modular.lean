import RequestProject.Gvcs.Web.Packs

/-!
# The modular pages

One engine, four builds.  Every page produced here is a single self-contained
HTML file — no `<script src>`, no `<link>`, no `fetch` — that carries

* the codec of `RequestProject/Web/Pack.lean`, in JavaScript;
* the rule book of `RequestProject/Web/Engine.lean`, in JavaScript;
* a shell to play it on;
* and its content **as share codes**, the very strings
  `decodeShare_encodeShare` is about.

So the page boots through the same door a pasted pack comes in by: there is no
privileged built-in content, and a pack a player pastes is on exactly the same
footing as the pack the page shipped with.

The builds differ only in how much content they carry and whether the extras
(help, the pack editor, the proved playthrough) are included, which is what
makes the small ones small:

| build | packs | extras |
|---|---|---|
| `tinyPage` | tiny | no |
| `corePage` | core | no |
| `workshopPage` | core, workshop | no |
| `farmPage` | core, workshop, farm | yes |
| `waterPage` | core, water | yes |
| `maxPage` | all five | yes |

`node web/packs-test.mjs` checks the JavaScript against the Lean it mirrors:
that the page's decoder reads the emitted share codes back to the packs Lean
says they are, that its encoder reproduces those codes character for
character, and that its engine replays the proved playthrough move for move.
-/

namespace LifeTrac
namespace Modular

/-! ## The style sheet -/

/-- The look of the pages. -/
def modularCss : String := r####"<style>
 :root { color-scheme: dark }
 body { background:#141210; color:#e8e2d8; font:15px/1.45 "Iowan Old Style",Georgia,serif;
        margin:0 }
 #wrap { max-width:960px; margin:0 auto; padding:16px }
 h1 { font-size:20px; letter-spacing:.06em; text-transform:uppercase; margin:0 0 2px }
 h2 { font-size:17px; margin:16px 0 6px; border-bottom:1px solid #3a352d; padding-bottom:3px }
 .note { color:#9a9184; font-size:13px }
 #hud { display:flex; gap:16px; flex-wrap:wrap; background:#1e1b17; border:1px solid #3a352d;
        padding:8px 12px; margin:10px 0; font-variant-numeric:tabular-nums }
 #hud span { color:#c8a24a; font-weight:bold }
 #goal { background:#1a2a1a; border:1px solid #2f5030; padding:6px 10px; margin:8px 0 }
 #goal.done { background:#22331c; border-color:#6a8f3a; color:#d8e8b8 }
 button { font:inherit; background:#2b2721; color:#e8e2d8; border:1px solid #554d40;
          padding:3px 9px; margin:2px; cursor:pointer }
 button:hover:enabled { background:#3b352c }
 button:disabled { opacity:.35; cursor:not-allowed }
 nav button.on { background:#4a4136; border-color:#8a7a5a }
 table { border-collapse:collapse; width:100% }
 td,th { padding:3px 6px; border-bottom:1px solid #2a2620; text-align:left;
         font-variant-numeric:tabular-nums }
 th { color:#9a9184; font-weight:normal; font-size:13px }
 input,textarea,select { font:inherit; background:#100e0c; color:#e8e2d8;
          border:1px solid #554d40; padding:2px 4px }
 input.q { width:5em; text-align:right }
 textarea { width:100%; height:5.5em; font:12px/1.35 ui-monospace,Menlo,Consolas,monospace }
 .bom { color:#9a9184; font-size:12px }
 #log { max-height:180px; overflow:auto; font-size:13px; color:#b8b0a2 }
 .win { color:#c8e08a }
 .bad { color:#e0a08a }
</style>
"####

/-! ## The codec, in JavaScript

A transcription of `encodeShare` and `decodeShare`.  `web/packs-test.mjs`
checks the transcription against the Lean. -/

/-- The pack codec. -/
def codecJs : String := r####"
/* ---- the pack codec: a transcription of RequestProject/Web/Pack.lean ---- */
const KINDS = ["material", "part", "crop"];

function checksum(body) {
  let a = 7;
  for (let i = 0; i < body.length; i++) a = (a * 131 + body.charCodeAt(i)) % 1000003;
  return a;
}

function b64enc(s) {
  if (typeof btoa === "function") return btoa(s);
  return Buffer.from(s, "binary").toString("base64");
}
function b64dec(s) {
  if (typeof atob === "function") return atob(s);
  return Buffer.from(s, "base64").toString("binary");
}

function encInt(x) { return String(x); }
function decInt(s) {
  if (!/^-?[0-9]+$/.test(s)) return null;
  if (s === "-") return null;
  return BigInt(s);
}
function decNat(s) { return /^[0-9]+$/.test(s) ? BigInt(s) : null; }

function itemFields(i) {
  const f = [i.id, i.name, String(KINDS.indexOf(i.kind)), i.unit,
             encInt(i.price), encInt(i.salvage), encInt(i.days), encInt(i.revenue)];
  for (const p of i.inputs) { f.push(p.k); f.push(encInt(p.v)); }
  return f;
}

function encodeBody(p) {
  const recs = [["LTPACK", p.id, p.title, String(p.version), p.goalItem, encInt(p.goalCash)]];
  for (const i of p.items) recs.push(itemFields(i));
  return recs.map(r => r.join("|")).join("\n");
}

function encodeShare(p) {
  const body = encodeBody(p);
  return "LTP1." + b64enc(body) + "." + String(checksum(body));
}

function decItem(f) {
  if (f.length < 8) return null;
  const kind = decNat(f[2]);
  if (kind === null || kind > 2n) return null;
  const nums = [decInt(f[4]), decInt(f[5]), decInt(f[6]), decInt(f[7])];
  if (nums.some(x => x === null)) return null;
  const rest = f.slice(8);
  if (rest.length % 2 !== 0) return null;
  const inputs = [];
  for (let k = 0; k < rest.length; k += 2) {
    const v = decInt(rest[k + 1]);
    if (v === null) return null;
    inputs.push({ k: rest[k], v: v });
  }
  return { id: f[0], name: f[1], kind: KINDS[Number(kind)], unit: f[3],
           price: nums[0], salvage: nums[1], days: nums[2], revenue: nums[3],
           inputs: inputs };
}

function decodeBody(body) {
  const recs = body.split("\n").map(r => r.split("|"));
  const h = recs[0];
  if (!h || h.length !== 6 || h[0] !== "LTPACK") return null;
  const v = decNat(h[3]);
  const cash = decInt(h[5]);
  if (v === null || cash === null) return null;
  const items = [];
  for (const r of recs.slice(1)) {
    const it = decItem(r);
    if (it === null) return null;
    items.push(it);
  }
  return { id: h[1], title: h[2], version: Number(v), goalItem: h[4], goalCash: cash,
           items: items };
}

function decodeShare(code) {
  const parts = String(code).trim().split(".");
  if (parts.length !== 3 || parts[0] !== "LTP1") return null;
  let body;
  try { body = b64dec(parts[1]); } catch (e) { return null; }
  if (!/^[0-9]+$/.test(parts[2])) return null;
  if (Number(parts[2]) !== checksum(body)) return null;
  return decodeBody(body);
}
"####

/-! ## The engine, in JavaScript

A transcription of `step`, `affords`, `need` and `payInputs`. -/

/-- The rule book. -/
def engineJs : String := r####"
/* ---- the engine: a transcription of RequestProject/Web/Engine.lean ---- */
const SCALE = 1000000n;

function findItem(w, id) { return w.find(i => i.id === id) || null; }

function loadPack(w, p) {
  return w.filter(i => !p.items.some(j => j.id === i.id)).concat(p.items);
}
function worldOf(ps) { return ps.reduce(loadPack, []); }

function qty(s, id) { const p = s.stock.find(x => x.k === id); return p ? p.v : 0n; }
function put(s, id, v) {
  return { cash: s.cash, day: s.day,
           stock: s.stock.filter(x => x.k !== id).concat([{ k: id, v: v }]) };
}
function add(s, id, d) { return put(s, id, qty(s, id) + d); }

function need(i, n, id) {
  let a = 0n;
  for (const p of i.inputs) if (p.k === id && p.v > 0n) a += n * p.v;
  return a;
}
function affords(s, i, n) {
  return i.inputs.every(p => p.v > 0n ? need(i, n, p.k) <= qty(s, p.k)
                                      : -p.v <= qty(s, p.k));
}
function payInputs(s, i, n) {
  return { cash: s.cash, day: s.day,
           stock: s.stock.map(p => ({ k: p.k, v: p.v - need(i, n, p.k) })) };
}

/* a move is {kind:"buy"|"sell"|"make"|"work", id, q} with q a BigInt */
function step(w, s, a) {
  const i = findItem(w, a.id);
  if (i === null) return null;
  if (a.kind === "buy") {
    if (!(a.q > 0n && i.kind === "material" && a.q * i.price <= s.cash)) return null;
    const t = { cash: s.cash - a.q * i.price, day: s.day, stock: s.stock };
    return add(t, a.id, a.q * SCALE);
  }
  if (a.kind === "sell") {
    if (!(a.q > 0n && i.kind === "material" && a.q * SCALE <= qty(s, a.id))) return null;
    const t = { cash: s.cash + a.q * i.salvage, day: s.day, stock: s.stock };
    return add(t, a.id, -(a.q * SCALE));
  }
  if (a.kind === "make") {
    if (!(i.kind === "part" && affords(s, i, 1n))) return null;
    const t = add(payInputs(s, i, 1n), a.id, SCALE);
    return { cash: s.cash + i.revenue, day: s.day + i.days, stock: t.stock };
  }
  if (a.kind === "work") {
    if (!(a.q > 0n && i.kind === "crop" && affords(s, i, a.q))) return null;
    const t = add(payInputs(s, i, a.q), a.id, a.q * SCALE);
    return { cash: s.cash + a.q * i.revenue, day: s.day + a.q * i.days, stock: t.stock };
  }
  return null;
}

function run(w, s, script) {
  for (const a of script) { s = step(w, s, a); if (s === null) return null; }
  return s;
}

function netWorth(w, s) {
  let a = s.cash * SCALE;
  for (const i of w) a += qty(s, i.id) * i.price;
  return a;
}
function won(goal, s) {
  return qty(s, goal.goalItem) >= SCALE && s.cash >= goal.goalCash;
}
const START = { cash: 15000000000n, day: 0n, stock: [] };
"####

/-! ## The shell -/

/-- The screens, the drawing and the event handlers. -/
def uiJs : String := r####"
/* ---- the shell ---- */
let W = [], PACKS = [], S = START, GOAL = null, LOG = [], PAST = [], SCREEN = 0, MSG = "";
const TABS = ["Yard", "Market", "Workbench", "Works", "Packs"];

function micro(x) { return Number(x) / 1e6; }
function money(x) { return micro(x).toLocaleString("en-GB",
  { minimumFractionDigits: 2, maximumFractionDigits: 2 }); }
function amount(x) { const v = micro(x);
  return v.toLocaleString("en-GB", { maximumFractionDigits: 3 }); }

function el(tag, attrs, kids) {
  const e = document.createElement(tag);
  if (attrs) for (const k in attrs) {
    if (k === "class") e.className = attrs[k];
    else if (k === "text") e.textContent = attrs[k];
    else if (k === "html") e.innerHTML = attrs[k];
    else if (k === "onclick") e.onclick = attrs[k];
    else e.setAttribute(k, attrs[k]);
  }
  for (const c of (kids || [])) e.appendChild(c);
  return e;
}
function btn(label, enabled, fn) {
  const b = el("button", { text: label, onclick: fn });
  b.disabled = !enabled;
  return b;
}
function qtyOf(id, dflt) {
  const v = document.getElementById(id);
  if (!v) return BigInt(dflt);
  const n = parseInt(v.value, 10);
  return Number.isFinite(n) ? BigInt(n) : 0n;
}

function describe(a) {
  const i = findItem(W, a.id);
  const nm = i ? i.name : a.id;
  if (a.kind === "buy") return "buy " + a.q + " " + (i ? i.unit : "") + " of " + nm;
  if (a.kind === "sell") return "sell " + a.q + " " + (i ? i.unit : "") + " of " + nm;
  if (a.kind === "make") return "fabricate the " + nm;
  return "work " + a.q + " " + (i ? i.unit : "") + " of " + nm;
}

function commit(a) {
  const t = step(W, S, a);
  if (t === null) { MSG = "the rule book refuses that move"; draw(); return false; }
  PAST.push(S); S = t; LOG.push(describe(a)); MSG = "";
  draw();
  return true;
}
function undo() { if (PAST.length) { S = PAST.pop(); LOG.pop(); MSG = ""; draw(); } }

function setPacks(ps) {
  PACKS = ps;
  W = worldOf(PACKS);
  GOAL = PACKS.length ? PACKS[PACKS.length - 1] : null;
}
function reset() { S = START; LOG = []; PAST = []; MSG = ""; draw(); }

function addPack(code) {
  const p = decodeShare(code);
  if (p === null) { MSG = "that is not a pack code, or it did not survive the trip"; draw(); return; }
  setPacks(PACKS.filter(q => q.id !== p.id).concat([p]));
  MSG = "loaded " + p.title + " (" + p.items.length + " items)";
  draw();
}

/* ---- the screens ---- */

function hud() {
  const h = document.getElementById("hud");
  h.innerHTML =
    "<div>cash <span>" + money(S.cash) + "</span></div>" +
    "<div>day <span>" + micro(S.day).toFixed(3) + "</span></div>" +
    "<div>net worth <span>" + money(netWorth(W, S) / SCALE) + "</span></div>" +
    "<div>items <span>" + W.length + "</span></div>" +
    "<div>packs <span>" + PACKS.length + "</span></div>";
  const g = document.getElementById("goal");
  if (!GOAL) { g.textContent = "no pack is loaded"; return; }
  const it = findItem(W, GOAL.goalItem);
  const done = won(GOAL, S);
  g.className = done ? "done" : "";
  g.innerHTML = done
    ? "<b>Won.</b> " + (it ? it.name : GOAL.goalItem) + " is in the yard and you hold " +
      money(S.cash) + ", on day " + micro(S.day).toFixed(3) + "."
    : "<b>Goal (" + GOAL.title + ")</b>: put " + (it ? it.name : GOAL.goalItem) +
      " in the yard and hold " + money(GOAL.goalCash) + ". You have " +
      amount(qty(S, GOAL.goalItem)) + " and " + money(S.cash) + ".";
}

function drawNav() {
  const n = document.getElementById("nav");
  n.innerHTML = "";
  TABS.forEach((t, k) => {
    const b = btn(t, true, () => { SCREEN = k; MSG = ""; draw(); });
    if (k === SCREEN) b.className = "on";
    n.appendChild(b);
  });
  n.appendChild(btn("undo", PAST.length > 0, undo));
  n.appendChild(btn("restart", true, reset));
  n.appendChild(btn("save", true, saveGame));
  n.appendChild(btn("load", true, loadGame));
}

function table(head) {
  const t = el("table");
  t.appendChild(el("tr", null, head.map(h => el("th", { text: h }))));
  return t;
}
function row(cells) {
  return el("tr", null, cells.map(c =>
    el("td", null, typeof c === "string" ? [document.createTextNode(c)] : [c])));
}
function bomText(i) {
  if (!i.inputs.length) return "";
  return i.inputs.map(p => {
    const j = findItem(W, p.k);
    const nm = j ? j.name : p.k;
    return (p.v < 0n ? "needs " + nm : amount(p.v) + " " + (j ? j.unit : "") + " " + nm);
  }).join(", ");
}

function drawYard() {
  const d = document.getElementById("screen");
  d.appendChild(el("h2", { text: "Yard" }));
  const owned = W.filter(i => i.kind !== "material" && qty(S, i.id) > 0n);
  if (!owned.length) d.appendChild(el("div", { class: "note", text: "The yard is empty." }));
  else {
    const t = table(["standing in the yard", "how many"]);
    for (const i of owned) t.appendChild(row([i.name, amount(qty(S, i.id))]));
    d.appendChild(t);
  }
  const shelf = W.filter(i => i.kind === "material" && qty(S, i.id) > 0n);
  if (shelf.length) {
    const t = table(["on the shelf", "quantity", "worth"]);
    for (const i of shelf)
      t.appendChild(row([i.name, amount(qty(S, i.id)) + " " + i.unit,
        money(qty(S, i.id) * i.price / SCALE)]));
    d.appendChild(t);
  }
}

function drawMarket() {
  const d = document.getElementById("screen");
  d.appendChild(el("h2", { text: "Market" }));
  const t = table(["material", "unit", "price", "salvage", "on the shelf", "", ""]);
  for (const i of W.filter(x => x.kind === "material")) {
    const inp = el("input", { class: "q", id: "q" + i.id, value: "1" });
    const buy = btn("buy", true, () => commit({ kind: "buy", id: i.id, q: qtyOf("q" + i.id, 1) }));
    const sell = btn("sell", qty(S, i.id) > 0n,
      () => commit({ kind: "sell", id: i.id, q: qtyOf("q" + i.id, 1) }));
    t.appendChild(row([i.name, i.unit, money(i.price), money(i.salvage),
      amount(qty(S, i.id)), inp, el("span", null, [buy, sell])]));
  }
  d.appendChild(t);
}

function drawWorkbench() {
  const d = document.getElementById("screen");
  d.appendChild(el("h2", { text: "Workbench" }));
  const t = table(["assembly", "days", "built", "bill of materials", ""]);
  for (const i of W.filter(x => x.kind === "part")) {
    t.appendChild(row([i.name, micro(i.days).toFixed(3), amount(qty(S, i.id)),
      el("span", { class: "bom", text: bomText(i) }),
      btn("fabricate", affords(S, i, 1n), () => commit({ kind: "make", id: i.id }))]));
  }
  d.appendChild(t);
}

function drawWorks() {
  const d = document.getElementById("screen");
  d.appendChild(el("h2", { text: "Works" }));
  const t = table(["work", "unit", "days each", "pays", "needs", "done", "", ""]);
  for (const i of W.filter(x => x.kind === "crop")) {
    const inp = el("input", { class: "q", id: "a" + i.id, value: "1" });
    t.appendChild(row([i.name, i.unit, micro(i.days).toFixed(5), money(i.revenue),
      el("span", { class: "bom", text: bomText(i) }), amount(qty(S, i.id)), inp,
      btn("work", affords(S, i, 1n),
          () => commit({ kind: "work", id: i.id, q: qtyOf("a" + i.id, 1) }))]));
  }
  d.appendChild(t);
}

function drawPacks() {
  const d = document.getElementById("screen");
  d.appendChild(el("h2", { text: "Packs" }));
  d.appendChild(el("div", { class: "note", html:
    "A pack is a line of text.  Paste one below to load it; press <i>copy code</i> " +
    "to put one on the clipboard and send it to somebody.  A pack loaded last " +
    "sets the goal, and an item whose key is already in the catalogue replaces it." }));
  const t = table(["pack", "items", "version", "goal", ""]);
  for (const p of PACKS) {
    const code = encodeShare(p);
    t.appendChild(row([p.title, String(p.items.length), String(p.version), p.goalItem,
      el("span", null, [
        btn("copy code", true, () => copyText(code)),
        btn("show", true, () => { document.getElementById("paste").value = code; }),
        btn("unload", PACKS.length > 1, () => {
          setPacks(PACKS.filter(q => q.id !== p.id)); MSG = "unloaded " + p.title; draw();
        })])]));
  }
  d.appendChild(t);
  const ta = el("textarea", { id: "paste", placeholder: "paste a pack code here (LTP1....)" });
  d.appendChild(ta);
  d.appendChild(el("div", null, [
    btn("load pasted pack", true, () => addPack(document.getElementById("paste").value)),
    btn("clear", true, () => { document.getElementById("paste").value = ""; })]));
}

function copyText(s) {
  if (navigator.clipboard) navigator.clipboard.writeText(s).then(
    () => { MSG = "copied " + s.length + " characters"; draw(); },
    () => { MSG = "could not copy; the code is in the box"; draw(); });
  const box = document.getElementById("paste");
  if (box) box.value = s;
}

function stateCode() {
  const body = "LTS1|" + S.cash + "|" + S.day + "|" +
    S.stock.map(p => p.k + ":" + p.v).join(",");
  return "LTS1." + b64enc(body) + "." + String(checksum(body));
}
function readState(code) {
  const parts = String(code).trim().split(".");
  if (parts.length !== 3 || parts[0] !== "LTS1") return null;
  let body; try { body = b64dec(parts[1]); } catch (e) { return null; }
  if (Number(parts[2]) !== checksum(body)) return null;
  const f = body.split("|");
  if (f.length !== 4 || f[0] !== "LTS1") return null;
  const stock = f[3].length ? f[3].split(",").map(x => {
    const kv = x.split(":");
    return { k: kv[0], v: BigInt(kv[1]) };
  }) : [];
  return { cash: BigInt(f[1]), day: BigInt(f[2]), stock: stock };
}
function saveGame() {
  const code = stateCode();
  try { localStorage.setItem("lifetrac-save", code); } catch (e) {}
  MSG = "saved; the save code is in the paste box on the Packs screen";
  const box = document.getElementById("paste");
  if (box) box.value = code;
  draw();
}
function loadGame() {
  let code = null;
  const box = document.getElementById("paste");
  if (box && box.value.trim().startsWith("LTS1.")) code = box.value;
  if (!code) { try { code = localStorage.getItem("lifetrac-save"); } catch (e) {} }
  const t = code ? readState(code) : null;
  if (t === null) { MSG = "no save to load"; draw(); return; }
  PAST.push(S); S = t; MSG = "loaded a save"; draw();
}

function drawLog() {
  const l = document.getElementById("log");
  l.innerHTML = LOG.length
    ? LOG.map((x, i) => (i + 1) + ". " + x).slice(-40).join("<br>")
    : "<span class='note'>nothing done yet</span>";
  document.getElementById("msg").textContent = MSG;
}

function draw() {
  hud(); drawNav();
  const d = document.getElementById("screen");
  d.innerHTML = "";
  if (SCREEN === 0) drawYard();
  else if (SCREEN === 1) drawMarket();
  else if (SCREEN === 2) drawWorkbench();
  else if (SCREEN === 3) drawWorks();
  else if (SCREEN === 4) drawPacks();
  else drawExtra();
  drawLog();
}

function boot() {
  const ps = [];
  for (const code of BUILTIN) {
    const p = decodeShare(code);
    if (p !== null) ps.push(p);
  }
  setPacks(ps);
  reset();
}
"####

/-! ## The extras, in the larger builds -/

/-- The help screen, the pack editor and the proved playthrough. -/
def extrasJs : String := r####"
/* ---- extras ---- */
TABS.push("Editor");
TABS.push("Help");

let DRAFT = { id: "mypack", title: "my pack", version: 1, goalItem: "", goalCash: 0n,
              items: [] };

function fieldRow(label, id, value) {
  return row([label, el("input", { id: id, value: value, size: "40" })]);
}
function fv(id) { const e = document.getElementById(id); return e ? e.value.trim() : ""; }

function drawEditor() {
  const d = document.getElementById("screen");
  d.appendChild(el("h2", { text: "Editor" }));
  d.appendChild(el("div", { class: "note", html:
    "Build a pack of your own, then press <i>make code</i> and send the line to " +
    "somebody.  Quantities and money are in whole units here and are scaled by a " +
    "million on the way in, exactly as the tables of the shipped packs are.  " +
    "A negative input quantity means <i>a tool that must be owned but is not " +
    "used up</i>." }));
  const t = table(["field", "value"]);
  t.appendChild(fieldRow("pack key", "e_pid", DRAFT.id));
  t.appendChild(fieldRow("pack title", "e_ptitle", DRAFT.title));
  t.appendChild(fieldRow("goal item key", "e_pgoal", DRAFT.goalItem));
  t.appendChild(fieldRow("goal cash", "e_pcash", String(DRAFT.goalCash / SCALE)));
  d.appendChild(t);
  const t2 = table(["item field", "value"]);
  t2.appendChild(fieldRow("key", "e_id", ""));
  t2.appendChild(fieldRow("name", "e_name", ""));
  const sel = el("select", { id: "e_kind" });
  for (const k of KINDS) sel.appendChild(el("option", { value: k, text: k }));
  t2.appendChild(row(["kind", sel]));
  t2.appendChild(fieldRow("unit", "e_unit", "each"));
  t2.appendChild(fieldRow("price", "e_price", "0"));
  t2.appendChild(fieldRow("salvage", "e_salvage", "0"));
  t2.appendChild(fieldRow("days", "e_days", "0"));
  t2.appendChild(fieldRow("pays", "e_revenue", "0"));
  t2.appendChild(fieldRow("inputs (key:qty, ...)", "e_inputs", ""));
  d.appendChild(t2);
  d.appendChild(el("div", null, [
    btn("add item", true, addDraftItem),
    btn("make code", true, () => {
      readDraftHeader();
      const code = encodeShare(DRAFT);
      const box = document.getElementById("draftcode");
      box.value = code;
      MSG = "the pack code is " + code.length + " characters";
      drawLog();
    }),
    btn("load into the game", true, () => { readDraftHeader(); addPack(encodeShare(DRAFT)); }),
    btn("empty the draft", true, () => { DRAFT.items = []; draw(); })]));
  d.appendChild(el("textarea", { id: "draftcode", placeholder: "the code appears here" }));
  const t3 = table(["draft item", "kind", "price", "bill"]);
  for (const i of DRAFT.items)
    t3.appendChild(row([i.name + " (" + i.id + ")", i.kind, money(i.price),
      el("span", { class: "bom", text: i.inputs.map(p => p.k + ":" + amount(p.v)).join(", ") })]));
  d.appendChild(t3);
}

function scaled(s) {
  const v = Number(s);
  if (!Number.isFinite(v)) return 0n;
  return BigInt(Math.round(v * 1e6));
}
function readDraftHeader() {
  DRAFT.id = fv("e_pid") || "mypack";
  DRAFT.title = fv("e_ptitle") || "my pack";
  DRAFT.goalItem = fv("e_pgoal");
  DRAFT.goalCash = scaled(fv("e_pcash") || "0");
}
function addDraftItem() {
  readDraftHeader();
  const id = fv("e_id");
  if (!id) { MSG = "an item needs a key"; drawLog(); return; }
  const inputs = [];
  for (const part of fv("e_inputs").split(",")) {
    const s = part.trim();
    if (!s) continue;
    const kv = s.split(":");
    inputs.push({ k: kv[0].trim(), v: scaled(kv[1]) });
  }
  DRAFT.items = DRAFT.items.filter(i => i.id !== id).concat([{
    id: id, name: fv("e_name") || id, kind: document.getElementById("e_kind").value,
    unit: fv("e_unit") || "each", price: scaled(fv("e_price")),
    salvage: scaled(fv("e_salvage")), days: scaled(fv("e_days")),
    revenue: scaled(fv("e_revenue")), inputs: inputs }]);
  MSG = "the draft has " + DRAFT.items.length + " items";
  draw();
}

function drawHelp() {
  const d = document.getElementById("screen");
  d.appendChild(el("h2", { text: "Help" }));
  d.appendChild(el("div", { html:
    "<p>You start with 15 000 and an empty shed.  Buy material at the market, " +
    "fabricate assemblies at the workbench when their bill of materials is on " +
    "the shelf, and work the land — or a machine — for money.  A button is live " +
    "exactly when the rule book accepts the move behind it.</p>" +
    "<p>Everything on these screens comes from the <b>packs</b> the page has " +
    "loaded, and every pack is a line of text.  The pages ship their own content " +
    "as pack codes and read them at boot through the same decoder a pasted pack " +
    "goes through, so there is nothing privileged about the game you were given: " +
    "retune a price, add a machine, set a new goal, and send the line to a " +
    "friend.</p>" +
    "<p>The rule book, the codec and the content are generated from a Lean " +
    "development that proves, among other things, that a pack encoded to a code " +
    "and decoded again is the pack you started with, that no move can put you " +
    "into debt or leave a negative quantity on the shelf, and that the games " +
    "shipped here can in fact be won — the <i>play the proved line</i> button " +
    "below replays the winning line the proof exhibits.</p>" }));
  d.appendChild(el("div", null, [
    btn("play the proved line", DEMO.length > 0, playDemo),
    btn("copy every loaded pack", true,
        () => copyText(PACKS.map(p => encodeShare(p)).join("\n")))]));
}

function playDemo() {
  reset();
  let n = 0;
  for (const a of DEMO) {
    const t = step(W, S, { kind: a[0], id: a[1], q: BigInt(a[2]) });
    if (t === null) break;
    PAST.push(S); S = t; LOG.push(describe({ kind: a[0], id: a[1], q: BigInt(a[2]) })); n++;
  }
  MSG = n + " moves of the proved line replayed";
  draw();
}

function drawExtra() {
  if (SCREEN === 5) drawEditor(); else drawHelp();
}
"####

/-- Without the extras there is still a sixth screen slot; keep the dispatcher
total. -/
def noExtrasJs : String := r####"
function drawExtra() { drawYard(); }
"####

/-! ## Assembling a page -/

/-- The packs a build ships, as the share codes the page boots from. -/
def builtinJs (ps : List Pack) : String :=
  "const BUILTIN = [\n" ++
  String.intercalate ",\n" (ps.map (fun p => "  \"" ++ encodeShare p ++ "\"")) ++
  "\n];\n"

/-- A move of a script, as the page's JavaScript writes it. -/
def actJs : Act → String
  | .buy id q => "[\"buy\",\"" ++ id ++ "\"," ++ toString q ++ "]"
  | .sell id q => "[\"sell\",\"" ++ id ++ "\"," ++ toString q ++ "]"
  | .make id => "[\"make\",\"" ++ id ++ "\",0]"
  | .work id q => "[\"work\",\"" ++ id ++ "\"," ++ toString q ++ "]"

/-- The proved playthrough, for the *play the proved line* button. -/
def demoJs (script : List Act) : String :=
  "const DEMO = [" ++ String.intercalate "," (script.map actJs) ++ "];\n"

/-- The body of a page: the head, the empty elements, and the script. -/
def page (title : String) (ps : List Pack) (script : List Act) (extras : Bool) : String :=
  "<!DOCTYPE html>\n<meta charset=\"utf-8\">\n<meta name=\"viewport\" " ++
  "content=\"width=device-width, initial-scale=1\">\n<title>" ++ title ++
  "</title>\n" ++ modularCss ++
  "<div id=\"wrap\">\n<h1>" ++ title ++ "</h1>\n" ++
  "<div class=\"note\">A modular game in one file: the rule book, the codec and " ++
  "the content are generated from a Lean development, and the content travels " ++
  "as text you can paste.</div>\n" ++
  "<div id=\"hud\"></div>\n<div id=\"goal\"></div>\n<nav id=\"nav\"></nav>\n" ++
  "<div id=\"screen\"></div>\n<div id=\"msg\" class=\"note\"></div>\n" ++
  "<h2>Log</h2>\n<div id=\"log\"></div>\n</div>\n<script>\n" ++
  codecJs ++ engineJs ++ builtinJs ps ++ demoJs script ++ uiJs ++
  (if extras then extrasJs else noExtrasJs) ++
  "\nboot();\n</script>\n"

/-- The smallest build there is: three items, so that the whole page — engine,
codec, shell and content — is as small as this game gets. -/
def tinyPage : String :=
  page "LifeTrac — tiny" [tinyPack] tinyDemo false

/-- The small build: the core pack alone. -/
def corePage : String :=
  page "LifeTrac — core" [corePack] coreDemo false

/-- The core game with the workshop. -/
def workshopPage : String :=
  page "LifeTrac — core and workshop" [corePack, workshopPack] coreDemo false

/-- Three packs, and the extras. -/
def farmPage : String :=
  page "LifeTrac — farm" [corePack, workshopPack, farmPack] coreDemo true

/-- The water-and-sun build: the core pack and the stall, playing for the
water computer. -/
def waterPage : String :=
  page "LifeTrac — water and sun" [corePack, waterPack] waterDemo true

/-- **The big one**: every pack including the stall, every screen. -/
def maxPage : String :=
  page "LifeTrac — the whole homestead" maxPacks bigDemo true

end Modular
end LifeTrac
