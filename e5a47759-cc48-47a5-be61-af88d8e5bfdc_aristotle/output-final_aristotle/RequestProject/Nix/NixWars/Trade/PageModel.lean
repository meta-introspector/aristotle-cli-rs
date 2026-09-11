import RequestProject.Nix.NixWars.Trade.PageData
import RequestProject.Nix.NixWars.Gl
import RequestProject.Nix.NixWars.Mobile

/-!
# The merged room's model and checks, in JavaScript

The half of `www/frontier-voxel.html` that is a model rather than a page: the
market, the flight, the shipyard, the token registry, the tape and the sync,
written out as JavaScript, and the checks that replay them against the Lean
values.  `Page.lean` wraps these in the room itself; the two files are split
only so that neither is unmanageably long.
-/

set_option maxRecDepth 100000

namespace NixWars
namespace Trade
namespace Page

/-! ## The model: the market, the flight, the yard and the tape, in JavaScript -/

/-- The page's own implementation of everything Lean proved about. -/
def modelJs : String := r##"
// ---- the market ---------------------------------------------------------
const NUMGOODS = GOODS.length, NUMPORTS = PORTS.length;
function price(g, q) { return Math.floor(BASE[g] * (2 * STOCKREF) / (q + STOCKREF)); }
function stockOf(st, g) { return (g < st.length ? st[g] : 0) || 0; }
function setStock(st, g, v) { const o = st.slice(); if (g < o.length) o[g] = v; return o; }
function addStock(st, g, n) { return setStock(st, g, stockOf(st, g) + n); }
function subStock(st, g, n) { return setStock(st, g, Math.max(0, stockOf(st, g) - n)); }
function initialEconomy() { return { stocks: PORTS.map(p => p.start.slice()), round: 0 }; }
function warehouse(e, i) { return i < e.stocks.length ? e.stocks[i] : []; }
function stockAt(e, i, g) { return stockOf(warehouse(e, i), g); }
function priceAt(e, i, g) { return price(g, stockAt(e, i, g)); }
function priceBoard(e) {
  const out = [];
  for (let i = 0; i < NUMPORTS; i++) {
    const row = [];
    for (let g = 0; g < NUMGOODS; g++) row.push(priceAt(e, i, g));
    out.push(row);
  }
  return out;
}
function econSet(e, i, st) {
  const s = e.stocks.map(x => x.slice());
  if (i < s.length) s[i] = st;
  return { stocks: s, round: e.round };
}
function econBuy(e, i, g) { return econSet(e, i, subStock(warehouse(e, i), g, 1)); }
function econSell(e, i, g) { return econSet(e, i, addStock(warehouse(e, i), g, 1)); }
function portTick(p, st) {
  if (!p.inputs.every(g => RATE <= stockOf(st, g))) return st;
  let s = st;
  for (const g of p.inputs) s = subStock(s, g, RATE);
  return addStock(s, p.out, RATE);
}
function tick(e) {
  return { stocks: PORTS.map((p, i) => portTick(p, warehouse(e, i))), round: e.round + 1 };
}
function cargoValue(e, i, hold) {
  let v = 0;
  for (let g = 0; g < NUMGOODS; g++) v += stockOf(hold, g) * priceAt(e, i, g);
  return v;
}
// the production circuit, as a reachability question
function flowFrom(g, n) {
  let S = [g];
  for (let k = 0; k < n; k++) {
    const T = S.slice();
    for (const p of PORTS) if (p.inputs.some(x => S.includes(x)) && !T.includes(p.out)) T.push(p.out);
    S = T;
  }
  return S;
}

// ---- the shipyard -------------------------------------------------------
const NOPART = { slot: 0, name: "", mass: 0, cost: 0, frame: 0, thrust: 0, tank: 0, hold: 0 };
function slotParts(k) { return PARTS.filter(p => p.slot === k); }
function slotPart(k, i) { const l = slotParts(k); return i < l.length ? l[i] : NOPART; }
function specParts(s) {
  return [slotPart(0, s.hull), slotPart(1, s.engine), slotPart(2, s.tank),
          slotPart(3, s.hold), slotPart(4, s.livery)];
}
function shipStats(s) {
  const ps = specParts(s);
  return { maxSpeed: Math.min(ps[1].thrust, ps[0].thrust),
           tank: ps[0].tank + ps[2].tank, hold: ps[0].hold + ps[3].hold,
           mass: ps.reduce((a, p) => a + p.mass, 0),
           cost: ps.reduce((a, p) => a + p.cost, 0) };
}
function shipOk(s) {
  const st = shipStats(s);
  return s.hull < 3 && s.engine < 4 && s.tank < 3 && s.hold < 3 && s.livery < 4 && s.hue < 360
    && st.mass <= slotPart(0, s.hull).frame && st.maxSpeed >= 1;
}
function encodeSpec(s) {
  return ((((s.hull * 4 + s.engine) * 3 + s.tank) * 3 + s.hold) * 4 + s.livery) * 360 + s.hue;
}
function decodeSpec(nm, n) {
  return { name: nm, hue: n % 360, livery: Math.floor(n / 360) % 4,
           hold: Math.floor(n / 1440) % 3, tank: Math.floor(n / 4320) % 3,
           engine: Math.floor(n / 12960) % 4, hull: Math.floor(n / 51840) };
}

// ---- the flight ---------------------------------------------------------
function newVoyage(spec) {
  const st = shipStats(spec);
  return { x: 0, y: 0, z: 0, hdg: 0, speed: 0, fuel: st.tank, docked: 1, credits: 400,
           hold: [0, 0, 0, 0, 0], econ: initialEconomy(), shipCode: encodeSpec(spec),
           maxSpeed: st.maxSpeed, tankCap: st.tank, holdCap: st.hold, turn: 0 };
}
function holdUsed(s) { return s.hold.reduce((a, b) => a + b, 0); }
function dockedAt(s) { return s.docked === 0 ? null : s.docked - 1; }
function voyAxis(i, c, h, d) {
  const m = BOX[i];
  if (h === 2 * i) return (c + d) % m;
  if (h === 2 * i + 1) return (c + (m - d % m)) % m;
  return c;
}
function portHere(x, y, z) {
  for (let i = 0; i < PORTS.length; i++) {
    const c = PORTS[i].cell;
    if (c[0] === x && c[1] === y && c[2] === z) return i;
  }
  return null;
}
function cloneVoyage(s) {
  return Object.assign({}, s, { hold: s.hold.slice(),
    econ: { stocks: s.econ.stocks.map(a => a.slice()), round: s.econ.round } });
}
// commands are numbers, exactly as Journal.encodeCmd writes them
function step(s, cmd) {
  const t = cloneVoyage(s);
  t.turn = s.turn + 1;
  if (cmd >= 10 && cmd <= 15) { const h = cmd - 10; if (h <= 5) t.hdg = h; return t; }
  if (cmd === 1) { if (s.docked === 0 && s.speed < s.maxSpeed) t.speed = s.speed + 1; return t; }
  if (cmd === 2) { t.speed = Math.max(0, s.speed - 1); return t; }
  if (cmd === 3) {
    if (s.docked === 0 && s.speed <= s.fuel) {
      t.x = voyAxis(0, s.x, s.hdg, s.speed);
      t.y = voyAxis(1, s.y, s.hdg, s.speed);
      t.z = voyAxis(2, s.z, s.hdg, s.speed);
      t.fuel = s.fuel - s.speed;
    }
    t.econ = tick(s.econ);
    return t;
  }
  if (cmd === 4) {
    if (s.docked !== 0) { t.docked = 0; return t; }
    const i = portHere(s.x, s.y, s.z);
    if (i !== null) { t.docked = i + 1; t.speed = 0; }
    return t;
  }
  if (cmd >= 20 && cmd <= 24) {
    const g = cmd - 20, i = dockedAt(s);
    if (i === null) return t;
    if (g < NUMGOODS && priceAt(s.econ, i, g) <= s.credits && stockAt(s.econ, i, g) >= 1
        && holdUsed(s) < s.holdCap) {
      t.credits = s.credits - priceAt(s.econ, i, g);
      t.hold = addStock(s.hold, g, 1);
      t.econ = econBuy(s.econ, i, g);
    }
    return t;
  }
  if (cmd >= 30 && cmd <= 34) {
    const g = cmd - 30, i = dockedAt(s);
    if (i === null) return t;
    if (g < NUMGOODS && stockOf(s.hold, g) >= 1) {
      t.credits = s.credits + priceAt(s.econ, i, g);
      t.hold = subStock(s.hold, g, 1);
      t.econ = econSell(s.econ, i, g);
    }
    return t;
  }
  if (cmd === 5) {
    const i = dockedAt(s);
    if (i === null) return t;
    if (priceAt(s.econ, i, FUELGOOD) <= s.credits && stockAt(s.econ, i, FUELGOOD) >= 1
        && s.fuel + FUELPERUNIT <= s.tankCap) {
      t.credits = s.credits - priceAt(s.econ, i, FUELGOOD);
      t.fuel = s.fuel + FUELPERUNIT;
      t.econ = econBuy(s.econ, i, FUELGOOD);
    }
    return t;
  }
  t.econ = tick(s.econ);   // wait, and anything unrecognised
  return t;
}
function run(s, cmds) { let t = s; for (const c of cmds) t = step(t, c); return t; }
function summary(s) {
  return [s.x, s.y, s.z, s.hdg, s.speed, s.fuel, s.docked, s.credits, s.turn, s.econ.round]
    .concat(s.hold).concat(s.econ.stocks.reduce((a, b) => a.concat(b), []));
}
function voyageOk(s) {
  return s.x < BOX[0] && s.y < BOX[1] && s.z < BOX[2] && s.hdg <= 5 && s.speed <= s.maxSpeed
    && s.fuel <= s.tankCap && s.hold.length === NUMGOODS && holdUsed(s) <= s.holdCap
    && s.docked <= NUMPORTS;
}

// ---- the tape -----------------------------------------------------------
function mix(h, b) { return (h * HASH_BASE + b + 1) % HASH_PRIME; }
function hashNums(h, l) { let a = h; for (const b of l) a = mix(a, b); return a; }
function digest(s) {
  return [s.x, s.y, s.z, s.hdg, s.speed, s.fuel, s.docked, s.credits, s.shipCode,
          s.maxSpeed, s.tankCap, s.holdCap, s.turn, s.econ.round]
    .concat(s.hold).concat(s.econ.stocks.reduce((a, b) => a.concat(b), []));
}
function logStart(l) { return newVoyage(decodeSpec("RECORDED", l.ship)); }
function logReplay(l) { return run(logStart(l), l.cmds); }
function logChain(l) {
  let s = logStart(l), h = hashNums(0, digest(s));
  const out = [];
  for (const c of l.cmds) { s = step(s, c); h = hashNums(h, [c].concat(digest(s))); out.push(h); }
  return out;
}
function logCommit(l) {
  const ch = logChain(l);
  return ch.length ? ch[ch.length - 1] : hashNums(0, digest(logStart(l)));
}
function encNat(n) {
  let out = "", v = n;
  while (v >= 64) { out += URL_TABLE[v % 64]; v = Math.floor(v / 64); }
  return out + URL_TABLE[v];
}
function saveLog(l) {
  return URL_PREFIX + [l.ship].concat(l.cmds).map(n => encNat(n) + ".").join("");
}
function loadLog(str) {
  if (str.slice(0, URL_PREFIX.length) !== URL_PREFIX) return null;
  const parts = str.slice(URL_PREFIX.length).split(".");
  parts.pop();
  const ns = [];
  for (const p of parts) {
    let v = 0, m = 1;
    for (const ch of p) {
      const d = URL_TABLE.indexOf(ch);
      if (d < 0) return null;
      v += d * m; m *= 64;
    }
    ns.push(v);
  }
  if (!ns.length) return null;
  return { ship: ns[0], cmds: ns.slice(1) };
}

// ---- the registry -------------------------------------------------------
function emptyYard() {
  return { tokens: [], next: 1, balances: new Array(NUMPLAYERS).fill(1000) };
}
function tokenOf(y, id) { return y.tokens.find(t => t.id === id) || null; }
function cloneYard(y) {
  return { tokens: y.tokens.map(t => Object.assign({}, t)), next: y.next,
           balances: y.balances.slice() };
}
function mint(y, owner, spec) {
  if (!shipOk(spec) || owner >= NUMPLAYERS) return y;
  const z = cloneYard(y);
  z.tokens.push({ id: y.next, code: encodeSpec(spec), name: spec.name, owner: owner, ask: 0 });
  z.next = y.next + 1;
  return z;
}
function listToken(y, id, who, ask) {
  const t = tokenOf(y, id);
  if (!t || t.owner !== who) return y;
  const z = cloneYard(y);
  for (const u of z.tokens) if (u.id === id) u.ask = ask;
  return z;
}
function buyToken(y, id, buyer) {
  const t = tokenOf(y, id);
  if (!t) return y;
  if (!(t.ask >= 1 && buyer < NUMPLAYERS && t.owner !== buyer && t.ask <= y.balances[buyer]))
    return y;
  const z = cloneYard(y);
  for (const u of z.tokens) if (u.id === id) { u.owner = buyer; u.ask = 0; }
  z.balances[buyer] -= t.ask;
  z.balances[t.owner] += t.ask;
  return z;
}
function giftToken(y, id, who, dest) {
  const t = tokenOf(y, id);
  if (!t || t.owner !== who || dest >= NUMPLAYERS) return y;
  const z = cloneYard(y);
  for (const u of z.tokens) if (u.id === id) { u.owner = dest; u.ask = 0; }
  return z;
}
function swapTokens(y, id1, id2) {
  const t1 = tokenOf(y, id1), t2 = tokenOf(y, id2);
  if (!t1 || !t2 || id1 === id2) return y;
  const z = cloneYard(y);
  for (const u of z.tokens) {
    if (u.id === id1) { u.owner = t2.owner; u.ask = 0; }
    else if (u.id === id2) { u.owner = t1.owner; u.ask = 0; }
  }
  return z;
}
function fingerprint(spec) { return hashNums(0, [encodeSpec(spec), 71]); }

// ---- the sync -----------------------------------------------------------
function firstDiff(as, bs) {
  let i = 0;
  while (i < as.length && i < bs.length && as[i] === bs[i]) i++;
  return i;
}
function isPrefix(as, bs) {
  return as.length <= bs.length && as.every((v, i) => v === bs[i]);
}
function syncLogs(mine, theirs) {
  if (mine.ship !== theirs.ship) return { kind: "otherShip", at: 0 };
  if (mine.cmds.length === theirs.cmds.length && isPrefix(mine.cmds, theirs.cmds))
    return { kind: "inSync", at: 0 };
  if (isPrefix(mine.cmds, theirs.cmds)) return { kind: "fastForward", at: mine.cmds.length };
  if (isPrefix(theirs.cmds, mine.cmds)) return { kind: "ahead", at: theirs.cmds.length };
  return { kind: "fork", at: firstDiff(mine.cmds, theirs.cmds) };
}
function acceptSealed(log, claim) { return logCommit(log) === claim ? log : null; }
function uucpRoute(i, j) {
  const hops = (j + UUCP_NODES - i % UUCP_NODES) % UUCP_NODES, out = [];
  for (let k = 0; k <= hops; k++) out.push((i + k) % UUCP_NODES);
  return out;
}
function sameVec(a, b) { return a.length === b.length && a.every((v, i) => v === b[i]); }
"##

/-! ## The checks -/

/-- Everything the page proves to itself before it lets anyone fly.  The
headless self-test runs exactly this. -/
def checksJs : String := r##"
function frontierChecks(check) {
  // --- the market is a market ---
  const e0 = initialEconomy();
  check("the price board matches Lean, round by round, for four production rounds",
    [0, 1, 2, 3].every(k => {
      let e = e0;
      for (let n = 0; n < k; n++) e = tick(e);
      return JSON.stringify(priceBoard(e)) === JSON.stringify(PRICE_BOARDS[k]);
    }));
  const ore = PRICE_BOARDS[0].map(r => r[0]);
  check("ORE alone is quoted at eight different prices: " + ore.join(" "),
    new Set(ore).size === 8);
  check("no two ports post the same board",
    new Set(PRICE_BOARDS[0].map(r => r.join(","))).size === 8);
  check("the board is different on each of the first four rounds",
    new Set(PRICE_BOARDS.map(b => JSON.stringify(b))).size === 4);
  const loads = PORTS.map((p, i) => cargoValue(e0, i, [5, 0, 0, 0, 2]));
  check("one load of five ORE and two RELICS is worth eight different sums: " + loads.join(" "),
    sameVec(loads, CARGO_VALUES) && new Set(loads).size === 8);
  check("a fuller shelf is never a dearer price",
    [0, 1, 2, 3, 4].every(g => [0, 1, 2, 3, 5, 8, 13, 30].every((q, k, a) =>
      k === 0 || price(g, a[k - 1]) >= price(g, q))));
  check("buying pushes the price up and selling pushes it down",
    priceAt(econBuy(e0, 0, 0), 0, 0) >= priceAt(e0, 0, 0)
      && priceAt(econSell(e0, 0, 0), 0, 0) <= priceAt(e0, 0, 0));
  // --- the circuit ---
  check("every good is made somewhere and eaten somewhere",
    [0, 1, 2, 3, 4].every(g => PORTS.some(p => p.out === g))
      && [0, 1, 2, 3, 4].every(g => PORTS.some(p => p.inputs.includes(g))));
  check("no port eats what it makes", PORTS.every(p => !p.inputs.includes(p.out)));
  check("the circuit is strongly connected: five conversions reach every good",
    [0, 1, 2, 3, 4].every(g => flowFrom(g, 5).length === 5));
  check("twelve conversions run on the map",
    CIRCUIT.length === 12 && PORTS.reduce((a, p) => a + p.inputs.length, 0) === 12);
  // --- the map is the voxel world ---
  check("the eight ports stand on eight different cells of the " + BOX.join(" x ") + " box",
    new Set(PORTS.map(p => p.cell.join(","))).size === 8
      && PORTS.every(p => p.cell[0] < BOX[0] && p.cell[1] < BOX[1] && p.cell[2] < BOX[2]));
  // --- the shipyard ---
  check("seventeen parts: three hulls, four engines, three tanks, three holds, four liveries",
    PARTS.length === 17 && [3, 4, 3, 3, 4].every((n, k) => slotParts(k).length === n));
  check("the six ships on the shelf have the statistics Lean reads off them",
    STOCK_SHIPS.every(s => {
      const st = shipStats(s);
      return sameVec([st.maxSpeed, st.tank, st.hold, st.mass, st.cost], s.stats);
    }));
  check("no two of them fly the same",
    new Set(STOCK_SHIPS.map(s => s.stats.join(","))).size === 6);
  check("a build survives the round trip through its number",
    STOCK_SHIPS.every(s => {
      const d = decodeSpec(s.name, s.code);
      return d.hull === s.hull && d.engine === s.engine && d.tank === s.tank
        && d.hold === s.hold && d.livery === s.livery && d.hue === s.hue
        && encodeSpec(d) === s.code;
    }));
  let legal = 0;
  for (let h = 0; h < 3; h++) for (let en = 0; en < 4; en++) for (let t = 0; t < 3; t++)
    for (let d = 0; d < 3; d++) for (let l = 0; l < 4; l++)
      if (shipOk({ hull: h, engine: en, tank: t, hold: d, livery: l, hue: 200 })) legal++;
  check("of " + ALL_BUILDS + " ways to bolt the parts together, " + LEGAL_BUILDS
    + " are legal ships", legal === LEGAL_BUILDS && 432 === ALL_BUILDS);
  check("no hull carries the heaviest engine with the biggest tank and hold",
    [0, 1, 2].every(h => [0, 1, 2, 3].every(l =>
      !shipOk({ hull: h, engine: 3, tank: 2, hold: 2, livery: l, hue: 200 }))));
  // --- the demo voyage, step by step against Lean ---
  const demo = { ship: DEMO_SHIP, cmds: DEMO_CMDS };
  let s = logStart(demo), bad = -1, illegal = -1;
  if (!sameVec(summary(s), DEMO_STATES[0])) bad = 0;
  if (!voyageOk(s)) illegal = 0;
  for (let i = 0; i < demo.cmds.length; i++) {
    s = step(s, demo.cmds[i]);
    if (bad < 0 && !sameVec(summary(s), DEMO_STATES[i + 1])) bad = i + 1;
    if (illegal < 0 && !voyageOk(s)) illegal = i + 1;
  }
  check("the whole " + demo.cmds.length + " command run matches the Lean state at every step",
    bad < 0);
  if (bad >= 0) check("  first disagreement at move " + bad, false);
  check("and the ship is inside the box, its tank and its hold at every step", illegal < 0);
  check("the run turns 400 credits into 478, docked at DIGSITE, hold empty",
    s.credits === 478 && s.docked === 5 && s.z === 23 && holdUsed(s) === 0);
  // --- the price is not always the same ---
  const fuelRun = [];
  let f = logStart(demo);
  for (let k = 0; k < 4; k++) {
    const before = f.credits;
    f = step(f, 20 + FUELGOOD);
    fuelRun.push(before - f.credits);
  }
  check("four units of FUEL bought one after another cost " + fuelRun.join(", ")
    + " credits", sameVec(fuelRun, [15, 16, 19, 21]));
  // --- the tape ---
  check("the hash chain is one hash per command and matches Lean",
    sameVec(logChain(demo), DEMO_CHAIN) && DEMO_CHAIN.length === demo.cmds.length);
  check("the " + DEMO_CHAIN.length + " hashes are all different",
    new Set(DEMO_CHAIN).size === DEMO_CHAIN.length);
  check("the commitment is the last of them", logCommit(demo) === DEMO_COMMIT);
  check("the saved game is the string Lean saves", saveLog(demo) === DEMO_SAVED);
  const back = loadLog(DEMO_SAVED);
  check("and it loads back exactly",
    back !== null && back.ship === demo.ship && sameVec(back.cmds, demo.cmds));
  check("a recording with one more move keeps every hash it already had",
    logChain({ ship: demo.ship, cmds: demo.cmds.concat([6]) }).slice(0, DEMO_CHAIN.length)
      .every((h, i) => h === DEMO_CHAIN[i]));
  check("a tampered tape does not verify",
    acceptSealed({ ship: demo.ship, cmds: demo.cmds.slice(0, 30).concat([6, 6, 6]) },
      DEMO_COMMIT) === null);
  check("an honest tape does", acceptSealed(demo, DEMO_COMMIT) !== null);
  // --- the registry ---
  let yard = emptyYard();
  for (const sp of STOCK_SHIPS) yard = mint(yard, 0, sp);
  check("six ships minted, serials 1 to 6, all player 0's",
    sameVec(yard.tokens.map(t => t.id), DEMO_YARD.tokens.map(t => t.id))
      && sameVec(yard.tokens.map(t => t.owner), DEMO_YARD.tokens.map(t => t.owner))
      && yard.next === DEMO_YARD.next);
  check("the six fingerprints are six different numbers",
    new Set(STOCK_SHIPS.map(s => s.print)).size === 6
      && STOCK_SHIPS.every(s => fingerprint(s) === s.print));
  const sale = buyToken(listToken(yard, 3, 0, 300), 3, 1);
  check("a sale moves the ship and the credits, and matches Lean",
    sameVec(sale.tokens.map(t => t.owner), DEMO_SALE.tokens.map(t => t.owner))
      && sameVec(sale.balances, DEMO_SALE.balances));
  check("no credits are created or destroyed by a sale",
    sale.balances.reduce((a, b) => a + b, 0) === yard.balances.reduce((a, b) => a + b, 0));
  check("a ship nobody offered cannot be bought",
    buyToken(yard, 3, 1).tokens.every((t, i) => t.owner === yard.tokens[i].owner));
  check("nor one the buyer cannot pay for",
    buyToken(listToken(yard, 3, 0, 5000), 3, 1).balances.every((b, i) => b === yard.balances[i]));
  const swap = swapTokens(sale, 3, 5);
  check("a swap is atomic: both ships change hands, and it matches Lean",
    sameVec(swap.tokens.map(t => t.owner), DEMO_SWAP.tokens.map(t => t.owner)));
  check("swapping twice is doing nothing",
    sameVec(swapTokens(swap, 3, 5).tokens.map(t => t.owner), sale.tokens.map(t => t.owner)));
  check("no operation creates or destroys a token",
    [sale, swap, giftToken(sale, 2, 0, 2)].every(y =>
      sameVec(y.tokens.map(t => t.id), yard.tokens.map(t => t.id))));
  // --- the sync ---
  const mine = demo, theirs = { ship: demo.ship, cmds: SYNC_THEIRS },
        other = { ship: demo.ship, cmds: SYNC_OTHER };
  check("my own game is in sync with itself", syncLogs(mine, mine).kind === "inSync");
  check("a player who has played on is a fast-forward",
    syncLogs(mine, theirs).kind === "fastForward");
  check("a player who is behind leaves me ahead", syncLogs(theirs, mine).kind === "ahead");
  check("a player flying another ship is not playing my game",
    syncLogs(mine, { ship: mine.ship + 1, cmds: mine.cmds }).kind === "otherShip");
  const fork = syncLogs(mine, other);
  check("a fork is found at move " + SYNC_FORK,
    fork.kind === "fork" && fork.at === SYNC_FORK);
  check("the two games agree up to the fork and differ at it",
    mine.cmds.slice(0, fork.at).every((c, i) => c === other.cmds[i])
      && mine.cmds[fork.at] !== other.cmds[fork.at]);
  check("taking their game keeps every hash of mine",
    logChain(theirs).slice(0, logChain(mine).length).every((h, i) => h === logChain(mine)[i]));
  const route = uucpRoute(0, 5);
  check("the UUCP bag reaches node 5 in " + (route.length - 1) + " hops, by " + UUCP_PATH,
    sameVec(route, UUCP_ROUTE) && route[route.length - 1] === 5 && route.length <= UUCP_NODES);
}
"##

end Page
end Trade
end NixWars
