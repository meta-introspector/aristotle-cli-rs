import RequestProject.Nix.NixWars.EmpireCodec
import RequestProject.Nix.NixWars.EmpireShare
import RequestProject.Nix.NixWars.Gl

/-!
# One move, one page

`www/empire.html` is a game of *Foundation and Empire* frozen into a single
static file: no server, no session, no clock. The page carries

* the log of every command played so far, and with it every state the game has
  been in, recomputed from the opening position when the page loads;
* the chain of hashes, one per state, which the page recomputes and checks
  against the ones written into it;
* the commitment — the SHA-256 of the canonical log text — which is the number
  a player posts to a chain, a rollup or a bulletin board;
* and its own source, base64 in a string, so that when you play a command the
  page writes the *next* page: same file, log one longer.

That is the whole protocol. A player hosts a page; the other player downloads
it, plays, and hosts the successor. Nobody has to trust anybody: the log
replays, and if a state in it is not the state the rules give, the chain does
not close.

`pageFor` is the fixed point: Lean's emitter and the page's own successor
function are the same function of the log, so the page a player saves after a
command is byte for byte the page Lean would have emitted for that log.
-/

namespace NixWars

/-- The page's source, with two holes: the log, and the page's own source in
base64. -/
def pageTemplate : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>FOUNDATION AND EMPIRE - a NixWars ledger game</title>
<style>
:root { --ink: #b8ffcf; --dim: #2b6b45; --bg: #04120a; --hot: #ffd166; --red: #ff6b6b; --blue: #7cc4ff; }
* { box-sizing: border-box; }
body { margin: 0; background: var(--bg); color: var(--ink);
       font-family: "DejaVu Sans Mono", "Courier New", monospace; font-size: 14px; }
a { color: var(--hot); }
header { padding: 10px 14px; border-bottom: 1px solid var(--dim); }
h1 { font-size: 18px; margin: 0 0 4px 0; letter-spacing: 2px; }
.sub { color: var(--dim); font-size: 12px; }
.wrap { display: flex; flex-wrap: wrap; gap: 12px; padding: 12px; }
.panel { border: 1px solid var(--dim); padding: 10px; flex: 1 1 340px; min-width: 320px; }
.panel h2 { font-size: 13px; margin: 0 0 8px 0; letter-spacing: 2px; color: var(--hot); }
table { border-collapse: collapse; width: 100%; font-size: 12px; }
th, td { text-align: left; padding: 2px 6px; border-bottom: 1px solid #123322; }
th { color: var(--dim); font-weight: normal; }
tr.sel td { background: #0d2a1a; }
tr.click:hover td { background: #103724; cursor: pointer; }
.p1 { color: var(--blue); }
.p2 { color: var(--red); }
.p0 { color: var(--dim); }
button, select, input { background: #061c10; color: var(--ink); border: 1px solid var(--dim);
                        font-family: inherit; font-size: 13px; padding: 4px 8px; }
button:hover { background: #0d2a1a; cursor: pointer; }
button:disabled { color: var(--dim); cursor: not-allowed; }
.ok { color: #7dff9e; }
.bad { color: var(--red); }
.mono { word-break: break-all; font-size: 11px; color: var(--hot); }
.scroll { max-height: 320px; overflow: auto; }
footer { padding: 10px 14px; border-top: 1px solid var(--dim); color: var(--dim); font-size: 11px; }
svg { width: 100%; height: auto; display: block; }
.legend { font-size: 11px; color: var(--dim); margin-top: 6px; }
"## ++ Gl.responsiveCss ++ r##"</style>
</head>
<body>
<header>
<h1>FOUNDATION AND EMPIRE</h1>
<div class="sub">A NixWars ledger game. Twelve systems, two empires. Play here, in the
page: every command you play is written into this page's own address and kept in your
browser, so the whole game travels as one link and nothing has to be downloaded to
take a turn. Everything below is recomputed from that game.</div>
</header>

<div class="wrap">
  <div class="panel" style="flex: 2 1 480px">
    <h2>THE GALAXY</h2>
    <div id="map"></div>
    <div class="legend">Ring of twelve systems. Blue: the Foundation (player 1, Terminus).
    Red: the Empire (player 2, Trantor). Grey: unclaimed. p = colonists, i = industry,
    f = hulls in orbit.</div>
  </div>
  <div class="panel">
    <h2>THE TWO EMPIRES</h2>
    <div id="stats"></div>
  </div>
</div>

<div class="wrap">
  <div class="panel">
    <h2>COMMAND</h2>
    <div id="console"></div>
    <div id="cmderr" class="bad"></div>
  </div>
  <div class="panel">
    <h2>THE LEDGER</h2>
    <div id="ledger"></div>
  </div>
</div>

<div class="wrap">
  <div class="panel" style="flex: 2 1 480px">
    <h2>THE LINK - the whole game, to keep and to hand over</h2>
    <div id="share"></div>
  </div>
  <div class="panel">
    <h2>JOIN - take on the other player's game</h2>
    <div id="join"></div>
    <div id="joinout"></div>
  </div>
</div>

<div class="wrap">
  <div class="panel" style="flex: 2 1 480px">
    <h2>THE LOG - every state of this game</h2>
    <div class="scroll"><table id="history"></table></div>
  </div>
  <div class="panel">
    <h2>WHAT IS PROVED</h2>
    <div id="proofs"></div>
  </div>
</div>

<div class="wrap">
  <div class="panel">
    <h2>THE STAKE</h2>
    <div id="stake"></div>
  </div>
  <div class="panel">
    <h2>THE REFEREE - audit another player's game</h2>
    <div id="audit"></div>
  </div>
</div>

<footer>
This page is emitted by Lean. The rules it plays, the chain it hashes and the
successor page it writes are the ones proved in
<span class="mono">RequestProject/NixWars/Empire.lean</span>,
<span class="mono">RequestProject/NixWars/Ledger.lean</span> and - for the share
code, the link and the join - <span class="mono">RequestProject/NixWars/EmpireShare.lean</span>. The page's own
JavaScript is a transcription of those definitions, checked against
Lean-computed values by <span class="mono">www/empire-selftest.mjs</span>.
</footer>

<script>
// ===ENGINE-START===
// A transcription of the Lean rules. Every function here mirrors a definition
// in RequestProject/NixWars/Empire.lean or Ledger.lean.
var N = 12, VICT = 8, SHIP = 5, COLONY = 20, TECHC = 30, CAP = 9;
var HP = 2147483647, HB = 131;
var NAMES = ["TERMINUS","ANACREON","SMYRNO","KALGAN","SIWENNA","ASKONE",
             "GLYPTAL IV","LORIS","VEGA","NEOTRANTOR","SANTANNI","TRANTOR"];

function emptySys() { return { o: 0, p: 0, i: 0, s1: 0, s2: 0 }; }
function home(p) {
  return p === 1 ? { o: 1, p: 6, i: 4, s1: 2, s2: 0 } : { o: 2, p: 6, i: 4, s1: 0, s2: 2 };
}
function genesis() {
  var sys = [home(1)];
  for (var i = 0; i < 10; i++) sys.push(emptySys());
  sys.push(home(2));
  return { sys: sys, c1: 60, c2: 60, t1: 0, t2: 0, round: 0, active: 1, winner: 0 };
}
function clone(g) { return JSON.parse(JSON.stringify(g)); }
function foe(p) { return p === 1 ? 2 : 1; }
function fleet(s, p) { return p === 1 ? s.s1 : (p === 2 ? s.s2 : 0); }
function setFleet(s, p, n) { if (p === 1) s.s1 = n; else if (p === 2) s.s2 = n; }
function cred(g, p) { return p === 1 ? g.c1 : (p === 2 ? g.c2 : 0); }
function setCred(g, p, n) { if (p === 1) g.c1 = n; else if (p === 2) g.c2 = n; }
function tech(g, p) { return p === 1 ? g.t1 : (p === 2 ? g.t2 : 0); }
function setTech(g, p, n) { if (p === 1) g.t1 = n; else if (p === 2) g.t2 = n; }
function sub(a, b) { return a > b ? a - b : 0; }
function holdings(g, p) { var n = 0; for (var i = 0; i < g.sys.length; i++) if (g.sys[i].o === p) n++; return n; }
function hulls(g, p) { var n = 0; for (var i = 0; i < g.sys.length; i++) n += fleet(g.sys[i], p); return n; }

function legal(g, m) {
  if (g.winner !== 0) return false;
  var p = g.active, s;
  if (m.t === "build") {
    s = g.sys[m.a];
    return m.a < N && !!s && s.o === p && s.i >= 1 && cred(g, p) >= SHIP;
  }
  if (m.t === "jump") {
    s = g.sys[m.a];
    return m.a < N && m.b < N && m.a !== m.b && m.n >= 1 && !!s &&
           m.n <= fleet(s, p) && m.n <= cred(g, p);
  }
  if (m.t === "colonise") {
    s = g.sys[m.a];
    return m.a < N && !!s && s.o === 0 && fleet(s, p) >= 1 && cred(g, p) >= COLONY;
  }
  if (m.t === "research") return cred(g, p) >= TECHC;
  if (m.t === "pass") return true;
  return false;
}

function resolve(p, s) {
  var a = fleet(s, p), d = fleet(s, foe(p)), k = Math.min(a, d);
  var captured = (a - k > 0) && (d - k === 0) && (s.o === foe(p));
  return { o: captured ? p : s.o,
           p: captured ? Math.floor(s.p / 2) : s.p,
           i: captured ? Math.floor(s.i / 2) : s.i,
           s1: p === 1 ? a - k : d - k,
           s2: p === 1 ? d - k : a - k };
}

function produce(g) {
  var h = clone(g);
  for (var i = 0; i < h.sys.length; i++) {
    var s = h.sys[i];
    if (s.o === 0) continue;
    var pop = Math.min(CAP, s.p + 1);
    var ind = (s.i < pop && s.i < CAP) ? s.i + 1 : s.i;
    s.p = pop; s.i = ind;
    setCred(h, s.o, cred(h, s.o) + ind * (2 + tech(h, s.o)));
  }
  h.round = h.round + 1;
  return h;
}

function endTurn(g) {
  var h = clone(g);
  if (h.active === 1) { h.active = 2; return h; }
  h.active = 1;
  return produce(h);
}

function crown(g) {
  var h = clone(g);
  if (holdings(h, 1) >= VICT) h.winner = 1;
  else if (holdings(h, 2) >= VICT) h.winner = 2;
  return h;
}

function applyMove(g, m) {
  var h = clone(g), p = h.active, s;
  if (m.t === "build") {
    s = h.sys[m.a]; setFleet(s, p, fleet(s, p) + 1);
    setCred(h, p, sub(cred(h, p), SHIP));
    return h;
  }
  if (m.t === "jump") {
    var a = h.sys[m.a]; setFleet(a, p, sub(fleet(a, p), m.n));
    var b = h.sys[m.b]; setFleet(b, p, fleet(b, p) + m.n);
    h.sys[m.b] = resolve(p, b);
    setCred(h, p, sub(cred(h, p), m.n));
    return h;
  }
  if (m.t === "colonise") {
    s = h.sys[m.a]; setFleet(s, p, sub(fleet(s, p), 1));
    s.o = p; s.p = 1; s.i = 1;
    setCred(h, p, sub(cred(h, p), COLONY));
    return h;
  }
  if (m.t === "research") {
    setTech(h, p, tech(h, p) + 1);
    setCred(h, p, sub(cred(h, p), TECHC));
    return h;
  }
  return endTurn(h);
}

function step(g, m) { return legal(g, m) ? crown(applyMove(g, m)) : clone(g); }

function statesOf(log) {
  var g = genesis(), out = [g];
  for (var i = 0; i < log.length; i++) { g = step(g, log[i]); out.push(g); }
  return out;
}

// --- the chain -------------------------------------------------------------
function mix(h, b) { return (h * HB + b + 1) % HP; }
function hashNums(h, l) { for (var i = 0; i < l.length; i++) h = mix(h, l[i]); return h; }
function encodeGalaxy(g) {
  var out = [];
  for (var i = 0; i < g.sys.length; i++) {
    var s = g.sys[i];
    out.push(s.o, s.p, s.i, s.s1, s.s2);
  }
  out.push(g.c1, g.c2, g.t1, g.t2, g.round, g.active, g.winner);
  return out;
}
function encodeMove(m) {
  if (m.t === "build") return [1, m.a, 0, 0];
  if (m.t === "jump") return [2, m.a, m.b, m.n];
  if (m.t === "colonise") return [3, m.a, 0, 0];
  if (m.t === "research") return [4, 0, 0, 0];
  return [5, 0, 0, 0];
}
function rootHash(g) { return hashNums(0, encodeGalaxy(g)); }
function chainStep(h, m, g) { return hashNums(h, encodeMove(m).concat(encodeGalaxy(g))); }
function chainOf(log) {
  var g = genesis(), h = rootHash(g), out = [h];
  for (var i = 0; i < log.length; i++) {
    g = step(g, log[i]);
    h = chainStep(h, log[i], g);
    out.push(h);
  }
  return out;
}
function commitOf(log) { var c = chainOf(log); return c[c.length - 1]; }
function moveLine(m) {
  if (m.t === "build") return "build " + m.a;
  if (m.t === "jump") return "jump " + m.a + " " + m.b + " " + m.n;
  if (m.t === "colonise") return "colonise " + m.a;
  if (m.t === "research") return "research";
  return "pass";
}
function logText(log) {
  var s = "NIXWARS-EMPIRE/1\n";
  for (var i = 0; i < log.length; i++) s += moveLine(log[i]) + "\n";
  return s + "chain " + commitOf(log) + "\n";
}

// --- SHA-256 ---------------------------------------------------------------
var SHA_K = [
  0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0xab1c5ed5,
  0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
  0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
  0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
  0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2c92e,0x92722c85,
  0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
  0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
  0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2];

function utf8Bytes(str) {
  var out = [], i, c;
  for (i = 0; i < str.length; i++) {
    c = str.charCodeAt(i);
    if (c < 0x80) out.push(c);
    else if (c < 0x800) { out.push(0xc0 | (c >> 6), 0x80 | (c & 63)); }
    else { out.push(0xe0 | (c >> 12), 0x80 | ((c >> 6) & 63), 0x80 | (c & 63)); }
  }
  return out;
}
function rotr32(x, n) { return ((x >>> n) | (x << (32 - n))) >>> 0; }
function sha256Hex(str) {
  var msg = utf8Bytes(str), bitLen = msg.length * 8;
  msg = msg.slice();
  msg.push(0x80);
  while (msg.length % 64 !== 56) msg.push(0);
  var hi = Math.floor(bitLen / 4294967296), lo = bitLen >>> 0;
  msg.push((hi >>> 24) & 255, (hi >>> 16) & 255, (hi >>> 8) & 255, hi & 255);
  msg.push((lo >>> 24) & 255, (lo >>> 16) & 255, (lo >>> 8) & 255, lo & 255);
  var H = [0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19];
  var w = new Array(64), i, j, a, b, c, d, e, f, g, h, s0, s1, ch, mj, t1, t2;
  for (i = 0; i < msg.length; i += 64) {
    for (j = 0; j < 16; j++) {
      w[j] = ((msg[i + 4*j] << 24) | (msg[i + 4*j + 1] << 16) |
              (msg[i + 4*j + 2] << 8) | msg[i + 4*j + 3]) >>> 0;
    }
    for (j = 16; j < 64; j++) {
      s0 = (rotr32(w[j-15], 7) ^ rotr32(w[j-15], 18) ^ (w[j-15] >>> 3)) >>> 0;
      s1 = (rotr32(w[j-2], 17) ^ rotr32(w[j-2], 19) ^ (w[j-2] >>> 10)) >>> 0;
      w[j] = (w[j-16] + s0 + w[j-7] + s1) >>> 0;
    }
    a = H[0]; b = H[1]; c = H[2]; d = H[3]; e = H[4]; f = H[5]; g = H[6]; h = H[7];
    for (j = 0; j < 64; j++) {
      s1 = (rotr32(e, 6) ^ rotr32(e, 11) ^ rotr32(e, 25)) >>> 0;
      ch = ((e & f) ^ ((~e) & g)) >>> 0;
      t1 = (h + s1 + ch + SHA_K[j] + w[j]) >>> 0;
      s0 = (rotr32(a, 2) ^ rotr32(a, 13) ^ rotr32(a, 22)) >>> 0;
      mj = ((a & b) ^ (a & c) ^ (b & c)) >>> 0;
      t2 = (s0 + mj) >>> 0;
      h = g; g = f; f = e; e = (d + t1) >>> 0; d = c; c = b; b = a; a = (t1 + t2) >>> 0;
    }
    H[0] = (H[0] + a) >>> 0; H[1] = (H[1] + b) >>> 0; H[2] = (H[2] + c) >>> 0;
    H[3] = (H[3] + d) >>> 0; H[4] = (H[4] + e) >>> 0; H[5] = (H[5] + f) >>> 0;
    H[6] = (H[6] + g) >>> 0; H[7] = (H[7] + h) >>> 0;
  }
  var out = "";
  for (i = 0; i < 8; i++) {
    var x = H[i];
    for (j = 3; j >= 0; j--) {
      var byteVal = (x >>> (8 * j)) & 255;
      out += "0123456789abcdef"[(byteVal >> 4) & 15] + "0123456789abcdef"[byteVal & 15];
    }
  }
  return out;
}
function commitHex(log) { return sha256Hex(logText(log)); }

// The stake receipt, byte for byte the way Lean's `receiptJson` writes it.
function receiptText(log) {
  var c = chainOf(log), st = statesOf(log);
  return "{\"format\":\"NIXWARS-EMPIRE/1\",\"moves\":" + log.length +
    ",\"root\":" + c[0] +
    ",\"commit\":" + c[c.length - 1] +
    ",\"sha256\":\"" + commitHex(log) + "\"" +
    ",\"winner\":" + st[st.length - 1].winner + "}";
}

// The log as JSON, byte for byte the way Lean's `logJson` writes it.
function moveJson(m) {
  return '{"t":"' + m.t + '","a":' + m.a + ',"b":' + m.b + ',"n":' + m.n + '}';
}
function logJson(log) {
  var out = [];
  for (var i = 0; i < log.length; i++) out.push(moveJson(log[i]));
  return "[" + out.join(",") + "]";
}

// --- the share code: a whole game in a few characters ----------------------
// A transcription of RequestProject/NixWars/EmpireShare.lean. A command is a
// tag and its arguments; each number is base 32, low digit first, raised by 32
// while another digit follows. So a pass is one character and a jump is four.
var SDIG = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_";

function encNat(n) {
  var out = "";
  while (n >= 32) { out += SDIG.charAt(32 + (n % 32)); n = Math.floor(n / 32); }
  return out + SDIG.charAt(n);
}

// read a number at position i: [value, next position], or null
function decNat(s, i) {
  if (i >= s.length) return null;
  var v = SDIG.indexOf(s.charAt(i));
  if (v < 0) return null;
  if (v < 32) return [v, i + 1];
  var more = decNat(s, i + 1);
  if (more === null) return null;
  return [v - 32 + 32 * more[0], more[1]];
}

function encMove(m) {
  if (m.t === "build") return encNat(0) + encNat(m.a);
  if (m.t === "jump") return encNat(1) + encNat(m.a) + encNat(m.b) + encNat(m.n);
  if (m.t === "colonise") return encNat(2) + encNat(m.a);
  if (m.t === "research") return encNat(3);
  return encNat(4);
}

function encodeLog(log) {
  var out = "";
  for (var i = 0; i < log.length; i++) out += encMove(log[i]);
  return out;
}

// the game a code carries, or null if it is not a code
function decodeLog(s) {
  if (typeof s !== "string") return null;
  var log = [], i = 0, t, a, b, n;
  while (i < s.length) {
    t = decNat(s, i);
    if (t === null) return null;
    i = t[1];
    if (t[0] === 0 || t[0] === 2) {
      a = decNat(s, i); if (a === null) return null; i = a[1];
      log.push({ t: t[0] === 0 ? "build" : "colonise", a: a[0], b: 0, n: 0 });
    } else if (t[0] === 1) {
      a = decNat(s, i); if (a === null) return null; i = a[1];
      b = decNat(s, i); if (b === null) return null; i = b[1];
      n = decNat(s, i); if (n === null) return null; i = n[1];
      log.push({ t: "jump", a: a[0], b: b[0], n: n[0] });
    } else if (t[0] === 3) {
      log.push({ t: "research", a: 0, b: 0, n: 0 });
    } else if (t[0] === 4) {
      log.push({ t: "pass", a: 0, b: 0, n: 0 });
    } else return null;
  }
  return log;
}

// the fragment a page keeps its game in, and the game a fragment carries
function hashOfLog(log) { return "#g=" + encodeLog(log); }
function logOfHash(h) {
  return (typeof h === "string" && h.slice(0, 3) === "#g=") ? decodeLog(h.slice(3)) : null;
}

// is one game the other with fewer commands played?
function isPrefixLog(a, b) {
  if (a.length > b.length) return false;
  for (var i = 0; i < a.length; i++) if (moveJson(a[i]) !== moveJson(b[i])) return false;
  return true;
}

// the join of two games: the longer, when one extends the other; null when
// they have really diverged and no single game contains them both.
function joinLogs(a, b) {
  if (isPrefixLog(a, b)) return b;
  if (isPrefixLog(b, a)) return a;
  return null;
}

// where two games part company
function forkPoint(a, b) {
  var i = 0;
  while (i < a.length && i < b.length && moveJson(a[i]) === moveJson(b[i])) i++;
  return i;
}
// ===ENGINE-END===

// --- the log this page carries ---------------------------------------------
var LOG = @@LOG@@;
var TEMPLATE = "@@TEMPLATE@@";

// --- the successor page ----------------------------------------------------
// The fixed point: the page's own source, with the log replaced. This is the
// same function of the log as Lean's `pageFor`, so the page saved after a
// command is the page Lean would have emitted for that log.
// The two holes are spelled in pieces so that the substitution below cannot
// clobber this function's own source when the page rewrites itself.
function pageFor(log) {
  var holeT = "@@" + "TEMPLATE" + "@@", holeL = "@@" + "LOG" + "@@";
  var tpl = atob(TEMPLATE);
  return tpl.split(holeT).join(TEMPLATE).split(holeL).join(logJson(log));
}
// ===PAGEFOR-END===

// --- where the game is kept --------------------------------------------------
// Three places may hold a game: the position this file was emitted for, the one
// this browser has been playing, and the one in the link that was opened. They
// are games of the same match, so they are JOINED rather than fought over: the
// longer wins, and a genuine fork is reported instead of quietly resolved.
var STORE_KEY = "nixwars-empire-v1";
var BASELOG = LOG;
var LOADNOTE = "";

function storedLog() {
  try { return decodeLog(window.localStorage.getItem(STORE_KEY)); } catch (e) { return null; }
}

function linkLog() {
  try { return logOfHash(window.location.hash); } catch (e) { return null; }
}

function saveLog(log) {
  try { window.localStorage.setItem(STORE_KEY, encodeLog(log)); } catch (e) { }
  try {
    var h = hashOfLog(log);
    if (window.history && window.history.replaceState) window.history.replaceState(null, "", h);
    else window.location.hash = h;
  } catch (e) { }
}

function absorb(log, other, what) {
  if (other === null) return log;
  var j = joinLogs(log, other);
  if (j === null) {
    LOADNOTE += "The " + what + " is a different game - it parts from this one at command " +
                forkPoint(log, other) + " - so it was left where it was. ";
    return log;
  }
  return j;
}

function bootLog() {
  var log = BASELOG;
  // the link was asked for by hand, so it is taken on first; a game left in
  // this browser is only taken on if it is the same game carried further.
  log = absorb(log, linkLog(), "game in the link");
  log = absorb(log, storedLog(), "game saved in this browser");
  return log;
}

LOG = bootLog();

// --- the page ---------------------------------------------------------------
var STATES = statesOf(LOG);
var CHAIN = chainOf(LOG);
var VIEW = STATES.length - 1;

function esc(s) { return String(s).replace(/&/g, "&amp;").replace(/</g, "&lt;"); }
function cls(o) { return o === 1 ? "p1" : (o === 2 ? "p2" : "p0"); }

function drawMap() {
  var g = STATES[VIEW], parts = [], i;
  var cx = 300, cy = 200, rx = 250, ry = 150;
  parts.push('<svg viewBox="0 0 600 400" role="img">');
  parts.push('<ellipse cx="300" cy="200" rx="250" ry="150" fill="none" stroke="#123322"/>');
  for (i = 0; i < g.sys.length; i++) {
    var ang = (i / g.sys.length) * 2 * Math.PI - Math.PI / 2;
    var x = cx + rx * Math.cos(ang), y = cy + ry * Math.sin(ang);
    var s = g.sys[i];
    var col = s.o === 1 ? "#7cc4ff" : (s.o === 2 ? "#ff6b6b" : "#2b6b45");
    var r = 6 + Math.min(9, s.i) * 1.6;
    parts.push('<circle cx="' + x.toFixed(1) + '" cy="' + y.toFixed(1) + '" r="' + r.toFixed(1) +
               '" fill="' + col + '" fill-opacity="0.25" stroke="' + col + '"/>');
    parts.push('<text x="' + x.toFixed(1) + '" y="' + (y - r - 6).toFixed(1) +
               '" fill="' + col + '" font-size="11" text-anchor="middle">' +
               i + " " + esc(NAMES[i]) + "</text>");
    var line = "p" + s.p + " i" + s.i;
    if (s.s1 > 0) line += " f1:" + s.s1;
    if (s.s2 > 0) line += " f2:" + s.s2;
    parts.push('<text x="' + x.toFixed(1) + '" y="' + (y + r + 14).toFixed(1) +
               '" fill="#b8ffcf" font-size="10" text-anchor="middle">' + esc(line) + "</text>");
  }
  parts.push('<text x="300" y="196" fill="#2b6b45" font-size="12" text-anchor="middle">ROUND ' +
             g.round + "</text>");
  parts.push('<text x="300" y="214" fill="#2b6b45" font-size="12" text-anchor="middle">STATE ' +
             VIEW + " OF " + (STATES.length - 1) + "</text>");
  parts.push("</svg>");
  document.getElementById("map").innerHTML = parts.join("");
}

function drawStats() {
  var g = STATES[VIEW], rows = [];
  rows.push("<table><tr><th></th><th class='p1'>FOUNDATION</th><th class='p2'>EMPIRE</th></tr>");
  rows.push("<tr><td>credits</td><td>" + g.c1 + "</td><td>" + g.c2 + "</td></tr>");
  rows.push("<tr><td>technology</td><td>" + g.t1 + "</td><td>" + g.t2 + "</td></tr>");
  rows.push("<tr><td>systems</td><td>" + holdings(g, 1) + "</td><td>" + holdings(g, 2) + "</td></tr>");
  rows.push("<tr><td>hulls</td><td>" + hulls(g, 1) + "</td><td>" + hulls(g, 2) + "</td></tr>");
  rows.push("</table>");
  rows.push("<p>Round " + g.round + ". To move: <span class='" + cls(g.active) + "'>" +
            (g.active === 1 ? "FOUNDATION" : "EMPIRE") + "</span>.</p>");
  if (g.winner !== 0) {
    rows.push("<p class='ok'>GAME OVER. Winner: " + (g.winner === 1 ? "FOUNDATION" : "EMPIRE") +
              ". A won game is frozen: no further command changes it.</p>");
  } else {
    rows.push("<p>Victory at " + VICT + " systems. Costs: hull " + SHIP + ", colony " + COLONY +
              ", technology " + TECHC + ", one credit per hull per jump.</p>");
  }
  if (VIEW !== STATES.length - 1) {
    rows.push("<p class='bad'>Viewing an earlier state. " +
              "<button onclick='setView(" + (STATES.length - 1) + ")'>BACK TO NOW</button></p>");
  }
  document.getElementById("stats").innerHTML = rows.join("");
}

function optionList(id, n, label) {
  var out = "<label>" + label + " <select id='" + id + "'>";
  for (var i = 0; i < n; i++) out += "<option value='" + i + "'>" + i + " " + esc(NAMES[i]) + "</option>";
  return out + "</select></label> ";
}

function drawConsole() {
  var g = STATES[STATES.length - 1];
  var out = [];
  if (g.winner !== 0) {
    out.push("<p>The game is over. Nothing further can be played; the ledger is closed.</p>");
    out.push("<p><button onclick='undoMove()'>TAKE BACK THE LAST COMMAND</button> " +
             "<button onclick='restartGame()'>START OVER</button></p>");
  } else {
    out.push("<p>You are playing as <span class='" + cls(g.active) + "'>" +
             (g.active === 1 ? "the FOUNDATION" : "the EMPIRE") + "</span>.</p>");
    out.push("<p><label>command <select id='cmd' onchange='drawArgs()'>" +
             "<option value='build'>build - lay down a hull</option>" +
             "<option value='jump'>jump - send hulls</option>" +
             "<option value='colonise'>colonise - plant a colony</option>" +
             "<option value='research'>research - buy a technology level</option>" +
             "<option value='pass'>pass - end your turn</option>" +
             "</select></label></p>");
    out.push("<p id='args'></p>");
    out.push("<p><button onclick='playMove()'>PLAY THIS COMMAND</button> " +
             "<button onclick='undoMove()'" + (LOG.length === 0 ? " disabled" : "") +
             ">TAKE BACK THE LAST</button> " +
             "<button onclick='restartGame()'>START OVER</button></p>");
  }
  out.push("<p id='played' class='ok'></p>");
  document.getElementById("console").innerHTML = out.join("");
  if (g.winner === 0) drawArgs();
}

function drawArgs() {
  var t = document.getElementById("cmd").value, out = "";
  if (t === "build" || t === "colonise") out = optionList("argA", N, "at");
  else if (t === "jump") {
    out = optionList("argA", N, "from") + optionList("argB", N, "to") +
          "<label>hulls <input id='argN' type='number' min='1' value='1' style='width:5em'></label>";
  } else out = "<span class='p0'>no arguments</span>";
  document.getElementById("args").innerHTML = out;
}

function readMove() {
  var t = document.getElementById("cmd").value;
  var a = 0, b = 0, n = 0;
  if (t === "build" || t === "colonise") a = parseInt(document.getElementById("argA").value, 10);
  if (t === "jump") {
    a = parseInt(document.getElementById("argA").value, 10);
    b = parseInt(document.getElementById("argB").value, 10);
    n = parseInt(document.getElementById("argN").value, 10);
  }
  return { t: t, a: a, b: b, n: n };
}

// Everything a change of the game goes through: the states and the hashes are
// recomputed, the game is written to the address bar and to local storage, and
// every panel is redrawn. No file leaves the browser to play a command.
function refresh() {
  STATES = statesOf(LOG);
  CHAIN = chainOf(LOG);
  VIEW = STATES.length - 1;
  saveLog(LOG);
  drawAll();
  drawConsole();
  drawLedger();
  drawStake();
  drawShare();
}

function playMove() {
  var g = STATES[STATES.length - 1], m = readMove();
  document.getElementById("cmderr").textContent = "";
  if (!legal(g, m)) {
    document.getElementById("cmderr").textContent =
      "That command is not legal here, and an illegal command is a no-op: the game would not change.";
    return;
  }
  LOG = LOG.concat([m]);
  refresh();
  document.getElementById("played").textContent =
    "Played: " + moveLine(m) + ". The game is now " + LOG.length + " command" +
    (LOG.length === 1 ? "" : "s") + " long, and the link in your address bar carries it.";
}

function undoMove() {
  if (LOG.length === 0) return;
  var m = LOG[LOG.length - 1];
  LOG = LOG.slice(0, LOG.length - 1);
  refresh();
  document.getElementById("played").textContent = "Took back: " + moveLine(m) + ".";
}

function restartGame() {
  LOG = [];
  refresh();
  document.getElementById("played").textContent = "A fresh game, nothing played.";
}

// --- the game as a link ------------------------------------------------------
function escAttr(s) { return esc(s).replace(/"/g, "&quot;"); }

function shareLink() {
  try { return String(window.location.href).split("#")[0] + hashOfLog(LOG); }
  catch (e) { return hashOfLog(LOG); }
}

function drawShare() {
  var code = encodeLog(LOG), out = [];
  out.push("<p>The game is written into this page's own address, after the " +
           "<span class='mono'>#</span>. Nothing after a <span class='mono'>#</span> is " +
           "ever sent to a server: the game sits in your browser and travels only when " +
           "you hand somebody the link. Open it and you are in this position, on this " +
           "move, with every command that led here.</p>");
  out.push("<p><input id='sharelink' readonly value=\"" + escAttr(shareLink()) + "\" " +
           "style='width:100%' onclick='this.select()'></p>");
  out.push("<p><button onclick='copyLink()'>COPY THE LINK</button> " +
           "<button onclick='copyCode()'>COPY THE CODE</button> " +
           "<span id='copiedlink' class='ok'></span></p>");
  out.push("<p>" + LOG.length + " command" + (LOG.length === 1 ? "" : "s") + " in " +
           code.length + " character" + (code.length === 1 ? "" : "s") +
           ":<br><span class='mono' id='sharecode'>" +
           (code === "" ? "(the opening position - nothing played yet)" : esc(code)) +
           "</span></p>");
  out.push("<p>This browser is keeping the game too, so closing the tab costs nothing: " +
           "come back to any page of this family and it resumes where you left off. " +
           (LOADNOTE === "" ? "" : "<span class='bad'>" + esc(LOADNOTE) + "</span>") + "</p>");
  out.push("<p><button onclick='saveGameFile()'>SAVE THE GAME AS A FILE</button> " +
           "<span id='saved'></span> &mdash; only if you want to host it yourself; " +
           "the link above is enough to play and to share.</p>");
  document.getElementById("share").innerHTML = out.join("");
}

function copyText(t, id) {
  var note = document.getElementById(id);
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(t).then(function () { note.textContent = "copied"; },
                                          function () { note.textContent = "select it by hand"; });
  } else { note.textContent = "select it by hand"; }
}
function copyLink() { copyText(shareLink(), "copiedlink"); }
function copyCode() { copyText(encodeLog(LOG), "copiedlink"); }

function saveGameFile() {
  var note = document.getElementById("saved");
  var name = "empire-" + LOG.length + "-" + commitHex(LOG).slice(0, 12) + ".html";
  try {
    var url = URL.createObjectURL(new Blob([pageFor(LOG)], { type: "text/html" }));
    note.innerHTML = "<a download='" + name + "' href='" + url + "'>" + name + "</a>";
  } catch (e) { note.textContent = "this browser will not write the file"; }
}

// --- joining the other player's game -----------------------------------------
// A link, a bare code, or a log as JSON: all of them are a game.
function logOfAnything(raw) {
  var s = String(raw === null || raw === undefined ? "" : raw).replace(/^\s+|\s+$/g, "");
  if (s === "") return null;
  var i = s.indexOf("#g=");
  if (i >= 0) return decodeLog(s.slice(i + 3));
  if (s.charAt(0) === "[" || s.charAt(0) === "{") {
    var j;
    try { j = JSON.parse(s); } catch (e) { return null; }
    if (j && !(j instanceof Array) && j.log instanceof Array) j = j.log;
    if (!(j instanceof Array)) return null;
    var out = [];
    for (var k = 0; k < j.length; k++) {
      var m = j[k];
      if (!m || typeof m.t !== "string") return null;
      out.push({ t: m.t, a: m.a | 0, b: m.b | 0, n: m.n | 0 });
    }
    return out;
  }
  return decodeLog(s);
}

function drawJoin() {
  var out = [];
  out.push("<p>Two people play one game by handing the link back and forth. Paste what " +
           "the other player sent - link, code or log - and the two games are joined: if " +
           "theirs is yours with more commands played on the end, you take those on; if " +
           "yours is the longer, nothing of yours is lost. Only a real fork, where each " +
           "of you played something the other did not, has no join, and then the page " +
           "says so rather than picking a side.</p>");
  out.push("<p><input id='joinin' style='width:100%' placeholder='paste a link, a code, or a log'></p>");
  out.push("<p><button onclick='runJoin()'>JOIN</button></p>");
  document.getElementById("join").innerHTML = out.join("");
}

function runJoin() {
  var box = document.getElementById("joinout");
  var other = logOfAnything(document.getElementById("joinin").value);
  if (other === null) {
    box.innerHTML = "<p class='bad'>That is not a game: expected a link, a share code, " +
                    "or a log as JSON.</p>";
    return;
  }
  var joined = joinLogs(LOG, other);
  if (joined === null) {
    box.innerHTML = "<p class='bad'>NO JOIN.</p><p>Their game parts from yours at command " +
      forkPoint(LOG, other) + ": each of you has played something the other has not, so no " +
      "single game holds them both. One side has to give way - the referee below will " +
      "replay theirs so you can see which game is the one you meant.</p>";
    return;
  }
  var gained = joined.length - LOG.length, spare = joined.length - other.length;
  LOG = joined;
  refresh();
  box.innerHTML = "<p class='ok'>JOINED.</p><p>The game is " + joined.length + " command" +
    (joined.length === 1 ? "" : "s") + " long: " +
    (gained > 0 ? "you took on " + gained + " command" + (gained === 1 ? "" : "s") + " of theirs"
                : (spare > 0 ? "yours was the longer, by " + spare + " command" +
                               (spare === 1 ? "" : "s") + ", and stands"
                             : "the two were already the same game")) +
    ". Every hash either side had computed is still in the chain, in the same place.</p>";
}

function drawLedger() {
  var recomputed = chainOf(LOG), ok = true, i;
  for (i = 0; i < recomputed.length; i++) if (recomputed[i] !== CHAIN[i]) ok = false;
  var out = [];
  out.push("<p>" + (ok
    ? "<span class='ok'>CHAIN VERIFIED.</span> Every state in this page is the state the rules give, and every hash is the hash of that state."
    : "<span class='bad'>CHAIN BROKEN.</span> A state in this page is not the state the rules give.") + "</p>");
  out.push("<p>Commands: " + LOG.length + ". States: " + STATES.length + ".</p>");
  out.push("<p>Rolling commitment (base " + HB + " mod " + HP + "):<br><span class='mono'>" +
           CHAIN[CHAIN.length - 1] + "</span></p>");
  out.push("<p>SHA-256 of the canonical log:<br><span class='mono' id='sha'>" +
           commitHex(LOG) + "</span></p>");
  out.push("<p>That digest is what a player posts - to a chain, a rollup, or a notice board - " +
           "to stake a claim on this position. Anyone can recompute it from this file alone.</p>");
  out.push("<p><button onclick='showText()'>SHOW THE CANONICAL LOG TEXT</button></p>");
  out.push("<pre id='logtext' class='mono' style='display:none'></pre>");
  document.getElementById("ledger").innerHTML = out.join("");
}

function showText() {
  var e = document.getElementById("logtext");
  e.style.display = "block";
  e.textContent = logText(LOG);
}

function setView(i) { VIEW = i; drawAll(); }

function drawHistory() {
  var rows = [], i;
  rows.push("<tr><th>#</th><th>command</th><th>by</th><th>systems 1/2</th><th>hash</th></tr>");
  for (i = 0; i < STATES.length; i++) {
    var g = STATES[i];
    var label = i === 0 ? "(opening position)" : moveLine(LOG[i - 1]);
    var by = i === 0 ? "-" : (STATES[i - 1].active === 1 ? "FOUNDATION" : "EMPIRE");
    rows.push("<tr class='click " + (i === VIEW ? "sel" : "") + "' onclick='setView(" + i + ")'>" +
              "<td>" + i + "</td><td>" + esc(label) + "</td>" +
              "<td class='" + (i === 0 ? "p0" : cls(STATES[i - 1].active)) + "'>" + by + "</td>" +
              "<td>" + holdings(g, 1) + "/" + holdings(g, 2) + "</td>" +
              "<td class='mono'>" + CHAIN[i] + "</td></tr>");
  }
  document.getElementById("history").innerHTML = rows.join("");
}

function drawProofs() {
  var items = [
    ["step_illegal", "an illegal command changes nothing"],
    ["step_over", "a won game is frozen: no command changes it, ever"],
    ["step_length", "the galaxy always has its twelve systems"],
    ["resolve_annihilates", "a battle destroys one of the two fleets outright"],
    ["resolve_le", "a battle never adds a hull to either side"],
    ["resolve_owner", "a system only changes hands if the attacker's fleet survives it"],
    ["build_adds_one", "a shipyard lays down exactly one hull, and pays for it"],
    ["colonise_neutral", "a colony can only be planted on an unclaimed system"],
    ["produce_cred", "a round of production never costs a player a credit"],
    ["step_round", "the clock never runs backwards"],
    ["chain_prefix", "the ledger is append-only: playing on never rewrites a hash"],
    ["verifyFrom_iff", "the verifier accepts a record exactly when the rules and hashes agree"],
    ["verify_of_play", "and it accepts every game that was really played by the rules"],
    ["commit_snoc", "one more command moves the commitment on by exactly one link"],
    ["commit_inj", "if the mixer never collides, the commitment determines the log"],
    ["campaign_legal", "every command of the shipped campaign is legal where it is played"],
    ["foundation_wins", "the campaign ends with the Foundation holding eight systems"],
    ["campaign_tight", "and not one command sooner"],
    ["loris_taken", "the last command is the battle of Loris: 21 hulls against 20, one survives"],
    ["decode_encode", "the share code is the game: it reads back exactly, nothing lost"],
    ["logOfHash_hashOfLog", "and the link a page writes reopens the very game it was written for"],
    ["encodeLog_length_le", "four characters a command at the worst, so a long game still fits in a link"],
    ["join_isSome_iff_common", "two records of one game always join; only a real fork refuses"],
    ["join_least", "the join is the shortest game both are part of, so it invents no move"],
    ["join_chain_prefix", "and joining never rewrites history: every hash either side had is still there"]
  ];
  var out = ["<table>"];
  for (var i = 0; i < items.length; i++) {
    out.push("<tr><td class='mono'>" + items[i][0] + "</td><td>" + esc(items[i][1]) + "</td></tr>");
  }
  out.push("</table>");
  out.push("<p class='p0'>Machine-checked in Lean 4. The page's arithmetic is a transcription of " +
           "those definitions and is checked against Lean-computed values by the harness; " +
           "the SHA-256 here is an implementation, not a proof.</p>");
  document.getElementById("proofs").innerHTML = out.join("");
}

// --- the stake, and the referee --------------------------------------------
function drawStake() {
  var out = [];
  out.push("<p>The receipt for this position. Post it - to a chain, a rollup, a " +
           "notice board - and you have staked on this game and no other: anyone " +
           "holding the file can recompute every field of it, and the referee " +
           "beside this panel will say whether the game behind it was played by " +
           "the rules.</p>");
  out.push("<pre class='mono' id='receipt'>" + esc(receiptText(LOG)) + "</pre>");
  out.push("<p><button onclick='copyReceipt()'>COPY THE RECEIPT</button> " +
           "<span id='copied' class='ok'></span></p>");
  document.getElementById("stake").innerHTML = out.join("");
}

function copyReceipt() {
  var t = receiptText(LOG), note = document.getElementById("copied");
  if (navigator.clipboard && navigator.clipboard.writeText) {
    navigator.clipboard.writeText(t).then(function () { note.textContent = "copied"; },
                                          function () { note.textContent = "select it by hand"; });
  } else {
    note.textContent = "select it by hand";
  }
}

function drawAudit() {
  var out = [];
  out.push("<p>Paste a log - the array of commands another player's page carries, " +
           "or the receipt they posted with it - and this page will replay it under " +
           "the rules and recompute the hashes.</p>");
  out.push("<p><textarea id='auditin' rows='4' style='width:100%' " +
           "placeholder='[{\"t\":\"jump\",\"a\":0,\"b\":1,\"n\":1}]'></textarea></p>");
  out.push("<p><button onclick='runAudit()'>AUDIT</button></p>");
  out.push("<div id='auditout'></div>");
  document.getElementById("audit").innerHTML = out.join("");
}

function runAudit() {
  var box = document.getElementById("auditout");
  var raw = document.getElementById("auditin").value;
  var log;
  try { log = JSON.parse(raw); } catch (e) { log = null; }
  if (log && !(log instanceof Array) && log.log instanceof Array) log = log.log;
  if (!(log instanceof Array)) {
    box.innerHTML = "<p class='bad'>That is not a log: expected an array of commands.</p>";
    return;
  }
  var g = genesis(), i, bad = -1;
  for (i = 0; i < log.length; i++) {
    var m = log[i];
    if (!m || typeof m.t !== "string") { bad = i; break; }
    m = { t: m.t, a: m.a | 0, b: m.b | 0, n: m.n | 0 };
    log[i] = m;
    if (!legal(g, m)) { bad = i; break; }
    g = step(g, m);
  }
  var out = [];
  if (bad >= 0) {
    out.push("<p class='bad'>REJECTED at command " + bad + ": it is not legal there.</p>");
  } else {
    out.push("<p><span class='ok'>ACCEPTED.</span> All " + log.length +
             " commands are legal where they are played.</p>");
    out.push("<p>Systems: " + holdings(g, 1) + " Foundation, " + holdings(g, 2) + " Empire. " +
             "Winner: " + (g.winner === 0 ? "none yet" : (g.winner === 1 ? "FOUNDATION" : "EMPIRE")) +
             ".</p>");
    out.push("<p>Its receipt:</p><pre class='mono'>" + esc(receiptText(log)) + "</pre>");
    out.push("<p>Compare that with the one they posted. If it differs, the game " +
             "they staked on is not the game they showed you.</p>");
  }
  box.innerHTML = out.join("");
}

function drawAll() { drawMap(); drawStats(); drawHistory(); }

drawAll();
drawConsole();
drawLedger();
drawStake();
drawShare();
drawJoin();
drawAudit();
drawProofs();
saveLog(LOG);
</script>
</body>
</html>
"##

/-- The page for a log: the template with its two holes filled. This is the
same function the page itself computes when it writes its successor. -/
def pageFor (l : List Move) : String :=
  (pageTemplate.replace "@@TEMPLATE@@" (base64 pageTemplate)).replace "@@LOG@@" (logJson l)

/-- The opening page: a fresh game, nothing played. -/
def openingPage : String := pageFor []

/-- The page of the campaign: seventy-eight commands, seventy-nine states. -/
def campaignPage : String := pageFor campaign

/-- One command in from the opening: what the opening page must write when the
Foundation sends a hull to Anacreon. -/
def firstMovePage : String := pageFor [Move.jump 0 1 1]

/-- Write the pages and the golden values. -/
def writeEmpire : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/empire.html" openingPage
  IO.FS.writeFile "www/empire-campaign.html" campaignPage
  IO.FS.writeFile "www/empire-move1.html" firstMovePage
  IO.FS.writeFile "www/empire-golden.json" goldenJson
  IO.FS.writeFile "www/empire-share-golden.json" Share.shareJson
  IO.println s!"empire: opening page {openingPage.length} bytes, campaign page {campaignPage.length} bytes"

#eval writeEmpire

end NixWars
