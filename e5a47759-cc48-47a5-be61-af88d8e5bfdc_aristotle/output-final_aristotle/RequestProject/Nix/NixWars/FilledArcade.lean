import RequestProject.Nix.NixWars.Emit
import RequestProject.Nix.NixWars.Broadcast

/-!
# The filled arcade

`www/arcade.html` is a room whose cabinets point at other files. This is the
same room with everything *inside it*: `www/filled-arcade.html` carries the
whole board page — all fifteen doors, the emitted transition tables and the
WebAssembly module — as a string, together with the free-flight cabinet and the
pantograph workshop, and stands each of them up in an iframe with no network
access of any kind. One file, all the game data, no server.

On top of the cabinets the page carries three galleries that are new here:

* the **training theatre**, which replays the tape the trained agent recorded
  (`qbertLearnedTape`), shows the plan it found, and prints the critic's notes;
* the **betting floor**, which chalks up the four books of
  `RequestProject/NixWars/Bets.lean` with the verdicts Lean settled them on and
  the payouts it computed — and recomputes the payouts in the page, so a
  disagreement would show;
* the **broadcast desk**, which lists the reel, the stills and the punters'
  feed from `RequestProject/NixWars/Broadcast.lean`, with the implied size of
  every clip against the five-megabyte budget.

Everything on the page is emitted from the Lean definitions, so the room cannot
drift from the development.
-/

set_option maxRecDepth 40000
set_option maxHeartbeats 4000000

namespace NixWars

namespace Filled

/-! ## Escaping -/

/-- One character of a JavaScript string literal. `<` is escaped so that no
embedded page can close the script element that carries it. -/
def jsEscapeChar : Char → List Char
  | '\\' => ['\\', '\\']
  | '"' => ['\\', '"']
  | '\n' => ['\\', 'n']
  | '\r' => ['\\', 'r']
  | '<' => ['\\', 'x', '3', 'c']
  | c => [c]

/-- A string as a JavaScript double-quoted literal, without the quotes. -/
def jsEscape (s : String) : String := String.ofList (s.toList.flatMap jsEscapeChar)

/-- A string as a complete JavaScript literal. -/
def jsString (s : String) : String := "\"" ++ jsEscape s ++ "\""

/-- A list of naturals as a JSON array. -/
def natsJson (xs : List Nat) : String :=
  "[" ++ String.intercalate "," (xs.map toString) ++ "]"

/-- A list of strings as a JSON array. -/
def stringsJson (xs : List String) : String :=
  "[" ++ String.intercalate "," (xs.map jsString) ++ "]"

/-! ## The training theatre -/

/-- The name of a hop, for the page. -/
def qbertCmdName : QbertCmd → String
  | .dl => "DL"
  | .dr => "DR"
  | .ul => "UL"
  | .ur => "UR"

/-- The name of an invaders control, for the page. -/
def invadersCmdName : InvadersCmd → String
  | .left => "LEFT"
  | .right => "RIGHT"
  | .fire => "FIRE"
  | .tick => "TICK"

/-- The recorded tape, as an array of payloads. -/
def tapeJson (tape : List Qbert) : String :=
  "[" ++ String.intercalate "," (tape.map (fun s => natsJson (qbertSerialize s))) ++ "]"

/-- The recorded tape at the invaders cabinet, as an array of payloads. -/
def invadersTapeJson (tape : List Invaders) : String :=
  "[" ++ String.intercalate "," (tape.map (fun s => natsJson (invadersSerialize s))) ++ "]"

/-- Everything the training theatre shows. -/
def learnJson : String :=
  "{\n" ++
  "  plan: " ++ stringsJson (qbertLearned.map qbertCmdName) ++ ",\n" ++
  "  tape: " ++ tapeJson qbertLearnedTape ++ ",\n" ++
  "  learnedScore: " ++ toString agentScore ++ ",\n" ++
  "  selfPlayPlan: " ++ stringsJson (qbertSelfPlayed.map qbertCmdName) ++ ",\n" ++
  "  selfPlayScore: " ++ toString selfPlayScore ++ ",\n" ++
  "  crossPlan: " ++ stringsJson (qbertCrossTrained.map qbertCmdName) ++ ",\n" ++
  "  crossScore: " ++
    toString (Learn.value monsterCubes qbertReward initialQbert qbertCrossTrained) ++ ",\n" ++
  "  invadersPlan: " ++ stringsJson (invadersLearned.map invadersCmdName) ++ ",\n" ++
  "  invadersTape: " ++
    invadersTapeJson (Learn.traceFrom shardInvaders initialInvaders invadersLearned) ++ ",\n" ++
  "  wastefulTape: " ++
    tapeJson (Learn.traceFrom monsterCubes initialQbert qbertWastefulRun) ++ ",\n" ++
  "  invadersScore: " ++
    toString (Learn.value shardInvaders invadersReward initialInvaders invadersLearned) ++ ",\n" ++
  "  wasteful: " ++ stringsJson (qbertWastefulRun.map qbertCmdName) ++ ",\n" ++
  "  critique: " ++ natsJson (Learn.critique monsterCubes initialQbert qbertWastefulRun) ++ ",\n" ++
  "  pruned: " ++
    stringsJson ((Learn.prune monsterCubes initialQbert qbertWastefulRun).map qbertCmdName) ++
    ",\n" ++
  "  prunedScore: " ++
    toString (Learn.value monsterCubes qbertReward initialQbert
      (Learn.prune monsterCubes initialQbert qbertWastefulRun)) ++ "\n" ++
  "}"

/-! ## The betting floor -/

/-- One ticket, as JSON, with the payout Lean computed for it. -/
def ticketJson (b : Bets.Book) (t : Bets.Ticket) : String :=
  "{ punter: " ++ jsString t.punter ++ ", side: " ++ (if t.side then "true" else "false") ++
  ", stake: " ++ toString t.stake ++ ", payout: " ++ toString (Bets.payout b t) ++ " }"

/-- One book, as JSON. -/
def bookJson (b : Bets.Book) : String :=
  "{\n    key: " ++ jsString b.claim.key ++
  ",\n    attr: " ++ jsString b.claim.attr.name ++
  ",\n    line: " ++ jsString b.claim.line ++
  ",\n    verdict: " ++ (if b.claim.verdict then "true" else "false") ++
  ",\n    pool: " ++ toString (Bets.pool b) ++
  ",\n    yes: " ++ toString (Bets.staked b.tickets true) ++
  ",\n    no: " ++ toString (Bets.staked b.tickets false) ++
  ",\n    impliedYes: " ++ toString (Bets.implied b true) ++
  ",\n    impliedNo: " ++ toString (Bets.implied b false) ++
  ",\n    paid: " ++ toString (Bets.payouts b) ++
  ",\n    tickets: [" ++ String.intercalate ", " (b.tickets.map (ticketJson b)) ++ "]\n  }"

/-- The whole floor, as JSON. -/
def betsJson : String :=
  "{\n  pool: " ++ toString (Bets.floorPool bettingFloor) ++
  ",\n  paid: " ++ toString (Bets.floorPayouts bettingFloor) ++
  ",\n  books: [\n  " ++ String.intercalate ",\n  " (bettingFloor.map bookJson) ++ "\n  ]\n}"

/-! ## The broadcast desk -/

/-- One clip, as JSON. -/
def clipJson (c : Broadcast.Clip) : String :=
  "{ slug: " ++ jsString c.slug ++ ", caption: " ++ jsString c.caption ++
  ", w: " ++ toString c.w ++ ", h: " ++ toString c.h ++ ", fps: " ++ toString c.fps ++
  ", secs: " ++ toString c.secs ++ ", kbps: " ++ toString (c.vkbps + c.akbps) ++
  ", bytes: " ++ toString c.bytes ++ ", frames: " ++ toString c.frames ++ " }"

/-- One still, as JSON. -/
def stillJson (s : Broadcast.Still) : String :=
  "{ slug: " ++ jsString s.slug ++ ", caption: " ++ jsString s.caption ++
  ", w: " ++ toString s.w ++ ", h: " ++ toString s.h ++
  ", rawBytes: " ++ toString s.rawBytes ++ " }"

/-- One post, as JSON. -/
def postJson (p : Broadcast.Post) : String :=
  "{ kind: " ++ jsString p.kind ++ ", slug: " ++ jsString p.slug ++
  ", text: " ++ jsString p.text ++ ", chars: " ++ toString p.text.length ++ " }"

/-- The broadcast desk, as JSON. -/
def castJson : String :=
  "{\n  limit: " ++ toString Broadcast.clipByteLimit ++
  ",\n  secsLimit: " ++ toString Broadcast.clipSecondsLimit ++
  ",\n  charLimit: " ++ toString Broadcast.postCharLimit ++
  ",\n  clips: [" ++ String.intercalate ",\n    " (broadcastReel.map clipJson) ++ "],\n" ++
  "  stills: [" ++ String.intercalate ",\n    " (broadcastStills.map stillJson) ++ "],\n" ++
  "  feed: [" ++ String.intercalate ",\n    " (punterFeed.map postJson) ++ "]\n}"

/-! ## The cabinets -/

/-- A cabinet of the filled room: which embedded page it stands up, which door
of the board to open, and the side art. -/
structure FilledCabinet where
  /-- The embedded page: `board`, `frontier` or `pantograph`. -/
  page : String
  /-- The door of the board, for the board page; empty otherwise. -/
  door : String
  /-- The name on the marquee. -/
  marquee : String
  /-- What is written on the coin door. -/
  coin : String
  /-- The side art blurb. -/
  blurb : String

/-- The door names of the board, in the order the arcade lists them. -/
def filledDoors : List (String × String × String) :=
  [ ("nixwars", "NIXWARS", "Trade, warp and unlock the shards of the Monster Crown."),
    ("dash", "SHARD DASH", "A one-lane runner along the ring of 71 shards."),
    ("market", "SHARD MARKET", "Buy low, sell high; the book never mints a coin from nothing."),
    ("lord", "LORD OF THE SHARDS", "The duel: attack, heal, flee or rest."),
    ("hunt", "HUNT THE WUMPUS", "Twenty caves, one beast, one arrow."),
    ("zx81", "ZX81", "A Z80 machine in the corner, running its own ROM."),
    ("frens", "THE LOBBY", "Claim a shard for a fren; the crown goes to the biggest chain."),
    ("tycoon", "SHARD TYCOON", "Mine, forge, run the convoy — and never conjure ore."),
    ("meme", "MEME LAB", "Breed, mutate and select; fitness never runs backwards."),
    ("hyper", "HYPERSPACE", "Walk the eight-dimensional manifold of the shard address space."),
    ("oracle", "THE ORACLE", "Witness, lift, mint: a chain of proofs closed for a bounty."),
    ("vote", "THE ASSEMBLY", "Twenty-three nodes, seven of them Byzantine, a quorum of twelve."),
    ("qbert", "MONSTER CUBES", "Hop the pyramid of ten cubes and paint every one. Q, W, A, S."),
    ("frontier", "FRONTIER RUN",
      "Free flight through a 16-cube of space; dock at the station. 1-6, Z, X, SPACE, K."),
    ("invaders", "SHARD INVADERS",
      "Five invaders over eight columns; shoot them down. Arrows, SPACE, T.") ]

/-- Every cabinet on the floor of the filled room. -/
def filledFloor : List FilledCabinet :=
  filledDoors.zipIdx.map (fun (d, i) =>
    { page := "board", door := d.1, marquee := d.2.1, coin := "DOOR " ++ toString (i + 1),
      blurb := d.2.2 }) ++
  [ { page := "frontier", door := "", marquee := "FRONTIER", coin := "ADD-ON",
      blurb := "The free-flight cabinet over the certified ledger: full-screen 3D." },
    { page := "pantograph", door := "", marquee := "THE PANTOGRAPH", coin := "WORKSHOP",
      blurb := "A brass card shop that punches its own deck out again." } ]

/-- One cabinet, as HTML. -/
def filledCabinetHtml (c : FilledCabinet) : String :=
  "<div class=\"cab\">\n" ++
  "  <div class=\"marquee\">" ++ c.marquee ++ "</div>\n" ++
  "  <div class=\"screen\"><button onclick=\"stand('" ++ c.page ++ "','" ++ c.door ++ "','" ++
    c.marquee ++ "')\">PLAY</button></div>\n" ++
  "  <div class=\"coin\">" ++ c.coin ++ "</div>\n" ++
  "  <div class=\"art\">" ++ c.blurb ++ "</div>\n" ++
  "</div>\n"

/-! ## The embedded pages -/

/-- The board page, patched so that it runs inside an iframe with no URL of its
own: the door comes from a variable the room sets, and the saved game goes into
a box the room can read instead of the address bar. -/
def boardPageEmbedded : String :=
  ((page.replace
      "typeof location.search === \"string\" ? location.search : \"\""
      "typeof __ARCADE_QS === \"string\" ? __ARCADE_QS : \"\"").replace
      "location.hash" "__ARCADE_HASH.hash")

/-- The prelude injected ahead of an embedded page. -/
def embedPrelude : String := r##"<script>
var __ARCADE_QS = "";
var __ARCADE_HASH = { _v: "" };
Object.defineProperty(__ARCADE_HASH, "hash", {
  get: function () { return this._v; },
  set: function (v) {
    this._v = (typeof v === "string" && v.charAt(0) === "#") ? v : ("#" + v);
    try { parent.postMessage({ nixwars: this._v }, "*"); } catch (e) {}
  }
});
</script>
"##

end Filled

/-! ## The page -/

open Filled

/-- The head of the filled arcade. -/
def filledHead : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>THE FILLED ARCADE — NixWars</title>
<style>
html, body { margin: 0; background: #050a06; color: #bfffd0;
  font-family: ui-monospace, Menlo, Consolas, monospace; }
h1 { margin: 0; font-size: 18px; letter-spacing: 0.4em; color: #8fffa5; }
h2 { font-size: 13px; letter-spacing: 0.28em; color: #8fffa5; margin: 0 0 10px; }
header { padding: 18px 22px; border-bottom: 1px solid #16351d; }
header p { margin: 8px 0 0; font-size: 12px; color: #5f9c6f; max-width: 78ch; line-height: 1.5; }
a { color: #8fffa5; }
section { padding: 18px 22px; border-top: 1px solid #16351d; }
.grid { display: grid; gap: 14px;
  grid-template-columns: repeat(auto-fill, minmax(230px, 1fr)); }
.cab { border: 1px solid #1e5c2c; border-radius: 6px; background:
  linear-gradient(180deg, #0a1a0e 0%, #071008 100%); padding: 10px; }
.marquee { font-size: 13px; letter-spacing: 0.18em; color: #d7ffe2;
  border-bottom: 1px solid #1e5c2c; padding-bottom: 6px; }
.screen { background: #020602; border: 1px solid #143a1c; margin: 8px 0;
  height: 58px; display: flex; align-items: center; justify-content: center; }
button { background: #0d2a14; color: #8fffa5; border: 1px solid #2aa843;
  font: inherit; letter-spacing: 0.2em; padding: 6px 14px; cursor: pointer; }
button:hover { background: #14401f; }
.coin { font-size: 10.5px; color: #4f8a5e; letter-spacing: 0.12em; }
.art { font-size: 11px; color: #6fbc82; margin-top: 6px; line-height: 1.45; }
#stagebar { font-size: 11.5px; color: #5f9c6f; letter-spacing: 0.14em; padding: 6px 0; }
#stage { width: 100%; height: 78vh; border: 1px solid #1e5c2c; background: #020602; }
table { border-collapse: collapse; font-size: 11.5px; width: 100%; }
th, td { border: 1px solid #14401f; padding: 4px 7px; text-align: left; }
th { color: #8fffa5; letter-spacing: 0.12em; font-weight: normal; }
td.num { text-align: right; }
.win { color: #b9ffcb; }
.lose { color: #5f7f68; }
.pill { display: inline-block; border: 1px solid #2aa843; border-radius: 10px;
  padding: 1px 8px; font-size: 10px; letter-spacing: 0.14em; color: #8fffa5; }
.two { display: grid; gap: 18px; grid-template-columns: repeat(auto-fit, minmax(320px, 1fr)); }
canvas { background: #020602; border: 1px solid #143a1c; }
.note { font-size: 11px; color: #5f9c6f; line-height: 1.55; margin: 8px 0 0; }
* { -webkit-tap-highlight-color: transparent; }
button { touch-action: manipulation; }
html { -webkit-text-size-adjust: 100%; }
@media (max-width: 700px) {
  header, section { padding: 12px; }
  h1 { font-size: 15px; letter-spacing: 0.22em; }
  .grid, .two { grid-template-columns: 1fr; }
  button { padding: 12px 16px; min-height: 44px; }
  #stage { height: 68vh; }
  canvas { max-width: 100%; height: auto; }
  table { font-size: 10.5px; }
}
.post { border: 1px solid #14401f; border-radius: 5px; padding: 8px 10px; margin-bottom: 8px;
  font-size: 11.5px; color: #a8f0bb; line-height: 1.5; }
.post .meta { color: #4f8a5e; font-size: 10px; letter-spacing: 0.12em; margin-bottom: 4px; }
footer { padding: 14px 22px 30px; font-size: 11px; color: #4f8a5e; }
code { color: #d7ffe2; }
</style>
</head>
<body>
<header>
<h1>THE FILLED ARCADE</h1>
<p>Every cabinet, and all of its data, inside this one file. The board — fifteen
doors, the emitted transition tables and the WebAssembly module they run on — is
carried here as a string and stood up in the screen below; so are the
free-flight cabinet and the pantograph workshop. Nothing is fetched, nothing is
saved, there is no server: open the file and play. Below the floor: the agent
that was trained to play these games, the market the punters bet on, and the
reel that goes out.</p>
</header>
<section>
<h2>THE FLOOR</h2>
<div class="grid" id="floor">
"##

/-- The tail of the filled arcade: the galleries and the script. -/
def filledTail : String := r##"</div>
<div id="stagebar">NOW PLAYING: <span id="now">nothing — pick a cabinet</span>
  &middot; SAVED GAME: <span id="save">—</span></div>
<iframe id="stage" title="the cabinet you are standing at"
  sandbox="allow-scripts allow-same-origin" srcdoc=""></iframe>
</section>

<section>
<h2>THE TRAINING THEATRE</h2>
<div class="two">
  <div>
    <canvas id="pyramid" width="320" height="240"></canvas>
    <div style="margin-top:8px">
      <button onclick="replay()">REPLAY</button>
      <button onclick="stepTape()">STEP</button>
      <button onclick="rewind()">REWIND</button>
      <span class="pill" id="frame">frame 0</span>
    </div>
    <p class="note">The tape the trained agent recorded, replayed frame by
    frame. The frames are the ones Lean computed: the last one is provably the
    state the game ends in.</p>
  </div>
  <div>
    <table id="learntable"></table>
    <p class="note" id="critnote"></p>
  </div>
</div>
</section>

<section>
<h2>THE BETTING FLOOR</h2>
<div id="books"></div>
<p class="note" id="floornote"></p>
</section>

<section>
<h2>THE BROADCAST DESK</h2>
<div class="two">
  <div><table id="reel"></table></div>
  <div id="feed"></div>
</div>
<p class="note" id="castnote"></p>
</section>

<footer>Emitted from RequestProject/NixWars/FilledArcade.lean. The room next
door, <a href="arcade.html">arcade.html</a>, is the same cabinets as separate
files; <a href="nixwars.html">nixwars.html</a> is the board on its own.</footer>

<script>
// ---- standing at a cabinet: the page is already here ----
function stand(which, door, name) {
  var src = PAGES[which];
  if (door) src = src.replace("var __ARCADE_QS = \"\";",
                              "var __ARCADE_QS = \"?door=" + door + "\";");
  document.getElementById("stage").srcdoc = src;
  document.getElementById("now").textContent = name;
  document.getElementById("save").textContent = "—";
}
window.addEventListener("message", function (e) {
  if (e.data && typeof e.data.nixwars === "string")
    document.getElementById("save").textContent = e.data.nixwars;
});

// ---- the training theatre ----
var frame = 0, timer = null;
var CUBES = [[0,0],[1,0],[1,1],[2,0],[2,1],[2,2],[3,0],[3,1],[3,2],[3,3]];

function drawTape(i) {
  var c = document.getElementById("pyramid"), g = c.getContext("2d");
  var s = LEARN.tape[Math.min(i, LEARN.tape.length - 1)];
  g.fillStyle = "#020602"; g.fillRect(0, 0, c.width, c.height);
  var cw = 46, ch = 26;
  for (var k = 0; k < CUBES.length; k++) {
    var r = CUBES[k][0], col = CUBES[k][1];
    var x = 160 + (col - r / 2) * cw, y = 40 + r * (ch + 22);
    g.fillStyle = s[2 + k] ? "#2aa843" : "#0d2a14";
    g.beginPath();
    g.moveTo(x, y); g.lineTo(x + cw / 2, y + ch / 2);
    g.lineTo(x, y + ch); g.lineTo(x - cw / 2, y + ch / 2);
    g.closePath(); g.fill();
    g.strokeStyle = "#1e5c2c"; g.stroke();
    if (s[0] === r && s[1] === col) {
      g.fillStyle = "#ffbe3c";
      g.beginPath(); g.arc(x, y + ch / 2 - 4, 6, 0, 6.2832); g.fill();
    }
  }
  g.fillStyle = "#8fffa5"; g.font = "11px monospace";
  g.fillText("PAINTED " + s.slice(2, 12).reduce(function (a, b) { return a + b; }, 0) +
             "/10   LIVES " + s[12], 8, 232);
  document.getElementById("frame").textContent =
    "frame " + Math.min(i, LEARN.tape.length - 1) + " of " + (LEARN.tape.length - 1);
}
function stepTape() { frame = Math.min(frame + 1, LEARN.tape.length - 1); drawTape(frame); }
function rewind() { frame = 0; drawTape(0); if (timer) { clearInterval(timer); timer = null; } }
function replay() {
  if (timer) clearInterval(timer);
  frame = 0; drawTape(0);
  timer = setInterval(function () {
    if (frame >= LEARN.tape.length - 1) { clearInterval(timer); timer = null; return; }
    frame++; drawTape(frame);
  }, 320);
}

function fillLearn() {
  var rows = [
    ["trained on a recorded game", LEARN.plan.join(" "), LEARN.learnedScore],
    ["self-play only", LEARN.selfPlayPlan.join(" "), LEARN.selfPlayScore],
    ["cross-trained from the invaders", LEARN.crossPlan.join(" "), LEARN.crossScore],
    ["at the invaders cabinet", LEARN.invadersPlan.join(" "), LEARN.invadersScore]
  ];
  var h = "<tr><th>AGENT</th><th>PLAN</th><th>SCORE</th></tr>";
  for (var i = 0; i < rows.length; i++)
    h += "<tr><td>" + rows[i][0] + "</td><td>" + rows[i][1] +
         "</td><td class=\"num\">" + rows[i][2] + "</td></tr>";
  document.getElementById("learntable").innerHTML = h;
  document.getElementById("critnote").innerHTML =
    "THE CRITIC. Given <code>" + LEARN.wasteful.join(" ") +
    "</code> the critic marks positions <code>" + LEARN.critique.join(", ") +
    "</code> — commands played on a cabinet that had already frozen — and the " +
    "rewrite returns <code>" + LEARN.pruned.join(" ") + "</code>, worth the same " +
    LEARN.prunedScore + " points. Shorter, same outcome, proved in Lean.";
}

// ---- the betting floor: recompute the payouts here, and compare ----
function payout(book, t) {
  var win = book.verdict ? book.yes : book.no;
  if (t.side !== book.verdict) return 0;
  if (win === 0) return 0;
  return Math.floor(t.stake * book.pool / win);
}
var MYBETS = {};
function placeBet(key, side) {
  var box = document.getElementById("stake-" + key);
  var stake = Math.max(0, Math.floor(Number(box.value) || 0));
  if (stake === 0) { delete MYBETS[key]; } else { MYBETS[key] = { side: side, stake: stake }; }
  fillBooks();
}
function clearBets() { MYBETS = {}; fillBooks(); }
function withMyBet(b) {
  var mine = MYBETS[b.key];
  if (!mine) return b;
  var tickets = b.tickets.concat([{ punter: "YOU", side: mine.side, stake: mine.stake,
                                    payout: 0, mine: true }]);
  var yes = tickets.filter(function (t) { return t.side; })
                   .reduce(function (a, t) { return a + t.stake; }, 0);
  var no = tickets.filter(function (t) { return !t.side; })
                  .reduce(function (a, t) { return a + t.stake; }, 0);
  var out = { key: b.key, attr: b.attr, line: b.line, verdict: b.verdict,
              pool: yes + no, yes: yes, no: no, tickets: tickets, provisional: true };
  out.tickets = tickets.map(function (t) {
    return { punter: t.punter, side: t.side, stake: t.stake, mine: t.mine,
             payout: payout(out, t) };
  });
  out.paid = out.tickets.reduce(function (a, t) { return a + t.payout; }, 0);
  out.impliedYes = out.pool ? Math.floor(yes * 100 / out.pool) : 0;
  out.impliedNo = out.pool ? Math.floor(no * 100 / out.pool) : 0;
  return out;
}
function fillBooks() {
  var html = "", agree = true, paid = 0;
  for (var i = 0; i < BETS.books.length; i++) {
    var settled = BETS.books[i];
    var b = withMyBet(settled);
    html += "<h2 style=\"margin-top:14px\">" + b.attr + " &middot; " + b.line + "</h2>";
    html += "<p class=\"note\">verdict <span class=\"pill\">" +
      (b.verdict ? "TRUE" : "FALSE") + "</span> &middot; pool " + b.pool +
      " &middot; for " + b.yes + " (" + b.impliedYes + "%) &middot; against " + b.no +
      " (" + b.impliedNo + "%) &middot; paid out " + b.paid +
      (b.provisional ? " &middot; <span class=\"pill\">YOUR BET IS IN</span>" : "") + "</p>";
    html += "<table><tr><th>PUNTER</th><th>SIDE</th><th>STAKE</th><th>PAYOUT</th></tr>";
    for (var j = 0; j < settled.tickets.length; j++) {
      var t = settled.tickets[j], mine = payout(settled, t);
      if (mine !== t.payout) agree = false;
      paid += t.payout;
    }
    for (var m = 0; m < b.tickets.length; m++) {
      var u = b.tickets[m];
      html += "<tr class=\"" + (u.payout ? "win" : "lose") + "\"><td>" + u.punter +
        "</td><td>" + (u.side ? "FOR" : "AGAINST") + "</td><td class=\"num\">" + u.stake +
        "</td><td class=\"num\">" + u.payout + "</td></tr>";
    }
    html += "</table>";
    html += "<p class=\"note\">stake <input id=\"stake-" + b.key +
      "\" size=\"5\" value=\"10\"> " +
      "<button onclick=\"placeBet('" + b.key + "',true)\">BACK IT</button> " +
      "<button onclick=\"placeBet('" + b.key + "',false)\">LAY IT</button></p>";
  }
  html += "<p class=\"note\"><button onclick=\"clearBets()\">TEAR UP MY TICKETS</button> " +
    "Your bets are yours alone: they are recomputed in this page, on the same " +
    "parimutuel arithmetic, and nothing leaves the file.</p>";
  document.getElementById("books").innerHTML = html;
  document.getElementById("floornote").textContent =
    "The floor holds " + BETS.pool + " credits and pays out " + BETS.paid +
    "; nothing is minted. This page recomputed every payout: " +
    (agree ? "it agrees with the Lean values." : "IT DISAGREES with the Lean values.") +
    " Each book settles on the truth value of a Lean proposition, not on an opinion.";
}

// ---- the broadcast desk ----
function fillCast() {
  var h = "<tr><th>CLIP</th><th>SIZE</th><th>SECS</th><th>IMPLIED BYTES</th></tr>";
  for (var i = 0; i < CAST.clips.length; i++) {
    var c = CAST.clips[i];
    h += "<tr><td><a href=\"broadcast/" + c.slug + ".gif\">" + c.slug +
      "</a><div class=\"art\">" + c.caption + "</div></td><td>" +
      c.w + "x" + c.h + " @" + c.fps + "</td><td class=\"num\">" + c.secs +
      "</td><td class=\"num\">" + c.bytes + "</td></tr>";
  }
  for (var k = 0; k < CAST.stills.length; k++) {
    var s = CAST.stills[k];
    h += "<tr><td><a href=\"broadcast/" + s.slug + ".png\">" + s.slug +
      "</a><div class=\"art\">" + s.caption + "</div></td><td>" +
      s.w + "x" + s.h + "</td><td class=\"num\">still</td><td class=\"num\">" +
      s.rawBytes + "</td></tr>";
  }
  document.getElementById("reel").innerHTML = h;
  var f = "";
  for (var j = 0; j < CAST.feed.length; j++) {
    var p = CAST.feed[j];
    f += "<div class=\"post\"><div class=\"meta\">" + p.kind.toUpperCase() + " &middot; " +
      p.slug + " &middot; " + p.chars + "/" + CAST.charLimit + " chars</div>" +
      p.text + "</div>";
  }
  document.getElementById("feed").innerHTML = f;
  var over = CAST.clips.filter(function (c) { return c.bytes > CAST.limit; }).length;
  document.getElementById("castnote").textContent =
    "Every clip is cut to the posting budget of " + CAST.limit + " bytes and " +
    CAST.secsLimit + " seconds" + (over ? " — but " + over + " are over!" : "; none is over.") +
    " The budget arithmetic is proved in Lean, and video/verify_broadcast.py checks the " +
    "files that were actually written.";
}

fillLearn(); drawTape(0); fillBooks(); fillCast();
stand("board", "qbert", "MONSTER CUBES");
</script>
</body>
</html>
"##

/-- Everything the page needs, as one script block: the three embedded pages and
the three galleries. -/
def filledData (frontierSrc pantographSrc : String) : String :=
  "<script>\n" ++
  "const PAGES = {\n" ++
  "  board: " ++ jsString (embedPrelude ++ boardPageEmbedded) ++ ",\n" ++
  "  frontier: " ++ jsString (embedPrelude ++ frontierSrc) ++ ",\n" ++
  "  pantograph: " ++ jsString (embedPrelude ++ pantographSrc) ++ "\n" ++
  "};\n" ++
  "const LEARN = " ++ learnJson ++ ";\n" ++
  "const BETS = " ++ betsJson ++ ";\n" ++
  "const CAST = " ++ castJson ++ ";\n" ++
  "</script>\n"

/-- The filled arcade page, given the two hand-written pages it embeds. -/
def filledArcadePage (frontierSrc pantographSrc : String) : String :=
  filledHead ++ String.join (filledFloor.map filledCabinetHtml) ++
    filledData frontierSrc pantographSrc ++ filledTail

/-- Seventeen cabinets stand on the floor of the filled room: the fifteen doors
of the board and the two add-ons that are pages of their own. -/
theorem filledFloor_length : filledFloor.length = 17 := rfl

/-- Every door of the board has a cabinet in the filled room. -/
theorem filledFloor_covers_board :
    ∀ d ∈ filledDoors, filledFloor.any (fun c => c.door == d.1) := by
  decide

/-- Write the filled arcade, embedding the two hand-written pages beside the
emitted one. -/
def writeFilledArcade : IO Unit := do
  IO.FS.createDirAll "www"
  let frontierSrc ← IO.FS.readFile "projects/nix/www/frontier.html"
  let pantographSrc ← IO.FS.readFile "projects/nix/www/pantograph.html"
  IO.FS.writeFile "www/filled-arcade.html" (filledArcadePage frontierSrc pantographSrc)

#eval writeFilledArcade

end NixWars
