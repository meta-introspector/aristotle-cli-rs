import RequestProject.Nix.NixWars.EmitData

/-!
# Emitting the single-page BBS

The whole browser app is generated from the Lean development: the transition
table (`stepIR`, proved equal to the game in `stepIR_correct`), the base-64
alphabet, the morse table, the numbers-station digits and the SLIP / PPP
framing constants are all printed from the definitions in this project. The
page carries a small evaluator for `Expr` and generic radix conversion; it
contains no hand-written copy of the game's rules.

The data itself is printed in `EmitData.lean`, as `emittedData`; this file is
the page it is wrapped in.

Evaluating this file writes `www/nixwars.html`, a self-contained page with no
network dependencies -- paste it into any static host.
-/

set_option maxRecDepth 100000

namespace NixWars

/-! ## The page -/

/-- Everything before the emitted data. -/
def pageHead : String := r#"<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>NIXWARS :: 8080 BBS</title>
<style>
:root { color-scheme: dark; }
body { background:#0b0f0b; color:#3cff5a; font-family:ui-monospace,Menlo,Consolas,monospace;
       margin:0; padding:1rem; font-size:14px; }
h1 { font-size:1.1rem; letter-spacing:.2em; border-bottom:1px solid #1d4d24; padding-bottom:.4rem; }
h2 { font-size:.8rem; letter-spacing:.18em; color:#8fffa5; margin:1.2rem 0 .3rem; }
pre { background:#060806; border:1px solid #1d4d24; padding:.6rem; overflow-x:auto;
      white-space:pre-wrap; word-break:break-all; margin:0; }
button { background:#0b190d; color:#3cff5a; border:1px solid #2f7a3a; padding:.35rem .7rem;
         font-family:inherit; cursor:pointer; margin:.15rem .2rem .15rem 0; }
button:hover { background:#14361a; }
input { background:#060806; color:#3cff5a; border:1px solid #2f7a3a; padding:.3rem;
        font-family:inherit; width:7rem; }
.grid { display:grid; grid-template-columns:repeat(auto-fit,minmax(320px,1fr)); gap:1rem; }
.small { color:#2aa843; font-size:.75rem; }
"#

/-- Everything from the end of the stylesheet to the opening of the script.
The joystick's styling, emitted by `Controls.controlsCss`, goes in between. -/
def pageHead2 : String := r#"</style>
</head>
<body>
<h1>NIXWARS &mdash; TRADEWARS 71 &mdash; STATELESS DOOR</h1>
<p class="small">Every byte of state lives in the URL. Share the URL, share the game.
Fifteen doors: NixWars, Monster Dash, the Shard Market, Legend of the Red Shard,
Hunt the Wumpus, a ZX81, the FRENS Tournament, the Combinator Tycoon, the Meme
Breeding Pool, 8D Hyperspace, the Provenance Oracle, the Assembly, and the three
cabinets of the arcade room: Monster Cubes, the Frontier Run and Shard
Invaders. Each is
stepped by a WebAssembly module emitted by the Lean development and proved to
compute that door's step function; the transition table it was compiled from is
carried too, and every move is checked against it. The ZX81's Z80 is emulated
here in JavaScript and checked against the checkpoints Lean computed from the
same ROMs.</p>
<script>
"#

/-- Everything after the emitted data. -/
def pageTail : String := r#"
// ---- evaluator for the emitted expressions (mirrors NixWars.Expr.eval) ----
function ev(e, st, arg) {
  switch (e[0]) {
    case "lit":  return e[1];
    case "fld":  return st[e[1]] || 0;
    case "arg":  return arg;
    case "add":  return ev(e[1],st,arg) + ev(e[2],st,arg);
    case "mul":  return ev(e[1],st,arg) * ev(e[2],st,arg);
    case "sub":  return Math.max(0, ev(e[1],st,arg) - ev(e[2],st,arg));   // truncated, as on Nat
    case "div":  return Math.floor(ev(e[1],st,arg) / ev(e[2],st,arg));
    case "le":   return ev(e[1],st,arg) <= ev(e[2],st,arg) ? 1 : 0;
    case "cond": return ev(e[1],st,arg) !== 0 ? ev(e[2],st,arg) : ev(e[3],st,arg);
  }
  throw new Error("bad expression");
}

// ---- the WebAssembly module emitted by Lean ----
// WASM is the byte-for-byte content of nixwars.wasm, produced by
// NixWars.Wasm.wasmBytes: one module for the whole board. Calling
// <door>_<cmd> on (arg, ...state fields) returns the successor state;
// wasm_step_correct and wasm_dash_step_correct prove that it is the game's.
let WEXPORTS = null, WERR = null;
try {
  const mod = new WebAssembly.Module(new Uint8Array(WASM));
  WEXPORTS = new WebAssembly.Instance(mod, {}).exports;
} catch (err) { WERR = String(err); }

function wasmStep(doorName, tag, st, arg) {
  return Array.from(WEXPORTS[doorName + "_" + tag](arg, ...st));
}

// self-test: the module against the vectors Lean computed from the table
function selfTest() {
  if (!WEXPORTS) return { ok: 0, total: WVEC.length, note: "no wasm: " + WERR };
  let ok = 0;
  for (const [doorName, tag, arg, st, want] of WVEC) {
    const got = wasmStep(doorName, tag, st, arg);
    if (got.length === want.length && got.every((x, i) => x === want[i])) ok++;
  }
  return { ok: ok, total: WVEC.length, note: "" };
}

// ---- the ZX81 (mirrors NixWars.Zx81.decode / NixWars.Zx81.exec) ----
// The door's state is just [rom, cycles]; the machine it denotes is
// NixWars.machine, which boots the ROM and runs that many Z80 cycles. So the
// whole emulator rides in the URL as two numbers.
function zxBoot(rom) {
  const bytes = ZX.roms[rom] || ZX.roms[0];
  const mem = new Array(ZX.memSize).fill(0);
  for (let i = 0; i < bytes.length && i < ZX.memSize; i++) mem[i] = bytes[i];
  return { a:0, b:0, c:0, h:0, l:0, pc:0, zf:false, halted:false, mem:mem };
}
function zxStep(s) {
  if (s.halted) return s;
  const M = ZX.memSize;
  const rd = a => s.mem[a % M];
  const op = rd(s.pc), n = rd(s.pc + 1), m = rd(s.pc + 2);
  const bump = k => (s.pc + k) % M;
  const jr = (base, e) => (base + e) % M;          // 256-byte space: e is signed
  const hl = () => (s.h * 256 + s.l) % M;
  const flag = v => { s.zf = (v === 0); return v; };
  switch (op) {
    case 0x00: s.pc = bump(1); break;                                    // NOP
    case 0x3E: s.a = n % 256; s.pc = bump(2); break;                     // LD A,n
    case 0x06: s.b = n % 256; s.pc = bump(2); break;                     // LD B,n
    case 0x0E: s.c = n % 256; s.pc = bump(2); break;                     // LD C,n
    case 0x21: s.l = n % 256; s.h = m % 256; s.pc = bump(3); break;      // LD HL,nn
    case 0x23: { const v = (s.h * 256 + s.l + 1) % 65536;                // INC HL
                 s.h = Math.floor(v / 256); s.l = v % 256; s.pc = bump(1); break; }
    case 0x3C: s.a = flag((s.a + 1) % 256); s.pc = bump(1); break;       // INC A
    case 0x3D: s.a = flag((s.a + 255) % 256); s.pc = bump(1); break;     // DEC A
    case 0x04: s.b = flag((s.b + 1) % 256); s.pc = bump(1); break;       // INC B
    case 0x05: s.b = flag((s.b + 255) % 256); s.pc = bump(1); break;     // DEC B
    case 0x0C: s.c = flag((s.c + 1) % 256); s.pc = bump(1); break;       // INC C
    case 0x77: s.mem[hl()] = s.a % 256; s.pc = bump(1); break;           // LD (HL),A
    case 0x7E: s.a = rd(hl()); s.pc = bump(1); break;                    // LD A,(HL)
    case 0x79: s.a = s.c % 256; s.pc = bump(1); break;                   // LD A,C
    case 0x80: s.a = flag((s.a + s.b) % 256); s.pc = bump(1); break;     // ADD A,B
    case 0x81: s.a = flag((s.a + s.c) % 256); s.pc = bump(1); break;     // ADD A,C
    case 0x90: s.a = flag((s.a + 256 - s.b % 256) % 256); s.pc = bump(1); break;  // SUB B
    case 0x10: { const v = (s.b + 255) % 256; s.b = flag(v);             // DJNZ e
                 s.pc = (v === 0) ? bump(2) : jr(bump(2), n); break; }
    case 0x18: s.pc = jr(bump(2), n); break;                             // JR e
    case 0x20: s.pc = s.zf ? bump(2) : jr(bump(2), n); break;            // JR NZ,e
    case 0x28: s.pc = s.zf ? jr(bump(2), n) : bump(2); break;            // JR Z,e
    case 0x76: s.halted = true; break;                                   // HALT (= newline)
    default:   s.halted = true; break;                                   // outside the fragment
  }
  return s;
}
function zxMachine(rom, cycles) {
  const s = zxBoot(rom);
  for (let i = 0; i < cycles && !s.halted; i++) zxStep(s);   // a halted machine is a fixpoint
  return s;
}
function zxScreen(s) {
  const out = [];
  for (let r = 0; r < ZX.rows; r++) {
    let line = "";
    for (let i = 0; i < ZX.cols; i++)
      line += ZX.chars[s.mem[(ZX.dfile + r * ZX.cols + i) % ZX.memSize]] || " ";
    out.push(line);
  }
  return out;
}
// the emulator against the checkpoints Lean computed from the same ROMs
function zxSelfTest() {
  let ok = 0;
  for (const [rom, cycles, want] of ZVEC) {
    const s = zxMachine(rom, cycles);
    const got = [s.a, s.b, s.c, s.h, s.l, s.pc, s.zf ? 1 : 0, s.halted ? 1 : 0,
                 s.mem.reduce((x, y) => x + y, 0)];
    const scr = zxScreen(s);
    if (got.every((x, i) => x === want[i]) && scr.length === want[9].length &&
        scr.every((x, i) => x === want[9][i])) ok++;
  }
  return { ok: ok, total: ZVEC.length };
}

// ---- payload codec (mirrors NixWars.fieldsCodec) ----
function digitsLE(n, r) {
  if (n < r) return [n];
  const out = [];
  while (n >= r) { out.push(n % r); n = Math.floor(n / r); }
  out.push(n);
  return out;
}
function encodeSyms(fields, r) {
  const out = [];
  for (const n of fields) { for (const d of digitsLE(n, r)) out.push(d); out.push(r); }
  return out;
}
function decodeSyms(syms, r) {
  const fields = [], cur = [];
  for (const s of syms) {
    if (s === r) { let v = 0; for (let i = cur.length - 1; i >= 0; i--) v = v * r + cur[i];
                   fields.push(v); cur.length = 0; }
    else cur.push(s);
  }
  return fields;   // a trailing unterminated block is dropped, as in Lean
}

// ---- transports ----
function toUrl(fields) { return PREFIX + encodeSyms(fields,64).map(s => ALPHA[s]).join(""); }
function fromUrl(txt) {
  if (!txt.startsWith(PREFIX)) return null;
  const syms = Array.from(txt.slice(PREFIX.length)).map(c => ALPHA.indexOf(c));
  if (syms.some(s => s < 0)) return null;
  return decodeSyms(syms, 64);
}
function toMorse(fields) { return encodeSyms(fields,36).map(s => MORSE[s] + " ").join(""); }
function padAdd(syms, key, m) {
  if (!key.length) return syms.slice();
  return syms.map((s,i) => (s + key[i % key.length]) % m);
}
function toNumbers(fields, key) {
  const syms = padAdd(encodeSyms(fields,9), key, 10);
  const digits = syms.map(s => NUMS[s]).join("");
  return (digits.match(/.{1,5}/g) || []).join(" ");
}
function toBytes(fields) { return encodeSyms(fields,64).map(s => ALPHA.charCodeAt(s)); }
function frame(bytes, F) {
  const out = [];
  for (const b of bytes) {
    if (b === F.term) out.push(F.esc, F.termCode);
    else if (b === F.esc) out.push(F.esc, F.escCode);
    else out.push(b);
  }
  out.push(F.term);
  return out;
}
function hex(bs) { return bs.map(b => b.toString(16).padStart(2,"0")).join(" "); }

// ---- the board: one session, whichever door it belongs to ----
let door = "nixwars";
let session = null;

function ship() { return session.slice(3); }
function setShip(s) { session = session.slice(0,3).concat(s); }
function doorOfSession(sess) {
  for (const name of Object.keys(DOORS))
    if (DOORS[name].game === sess[2] && DOORS[name].init.length === sess.length) return name;
  return null;
}

function load() {
  // ?door=<name> walks up to that cabinet; the hash, if there is one, wins,
  // because the hash is the whole saved game.
  const q = (typeof location.search === "string" ? location.search : "")
              .match(/[?&]door=([a-z0-9]+)/);
  if (q && DOORS[q[1]]) door = q[1];
  const fromHash = fromUrl(PREFIX + location.hash.slice(1));
  const d = fromHash && doorOfSession(fromHash);
  if (d) { door = d; session = fromHash; }
  else   { session = DOORS[door].init.slice(); }
}

let lastAgree = null;

function send(tag, arg) {
  // one command: decode from the wire, step in wasm, re-encode. Every command
  // that leaves this function, whatever sent it -- button, key, swipe, stick or
  // macro -- is what the macro builder's RECORD button writes down.
  if (kmRecording) kmRecording.push(["cmd", tag, arg]);
  const before = toUrl(session);
  const fields = fromUrl(before);
  const st = fields.slice(3);
  const table = DOORS[door].prog[tag].map(e => ev(e, st, arg));   // the emitted table
  const next = WEXPORTS ? wasmStep(door, tag, st, arg) : table;   // the emitted module
  lastAgree = WEXPORTS
    ? (next.length === table.length && next.every((x, i) => x === table[i]))
    : null;
  setShip(next);
  location.hash = toUrl(session).slice(PREFIX.length);
  render(tag, arg);
}

function scanReport(d) {
  if (d < 100) return "GALACTIC CENTER DETECTED. Sgr A* is here.";
  if (d < 1000) return "Strong gravitational waves. Black hole nearby.";
  if (d < 5000) return "Galactic center region. High star density.";
  return "Normal space. No anomalies detected.";
}

function track(s) {
  // three lanes, the runner and the obstacle for this turn
  const obstacle = s[3] % 3, out = [];
  for (let i = 0; i < 3; i++)
    out.push(i === s[0] ? (i === obstacle ? "[X]" : "[o]") : (i === obstacle ? " X " : " . "));
  return out.join("");
}

function marketReport(s) {
  // [credits, held, price, turn]: the quote is one of the three largest Monster primes
  const worth = s[0] + s[1] * s[2];
  return "QUOTE " + s[2] + " credits/shard   NET WORTH " + worth +
         (s[2] > s[0] && s[1] === 0 ? "   (cannot afford a shard)" : "");
}

function lordReport(s) {
  // [hp, gold, level, foe, turn]
  if (s[0] === 0) return "*** YOU DIED ON LEVEL " + s[2] + ". THE RED SHARD KEEPS YOUR GOLD. ***";
  return "LEVEL " + s[2] + "   HP " + s[0] + "/59   GOLD " + s[1] +
         "   CHAMPION " + s[3] + " HP" + (s[1] >= 10 ? "   (a heal costs 10)" : "");
}

function huntReport(s) {
  // [room, wumpus, arrows, alive, turn]
  if (s[3] === 0) return "*** THE WUMPUS ATE YOU ON SHARD " + s[0] + ". ***";
  if (s[1] >= SHARDS) return "*** THE WUMPUS IS SLAIN. THE DMZ IS YOURS. ***";
  const gap = Math.min((s[1] - s[0] + SHARDS) % SHARDS, (s[0] - s[1] + SHARDS) % SHARDS);
  return "SHARD " + s[0] + "   ARROWS " + s[2] + "   " +
         (gap === 0 ? "YOU ARE STANDING ON IT"
          : gap === 1 ? "YOU SMELL THE WUMPUS NEXT DOOR"
          : gap <= 3 ? "THE AIR IS FOUL. IT IS CLOSE." : "NOTHING BUT PACKET NOISE");
}

function zx81Report(s) {
  // [rom, cycles]
  const cpu = zxMachine(s[0], s[1]);
  return "ROM " + (ZX.names[s[0]] || "BANNER") + "   CYCLE " + s[1] +
         "   A=" + cpu.a + " B=" + cpu.b + " C=" + cpu.c +
         " HL=" + (cpu.h * 256 + cpu.l) + " PC=" + cpu.pc +
         (cpu.halted ? "   HALTED" : "");
}

// ---- the FRENS tournament (mirrors NixWars.lobbyStep) ----
// The state is [seat, mmc0..mmc3]; the players are the handles read off the
// upstream branches and pull requests, in roster order.
function frensReport(s) {
  const seat = s[0];
  const rows = FRENS.map((f, i) =>
    (i === seat ? "> " : "  ") + f.handle.padEnd(14) + ("x" + f.mult).padEnd(4) +
    ("shard " + f.shard).padEnd(11) + String(s[i + 1]).padStart(4) + " MMC" +
    (f.shard === CROWN ? "   (crown shard)" : ""));
  const pot = s[1] + s[2] + s[3] + s[4];
  const best = Math.max(s[1], s[2], s[3], s[4]);
  const leaders = FRENS.filter((f, i) => s[i + 1] === best && best > 0).map(f => f.handle);
  return rows.join("\n") + "\npot " + pot + " MMC" +
         (leaders.length ? "   leading: " + leaders.join(", ") : "   nobody has claimed yet");
}

// ---- the hackathon doors (mirrors NixWars.tycoonStep / memeStep / hyperStep /
//      oracleStep) ----
function tycoonReport(s) {
  // [cash, raw, mines, forges, tick]
  const conv = Math.min(s[1], s[3]);
  return "CASH " + s[0] + "   RAW " + s[1] + "   MINES " + s[2] + "   FOUNDRIES " + s[3] +
         "   (a mine costs 7, a foundry 11)\n" +
         (s[3] === 0
            ? "no foundry yet: raw matter just piles up in the yard"
            : "next run compresses " + conv + " unit(s) into essence worth " + (2 * conv) +
              " credits");
}

function memeReport(s) {
  // [champfit, champcyc, chalfit, chalcyc, gen]
  return "GENERATION " + s[4] +
         "\nchampion     fitness " + s[0] + "   cycles " + s[1] +
         "\nchallenger   fitness " + s[2] + "   cycles " + s[3] + "\n" +
         (s[2] >= s[0] ? "the challenger is ready to take the crown"
                       : "the champion still leads; breed or mutate");
}

function hyperReport(s) {
  // eight coordinates on the Monster manifold, and the address they spell
  const F = DOORS.hyper.fields;
  const addr = s.reduceRight((a, x) => a * 8 + x, 0);   // base 8, axis 0 least significant
  const bar = i => "[" + ".".repeat(s[i]) + "*" + ".".repeat(7 - s[i]) + "]";
  const rows = F.map((nm, i) => "  " + nm.padEnd(12) + bar(i) + " " + s[i]);
  return rows.join("\n") + "\naddress " + addr + " of 16777216   shard " + (addr % SHARDS) +
         (addr % SHARDS === CROWN ? "   (the Monster Crown's shard)" : "");
}

function oracleReport(s) {
  // [layer, evidence, seeds, bounty]
  const LAYERS = ["assembly", "C", "scheme", "seed"];
  const chain = LAYERS.map((nm, i) =>
    (i < s[0] ? "[x] " : i === s[0] ? " >  " : "[ ] ") + nm).join("   ");
  return chain + "\nwitnesses " + s[1] + "/3 at this layer   seeds " + s[2] +
         "   bounty " + s[3] + " MMC\n" +
         (s[1] < 3
            ? "collect " + (3 - s[1]) + " more witness(es) before you can climb"
            : s[0] < 3
              ? "the evidence carries: LIFT to " + LAYERS[s[0] + 1]
              : "the chain is complete: MINT the seed for 59 MMC");
}

function voteReport(s) {
  // [ayes, nays, round, passed]
  const NODES = 23, QUORUM = 12;
  const bar = (n, ch) => ch.repeat(n);
  return "ROUND " + s[2] + "   nodes " + NODES + "   quorum " + QUORUM +
         "\n  aye  " + String(s[0]).padStart(2) + " " + bar(s[0], '#') +
         "\n  nay  " + String(s[1]).padStart(2) + " " + bar(s[1], "-") +
         "\n  silent " + (NODES - s[0] - s[1]) + "\n" +
         (s[3] === 1
            ? "*** THE PROPOSAL CARRIES — a quorum voted for it ***"
            : s[0] >= QUORUM
              ? "the ayes have a quorum: TALLY to carry the proposal"
              : "the ayes need " + (QUORUM - s[0]) + " more node(s) for a quorum");
}

function qbertReport(s) {
  // [row, col, c0 .. c9, lives] on the four-row pyramid
  const paint = s.slice(2, 12);
  const ROWS = [[0], [1, 2], [3, 4, 5], [6, 7, 8, 9]];
  const lines = ROWS.map((row, r) =>
    "     ".repeat(3 - r) +
    row.map((j, c) => (s[0] === r && s[1] === c) ? " <o> "
                      : (paint[j] ? " [*] " : " [ ] ")).join(""));
  const score = paint.reduce((a, x) => a + x, 0);
  return lines.join("\n") + "\n\nPAINTED " + score + "/10   LIVES " + s[12] +
    (s[12] === 0 ? "   *** GAME OVER. THE CABINET IS FROZEN. ***"
     : score === 10 ? "   *** BOARD CLEARED. THE MONSTER CUBES ARE YOURS. ***" : "");
}

function invadersReport(s) {
  // [px, ox, dir, dy, a0 .. a4, turn]
  const rank = [];
  for (let c = 0; c < 8; c++) {
    const j = c - s[1];
    rank.push((j >= 0 && j < 5 && s[4 + j]) ? " M " : " . ");
  }
  const floor = [];
  for (let c = 0; c < 8; c++) floor.push(c === s[0] ? " ^ " : " . ");
  const alive = s[4] + s[5] + s[6] + s[7] + s[8];
  const sky = [];
  for (let r = 0; r < 5; r++) sky.push(r === s[3] ? rank.join("") : "");
  return sky.filter(l => l !== "").concat(["", floor.join("")]).join("\n") +
    "\n\nSHOT DOWN " + (5 - alive) + "/5   DROP " + s[3] + "/5   CLOCK " + s[9] +
    (s[3] === 5 ? "   *** THE RANK HAS LANDED. THE CABINET IS FROZEN. ***"
     : alive === 0 ? "   *** SKY CLEARED. THE SHARDS ARE SAFE. ***" : "");
}

function frontierReport(s) {
  // [x, y, z, hdg, speed, fuel, docked, turn]
  const HDG = ["+x", "-x", "+y", "-y", "+z", "-z"];
  const ring = (a, b) => Math.min((a - b + 16) % 16, (b - a + 16) % 16);
  const range = ring(s[0], 6) + ring(s[1], 4) + ring(s[2], 2);
  return "POS " + s[0] + "," + s[1] + "," + s[2] + "   HDG " + (HDG[s[3]] || "?") +
    "   THROTTLE " + s[4] + "/3   FUEL " + s[5] +
    "\nSTATION 6,4,2   RANGE " + range + " cells   CLOCK " + s[7] + "\n" +
    (s[6] === 1 ? "*** DOCKED AT THE STATION. TANK FULL. ***"
     : range === 0 ? "you are on the station's cell: DOCK"
     : s[5] < s[4] ? "the tank will not carry this throttle: BRAKE"
     : "fly the cube; every face wraps round to the other side");
}

// ---- the 3D view of the Frontier Run ----
// A perspective projection from the ship's cell along its heading. The cube of
// space is a 3-torus, so every point is drawn at its nearest image.
function drawFrontier(s) {
  const cv = document.getElementById("view3d");
  if (!cv || !cv.getContext) return;
  const g = cv.getContext("2d"), W = cv.width, H = cv.height;
  g.fillStyle = '#020402'; g.fillRect(0, 0, W, H);
  const HDGV = [[1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1]];
  const fwd = HDGV[s[3]] || HDGV[0];
  const up = (s[3] === 2 || s[3] === 3) ? [0,0,1] : [0,1,0];
  const right = [fwd[1]*up[2] - fwd[2]*up[1], fwd[2]*up[0] - fwd[0]*up[2],
                 fwd[0]*up[1] - fwd[1]*up[0]];
  const dot = (a, b) => a[0]*b[0] + a[1]*b[1] + a[2]*b[2];
  const wrap = (a, b) => { let d = (a - b + 16) % 16; if (d > 8) d -= 16; return d; };
  const rel = (p) => [wrap(p[0], s[0]), wrap(p[1], s[1]), wrap(p[2], s[2])];
  const F = 260;
  const proj = (p) => {
    const v = rel(p), z = dot(v, fwd);
    if (z < 0.35) return null;
    return [W/2 + F * dot(v, right) / z, H/2 - F * dot(v, up) / z, z];
  };
  // the lattice: a beacon in every fifth cell, so the starfield moves with you
  g.fillStyle = '#1e7a2c';
  for (let x = 0; x < 16; x++) for (let y = 0; y < 16; y++) for (let z = 0; z < 16; z++) {
    if ((x + 2*y + 3*z) % 7 !== 0) continue;
    const q = proj([x, y, z]);
    if (!q) continue;
    const r = Math.max(0.6, 3 - q[2] / 4);
    g.beginPath(); g.arc(q[0], q[1], r, 0, 6.284); g.fill();
  }
  // the station: a wireframe cube on cell 6,4,2
  const C = [6, 4, 2], h = 0.42;
  const corners = [];
  for (let i = 0; i < 8; i++)
    corners.push([C[0] + (i & 1 ? h : -h), C[1] + (i & 2 ? h : -h), C[2] + (i & 4 ? h : -h)]);
  const EDGES = [[0,1],[0,2],[1,3],[2,3],[4,5],[4,6],[5,7],[6,7],[0,4],[1,5],[2,6],[3,7]];
  g.strokeStyle = s[6] === 1 ? '#8fffa5' : '#3cff5a'; g.lineWidth = 1.4;
  for (const [i, j] of EDGES) {
    const a = proj(corners[i]), b = proj(corners[j]);
    if (!a || !b) continue;
    g.beginPath(); g.moveTo(a[0], a[1]); g.lineTo(b[0], b[1]); g.stroke();
  }
  // crosshair and HUD
  g.strokeStyle = '#2aa843'; g.lineWidth = 1;
  g.beginPath();
  g.moveTo(W/2 - 14, H/2); g.lineTo(W/2 - 4, H/2);
  g.moveTo(W/2 + 4, H/2); g.lineTo(W/2 + 14, H/2);
  g.moveTo(W/2, H/2 - 14); g.lineTo(W/2, H/2 - 4);
  g.moveTo(W/2, H/2 + 4); g.lineTo(W/2, H/2 + 14);
  g.stroke();
  const HDGN = ["+x", "-x", "+y", "-y", "+z", "-z"];
  g.fillStyle = '#3cff5a'; g.font = "12px ui-monospace,monospace";
  g.fillText("HDG " + (HDGN[s[3]] || "?") + "   THR " + s[4] + "/3   FUEL " + s[5], 12, 20);
  g.fillText("CELL " + s[0] + "," + s[1] + "," + s[2] +
             (s[6] === 1 ? "   DOCKED" : ""), 12, H - 14);
  // throttle bar
  g.fillStyle = '#14361a'; g.fillRect(W - 26, H - 90, 12, 76);
  g.fillStyle = '#3cff5a'; g.fillRect(W - 26, H - 14 - 25 * s[4], 12, 25 * s[4]);
}

function report() {
  const s = ship();
  if (door === "nixwars")
    return s[0] === 0 ? "*** YOU HAVE REACHED SGR A*. THE MONSTER IS THE MESSAGE. ***"
                      : scanReport(s[0]);
  if (door === "market") return marketReport(s);
  if (door === "lord") return lordReport(s);
  if (door === "hunt") return huntReport(s);
  if (door === "zx81") return zx81Report(s);
  if (door === "frens") return frensReport(s);
  if (door === "tycoon") return tycoonReport(s);
  if (door === "meme") return memeReport(s);
  if (door === "hyper") return hyperReport(s);
  if (door === "oracle") return oracleReport(s);
  if (door === "vote") return voteReport(s);
  if (door === "qbert") return qbertReport(s);
  if (door === "frontier") return frontierReport(s);
  if (door === "invaders") return invadersReport(s);
  if (s[2] === 0) return "*** GAME OVER. THE MONSTER CAUGHT YOU. ***  " + track(s);
  return "obstacle in lane " + (s[3] % 3) + "   " + track(s);
}

function render(tag, arg) {
  const s = ship(), F = DOORS[door].fields;
  const key = Array.from(document.getElementById("padkey").value)
                   .filter(c => c >= "0" && c <= "9").map(c => +c);
  const lines = [];
  lines.push("USER " + session[0] + "   SHARD " + session[1] + "   GAME " + session[2] +
             "   DOOR " + door.toUpperCase());
  lines.push("");
  for (let i = 0; i < F.length; i++) lines.push(F[i].padEnd(10) + s[i]);
  lines.push("");
  lines.push(report());
  if (tag) lines.push("");
  if (tag === "no-crown")
    lines.push("> UNLOCK REFUSED. THE MONSTER CROWN IS ON SHARD " + CROWN + ".");
  else if (tag)
    lines.push("> " + tag.toUpperCase() + (tag === "warp" ? " " + arg : ""));
  document.getElementById("term").textContent = lines.join("\n");
  document.getElementById("url").textContent = toUrl(session);
  document.getElementById("morse").textContent = toMorse(session);
  document.getElementById("numbers").textContent = toNumbers(session, key);
  document.getElementById("slip").textContent = hex(frame(toBytes(session), SLIP));
  document.getElementById("ppp").textContent =
    hex([PPP.term].concat(frame(toBytes(session), PPP)));
  document.getElementById("screen").textContent =
    door === "zx81" ? zxScreen(zxMachine(s[0], s[1])).join("\n") : "";
  if (door === "frontier") drawFrontier(s);
  const t = selfTest();
  const z = zxSelfTest();
  const wlines = [];
  wlines.push("module      " + WASM.length + " bytes, emitted by Lean");
  wlines.push("doors       " + Object.keys(DOORS).join(" ") + "   (one module, all doors)");
  wlines.push("exports     " + (WEXPORTS ? Object.keys(WEXPORTS).join(" ") : "none"));
  wlines.push("self-test   " + t.ok + "/" + t.total + " vectors" +
              (t.note ? "  " + t.note : ""));
  wlines.push("engine      " + (WEXPORTS ? "stepping the game in WebAssembly"
                                         : "fallback: interpreting the table"));
  wlines.push("zx81        " + z.ok + "/" + z.total +
              " checkpoints against the Lean emulator");
  if (lastAgree !== null)
    wlines.push("last step   " + (lastAgree ? "wasm agrees with the table"
                                            : "DISAGREEMENT"));
  document.getElementById("wasm").textContent = wlines.join("\n");
  for (const name of Object.keys(DOORS))
    document.getElementById("panel-" + name).style.display =
      (name === door) ? "block" : "none";
  kbSync();   // each cabinet has its own keyboard and its own book of macros
}

function warp() {
  const d = parseInt(document.getElementById("dist").value || "0", 10);
  send("warp", Number.isFinite(d) && d > 0 ? d : 0);
}

function huntArg() {
  const r = parseInt(document.getElementById("room").value || "0", 10);
  return Number.isFinite(r) && r >= 0 ? r : 0;
}
function walk() { send("move", huntArg()); }
function loose() { send("shoot", huntArg()); }
function fast() { send("fast", 50); }
function loadRom(i) { send("load", i); }

// ---- moving around the 71-shard ring, and the Monster Crown ----
// A Chord hop adds a power of two to the shard, modulo 71; seven of them reach
// any shard from any shard (NixWars.chordPath_chordRoute). The crown sits on
// shard 47 and unlocks j-nav there and nowhere else (NixWars.crownUnlock).
function hop(k) {
  session[1] = (session[1] + Math.pow(2, k)) % SHARDS;
  location.hash = toUrl(session).slice(PREFIX.length);
  render("hop +" + Math.pow(2, k), 0);
}
function crown() {
  if (session[1] === CROWN) send("unlock", 0);
  else render("no-crown", 0);
}
function enter(name) {
  door = name;
  session = DOORS[door].init.slice();
  location.hash = toUrl(session).slice(PREFIX.length);
  render(null, 0);
}
function reset() { enter(door); }
window.addEventListener("hashchange", () => { load(); render(null, 0); });

// ---- the keyboard ----
// The hotkeys used to be a hand-written table here, for three cabinets. They
// are now the emitted keymap: KMAP.caps, proved to carry every command of every
// door and nothing else, dispatched by kmKeyDown below -- the same table the
// on-screen keyboard draws, so the two cannot disagree.
"#

/-- Everything after the script: the panels and the page's furniture. -/
def pageTail2 : String := r#"</script>

<div>
  <button onclick="enter('nixwars')">DOOR 1 &mdash; NIXWARS</button>
  <button onclick="enter('dash')">DOOR 2 &mdash; MONSTER DASH</button>
  <button onclick="enter('market')">DOOR 3 &mdash; SHARD MARKET</button>
  <button onclick="enter('lord')">DOOR 4 &mdash; RED SHARD</button>
  <button onclick="enter('hunt')">DOOR 5 &mdash; WUMPUS</button>
  <button onclick="enter('zx81')">DOOR 6 &mdash; ZX81</button>
  <button onclick="enter('frens')">DOOR 7 &mdash; FRENS</button>
  <button onclick="enter('tycoon')">DOOR 8 &mdash; TYCOON</button>
  <button onclick="enter('meme')">DOOR 9 &mdash; MEMES</button>
  <button onclick="enter('hyper')">DOOR 10 &mdash; HYPERSPACE</button>
  <button onclick="enter('oracle')">DOOR 11 &mdash; ORACLE</button>
  <button onclick="enter('vote')">DOOR 12 &mdash; ASSEMBLY</button>
  <button onclick="enter('qbert')">DOOR 13 &mdash; MONSTER CUBES</button>
  <button onclick="enter('frontier')">DOOR 14 &mdash; FRONTIER RUN</button>
  <button onclick="enter('invaders')">DOOR 15 &mdash; SHARD INVADERS</button>
  <button onclick="reset()">NEW GAME</button>
</div>

<div id="panel-nixwars">
  <div>
    <button onclick="send('scan',0)">SCAN</button>
    <button onclick="send('status',0)">STATUS</button>
    <button onclick="send('jnav',0)">J-NAV</button>
    <button onclick="crown()">UNLOCK</button>
    <button onclick="send('quit',0)">QUIT</button>
  </div>
  <div>
    <span class="small">chord hop:</span>
    <button onclick="hop(0)">+1</button>
    <button onclick="hop(1)">+2</button>
    <button onclick="hop(2)">+4</button>
    <button onclick="hop(3)">+8</button>
    <button onclick="hop(4)">+16</button>
    <button onclick="hop(5)">+32</button>
    <button onclick="hop(6)">+64</button>
    <span class="small">seven hops reach any of the 71 shards; the Monster Crown,
    which unlocks J-NAV, is on shard 47</span>
  </div>
  <div>
    <input id="dist" value="99" inputmode="numeric"> <button onclick="warp()">WARP</button>
    <span class="small">short hops of 99 ly are free (99/100 = 0 fuel)</span>
  </div>
</div>

<div id="panel-dash">
  <div>
    <button onclick="send('left',0)">LEFT</button>
    <button onclick="send('right',0)">RIGHT</button>
    <button onclick="send('tick',0)">TICK</button>
    <span class="small">the obstacle on turn t sits in lane t mod 3</span>
  </div>
</div>

<div id="panel-market">
  <div>
    <button onclick="send('buy',0)">BUY</button>
    <button onclick="send('sell',0)">SELL</button>
    <button onclick="send('hold',0)">HOLD</button>
    <span class="small">the quote cycles 47 &rarr; 59 &rarr; 71, the three largest Monster
    primes; buy low, sell high</span>
  </div>
</div>

<div id="panel-lord">
  <div>
    <button onclick="send('attack',0)">ATTACK</button>
    <button onclick="send('heal',0)">HEAL</button>
    <button onclick="send('flee',0)">FLEE</button>
    <button onclick="send('rest',0)">REST</button>
    <span class="small">the champion on level n has 3n+2 hit points; a heal costs
    10 gold and gives 7 hit points; death is final</span>
  </div>
</div>

<div id="panel-hunt">
  <div>
    <input id="room" value="18" inputmode="numeric">
    <button onclick="walk()">MOVE</button>
    <button onclick="loose()">SHOOT</button>
    <button onclick="send('sense',0)">SENSE</button>
    <span class="small">the wumpus creeps one shard forward every turn round the
    71-shard ring; three arrows</span>
  </div>
</div>

<div id="panel-zx81">
  <div>
    <button onclick="send('step',0)">STEP</button>
    <button onclick="fast()">RUN 50</button>
    <button onclick="send('reset',0)">RESET</button>
    <button onclick="loadRom(0)">ROM: BANNER</button>
    <button onclick="loadRom(1)">ROM: COUNT</button>
    <button onclick="loadRom(2)">ROM: FILL</button>
    <span class="small">a Z80 and a 256-byte address space; the display file is
    the upper half. The whole machine travels in two numbers.</span>
  </div>
  <h2>ZX81 SCREEN</h2>
  <pre id="screen"></pre>
</div>

<div id="panel-frens">
  <div>
    <button onclick="send('claim',0)">CLAIM</button>
    <button onclick="send('pass',0)">PASS</button>
    <button onclick="send('crown',0)">CROWN</button>
    <span class="small">four seats, round-robin: the seated player claims its
    reward multiplier in Metameme Coin and the turn moves on. The crown bonus of
    47 is paid only on the crown shard.</span>
  </div>
  <p class="small">The players are the handles found on every branch and pull
  request of meta-introspector/shards: jmikedupont2 (branch main), nathan
  (FRENS.md), nydiokar and kanebra (PR #1, frens/*.json).</p>
</div>

<div id="panel-tycoon">
  <div>
    <button onclick="send('mine',0)">MINE</button>
    <button onclick="send('forge',0)">FORGE</button>
    <button onclick="send('run',0)">RUN 1s</button>
    <button onclick="send('dump',0)">DUMP</button>
    <span class="small">Kleene Algebra Mines dig raw syntactic matter; Monster
    Group Foundries compress it into semantic essence worth two credits a unit.
    Dumping the yard raw pays one.</span>
  </div>
</div>

<div id="panel-meme">
  <div>
    <button onclick="send('breed',0)">BREED</button>
    <button onclick="send('mutate',0)">MUTATE</button>
    <button onclick="send('select',0)">SELECT</button>
    <span class="small">crossover averages the parents and adds one for hybrid
    vigor; mutation takes a tenth off the challenger's cycles. Breeding alone
    stalls &mdash; the pool needs mutation to keep climbing.</span>
  </div>
</div>

<div id="panel-hyper">
  <div>
    <span class="small">axis:</span>
    <button onclick="send('fwd',0)">+0</button>
    <button onclick="send('fwd',1)">+1</button>
    <button onclick="send('fwd',2)">+2</button>
    <button onclick="send('fwd',3)">+3</button>
    <button onclick="send('fwd',4)">+4</button>
    <button onclick="send('fwd',5)">+5</button>
    <button onclick="send('fwd',6)">+6</button>
    <button onclick="send('fwd',7)">+7</button>
  </div>
  <div>
    <span class="small">back:</span>
    <button onclick="send('back',0)">-0</button>
    <button onclick="send('back',1)">-1</button>
    <button onclick="send('back',2)">-2</button>
    <button onclick="send('back',3)">-3</button>
    <button onclick="send('back',4)">-4</button>
    <button onclick="send('back',5)">-5</button>
    <button onclick="send('back',6)">-6</button>
    <button onclick="send('back',7)">-7</button>
  </div>
  <div>
    <button onclick="send('home',0)">HOME</button>
    <button onclick="send('fix',0)">Y &mdash; FIX</button>
    <span class="small">eight axes of the Monster manifold, each a ring of
    eight; Y is the fixed point, the command that maps the position to
    itself.</span>
  </div>
</div>

<div id="panel-oracle">
  <div>
    <button onclick="send('witness',0)">WITNESS</button>
    <button onclick="send('lift',0)">LIFT</button>
    <button onclick="send('mint',0)">MINT</button>
    <button onclick="send('audit',0)">AUDIT</button>
    <span class="small">the provenance chain assembly &rarr; C &rarr; scheme
    &rarr; seed. Three witnesses buy one layer, and a closed chain mints a seed
    worth 59 &mdash; so a seed costs twelve witnesses and cannot be had for
    less.</span>
  </div>
</div>

<div id="panel-vote">
  <div>
    <button onclick="send('aye',0)">AYE</button>
    <button onclick="send('nay',0)">NAY</button>
    <button onclick="send('tally',0)">TALLY</button>
    <button onclick="send('next',0)">NEXT ROUND</button>
    <span class="small">the community vote of the 23-node network: a proposal
    carries on a quorum of twelve, eleven is not enough, and the seven
    Byzantine nodes cannot block the sixteen honest ones.</span>
  </div>
</div>

<div id="panel-qbert">
  <div>
    <button onclick="send('ul',0)">&#8598; UP-LEFT</button>
    <button onclick="send('ur',0)">&#8599; UP-RIGHT</button>
    <button onclick="send('dl',0)">&#8601; DOWN-LEFT</button>
    <button onclick="send('dr',0)">&#8600; DOWN-RIGHT</button>
    <span class="small">keys Q W A S, or the arrow keys. Ten cubes on a four-row
    pyramid: hop on every one to clear the board. A hop off the edge costs a
    life, and paint never comes off.</span>
  </div>
</div>

<div id="panel-invaders">
  <div>
    <button onclick="send('left',0)">&#8592; LEFT</button>
    <button onclick="send('right',0)">RIGHT &#8594;</button>
    <button onclick="send('fire',0)">FIRE</button>
    <button onclick="send('tick',0)">LET THEM MOVE</button>
    <span class="small">arrow keys or A and D walk the gun, SPACE fires, T lets
    the rank slide. Five invaders over eight columns: a shot hits whatever is
    directly overhead. Every time the rank reaches a wall it reverses and drops
    a row, and five rows down it has landed.</span>
  </div>
</div>

<div id="panel-frontier">
  <div>
    <canvas id="view3d" width="640" height="360"
      style="border:1px solid #1d4d24;background:#020402;max-width:100%"></canvas>
  </div>
  <div>
    <span class="small">heading:</span>
    <button onclick="send('turn',0)">+X</button>
    <button onclick="send('turn',1)">-X</button>
    <button onclick="send('turn',2)">+Y</button>
    <button onclick="send('turn',3)">-Y</button>
    <button onclick="send('turn',4)">+Z</button>
    <button onclick="send('turn',5)">-Z</button>
  </div>
  <div>
    <button onclick="send('thrust',0)">THROTTLE +</button>
    <button onclick="send('brake',0)">THROTTLE -</button>
    <button onclick="send('fly',0)">FLY</button>
    <button onclick="send('dock',0)">DOCK</button>
    <span class="small">keys 1-6 point the nose, Z and X work the throttle,
    SPACE flies and K docks. Sixteen cells to a side and every face wraps;
    flying burns one unit of fuel per cell, and only the station at 6,4,2
    refuels you.</span>
  </div>
</div>

<h2>TERMINAL</h2>
<pre id="term"></pre>

<h2>WASM ENGINE</h2>
<pre id="wasm"></pre>

<div class="grid">
  <div>
    <h2>URL &mdash; the whole state</h2>
    <pre id="url"></pre>
  </div>
  <div>
    <h2>MORSE</h2>
    <pre id="morse"></pre>
  </div>
  <div>
    <h2>NUMBERS STATION
      <input id="padkey" value="" placeholder="pad key" oninput="render(null,0)"></h2>
    <pre id="numbers"></pre>
  </div>
  <div>
    <h2>SLIP FRAME</h2>
    <pre id="slip"></pre>
  </div>
  <div>
    <h2>PPP FRAME</h2>
    <pre id="ppp"></pre>
  </div>
</div>

<p class="small">Emitted from the Lean development in RequestProject/NixWars.
Round-trip of every transport, determinism, fuel conservation and the
equivalence of this page's transition table with the game are machine-checked.
The cabinets all stand in <a href="arcade.html" style="color:#8fffa5">THE ARCADE
ROOM</a>, together with FRONTIER, the free-flight add-on — or, all of them and
all of their data in a single file, in
<a href="filled-arcade.html" style="color:#8fffa5">THE FILLED ARCADE</a>, which
also carries the trained agent, the betting floor and the broadcast desk.
All fifteen doors are also playable in WebGL, drawn as voxels, in
<a href="arcade-3d.html" style="color:#8fffa5">THE ARCADE IN 3D</a>, and the
ship can be flown through the Monster's world &mdash; in three dimensions or in
fifteen &mdash; in <a href="fly.html" style="color:#8fffa5">THE VOXEL
FLIGHT</a>.
There is a
<a href="video.html" style="color:#8fffa5">video about the game</a>
next door: an animated SVG with narration, and the same thing as MPEG-1.
And in the workshop behind the board, <a href="pantograph.html" style="color:#8fffa5">THE
PANTOGRAPH</a>: a brass card shop whose deck of punched shims, fed back into the
shop, punches that same deck out again — proved in Lean.
Across the arm, <a href="empire.html" style="color:#8fffa5">FOUNDATION AND
EMPIRE</a>: a twelve-system space empire in which every command saves the next
page, carrying the whole history and a hash chain over it, so a player can host
the file and commit its digest.</p>

"#

/-- The last line of the page: load the session, draw it, and bind the
controls. -/
def pageTail3 : String := r#"<script>load(); render(null, 0); ctrlInit(); kmInit();</script>
</body>
</html>
"#


/-- The complete single-page app. -/
def page : String :=
  pageHead ++ Controls.controlsCss ++ Keys.keymapCss ++ pageHead2 ++ emittedData ++
    pageTail ++ Controls.controlsJs ++ Keys.keymapJs ++ pageTail2 ++
    Controls.controlsHtml ++ Keys.keymapHtml ++ pageTail3

/-! ## Golden values

These are the transmissions of the starting session on each wire. The emitted
page produces exactly these strings, so they pin the page's format to the Lean
model. -/

unseal natToDigits in
example : sessionUrl initialSession = "https://bbs.8080.monster/nixwars#HB.R.B.xgG.kB.QcC.A.A." :=
  rfl

unseal natToDigits in
example : sessionNumbers initialSession = "9809202073615023202575201010" := rfl

unseal natToDigits in
example : morseString (sessionMorse initialSession) =
    "--.. .---- .-.-.- .... .-.-.- .---- .-.-.- -..- -.- -.- .-.-.- ... ..--- .-.-.- " ++
    "... .--. --... .-.-.- ----- .-.-.- ----- .-.-.- " := rfl

unseal natToDigits in
example : (sessionSlip initialSession).map UInt8.toNat =
    [0x48, 0x42, 0x2e, 0x52, 0x2e, 0x42, 0x2e, 0x78, 0x67, 0x47, 0x2e, 0x6b, 0x42, 0x2e,
     0x51, 0x63, 0x43, 0x2e, 0x41, 0x2e, 0x41, 0x2e, 0xc0] := rfl

unseal natToDigits in
example : (sessionPpp initialSession).map UInt8.toNat =
    [0x7e, 0x48, 0x42, 0x2e, 0x52, 0x2e, 0x42, 0x2e, 0x78, 0x67, 0x47, 0x2e, 0x6b, 0x42, 0x2e,
     0x51, 0x63, 0x43, 0x2e, 0x41, 0x2e, 0x41, 0x2e, 0x7e] := rfl

/-- Write the page and the WebAssembly module. The page embeds the module's
bytes, so `www/nixwars.html` remains self-contained; `www/nixwars.wasm` is the
same bytes as a file, for anyone who wants to disassemble it. -/
def writePage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/nixwars.html" page
  IO.FS.writeFile "www/arcade.html" arcadePage
  Wasm.writeWasm

#eval writePage

end NixWars
