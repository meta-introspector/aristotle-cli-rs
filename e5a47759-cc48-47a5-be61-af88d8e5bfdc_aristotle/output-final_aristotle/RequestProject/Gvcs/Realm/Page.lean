import RequestProject.Gvcs.Realm.Stake
import RequestProject.Gvcs.Realm.Input

/-!
# One page per move

`realmPage ms` is a whole game of `Realm` as a single static HTML file: the
board, the rules, the digest, every position the game has passed through, and
the means to make the next page.  There is no `fetch`, no `<script src>`, no
image and no style sheet — opening the file is enough to play.

The only thing that changes from one page to the next is the line

    const MOVES = [ ... ];

inside `<script id="chain">`, and the title.  Everything else — who is to move,
what everyone holds, the digest to publish, the verification banner — the page
works out for itself when it is opened, by replaying that list through its own
copy of the rules.  That is what lets a page *make its successor*: it rewrites
that one line in its own DOM, serializes itself, and hands the result over as a
download.

The JavaScript in `<script id="rules">` is a transliteration of
`RequestProject/Realm/Rules.lean` and `RequestProject/Realm/Hash.lean`;
`web/realm-test.mjs` runs it against the positions and digests Lean computed, so
the two cannot drift apart.  `RequestProject/Realm/Chain.lean`'s
`runFrom_impl_eq` is the statement of what that test establishes.
-/

namespace LifeTrac
namespace Realm

/-! ## Small renderings -/

/-- A list of naturals as a JavaScript array. -/
def jsNats (l : List Nat) : String := "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- A bit as `0` or `1`. -/
def jsBit (b : Bool) : String := if b then "1" else "0"

/-- What a tile is called: file `a`–`h` from the left, rank `8`–`1` from the
top. -/
def tileName (p : Nat) : String :=
  let files := ["a", "b", "c", "d", "e", "f", "g", "h"]
  if p < boardN then (files.getD (p % boardW) "?") ++ toString (boardH - p / boardW) else "??"

/-- What a direction is called. -/
def dirName (d : Nat) : String :=
  match d with
  | 0 => "north"
  | 1 => "east"
  | 2 => "south"
  | 3 => "west"
  | _ => "nowhere"

/-- A move in words. -/
def moveText : Move → String
  | .march p d => "march " ++ tileName p ++ " " ++ dirName d
  | .gather p => "gather at " ++ tileName p
  | .build p .farm => "build a farm at " ++ tileName p
  | .build p .barracks => "build barracks at " ++ tileName p
  | .train p .worker => "train a worker at " ++ tileName p
  | .train p .soldier => "train a soldier at " ++ tileName p
  | .strike p d => "strike from " ++ tileName p ++ " to the " ++ dirName d
  | .endTurn => "end the turn"

/-- A position in the canonical form the page's JavaScript prints, so that Lean
and the page can be compared string for string. -/
def stateJson (s : State) : String :=
  "{\"turn\":" ++ jsBit s.turn ++ ",\"round\":" ++ toString s.round ++
  ",\"g\":[[" ++ toString s.p0.gold ++ "," ++ toString s.p0.wood ++ "],[" ++
    toString s.p1.gold ++ "," ++ toString s.p1.wood ++ "]]" ++
  ",\"u\":[" ++ String.intercalate ","
    (s.pieces.map (fun u => "[" ++ jsBit u.owner ++ "," ++ toString u.kind.code ++ "," ++
      toString u.pos ++ "," ++ toString u.hp ++ "," ++ jsBit u.acted ++ "]")) ++ "]" ++
  ",\"b\":[" ++ String.intercalate ","
    (s.bldgs.map (fun b => "[" ++ jsBit b.owner ++ "," ++ toString b.kind.code ++ "," ++
      toString b.pos ++ "]")) ++ "]}"

/-! ## The tables the page is generated from -/

/-- Everything the page needs to know that Lean decides: the map, the prices,
the figures and the opening position. -/
def pageData : String :=
  "const DATA = {\n" ++
  "  terrain: " ++ jsNats terrainCodes ++ ",\n" ++
  "  bcost: [[" ++ toString (bldgCost .farm).gold ++ "," ++ toString (bldgCost .farm).wood ++
    "],[" ++ toString (bldgCost .barracks).gold ++ "," ++ toString (bldgCost .barracks).wood ++
    "]],\n" ++
  "  ucost: [[" ++ toString (unitCost .worker).gold ++ "," ++ toString (unitCost .worker).wood ++
    "],[" ++ toString (unitCost .soldier).gold ++ "," ++ toString (unitCost .soldier).wood ++
    "]],\n" ++
  "  uhp: [" ++ toString (unitHp .worker) ++ "," ++ toString (unitHp .soldier) ++ "],\n" ++
  "  udmg: [" ++ toString (unitDmg .worker) ++ "," ++ toString (unitDmg .soldier) ++ "],\n" ++
  "  trainer: [" ++ toString (trainer .worker).code ++ "," ++ toString (trainer .soldier).code ++
    "],\n" ++
  "  yield: [[" ++ toString (tileYield .plains).gold ++ "," ++ toString (tileYield .plains).wood ++
    "],[" ++ toString (tileYield .forest).gold ++ "," ++ toString (tileYield .forest).wood ++
    "],[" ++ toString (tileYield .hills).gold ++ "," ++ toString (tileYield .hills).wood ++
    "],[" ++ toString (tileYield .water).gold ++ "," ++ toString (tileYield .water).wood ++
    "]],\n" ++
  "  wealth: " ++ toString wealthGoal ++ ",\n" ++
  "  bound: " ++ toString moveCodeBound ++ ",\n" ++
  "  prime: \"" ++ toString fnvPrime ++ "\",\n" ++
  "  seed: \"" ++ toString fnvSeed ++ "\",\n" ++
  "  genesis: " ++ stateJson genesis ++ "\n" ++
  "};\n"

/-! ## The parts of the page -/

/-- The style sheet. -/
def pageStyle : String := r#"
:root { --ink:#1c1a17; --paper:#f4efe6; --line:#c8bda8; --cell:min(52px,11.2vw); }
html { -webkit-text-size-adjust:100%; }
* { box-sizing: border-box; }
body { margin:0; padding:18px; background:var(--paper); color:var(--ink);
  font:15px/1.45 "Iowan Old Style","Palatino Linotype",Palatino,Georgia,serif; }
h1 { font-size:26px; margin:0 0 2px; letter-spacing:.02em; }
h2 { font-size:17px; margin:22px 0 6px; }
.sub { color:#6b6255; margin:0 0 14px; }
.wrap { display:flex; flex-wrap:wrap; gap:22px; align-items:flex-start; }
.panel { border:1px solid var(--line); background:#fbf8f2; padding:12px 14px; }
#board { display:grid; grid-template-columns:repeat(8,var(--cell)); grid-template-rows:repeat(8,var(--cell));
  border:2px solid #6b6255; width:max-content; touch-action:none; user-select:none;
  -webkit-user-select:none; }
.cell { position:relative; border:1px solid rgba(0,0,0,.12); display:flex;
  align-items:center; justify-content:center; cursor:pointer; }
.t0 { background:#ded3b4; } .t1 { background:#7d9b6a; } .t2 { background:#b39a72; }
.t3 { background:#7fa8c9; cursor:not-allowed; }
.cell .tag { position:absolute; top:1px; left:3px; font-size:9px; color:rgba(0,0,0,.45); }
.cell .bl { position:absolute; bottom:1px; right:3px; font-size:15px; }
.pc { width:min(32px,6.4vw); height:min(32px,6.4vw); border-radius:50%; display:flex; align-items:center;
  justify-content:center; font-weight:700; font-size:14px; color:#fff;
  border:2px solid rgba(0,0,0,.35); }
.s0 { background:#2f6fb0; } .s1 { background:#a33427; }
.done { opacity:.45; }
.sel { outline:3px solid #e2b13c; outline-offset:-3px; }
.hint { outline:2px dashed rgba(0,0,0,.4); outline-offset:-2px; }
button { font:inherit; padding:5px 10px; margin:0 6px 6px 0; background:#efe7d8;
  border:1px solid var(--line); cursor:pointer; }
button:disabled { opacity:.4; cursor:default; }
button.go { background:#2f6fb0; color:#fff; border-color:#24558a; }
code, .mono { font-family:ui-monospace,Menlo,Consolas,monospace; font-size:12.5px; }
table { border-collapse:collapse; font-size:12.5px; }
td, th { border:1px solid var(--line); padding:2px 6px; text-align:left; }
th { background:#efe7d8; }
.ok { color:#1d6b2f; font-weight:700; } .bad { color:#a33427; font-weight:700; }
.digest { word-break:break-all; }
.scroll { max-height:320px; overflow:auto; }
.note { color:#6b6255; font-size:13px; }
.col { min-width:300px; flex:1 1 300px; }
#pad { display:flex; gap:16px; align-items:flex-start; flex-wrap:wrap; }
#stick { position:relative; width:136px; height:136px; border-radius:50%; background:#e7dcc6;
  border:2px solid var(--line); touch-action:none; flex:0 0 auto; user-select:none;
  -webkit-user-select:none; }
#stick .ring { position:absolute; inset:34px; border:1px dashed rgba(0,0,0,.3); border-radius:50%; }
#knob { position:absolute; left:50%; top:50%; width:54px; height:54px; margin:-27px 0 0 -27px;
  border-radius:50%; background:#2f6fb0; border:2px solid #24558a; }
.keys { display:flex; flex-wrap:wrap; gap:6px; }
.keys button { margin:0; text-align:left; }
.cap { display:block; font-size:11px; color:#6b6255;
  font-family:ui-monospace,Menlo,Consolas,monospace; }
.chip { display:inline-block; padding:2px 6px; border:1px solid var(--line); background:#efe7d8;
  font-family:ui-monospace,Menlo,Consolas,monospace; font-size:12px; }
.rec { background:#a33427; color:#fff; border-color:#7d2418; }
.row { display:flex; flex-wrap:wrap; gap:6px; align-items:center; margin:5px 0; }
select, input[type=text] { font:inherit; padding:6px; border:1px solid var(--line);
  background:#fbf8f2; max-width:100%; }
@media (max-width:760px) {
  body { padding:10px; }
  h1 { font-size:22px; }
  .wrap { gap:12px; }
  .panel, .col { min-width:0; width:100%; }
  button { padding:9px 13px; font-size:15px; min-height:40px; }
  table { font-size:11.5px; }
  .scroll { max-height:260px; }
  #stick { width:118px; height:118px; }
}
"#

/-- The rules, as JavaScript: a transliteration of `Rules.lean` and `Hash.lean`
with no reference to the document, so that a test can lift it out of the page
and run it on its own. -/
def pageRules : String := r#"
const N = 64, BW = 8, BH = 8;
const TERRAIN = DATA.terrain, BCOST = DATA.bcost, UCOST = DATA.ucost;
const UHP = DATA.uhp, UDMG = DATA.udmg, TRAINER = DATA.trainer, YIELD = DATA.yield;
const WEALTH = DATA.wealth, BOUND = DATA.bound;
const WORD = 1n << 64n, PRIME = BigInt(DATA.prime), SEED = BigInt(DATA.seed);

function genesis() {
  const g = DATA.genesis;
  return { turn: g.turn, round: g.round, g: [g.g[0].slice(), g.g[1].slice()],
    u: g.u.map(x => ({ o: x[0], k: x[1], pos: x[2], hp: x[3], a: x[4] })),
    b: g.b.map(x => ({ o: x[0], k: x[1], pos: x[2] })) };
}
function passable(p) { return p < N && TERRAIN[p] !== 3; }

function stepPos(p, d) {
  if (p >= N) return -1;
  if (d === 0) return ((p / 8) | 0) === 0 ? -1 : p - 8;
  if (d === 1) return (p % 8) === 7 ? -1 : p + 1;
  if (d === 2) return ((p / 8) | 0) === 7 ? -1 : p + 8;
  if (d === 3) return (p % 8) === 0 ? -1 : p - 1;
  return -1;
}

function encodeMove(t, p, a) { return t === 5 ? 5 : t + 6 * (p + 64 * a); }

function decodeMove(n) {
  if (n >= BOUND) return null;
  const t = n % 6, p = ((n / 6) | 0) % 64, a = (n / 384) | 0;
  if (t === 0) return { t: 0, p: p, a: a };
  if (t === 1) return a === 0 ? { t: 1, p: p, a: 0 } : null;
  if (t === 2) return a < 2 ? { t: 2, p: p, a: a } : null;
  if (t === 3) return a < 2 ? { t: 3, p: p, a: a } : null;
  if (t === 4) return { t: 4, p: p, a: a };
  return (p === 0 && a === 0) ? { t: 5, p: 0, a: 0 } : null;
}

function pieceAt(s, p) { for (const u of s.u) if (u.pos === p) return u; return null; }
function bldgAt(s, p) { for (const b of s.b) if (b.pos === p) return b; return null; }
function canPay(q, c) { return c[0] <= q[0] && c[1] <= q[1]; }

function copyState(s) {
  return { turn: s.turn, round: s.round,
    g: [s.g[0].slice(), s.g[1].slice()],
    u: s.u.map(x => ({ o: x.o, k: x.k, pos: x.pos, hp: x.hp, a: x.a })),
    b: s.b.map(x => ({ o: x.o, k: x.k, pos: x.pos })) };
}

function applyMove(s0, code) {
  const m = decodeMove(code);
  if (m === null) return null;
  const s = copyState(s0);
  if (m.t === 0) {
    const u = pieceAt(s, m.p);
    if (!u || u.o !== s.turn || u.a) return null;
    const q = stepPos(m.p, m.a);
    if (q < 0 || !passable(q) || pieceAt(s, q)) return null;
    u.pos = q; u.a = 1;
    return s;
  }
  if (m.t === 1) {
    const u = pieceAt(s, m.p);
    if (!u || u.o !== s.turn || u.a || u.k !== 0) return null;
    u.a = 1;
    const y = YIELD[m.p < N ? TERRAIN[m.p] : 3];
    s.g[s.turn][0] += y[0]; s.g[s.turn][1] += y[1];
    return s;
  }
  if (m.t === 2) {
    const u = pieceAt(s, m.p);
    if (!u || u.o !== s.turn || u.a || u.k !== 0) return null;
    if (bldgAt(s, m.p)) return null;
    if (!(m.p < N) || TERRAIN[m.p] !== 0) return null;
    const c = BCOST[m.a];
    if (!canPay(s.g[s.turn], c)) return null;
    u.a = 1;
    s.b.unshift({ o: s.turn, k: m.a, pos: m.p });
    s.g[s.turn][0] -= c[0]; s.g[s.turn][1] -= c[1];
    return s;
  }
  if (m.t === 3) {
    const b = bldgAt(s, m.p);
    if (!b || b.o !== s.turn || b.k !== TRAINER[m.a]) return null;
    if (pieceAt(s, m.p)) return null;
    const c = UCOST[m.a];
    if (!canPay(s.g[s.turn], c)) return null;
    s.u.unshift({ o: s.turn, k: m.a, pos: m.p, hp: UHP[m.a], a: 1 });
    s.g[s.turn][0] -= c[0]; s.g[s.turn][1] -= c[1];
    return s;
  }
  if (m.t === 4) {
    const u = pieceAt(s, m.p);
    if (!u || u.o !== s.turn || u.a) return null;
    const q = stepPos(m.p, m.a);
    if (q < 0) return null;
    const v = pieceAt(s, q);
    if (!v || v.o === s.turn) return null;
    u.a = 1;
    v.hp = Math.max(0, v.hp - UDMG[u.k]);
    s.u = s.u.filter(x => x.hp > 0);
    return s;
  }
  let farms = 0;
  for (const b of s.b) if (b.o === s.turn && b.k === 0) farms++;
  s.g[s.turn][0] += farms;
  if (s.turn === 1) s.round += 1;
  s.turn = s.turn === 1 ? 0 : 1;
  for (const u of s.u) u.a = 0;
  return s;
}

function aliveCount(s, side) {
  let n = 0;
  for (const u of s.u) if (u.o === side) n++;
  for (const b of s.b) if (b.o === side) n++;
  return n;
}

function winnerOf(s) {
  if (aliveCount(s, 1) === 0) return 0;
  if (aliveCount(s, 0) === 0) return 1;
  if (s.g[0][0] >= WEALTH) return 0;
  if (s.g[1][0] >= WEALTH) return 1;
  return -1;
}

function stateJson(s) {
  return '{"turn":' + s.turn + ',"round":' + s.round +
    ',"g":[[' + s.g[0][0] + ',' + s.g[0][1] + '],[' + s.g[1][0] + ',' + s.g[1][1] + ']]' +
    ',"u":[' + s.u.map(x => '[' + x.o + ',' + x.k + ',' + x.pos + ',' + x.hp + ',' + x.a + ']').join(',') +
    '],"b":[' + s.b.map(x => '[' + x.o + ',' + x.k + ',' + x.pos + ']').join(',') + ']}';
}

function mix(h, x) { return ((h ^ (BigInt(x) % WORD)) * PRIME) % WORD; }

function digestOf(codes) {
  let h = SEED;
  for (const c of codes) h = mix(h, c);
  return h;
}

function digestHex(h) { return h.toString(16).padStart(16, '0'); }

// Replay a transcript.  `ok` is false when a move breaks a rule, and `bad` is
// then the index of the first one that does: the fraud proof.
function replay(codes) {
  let s = genesis();
  const states = [s], digests = [SEED];
  let h = SEED;
  for (let i = 0; i < codes.length; i++) {
    const t = applyMove(s, codes[i]);
    if (t === null) return { ok: false, bad: i, states: states, digests: digests };
    s = t; h = mix(h, codes[i]);
    states.push(s); digests.push(h);
  }
  return { ok: true, bad: -1, states: states, digests: digests };
}

function legalMoves(s) {
  const out = [];
  for (let c = 0; c < BOUND; c++) if (applyMove(s, c) !== null) out.push(c);
  return out;
}

const FILES = ['a','b','c','d','e','f','g','h'];
function tileName(p) { return FILES[p % 8] + (8 - ((p / 8) | 0)); }
const DIRS = ['north','east','south','west'];

function moveText(code) {
  const m = decodeMove(code);
  if (m === null) return 'nonsense (' + code + ')';
  if (m.t === 0) return 'march ' + tileName(m.p) + ' ' + DIRS[m.a];
  if (m.t === 1) return 'gather at ' + tileName(m.p);
  if (m.t === 2) return 'build ' + (m.a === 0 ? 'a farm' : 'barracks') + ' at ' + tileName(m.p);
  if (m.t === 3) return 'train ' + (m.a === 0 ? 'a worker' : 'a soldier') + ' at ' + tileName(m.p);
  if (m.t === 4) return 'strike from ' + tileName(m.p) + ' to the ' + DIRS[m.a];
  return 'end the turn';
}
"#

/-- The input model, as JavaScript: a transliteration of
`RequestProject/Realm/Input.lean`, with no reference to the document, so that
`web/input-test.mjs` can lift it out of the page and run it against the vectors
Lean printed.  Swipes, the joystick, the on-screen keys, the hotkeys and the
macros all come through these functions. -/
def pageInput : String := r#"
// A drag or a stick deflection as one of the four directions, or -1 inside the
// dead zone: `axisDir` of Input.lean.  Screen y grows downwards.
function axisDir(dx, dy, dead) {
  const ax = Math.abs(dx), ay = Math.abs(dy);
  if (ax <= dead && ay <= dead) return -1;
  if (ay <= ax) return dx > 0 ? 1 : 3;
  return dy > 0 ? 2 : 0;
}
function dirOpp(d) { return (d + 2) % 4; }

// Intents, and their numbers: `Intent.code` / `Intent.ofCode`.
function intentCode(i) {
  if (i.t === 'march') return i.a;
  if (i.t === 'strike') return 4 + i.a;
  if (i.t === 'gather') return 8;
  if (i.t === 'build') return 9 + i.a;
  if (i.t === 'train') return 11 + i.a;
  if (i.t === 'endTurn') return 13;
  if (i.t === 'undo') return 14;
  return 100 + i.a;
}
function intentOfCode(n) {
  if (n < 4) return { t: 'march', a: n };
  if (n < 8) return { t: 'strike', a: n - 4 };
  if (n === 8) return { t: 'gather', a: 0 };
  if (n < 11) return { t: 'build', a: n - 9 };
  if (n < 13) return { t: 'train', a: n - 11 };
  if (n === 13) return { t: 'endTurn', a: 0 };
  if (n === 14) return { t: 'undo', a: 0 };
  if (n >= 100 && n < 164) return { t: 'select', a: n - 100 };
  return null;
}

// Steps: an intent (even) or a call to a macro of the book (odd).
function stepCode(st) {
  return st.call === undefined ? 2 * intentCode(st.act) : 2 * st.call + 1;
}
function stepOfCode(n) {
  if (n % 2 === 1) return { call: (n - 1) / 2 };
  const i = intentOfCode(n / 2);
  return i === null ? null : { act: i };
}

// The move an intent means, given the selected tile (-1 for none), or -1.
function intentMove(sel, i) {
  if (i.t === 'endTurn') return encodeMove(5, 0, 0);
  if (sel < 0) return -1;
  if (i.t === 'march') return encodeMove(0, sel, i.a);
  if (i.t === 'strike') return encodeMove(4, sel, i.a);
  if (i.t === 'gather') return encodeMove(1, sel, 0);
  if (i.t === 'build') return encodeMove(2, sel, i.a);
  if (i.t === 'train') return encodeMove(3, sel, i.a);
  return -1;
}

// Write a move down if the rules allow it here, and otherwise do nothing at
// all: `playMove`.  This is why no gesture can put an illegal move on a page.
function playMoveCode(sess, code) {
  const r = replay(sess.moves);
  if (!r.ok) return sess;
  const st = r.states[r.states.length - 1];
  if (applyMove(st, code) === null) return sess;
  return { moves: sess.moves.concat([code]), sel: -1 };
}

// What one intent does to a session: `stepSession`.
function stepSession(sess, i) {
  if (i.t === 'select') return { moves: sess.moves, sel: sess.sel === i.a ? -1 : i.a };
  if (i.t === 'undo') return { moves: sess.moves.slice(0, -1), sel: -1 };
  const code = intentMove(sess.sel, i);
  if (code < 0) return sess;
  return playMoveCode(sess, code);
}

function runIntents(sess, l) {
  for (const i of l) sess = stepSession(sess, i);
  return sess;
}

// Expanding macro bodies under a fuel, so that macros calling one another
// cannot hang the page: `expand`.
function expandSteps(book, fuel, steps) {
  if (fuel <= 0) return [];
  const out = [];
  for (const st of steps) {
    if (st.call === undefined) out.push(st.act);
    else {
      const m = book[st.call];
      for (const j of expandSteps(book, fuel - 1, m ? m.body : [])) out.push(j);
    }
  }
  return out;
}

// The keymap: the first entry for a chord wins, so rebinding is putting a new
// entry in front.
function chordEq(a, b) {
  return a.key === b.key && !!a.shift === !!b.shift && !!a.ctrl === !!b.ctrl &&
    !!a.alt === !!b.alt;
}
function keymapFind(km, c) {
  for (const e of km) if (chordEq(e.chord, c)) return e.step;
  return null;
}
function keymapBind(km, c, st) {
  return [{ chord: c, step: st }].concat(km.filter(e => !chordEq(e.chord, c)));
}
function keymapUnbind(km, c) { return km.filter(e => !chordEq(e.chord, c)); }

// Pressing a chord, whether on the keyboard or on the on-screen keyboard.
function press(book, km, fuel, sess, c) {
  const st = keymapFind(km, c);
  if (st === null) return sess;
  return runIntents(sess, expandSteps(book, fuel, [st]));
}

// The intent a drag on the board, or a push of the stick, means.
function swipeIntent(dx, dy, dead, strikeMode) {
  const d = axisDir(dx, dy, dead);
  if (d < 0) return null;
  return { t: strikeMode ? 'strike' : 'march', a: d };
}

// A config line as the page uses it, and back again.
function readConfig(c) {
  return {
    keys: (c.keys || []).map(e => ({
      chord: { key: e[0][0], shift: !!e[0][1], ctrl: !!e[0][2], alt: !!e[0][3] },
      step: stepOfCode(e[1]) })).filter(e => e.step !== null),
    macros: (c.macros || []).map(m => ({
      name: m.name, body: (m.body || []).map(stepOfCode).filter(x => x !== null) })),
    dead: c.dead === undefined ? 24 : c.dead,
    fuel: c.fuel === undefined ? 8 : c.fuel
  };
}
function writeConfig(cfg) {
  return {
    keys: cfg.keys.map(e =>
      [[e.chord.key, e.chord.shift, e.chord.ctrl, e.chord.alt], stepCode(e.step)]),
    macros: cfg.macros.map(m => ({ name: m.name, body: m.body.map(stepCode) })),
    dead: cfg.dead, fuel: cfg.fuel
  };
}
"#

/-- The shell: the board, the buttons, the ledger of every earlier position,
and the making of the next page. -/
def pageShell : String := r#"
const SIDE = ['the Ash Vale', 'the Iron Horde'];
const KIND = ['worker', 'soldier'];
const BKIND = ['farm', 'barracks'];
const PADNOTE = 'Choose a tile, then swipe it \u2014 or push the stick \u2014 to march. ' +
  'Two fingers, the right mouse button, or the mode button strike instead.';
let sel = -1;
let CFG = readConfig(CONFIG);
let strikeMode = false;
let recording = -1;

function el(id) { return document.getElementById(id); }

function view() {
  const r = replay(MOVES);
  const n = r.states.length - 1;
  const s = r.states[n];
  return { r: r, n: n, s: s, h: r.digests[n] };
}

function renderHeader(v) {
  const w = v.r.ok ? winnerOf(v.s) : -1;
  const banner = v.r.ok
    ? '<span class="ok">&#10003; verified</span> — every one of the ' + MOVES.length +
      ' move(s) on this page replays legally from the opening position'
    : '<span class="bad">&#10007; broken</span> — move ' + v.r.bad +
      ' (' + moveText(MOVES[v.r.bad]) + ') is not allowed; this is the fraud proof';
  const win = w < 0 ? '' :
    '<p class="bad">' + SIDE[w] + ' has won.</p>';
  el('hdr').innerHTML =
    '<p>' + banner + '</p>' + win +
    '<table><tr><th>page</th><td>move ' + MOVES.length + ', round ' + v.s.round + '</td>' +
    '<th>to move</th><td>' + SIDE[v.s.turn] + '</td></tr>' +
    '<tr><th>Ash Vale</th><td>' + v.s.g[0][0] + ' gold, ' + v.s.g[0][1] + ' wood</td>' +
    '<th>Iron Horde</th><td>' + v.s.g[1][0] + ' gold, ' + v.s.g[1][1] + ' wood</td></tr>' +
    '<tr><th>digest</th><td colspan="3" class="mono digest">0x' + digestHex(v.h) +
    ' &nbsp;(' + v.h.toString() + ')</td></tr></table>';
}

function renderBoard(v) {
  const s = v.s, legal = v.r.ok ? legalMoves(s) : [];
  const targets = new Set();
  if (sel >= 0) for (const c of legal) {
    const m = decodeMove(c);
    if ((m.t === 0 || m.t === 4) && m.p === sel) targets.add(stepPos(m.p, m.a));
  }
  let out = '';
  for (let p = 0; p < 64; p++) {
    const u = pieceAt(s, p), b = bldgAt(s, p);
    let cls = 'cell t' + TERRAIN[p];
    if (p === sel) cls += ' sel';
    if (targets.has(p)) cls += ' hint';
    out += '<div class="' + cls + '" data-p="' + p + '" title="' + tileName(p) + '">' +
      '<span class="tag">' + tileName(p) + '</span>' +
      (b ? '<span class="bl">' + (b.k === 0 ? '&#9968;' : '&#9876;') + '</span>' : '') +
      (u ? '<span class="pc s' + u.o + (u.a ? ' done' : '') + '">' +
        (u.k === 0 ? 'W' : 'S') + '<sub>' + u.hp + '</sub></span>' : '') +
      '</div>';
  }
  el('board').innerHTML = out;
  for (const c of el('board').children) wireCell(c);
}

function renderActions(v) {
  const s = v.s, legal = new Set(v.r.ok ? legalMoves(s) : []);
  const rows = [];
  const push = (label, code) => rows.push(
    '<button ' + (legal.has(code) ? '' : 'disabled ') + 'data-c="' + code + '">' + label + '</button>');
  if (sel >= 0) {
    for (let d = 0; d < 4; d++) push('march ' + DIRS[d], encodeMove(0, sel, d));
    for (let d = 0; d < 4; d++) push('strike ' + DIRS[d], encodeMove(4, sel, d));
    push('gather', encodeMove(1, sel, 0));
    push('build farm', encodeMove(2, sel, 0));
    push('build barracks', encodeMove(2, sel, 1));
    push('train worker', encodeMove(3, sel, 0));
    push('train soldier', encodeMove(3, sel, 1));
  }
  push('end the turn', 5);
  el('acts').innerHTML =
    (sel >= 0 ? '<p class="note">selected: ' + tileName(sel) + '</p>' :
      '<p class="note">click one of your tiles to choose what acts.</p>') +
    rows.join('');
  for (const b of el('acts').querySelectorAll('button'))
    b.onclick = () => play(parseInt(b.dataset.c, 10));
}

function renderLedger(v) {
  let rows = '<table><tr><th>#</th><th>move</th><th>code</th><th>digest after</th>' +
    '<th>position after</th></tr>';
  rows += '<tr><td>0</td><td><i>the opening</i></td><td>&mdash;</td>' +
    '<td class="mono">0x' + digestHex(v.r.digests[0]) + '</td>' +
    '<td class="mono">' + stateJson(v.r.states[0]) + '</td></tr>';
  for (let i = 0; i < v.r.states.length - 1; i++) {
    rows += '<tr><td>' + (i + 1) + '</td><td>' + moveText(MOVES[i]) + '</td>' +
      '<td class="mono">' + MOVES[i] + '</td>' +
      '<td class="mono">0x' + digestHex(v.r.digests[i + 1]) + '</td>' +
      '<td class="mono">' + stateJson(v.r.states[i + 1]) + '</td></tr>';
  }
  if (!v.r.ok) rows += '<tr><td>' + (v.r.bad + 1) + '</td><td class="bad">' +
    moveText(MOVES[v.r.bad]) + '</td><td class="mono">' + MOVES[v.r.bad] +
    '</td><td colspan="2" class="bad">rejected: this move breaks a rule</td></tr>';
  el('log').innerHTML = rows + '</table>';
}

function renderStake(v) {
  el('stake').innerHTML =
    '<p>Publish this number and you have published the game:</p>' +
    '<p class="mono digest">0x' + digestHex(v.h) + '</p>' +
    '<p class="note">Each side locks a bond against it.  A challenger who can point at a ' +
    'move that breaks the rules takes the pot; otherwise it goes to the winner, and a game ' +
    'still in play is refunded.  Nothing is minted and nothing is burned: ' +
    '<code>settle_conserves</code>.</p>' +
    '<p><button id="cp">copy the digest</button></p>';
  el('cp').onclick = () => {
    const t = '0x' + digestHex(view().h);
    if (navigator.clipboard) navigator.clipboard.writeText(t);
    el('cp').textContent = 'copied ' + t;
  };
}

function render() {
  const v = view();
  renderHeader(v);
  renderBoard(v);
  renderActions(v);
  renderKeys();
  renderBuilder();
  renderLedger(v);
  renderStake(v);
  el('mode').textContent = 'mode: ' + (strikeMode ? 'strike' : 'march');
  el('mode').className = strikeMode ? 'rec' : '';
  el('mk').disabled = !v.r.ok;
}

// ---------------------------------------------------------- the input layer
//
// Everything below hands work to the functions of <script id="input">, which
// are a transliteration of RequestProject/Realm/Input.lean.  A tap, a swipe, a
// push of the stick, an on-screen key, a hotkey and a macro all end up in
// `stepSession`, and `stepSession_valid` is why none of them can put an
// illegal move on the page.

function sess() { return { moves: MOVES, sel: sel }; }

function commit(t) {
  const grew = t.moves.length > MOVES.length;
  MOVES = t.moves; sel = t.sel;
  render();
  if (grew) el('mk').textContent = 'save move ' + MOVES.length + ' as a new page';
}

function doIntent(i) {
  if (recording >= 0) CFG.macros[recording].body.push({ act: i });
  commit(stepSession(sess(), i));
}

function doStep(st) {
  if (recording >= 0 && !(st.call === recording)) CFG.macros[recording].body.push(st);
  commit(runIntents(sess(), expandSteps(CFG.macros, CFG.fuel, [st])));
}

function click(p) { doIntent({ t: 'select', a: p }); }

function play(code) {
  const m = decodeMove(code);
  if (m === null) return;
  if (m.t === 5) { doIntent({ t: 'endTurn', a: 0 }); return; }
  sel = m.p;
  if (m.t === 0) doIntent({ t: 'march', a: m.a });
  else if (m.t === 1) doIntent({ t: 'gather', a: 0 });
  else if (m.t === 2) doIntent({ t: 'build', a: m.a });
  else if (m.t === 3) doIntent({ t: 'train', a: m.a });
  else doIntent({ t: 'strike', a: m.a });
}

// ------------------------------------------------------------- the gestures

let gesture = null, down = 0;

function wireCell(c) {
  c.oncontextmenu = (e) => { e.preventDefault(); };
  c.onpointerdown = (e) => {
    down += 1;
    gesture = { p: parseInt(c.dataset.p, 10), x: e.clientX, y: e.clientY,
                strike: strikeMode || e.button === 2 || down > 1 };
    if (c.setPointerCapture) c.setPointerCapture(e.pointerId);
  };
  c.onpointercancel = () => { gesture = null; down = 0; };
  c.onpointerup = (e) => {
    down = Math.max(0, down - 1);
    const g = gesture;
    gesture = null;
    if (!g) return;
    const i = swipeIntent(Math.round(e.clientX - g.x), Math.round(e.clientY - g.y),
                          CFG.dead, g.strike);
    if (i === null) { doIntent({ t: 'select', a: g.p }); return; }
    sel = g.p;
    doIntent(i);
  };
}

// -------------------------------------------------------------- the joystick

function wireStick() {
  const st = el('stick'), kn = el('knob');
  let base = null;
  const R = 40;
  const clamp = (v) => Math.max(-R, Math.min(R, v));
  const show = (t) => { el('padnote').textContent = t; };
  st.onpointerdown = (e) => {
    base = { x: e.clientX, y: e.clientY };
    if (st.setPointerCapture) st.setPointerCapture(e.pointerId);
    e.preventDefault();
  };
  st.onpointermove = (e) => {
    if (!base) return;
    const dx = clamp(e.clientX - base.x), dy = clamp(e.clientY - base.y);
    kn.style.transform = 'translate(' + dx + 'px,' + dy + 'px)';
    const d = axisDir(Math.round(e.clientX - base.x), Math.round(e.clientY - base.y), CFG.dead);
    show(d < 0 ? 'the stick is inside the dead zone' :
      (strikeMode ? 'strike ' : 'march ') + DIRS[d] + (sel < 0 ? ' — but nothing is chosen' : ''));
  };
  const release = (e) => {
    if (!base) return;
    const dx = Math.round(e.clientX - base.x), dy = Math.round(e.clientY - base.y);
    base = null;
    kn.style.transform = '';
    const i = swipeIntent(dx, dy, CFG.dead, strikeMode);
    show(PADNOTE);
    if (i !== null) doIntent(i);
  };
  st.onpointerup = release;
  st.onpointercancel = () => { base = null; kn.style.transform = ''; show(PADNOTE); };
}

// ------------------------------------------- what things are called on screen

function intentText(i) {
  if (i.t === 'march') return 'march ' + DIRS[i.a];
  if (i.t === 'strike') return 'strike ' + DIRS[i.a];
  if (i.t === 'gather') return 'gather';
  if (i.t === 'build') return 'build ' + BKIND[i.a];
  if (i.t === 'train') return 'train ' + KIND[i.a];
  if (i.t === 'endTurn') return 'end the turn';
  if (i.t === 'undo') return 'take the last move back';
  return 'choose ' + tileName(i.a);
}

function stepText(st) {
  if (st.call === undefined) return intentText(st.act);
  const m = CFG.macros[st.call];
  return 'run \u201c' + (m ? m.name : '?') + '\u201d';
}

function chordText(c) {
  return (c.ctrl ? 'Ctrl+' : '') + (c.alt ? 'Alt+' : '') + (c.shift ? 'Shift+' : '') +
    (c.key === ' ' ? 'Space' : c.key);
}

function everyStep() {
  const out = [];
  for (let d = 0; d < 4; d++) out.push({ act: { t: 'march', a: d } });
  for (let d = 0; d < 4; d++) out.push({ act: { t: 'strike', a: d } });
  out.push({ act: { t: 'gather', a: 0 } });
  for (let b = 0; b < 2; b++) out.push({ act: { t: 'build', a: b } });
  for (let u = 0; u < 2; u++) out.push({ act: { t: 'train', a: u } });
  out.push({ act: { t: 'endTurn', a: 0 } });
  out.push({ act: { t: 'undo', a: 0 } });
  for (let i = 0; i < CFG.macros.length; i++) out.push({ call: i });
  return out;
}

function stepMenu(id, extra) {
  return '<select id="' + id + '">' + everyStep().map(st =>
    '<option value="' + stepCode(st) + '">' + stepText(st) + '</option>').join('') +
    '</select>' + (extra || '');
}

// --------------------------------------------- the on-screen keys and macros

function renderKeys() {
  el('keys').innerHTML = CFG.keys.map((e, i) =>
    '<button data-k="' + i + '">' + stepText(e.step) +
    '<span class="cap">' + chordText(e.chord) + '</span></button>').join('');
  for (const b of el('keys').querySelectorAll('button'))
    b.onclick = () => doStep(CFG.keys[parseInt(b.dataset.k, 10)].step);
  el('macros').innerHTML = '<b style="align-self:center">macros:</b>' +
    CFG.macros.map((m, i) => '<button data-m="' + i + '">' +
      (recording === i ? '\u25cf ' : '\u25b6 ') + m.name + '</button>').join('') +
    '<button id="mrec">' + (recording >= 0 ? 'stop recording' : 'record a new macro') + '</button>';
  for (const b of el('macros').querySelectorAll('button[data-m]'))
    b.onclick = () => doStep({ call: parseInt(b.dataset.m, 10) });
  el('mrec').onclick = () => {
    if (recording >= 0) { recording = -1; render(); return; }
    CFG.macros.push({ name: 'macro ' + (CFG.macros.length + 1), body: [] });
    recording = CFG.macros.length - 1;
    render();
  };
}

// ---------------------------------------------------------------- the builder

let capture = null;   // { kind: 'bind', step } or { kind: 'rebind', i }

function renderBuilder() {
  let h = '<h3 style="margin-top:0">Your keys</h3>' +
    '<p class="note">Tap one of these on screen, or press it on a keyboard: the same ' +
    'binding serves both.  Rebinding one key leaves the others alone ' +
    '(<code>Keymap.find_bind_other</code>).</p>' +
    '<table><tr><th>key</th><th>does</th><th></th></tr>';
  CFG.keys.forEach((e, i) => {
    h += '<tr><td class="mono">' + chordText(e.chord) + '</td><td>' + stepText(e.step) +
      '</td><td><button data-rb="' + i + '">rebind</button>' +
      '<button data-rx="' + i + '">remove</button></td></tr>';
  });
  h += '</table><div class="row">' + stepMenu('newstep') +
    '<button id="addkey">bind a key to this</button>' +
    '<span class="note" id="capnote"></span></div>';
  h += '<h3>Your macros</h3><p class="note">A macro is a list of steps, and a step is ' +
    'either an action or a call to another macro.  Calls are expanded under a fuel, so ' +
    'macros that call one another still stop (<code>expand</code>).</p>';
  CFG.macros.forEach((m, i) => {
    h += '<div class="row"><b>' + m.name + '</b><span class="chip">' +
      (m.body.length ? m.body.map(stepText).join(' \u2192 ') : 'empty') + '</span>' +
      '<button data-run="' + i + '">run</button>' +
      '<button data-rec="' + i + '"' + (recording === i ? ' class="rec"' : '') + '>' +
      (recording === i ? 'stop recording' : 'record into') + '</button>' +
      '<button data-pop="' + i + '">drop last step</button>' +
      '<button data-del="' + i + '">delete</button></div>';
  });
  h += '<div class="row">' + stepMenu('addstep') +
    '<span>to</span><select id="tomacro">' +
    CFG.macros.map((m, i) => '<option value="' + i + '">' + m.name + '</option>').join('') +
    '</select><button id="addstepbtn">add this step</button></div>' +
    '<div class="row"><input type="text" id="mname" placeholder="name a new macro">' +
    '<button id="addmacro">new macro</button></div>' +
    '<div class="row"><label>a swipe shorter than <input type="text" id="deadz" value="' +
    CFG.dead + '"> pixels is a tap</label><button id="setdead">use this dead zone</button>' +
    '</div><div class="row">' +
    '<button id="resetcfg">back to the layout this page shipped with</button></div>' +
    '<p class="note">Whatever you build here is saved into the next page, in its ' +
    '<code>let CONFIG = ...</code> line: the layout travels with the game ' +
    '(<code>Step.ofCode_code</code>).</p>';
  el('builder').innerHTML = h;

  const q = (sel) => el('builder').querySelectorAll(sel);
  for (const b of q('button[data-rb]')) b.onclick = () => {
    capture = { kind: 'rebind', i: parseInt(b.dataset.rb, 10) };
    el('capnote').textContent = 'press the key you want\u2026';
  };
  for (const b of q('button[data-rx]')) b.onclick = () => {
    CFG.keys.splice(parseInt(b.dataset.rx, 10), 1); render();
  };
  el('addkey').onclick = () => {
    capture = { kind: 'bind', step: stepOfCode(parseInt(el('newstep').value, 10)) };
    el('capnote').textContent = 'press the key you want\u2026';
  };
  for (const b of q('button[data-run]')) b.onclick = () =>
    doStep({ call: parseInt(b.dataset.run, 10) });
  for (const b of q('button[data-rec]')) b.onclick = () => {
    const i = parseInt(b.dataset.rec, 10);
    recording = (recording === i) ? -1 : i;
    render();
  };
  for (const b of q('button[data-pop]')) b.onclick = () => {
    CFG.macros[parseInt(b.dataset.pop, 10)].body.pop(); render();
  };
  for (const b of q('button[data-del]')) b.onclick = () => {
    const i = parseInt(b.dataset.del, 10);
    CFG.macros.splice(i, 1);
    CFG.keys = CFG.keys.filter(e => e.step.call === undefined || e.step.call !== i)
      .map(e => (e.step.call !== undefined && e.step.call > i)
        ? { chord: e.chord, step: { call: e.step.call - 1 } } : e);
    if (recording === i) recording = -1;
    render();
  };
  el('addstepbtn').onclick = () => {
    const st = stepOfCode(parseInt(el('addstep').value, 10));
    const i = parseInt(el('tomacro').value, 10);
    if (st !== null && CFG.macros[i]) CFG.macros[i].body.push(st);
    render();
  };
  el('addmacro').onclick = () => {
    const n = el('mname').value.trim();
    CFG.macros.push({ name: n === '' ? 'macro ' + (CFG.macros.length + 1) : n, body: [] });
    render();
  };
  el('setdead').onclick = () => {
    const d = parseInt(el('deadz').value, 10);
    if (!isNaN(d) && d >= 0 && d < 400) CFG.dead = d;
    render();
  };
  el('resetcfg').onclick = () => { CFG = readConfig(CONFIG); recording = -1; capture = null; render(); };
}

function takeChord(c) {
  if (capture.kind === 'rebind') {
    const e = CFG.keys[capture.i];
    if (e) CFG.keys = keymapBind(keymapUnbind(CFG.keys, e.chord), c, e.step);
  } else if (capture.step !== null) {
    CFG.keys = keymapBind(CFG.keys, c, capture.step);
  }
  capture = null;
  render();
}

// The page rewrites the one line that distinguishes it from its successor,
// serializes itself, and hands the result over.  Nothing else about the file
// changes, so the next page is this page with one more move on it.
function nextPage() {
  const chain = el('chain'), cfg = el('cfg'), hdr = el('hdr'), log = el('log'),
        acts = el('acts'), stake = el('stake'), keys = el('keys'),
        macros = el('macros'), builder = el('builder');
  const keep = [chain.textContent, hdr.innerHTML, log.innerHTML, acts.innerHTML,
                stake.innerHTML, el('board').innerHTML, document.title, cfg.textContent,
                keys.innerHTML, macros.innerHTML, builder.innerHTML];
  chain.textContent = 'let MOVES = [' + MOVES.join(',') + '];';
  cfg.textContent = 'let CONFIG = ' + JSON.stringify(writeConfig(CFG)) + ';';
  hdr.innerHTML = ''; log.innerHTML = ''; acts.innerHTML = ''; stake.innerHTML = '';
  el('board').innerHTML = ''; keys.innerHTML = ''; macros.innerHTML = ''; builder.innerHTML = '';
  document.title = 'Realm \u2014 move ' + MOVES.length;
  const html = '<!DOCTYPE html>\n' + document.documentElement.outerHTML + '\n';
  chain.textContent = keep[0]; hdr.innerHTML = keep[1]; log.innerHTML = keep[2];
  acts.innerHTML = keep[3]; stake.innerHTML = keep[4]; el('board').innerHTML = keep[5];
  document.title = keep[6]; cfg.textContent = keep[7]; keys.innerHTML = keep[8];
  macros.innerHTML = keep[9]; builder.innerHTML = keep[10];
  const v = view();
  const name = 'realm-' + String(MOVES.length).padStart(3, '0') + '-' + digestHex(v.h) + '.html';
  const a = document.createElement('a');
  a.href = URL.createObjectURL(new Blob([html], { type: 'text/html' }));
  a.download = name;
  a.click();
  URL.revokeObjectURL(a.href);
  render();
  el('mk').textContent = 'saved ' + name;
}

// A hotkey is the same binding as the on-screen key beside it.
window.addEventListener('keydown', (e) => {
  const t = e.target;
  if (t && (t.tagName === 'INPUT' || t.tagName === 'SELECT' || t.tagName === 'TEXTAREA')) return;
  const c = { key: e.key, shift: e.shiftKey, ctrl: e.ctrlKey || e.metaKey, alt: e.altKey };
  if (capture !== null) { e.preventDefault(); takeChord(c); return; }
  const st = keymapFind(CFG.keys, c);
  if (st === null) return;
  e.preventDefault();
  doStep(st);
});

window.addEventListener('DOMContentLoaded', () => {
  el('mk').onclick = nextPage;
  el('undo').onclick = () => doIntent({ t: 'undo', a: 0 });
  el('mode').onclick = () => { strikeMode = !strikeMode; render(); };
  el('unsel').onclick = () => { sel = -1; render(); };
  wireStick();
  render();
});
"#

/-- The unchanging body of the page. -/
def pageBody : String := r#"
<h1>Realm</h1>
<p class="sub">A game of two peoples, one move to a page.  This file is the whole
game: the rules, the board, every position so far, and the digest that commits
to all of it.</p>

<div id="hdr" class="panel"></div>

<div class="wrap" style="margin-top:16px">
  <div>
    <div id="board"></div>
    <p class="note" style="max-width:430px">
      <b>W</b> worker, <b>S</b> soldier; blue is the Ash Vale, red the Iron Horde,
      faded means it has already acted this turn.  &#9968; a farm, &#9876; barracks.
      Green is forest (wood), brown hills (gold), sand plains (a little gold, and the
      only ground a building will stand on), blue water (impassable).
    </p>
    <div class="panel" id="ctrl">
      <div id="pad">
        <div id="stick"><div class="ring"></div><div id="knob"></div></div>
        <div style="flex:1 1 220px">
          <div class="row">
            <button id="mode">mode: march</button>
            <button id="unsel">nothing chosen</button>
          </div>
          <p class="note" id="padnote">Choose a tile, then swipe it &mdash; or push the
          stick &mdash; to march.  Two fingers, the right mouse button, or the mode button
          strike instead.</p>
        </div>
      </div>
      <div class="keys" id="keys"></div>
      <hr>
      <div class="keys" id="macros"></div>
    </div>
  </div>
  <div class="panel col">
    <h2 style="margin-top:0">Your move</h2>
    <div id="acts"></div>
    <hr>
    <button id="mk" class="go">save the next page</button>
    <button id="undo">take the last move back</button>
    <p class="note">Saving writes a new self-contained HTML file: this page, with one
    more move on it.  Host it, send it, or put its digest on a chain.</p>
  </div>
  <div class="panel col">
    <h2 style="margin-top:0">The commitment</h2>
    <div id="stake"></div>
  </div>
</div>

<h2>Build your own controls</h2>
<div class="panel" id="builder"></div>

<h2>Every position this game has passed through</h2>
<div class="panel scroll" id="log"></div>

<h2>What is proved about this</h2>
<div class="panel">
<p>The rules, the digest and the settlement of the stake are formalized in Lean
in <code>RequestProject/Realm/</code>, and these are machine-checked:</p>
<ul>
<li><code>wf_apply</code> — no move the rules allow can break the world: pieces stay on
passable ground, stay alive, and never share a tile.</li>
<li><code>valid_take</code> — every earlier page of this game verifies on its own, so the
whole history on this page is checkable link by link.</li>
<li><code>page_prefix</code> — this page's digest is the previous page's digest with this
page's move folded into it, and its position is the previous position after that one
legal move.</li>
<li><code>firstBad_spec</code> — if a transcript does break a rule, there is a first move
that does, everything before it is legal, and pointing at it is a complete fraud proof.</li>
<li><code>Move.code_inj</code> — the list of numbers this page carries determines the moves
that made it.</li>
<li><code>foldWith_inj</code> — a chained digest whose compression function does not
collide determines the whole transcript: publishing the digest publishes the game.</li>
<li><code>settle_conserves</code>, <code>vale_not_slashed</code>,
<code>horde_not_slashed</code> — the escrow is never minted or burned, and a player only
loses their bond by breaking a rule or by being beaten.</li>
<li><code>runFrom_impl_eq</code> — an engine that agrees with the Lean rules move by move,
as the JavaScript above is tested to do, replays every transcript to the same position.</li>
<li><code>march_mover_owns</code>, <code>gather_mover_owns</code>,
<code>build_mover_owns</code>, <code>train_mover_owns</code>,
<code>strike_mover_owns</code> — you may only move your own pieces and buildings, only
ones that have not already acted this turn, and you may only strike the other side.</li>
<li><code>stepSession_valid</code>, <code>runIntents_valid</code> — nothing you can do with
this page &mdash; a tap, a swipe, the stick, an on-screen key, a hotkey or a macro of any
length &mdash; can put an illegal move on it.</li>
<li><code>axisDir_neg</code>, <code>axisDir_scale</code> — a swipe the other way means the
opposite direction, and the gesture means the same thing whatever the size of the screen it
is measured on.</li>
<li><code>Keymap.find_bind_other</code>, <code>Keymap.bind_bind</code> — rebinding one key
leaves every other key alone, and binding a key twice is binding it once.</li>
<li><code>expand_append</code>, <code>expand_acts</code> — a macro built out of steps runs
exactly those steps, in order, and macros that call one another are expanded under a fuel
and so always stop.</li>
<li><code>Step.ofCode_code</code> — the layout and the macros you build here read back
unchanged out of the page that carries them.</li>
<li><code>never_stuck</code> — no position is a dead end: the turn can always be handed
over, so a game can always be continued and this page always has a successor.</li>
<li><code>realm_is_winnable</code> — the game is not vacuous: there are legal transcripts
from the opening that the Ash Vale wins by wealth, that the Iron Horde wins by wealth,
and that the Ash Vale wins by sweeping the Horde off the map.</li>
</ul>
<p class="note">No <code>fetch</code>, no <code>&lt;script src&gt;</code>, no image, no
style sheet: everything above is in this file.</p>
</div>
"#

/-! ## The page -/

/-- The whole game as one static page, with a layout of its own: `cfg` is the
config line, which carries the keyboard, the hotkeys and the macros. -/
def realmPageWith (ms : List Move) (cfg : String) : String :=
  "<!DOCTYPE html>\n<html lang=\"en\"><head><meta charset=\"utf-8\">\n" ++
  "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1,viewport-fit=cover\">\n" ++
  "<title>Realm \u2014 move " ++ toString ms.length ++ "</title>\n" ++
  "<style>" ++ pageStyle ++ "</style>\n</head><body>\n" ++
  "<div id=\"app\">" ++ pageBody ++ "</div>\n" ++
  "<script id=\"chain\">let MOVES = " ++ jsNats (ms.map Move.code) ++ ";</script>\n" ++
  "<script id=\"cfg\">let CONFIG = " ++ cfg ++ ";</script>\n" ++
  "<script id=\"data\">" ++ pageData ++ "</script>\n" ++
  "<script id=\"rules\">" ++ pageRules ++ "</script>\n" ++
  "<script id=\"input\">" ++ pageInput ++ "</script>\n" ++
  "<script id=\"shell\">" ++ pageShell ++ "</script>\n" ++
  "</body></html>\n"

/-- The whole game as one static page, with the layout it ships with. -/
def realmPage (ms : List Move) : String := realmPageWith ms defaultConfigJson

/-! ## The shell is the same in every page

A page writes its successor by rewriting three places in its own source: the
move number in the `<title>`, the transcript in `<script id="chain">`, and the
player's layout in `<script id="cfg">`.  That is only sound if everything else
is the same in every page of every game, which is what `realmPageWith_parts`
says: the page is four fixed strings with the move count, the move codes and the
config written between them. -/

/-- Everything in a page before the move number in its title. -/
def pageHead : String :=
  "<!DOCTYPE html>\n<html lang=\"en\"><head><meta charset=\"utf-8\">\n" ++
  "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1,viewport-fit=cover\">\n" ++
  "<title>Realm \u2014 move "

/-- Everything in a page between the move number in its title and the
transcript. -/
def pageMid : String :=
  "</title>\n<style>" ++ pageStyle ++ "</style>\n</head><body>\n" ++
  "<div id=\"app\">" ++ pageBody ++ "</div>\n" ++
  "<script id=\"chain\">let MOVES = "

/-- Everything in a page between the transcript and the layout. -/
def pageCfgMid : String := ";</script>\n<script id=\"cfg\">let CONFIG = "

/-- Everything in a page after the layout: the tables, the rules, the input
model and the shell. -/
def pageTail : String :=
  ";</script>\n" ++
  "<script id=\"data\">" ++ pageData ++ "</script>\n" ++
  "<script id=\"rules\">" ++ pageRules ++ "</script>\n" ++
  "<script id=\"input\">" ++ pageInput ++ "</script>\n" ++
  "<script id=\"shell\">" ++ pageShell ++ "</script>\n" ++
  "</body></html>\n"

/-- **A page is the fixed shell with three things written into it.**  Whatever
the game and whatever the player has done to their controls, a page is
`pageHead`, the number of moves, `pageMid`, the move codes, `pageCfgMid`, the
config, and `pageTail` — so two pages of any two games differ only in the title,
in the one line that carries the transcript, and in the one line that carries
the layout.  This is what makes a page able to write its successor by editing
itself. -/
theorem realmPageWith_parts (ms : List Move) (cfg : String) :
    realmPageWith ms cfg =
      pageHead ++ toString ms.length ++ pageMid ++ jsNats (ms.map Move.code) ++
        pageCfgMid ++ cfg ++ pageTail := by
  simp [realmPageWith, pageHead, pageMid, pageCfgMid, pageTail, String.append_assoc]

theorem realmPage_parts (ms : List Move) :
    realmPage ms =
      pageHead ++ toString ms.length ++ pageMid ++ jsNats (ms.map Move.code) ++
        pageCfgMid ++ defaultConfigJson ++ pageTail :=
  realmPageWith_parts ms defaultConfigJson

/-- The successor page: one more move, one higher move number, whatever layout
the player has arrived at, and the same shell as every other page. -/
theorem realmPageWith_concat (ms : List Move) (m : Move) (cfg : String) :
    realmPageWith (ms ++ [m]) cfg =
      pageHead ++ toString (ms.length + 1) ++ pageMid ++
        jsNats ((ms.map Move.code) ++ [m.code]) ++ pageCfgMid ++ cfg ++ pageTail := by
  rw [realmPageWith_parts]
  simp

theorem realmPage_concat (ms : List Move) (m : Move) :
    realmPage (ms ++ [m]) =
      pageHead ++ toString (ms.length + 1) ++ pageMid ++
        jsNats ((ms.map Move.code) ++ [m.code]) ++ pageCfgMid ++ defaultConfigJson ++
        pageTail :=
  realmPageWith_concat ms m defaultConfigJson

/-- **Customizing the controls changes one line and nothing else.**  Two pages
of the same game with different layouts agree on the head, the title, the body,
the transcript and the whole of the tail. -/
theorem realmPageWith_config (ms : List Move) (cfg cfg' : String) :
    realmPageWith ms cfg =
      pageHead ++ toString ms.length ++ pageMid ++ jsNats (ms.map Move.code) ++
        pageCfgMid ++ cfg ++ pageTail ∧
    realmPageWith ms cfg' =
      pageHead ++ toString ms.length ++ pageMid ++ jsNats (ms.map Move.code) ++
        pageCfgMid ++ cfg' ++ pageTail :=
  ⟨realmPageWith_parts ms cfg, realmPageWith_parts ms cfg'⟩

end Realm
end LifeTrac
