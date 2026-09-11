import RequestProject.Nix.NixWars.Echomail

/-!
# The board as a page: `www/bbs.html`

`Bbs.lean` is the system; this file is the terminal in front of it.  The page
carries the Lean-emitted callers, areas, message base, menu table and door list,
and a small core of JavaScript that does nothing but interpret them — the
navigation is a lookup in `stepTable`, not a hand-written switch, so the screen
you are on is the screen the Lean machine says you are on.

Everything the page and the harness both need is in one string, `bbsCore`, so
the code the browser runs is character for character the code `node
www/bbs-selftest.mjs` runs.  The golden values at the end of this file — the
hashes of the four secrets, the unread counts of every caller in every area,
the thread of every message, and the drop file for every caller at every door —
are computed by Lean, and both the page and the harness check themselves
against them.
-/

set_option maxRecDepth 40000

namespace NixWars

namespace BbsPage

open Bbs Echomail

/-! ## Rendering the model as JSON -/

/-- Escape a string for a JSON literal. -/
def esc (s : String) : String :=
  ((s.replace "\\" "\\\\").replace "\"" "\\\"").replace "\n" "\\n"

/-- A JSON string. -/
def str (s : String) : String := "\"" ++ esc s ++ "\""

/-- A JSON array. -/
def arr (xs : List String) : String := "[" ++ String.intercalate "," xs ++ "]"

/-- The name a screen goes by in the page. -/
def screenName : Screen → String
  | .login => "login"
  | .main => "main"
  | .areas => "areas"
  | .reading => "reading"
  | .posting => "posting"
  | .doors => "doors"
  | .files => "files"
  | .callers => "callers"
  | .mail => "mail"
  | .sysop => "sysop"
  | .goodbye => "goodbye"

/-- The callers. -/
def usersJson : String :=
  arr (Bbs.users.map fun u => arr [str u.handle, natToDec u.secret, natToDec u.level])

/-- The message areas. -/
def areasJson : String :=
  arr (Bbs.areas.map fun a =>
    arr [str a.tag, str a.name, natToDec a.readLevel, natToDec a.postLevel])

/-- The message base. -/
def msgsJson : String :=
  arr (seedMsgs.map fun m =>
    arr [natToDec m.id, str m.area, str m.author, str m.subject, str m.body,
      match m.parent with | none => "null" | some p => natToDec p])

/-- The new-message pointers the board ships with. -/
def marksJson : String :=
  arr (board.marks.map fun k => arr [str k.1, natToDec k.2])

/-- The callers log. -/
def callersJson : String := arr (board.callers.map str)

/-- The menu machine, exactly as Lean has it. -/
def stepJson : String :=
  arr (stepTable.map fun e =>
    arr [str (screenName e.1), str e.2.1.toString, str (screenName e.2.2.1),
      natToDec e.2.2.2])

/-! ## The doors

The doors of this board are the pages the rest of the repository already
emits: opening one writes a drop file and hands over. -/

/-- A door: the key that opens it, its name, the tag it goes by in the drop
file, and the page it hands over to. -/
structure Door where
  /-- The key on the door menu. -/
  key : String
  /-- The name on the menu. -/
  name : String
  /-- The tag written into the drop file. -/
  tag : String
  /-- The page the board hands over to. -/
  page : String

/-- The doors this board carries. -/
def doors : List Door :=
  [⟨"1", "NIXWARS — THE BOARD", "nixwars", "nixwars.html"⟩,
   ⟨"2", "THE TAPE ROOM", "tape", "tape.html"⟩,
   ⟨"3", "THE ARCADE", "arcade", "arcade.html"⟩,
   ⟨"4", "FRONTIER RUN", "frontier", "frontier.html"⟩,
   ⟨"5", "THE VOXEL FRONTIER", "voxel", "frontier-voxel.html"⟩,
   ⟨"6", "EMPIRE", "empire", "empire.html"⟩,
   ⟨"7", "FLY THE VOXEL WORLD", "fly", "fly.html"⟩]

/-- The doors as JSON. -/
def doorsJson : String :=
  arr (doors.map fun d => arr [str d.key, str d.name, str d.tag, str d.page])

/-! ## The golden values

Lean computes these; the page and the harness check the JavaScript against
them. -/

/-- The secrets, and what the board stores instead of them. -/
def hashesJson : String :=
  arr ([("monster", Bbs.hash "monster"), ("196883", Bbs.hash "196883"),
        ("shards", Bbs.hash "shards"), ("guest", Bbs.hash "guest")].map
    fun p => arr [str p.1, natToDec p.2])

/-- How much is new for each caller in each area. -/
def unreadJson : String :=
  arr (Bbs.users.flatMap fun u =>
    Bbs.areas.map fun a =>
      arr [str u.handle, str a.tag, natToDec (unread board u a).length])

/-- The thread every message hangs in. -/
def threadsJson : String :=
  arr (seedMsgs.map fun m =>
    arr [natToDec m.id, arr ((ancestors board m.id m.id).map natToDec)])

/-- The drop file the board writes for each caller at each door. -/
def dropsJson : String :=
  arr (Bbs.users.flatMap fun u =>
    doors.map fun d =>
      arr [str u.handle, str d.tag,
        str (Drop.render ⟨u.handle, u.level, d.tag, 47, 1800⟩)])

/-- The packet the home node carries to the other one. -/
def mailRunJson : String :=
  arr (mailRun.map fun p =>
    arr [str p.msgid, str p.area, str p.author, str p.subject, str p.body,
      match p.replyTo with | none => "null" | some r => str r])

/-- A node's message base as JSON. -/
def nodeMsgsJson (n : Node) : String :=
  arr (n.board.msgs.map fun m =>
    arr [natToDec m.id, str m.area, str m.author, str m.subject, str m.body,
      match m.parent with | none => "null" | some q => natToDec q])

/-- The far node before the mail, after it, and after it a second time. -/
def farJson : String :=
  arr [nodeMsgsJson shardnet,
       nodeMsgsJson (importAll shardnet mailRun),
       nodeMsgsJson (importAll (importAll shardnet mailRun) mailRun)]

/-- The keys that walk to each screen. -/
def pathsJson : String :=
  arr (allScreens.map fun s =>
    arr [str (screenName s), arr ((pathTo s).map (fun c => str c.toString))])

/-! ## The core

One string, used by the page and by the harness. -/

/-- The interpreter: everything the page does to the model, and nothing else. -/
def bbsCore : String := r##"
// Emitted by RequestProject/NixWars/BbsPage.lean — the page and the headless
// harness run this same text.  Nothing here decides anything the Lean model
// has not already decided: the menu is a lookup in the emitted table.
export function hash(s) {
  let a = 7;
  for (const ch of s) a = (a * 131 + ch.codePointAt(0)) % 1000003;
  return a;
}
export function login(users, handle, secret) {
  const h = hash(secret);
  return users.find(u => u[0] === handle && u[1] === h) || null;
}
export function level(u) { return u ? u[2] : 0; }
export function canRead(u, a) { return level(u) >= a[2]; }
export function canPost(u, a) { return level(u) >= a[3]; }
export function topId(msgs) { return msgs.reduce((m, x) => Math.max(m, x[0]), 0); }
export function markOf(marks, handle) {
  const k = marks.find(k => k[0] === handle);
  return k ? k[1] : 0;
}
export function unread(msgs, marks, u, a) {
  if (!canRead(u, a)) return [];
  const mark = markOf(marks, u[0]);
  return msgs.filter(m => m[1] === a[0] && mark < m[0]);
}
export function readAll(msgs, marks, u) {
  return [[u[0], topId(msgs)]].concat(marks.filter(k => k[0] !== u[0]));
}
// append-only: post returns the new base, or the old one untouched if the
// caller may not post or the reply has nothing to hang on
export function post(msgs, u, a, subject, body, parent) {
  if (!canPost(u, a)) return msgs;
  if (parent !== null && !msgs.some(m => m[0] === parent && m[1] === a[0])) return msgs;
  return msgs.concat([[topId(msgs) + 1, a[0], u[0], subject, body, parent]]);
}
export function step(table, lvl, screen, key) {
  const e = table.find(e => e[0] === screen && e[1] === key && e[3] <= lvl);
  return e ? e[2] : null;
}
export function run(table, lvl, screen, keys) {
  for (const k of keys) {
    const t = step(table, lvl, screen, k);
    if (t !== null) screen = t;
  }
  return screen;
}
export function ancestors(msgs, id) {
  const out = [];
  let cur = id;
  for (let i = 0; i <= msgs.length; i++) {
    const m = msgs.find(x => x[0] === cur);
    if (!m || m[5] === null) break;
    out.push(m[5]);
    cur = m[5];
  }
  return out;
}
// echomail: a node is { msgs, seen, localOf }.  A packet already in the dupe
// database is entered again as a no-op; a new one takes this node's own next
// free number and its reply is re-hung on this node's copy of the parent.
export function importOne(node, p) {
  if (node.seen.includes(p[0])) return node;
  const id = topId(node.msgs) + 1;
  let parent = null;
  if (p[5] !== null) {
    const k = node.localOf.find(k => k[0] === p[5]);
    if (k && node.msgs.some(m => m[0] === k[1] && m[1] === p[1])) parent = k[1];
  }
  return {
    msgs: node.msgs.concat([[id, p[1], p[2], p[3], p[4], parent]]),
    seen: [p[0]].concat(node.seen),
    localOf: [[p[0], id]].concat(node.localOf)
  };
}
export function importAll(node, ps) {
  for (const p of ps) node = importOne(node, p);
  return node;
}
export function outbox(node, area) {
  return node.localOf.flatMap(k => {
    const m = node.msgs.find(x => x[0] === k[1]);
    return m && m[1] === area ? [[k[0], m[1], m[2], m[3], m[4], null]] : [];
  });
}
export function dropRender(handle, lvl, door, shard, seconds) {
  return [handle, String(lvl), door, String(shard), String(seconds)].join("\n") + "\n";
}
"##

/-- The core with the `export` keywords dropped, for inlining in the page. -/
def bbsCoreInline : String := bbsCore.replace "export function" "function"

/-- The emitted data, as one JavaScript block. -/
def bbsData : String :=
  "const USERS = " ++ usersJson ++ ";\n" ++
  "const AREAS = " ++ areasJson ++ ";\n" ++
  "const SEED = " ++ msgsJson ++ ";\n" ++
  "const MARKS0 = " ++ marksJson ++ ";\n" ++
  "const CALLERS = " ++ callersJson ++ ";\n" ++
  "const STEP = " ++ stepJson ++ ";\n" ++
  "const DOORS = " ++ doorsJson ++ ";\n" ++
  "const GOLD = { hashes: " ++ hashesJson ++ ", unread: " ++ unreadJson ++
    ", threads: " ++ threadsJson ++ ", drops: " ++ dropsJson ++
    ", paths: " ++ pathsJson ++ ", mailrun: " ++ mailRunJson ++
    ", far: " ++ farJson ++ " };\n" ++
  "const SYSOP_LEVEL = " ++ natToDec sysopLevel ++ ";\n"

/-- The checks, run in the page and in the harness alike. -/
def bbsChecks : String := r##"
export function checkAll(core, data, check) {
  const { USERS, AREAS, SEED, MARKS0, STEP, DOORS, GOLD, SYSOP_LEVEL } = data;
  // the stored secrets are the hashes Lean computed
  for (const [plain, h] of GOLD.hashes)
    check("hash(" + plain + ") = " + h, core.hash(plain) === h);
  // logging in
  const sysop = core.login(USERS, "SYSOP", "monster");
  check("SYSOP logs in with the right secret", sysop !== null && sysop[2] === 100);
  check("SYSOP does not log in with the wrong secret",
    core.login(USERS, "SYSOP", "196883") === null);
  check("an unknown handle does not log in", core.login(USERS, "NOBODY", "guest") === null);
  // what is new, for whom
  for (const [handle, tag, n] of GOLD.unread) {
    const u = USERS.find(u => u[0] === handle);
    const a = AREAS.find(a => a[0] === tag);
    check(handle + " has " + n + " unread in " + tag,
      core.unread(SEED, MARKS0, u, a).length === n);
  }
  // and nothing, once read
  for (const u of USERS) {
    const marks = core.readAll(SEED, MARKS0, u);
    check(u[0] + " has nothing unread after reading",
      AREAS.every(a => core.unread(SEED, marks, u, a).length === 0));
  }
  // threads
  for (const [id, chain] of GOLD.threads)
    check("message " + id + " hangs under [" + chain.join(",") + "]",
      core.ancestors(SEED, id).join(",") === chain.join(","));
  check("no message is its own ancestor",
    SEED.every(m => !core.ancestors(SEED, m[0]).includes(m[0])));
  // posting is append-only, and refused when it should be
  const guest = USERS.find(u => u[0] === "GUEST");
  const shard = AREAS.find(a => a[0] === "SHARD");
  const gen = AREAS.find(a => a[0] === "GEN");
  check("GUEST cannot post in SHARD",
    core.post(SEED, guest, shard, "HELLO", "anyone there?", null) === SEED);
  check("a reply with nothing to hang on is refused",
    core.post(SEED, guest, gen, "RE", "...", 999) === SEED);
  const zos = USERS.find(u => u[0] === "ZOS");
  const after = core.post(SEED, zos, gen, "NEW", "posted from the page", null);
  check("a post that goes through appends exactly one message",
    after.length === SEED.length + 1 &&
    SEED.every((m, i) => after[i] === m));
  check("the new message takes the next free number",
    after[after.length - 1][0] === core.topId(SEED) + 1);
  check("message numbers strictly increase",
    after.every((m, i) => i === 0 || after[i - 1][0] < m[0]));
  check("the post is exactly one more unread for a cleared caller",
    core.unread(after, MARKS0, guest, gen).length ===
      core.unread(SEED, MARKS0, guest, gen).length + 1);
  // the menu machine
  for (const [screen, keys] of GOLD.paths)
    check("the keys " + (keys.join("") || "(none)") + " reach " + screen,
      core.run(STEP, SYSOP_LEVEL, "login", keys) === screen);
  const keys = ["L", "M", "R", "P", "Q", "S", "D", "G"];
  let reached = 0, worst = null;
  for (const a of keys) for (const b of keys) for (const c of keys) for (const d of keys) {
    reached++;
    if (core.run(STEP, 5, "login", [a, b, c, d]) === "sysop") worst = [a, b, c, d].join("");
  }
  check("no sequence of four keys at level 5 reaches the sysop area (" +
    reached + " tried)", worst === null);
  check("at sysop level, L S does", core.run(STEP, SYSOP_LEVEL, "login", ["L", "S"]) === "sysop");
  check("goodbye is the end",
    keys.every(k => core.step(STEP, SYSOP_LEVEL, "goodbye", k) === null));
  // the drop file
  for (const [handle, door, text] of GOLD.drops) {
    const u = USERS.find(u => u[0] === handle);
    check("the drop file for " + handle + " at " + door + " is the one Lean wrote",
      core.dropRender(handle, u[2], door, 47, 1800) === text);
  }
  check("every door hands over to a page", DOORS.every(d => d[3].endsWith(".html")));
  // echomail: the far node before the mail, after it, and after it twice
  const far0 = { msgs: GOLD.far[0], seen: [], localOf: [] };
  const far1 = core.importAll(far0, GOLD.mailrun);
  const far2 = core.importAll(far1, GOLD.mailrun);
  check("the mail arrives at the far node exactly as Lean says",
    JSON.stringify(far1.msgs) === JSON.stringify(GOLD.far[1]));
  check("delivering it a second time changes nothing",
    JSON.stringify(far2.msgs) === JSON.stringify(GOLD.far[2]) &&
    JSON.stringify(far2.msgs) === JSON.stringify(far1.msgs));
  check("the reply hangs on the far node's own copy of its parent",
    far1.msgs[1][5] === far1.msgs[0][0]);
  check("what the far node offers back, it has already seen",
    core.outbox(far1, "TRADE").every(p => far1.seen.includes(p[0])));
  check("and sending it back to the far node is a no-op",
    JSON.stringify(core.importAll(far1, core.outbox(far1, "TRADE")).msgs) ===
      JSON.stringify(far1.msgs));
}
"##

/-- The checks with the `export` keyword dropped, for inlining in the page. -/
def bbsChecksInline : String := bbsChecks.replace "export function" "function"

/-! ## The page -/

/-- The board, as a page. -/
def bbsPage : String :=
  r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NIXWARS BBS &mdash; dial in</title>
<style>
:root { color-scheme: dark; }
body { margin: 0; background: #04070d; color: #cfe6ff;
  font: 15px/1.45 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
.wrap { max-width: 60rem; margin: 0 auto; padding: 1rem 1rem 4rem; }
pre.banner { color: #6ef2c0; margin: 0 0 .6rem; font-size: 12px; line-height: 1.15;
  overflow-x: auto; }
#screen { border: 1px solid #16283c; background: #060c15; border-radius: .3rem;
  padding: .9rem 1rem; min-height: 20rem; white-space: pre-wrap; }
.k { color: #ffd479; font-weight: 700; }
.hi { color: #6ef2c0; }
.dim { color: #7fa6c8; }
.bad { color: #ff7b7b; }
a { color: #6ef2c0; }
input, textarea, button { font: inherit; background: #0b1726; color: #cfe6ff;
  border: 1px solid #1f3a52; border-radius: .25rem; padding: .3rem .5rem; }
button { cursor: pointer; }
button:hover { background: #14263a; }
.row { margin: .6rem 0; }
#log { white-space: pre-wrap; color: #8fb3d0; font-size: 12.5px; }
h2 { font-size: .9rem; letter-spacing: .16em; color: #ffd479; margin: 1.4rem 0 .4rem; }
.small { color: #7fa6c8; font-size: 13px; }
</style>
</head>
<body>
<div class="wrap">
<pre class="banner">
 _  _ _____  ___      ___   ___  ___    ___  ___ ___
| \| |_ _\ \/ / \    / /_\ | _ \/ __|  | _ )| _ ) __|
| .` || | >  <\ \/\/ / _ \|   /\__ \  | _ \| _ \__ \
|_|\_|___/_/\_\\_/\_/_/ \_\_|_\|___/  |___/|___/___/
</pre>
<p class="small">One node, 71 shards, seven doors. Type at the prompt or press the
letters. The board keeps no server state: the callers, the areas, the message base
and the whole menu are the Lean tables in this file, and the keys you press are
looked up in them.</p>
<div id="screen"></div>
<div class="row" id="controls"></div>

<h2>SELF-CHECK</h2>
<pre id="log"></pre>
<p class="small">The model and its proofs are in
<code>RequestProject/NixWars/Bbs.lean</code>; this page and this check are emitted from
<code>RequestProject/NixWars/BbsPage.lean</code>.</p>
</div>
<script type="module">
"##
  ++ bbsData ++ bbsCoreInline ++ bbsChecksInline ++ r##"
const core = { hash, login, level, canRead, canPost, topId, markOf, unread, readAll,
  post, step, run, ancestors, dropRender, importOne, importAll, outbox };
const data = { USERS, AREAS, SEED, MARKS0, STEP, DOORS, GOLD, SYSOP_LEVEL };

let state = { screen: "login", user: null, msgs: SEED.slice(), marks: MARKS0.slice(),
  area: null, reply: null, note: "",
  far: { msgs: GOLD.far[0].slice(), seen: [], localOf: [] } };

const el = document.getElementById("screen");
const controls = document.getElementById("controls");

function press(k) {
  const t = core.step(STEP, core.level(state.user), state.screen, k);
  if (t === null) { state.note = "Nothing on " + k + " here."; }
  else { state.note = ""; state.screen = t; }
  if (state.screen === "login") state.user = null;
  draw();
}

function attempt(handle, secret) {
  const found = core.login(USERS, handle, secret);
  if (!found) { state.note = "No such caller, or the secret is wrong."; draw(); return false; }
  state.user = found;
  press("L");
  return true;
}

function areasOpen() { return AREAS.filter(a => core.canRead(state.user, a)); }

function draw() {
  const u = state.user;
  const lines = [];
  const note = state.note ? "\n" + state.note : "";
  if (state.screen === "login") {
    lines.push("LOGIN\n");
    lines.push("Handle and secret, then L to log in. Try GUEST / guest, or ZOS / 196883.");
    controls.innerHTML =
      '<input id="h" placeholder="handle" value="GUEST" size="10"> ' +
      '<input id="s" placeholder="secret" value="guest" size="10"> ' +
      '<button id="go">L &mdash; LOG IN</button> <button data-k="G">G &mdash; HANG UP</button>';
    el.textContent = lines.join("\n") + note;
    document.getElementById("go").onclick = () => {
      attempt(document.getElementById("h").value.trim().toUpperCase(),
        document.getElementById("s").value);
    };
    wire();
    return;
  }
  if (state.screen === "main") {
    const news = AREAS.map(a => core.unread(state.msgs, state.marks, u, a).length)
      .reduce((x, y) => x + y, 0);
    lines.push("MAIN MENU — " + u[0] + ", level " + u[2]);
    lines.push("");
    lines.push(news + " message" + (news === 1 ? "" : "s") + " new to you.");
    lines.push("");
    lines.push("  M  message areas");
    lines.push("  D  doors — the games");
    lines.push("  F  files");
    lines.push("  C  callers log");
    lines.push("  E  mail room \u2014 the packet to the other node");
    lines.push("  S  sysop area" + (u[2] >= SYSOP_LEVEL ? "" : "   (level " + SYSOP_LEVEL + ")"));
    lines.push("  G  hang up");
    controls.innerHTML = ["M", "D", "F", "C", "E", "S", "G"]
      .map(k => '<button data-k="' + k + '">' + k + '</button>').join(" ");
  } else if (state.screen === "areas") {
    lines.push("MESSAGE AREAS");
    lines.push("");
    for (const a of areasOpen()) {
      const n = core.unread(state.msgs, state.marks, u, a).length;
      lines.push("  " + a[0].padEnd(6) + a[1].padEnd(22) +
        (n ? n + " new" : "-") + (core.canPost(u, a) ? "" : "   (read only)"));
    }
    const shut = AREAS.filter(a => !core.canRead(u, a));
    if (shut.length) lines.push("\n  " + shut.length + " area(s) above your level are not shown.");
    lines.push("\n  R  read the area selected below      Q  back");
    controls.innerHTML =
      '<select id="pick">' + areasOpen().map(a =>
        '<option value="' + a[0] + '">' + a[0] + " — " + a[1] + '</option>').join("") +
      "</select> " +
      '<button data-k="R">R &mdash; READ</button> <button data-k="Q">Q &mdash; BACK</button>';
    el.textContent = lines.join("\n") + note;
    const pick = document.getElementById("pick");
    if (pick) { if (state.area) pick.value = state.area; pick.onchange = () => state.area = pick.value; }
    if (!state.area && areasOpen().length) state.area = areasOpen()[0][0];
    wire();
    return;
  } else if (state.screen === "reading") {
    const a = AREAS.find(x => x[0] === state.area) || areasOpen()[0];
    state.area = a[0];
    lines.push("AREA " + a[0] + " — " + a[1]);
    lines.push("");
    const here = state.msgs.filter(m => m[1] === a[0]);
    for (const m of here) {
      const chain = core.ancestors(state.msgs, m[0]);
      lines.push("#" + m[0] + "  " + m[3] + "   [" + m[2] + "]" +
        (m[5] === null ? "" : "   in reply to #" + m[5] +
          (chain.length > 1 ? " (thread " + chain.slice().reverse().join(" > ") + " > " + m[0] + ")" : "")));
      lines.push("    " + m[4]);
      lines.push("");
    }
    const n = core.unread(state.msgs, state.marks, u, a).length;
    lines.push(n + " of these are new to you.");
    lines.push("\n  P  post      N  mark them read      Q  back");
    controls.innerHTML =
      '<button data-k="P">P &mdash; POST</button> ' +
      '<button id="mark">N &mdash; MARK READ</button> ' +
      '<button data-k="Q">Q &mdash; BACK</button>';
    el.textContent = lines.join("\n") + note;
    document.getElementById("mark").onclick = () => {
      state.marks = core.readAll(state.msgs, state.marks, u);
      state.note = "Marked read.";
      draw();
    };
    wire();
    return;
  } else if (state.screen === "posting") {
    const a = AREAS.find(x => x[0] === state.area);
    lines.push("POST TO " + a[0] + " — " + a[1]);
    lines.push("");
    lines.push(core.canPost(u, a) ? "Your level lets you post here."
      : "Your level does not let you post here: the board will refuse it.");
    controls.innerHTML =
      '<input id="subj" placeholder="subject" size="28"> ' +
      '<input id="par" placeholder="in reply to # (blank for none)" size="24"> ' +
      '<button id="send">SEND</button> <button data-k="Q">Q &mdash; BACK</button><br>' +
      '<textarea id="body" rows="3" cols="60" placeholder="your message"></textarea>';
    el.textContent = lines.join("\n") + note;
    document.getElementById("send").onclick = () => {
      const subj = document.getElementById("subj").value || "(no subject)";
      const body = document.getElementById("body").value || "(empty)";
      const raw = document.getElementById("par").value.trim();
      const parent = raw === "" ? null : Number(raw);
      const before = state.msgs;
      state.msgs = core.post(state.msgs, u, a, subj, body, parent);
      state.note = state.msgs === before
        ? "Refused: your level, or nothing to reply to in this area."
        : "Posted as #" + state.msgs[state.msgs.length - 1][0] + ".";
      draw();
    };
    wire();
    return;
  } else if (state.screen === "doors") {
    lines.push("DOORS");
    lines.push("");
    for (const d of DOORS) lines.push("  " + d[0] + "  " + d[1]);
    lines.push("");
    lines.push("Opening a door writes this drop file and hands over:");
    lines.push("");
    lines.push(core.dropRender(u[0], u[2], "<door>", 47, 1800).trimEnd()
      .split("\n").map(l => "    " + l).join("\n"));
    lines.push("\n  Q  back");
    controls.innerHTML = DOORS.map(d =>
      '<a href="' + d[3] + '"><button>' + d[0] + " &mdash; " + d[1] + "</button></a>").join(" ") +
      ' <button data-k="Q">Q &mdash; BACK</button>';
  } else if (state.screen === "files") {
    lines.push("FILE AREA");
    lines.push("");
    lines.push("  bbs-selftest.mjs   the headless harness for this board");
    lines.push("  nixwars.wasm       the module every door runs on");
    lines.push("  index.html         the lobby, and the rest of the rooms");
    lines.push("\n  Q  back");
    controls.innerHTML = '<button data-k="Q">Q &mdash; BACK</button>';
  } else if (state.screen === "callers") {
    lines.push("CALLERS LOG");
    lines.push("");
    for (const c of CALLERS) lines.push("  " + c);
    lines.push("\n  Q  back");
    controls.innerHTML = '<button data-k="Q">Q &mdash; BACK</button>';
  } else if (state.screen === "mail") {
    lines.push("MAIL ROOM \u2014 the other node");
    lines.push("");
    lines.push("A packet is a bag of messages, each with a name of its own. Every node keeps");
    lines.push("the names it has already entered, so a message that comes round the loop twice");
    lines.push("is only entered once. Deliver it as often as you like.");
    lines.push("");
    lines.push("OUTGOING (" + GOLD.mailrun.length + " messages)");
    for (const p of GOLD.mailrun)
      lines.push("  " + p[0].padEnd(12) + p[1].padEnd(7) + p[3]);
    lines.push("");
    lines.push("THE FAR NODE: " + state.far.msgs.length + " message(s), " +
      state.far.seen.length + " name(s) in its dupe database");
    for (const m of state.far.msgs)
      lines.push("  #" + m[0] + "  " + m[3] + "   [" + m[2] + "]" +
        (m[5] === null ? "" : "   in reply to #" + m[5]));
    lines.push("\n  D  deliver the packet      Q  back");
    controls.innerHTML =
      '<button id="deliver">D &mdash; DELIVER</button> ' +
      '<button data-k="Q">Q &mdash; BACK</button>';
    el.textContent = lines.join("\n") + note;
    document.getElementById("deliver").onclick = () => {
      const before = state.far.msgs.length;
      state.far = core.importAll(state.far, GOLD.mailrun);
      state.note = state.far.msgs.length === before
        ? "Nothing new: every name in that packet is already in the dupe database."
        : (state.far.msgs.length - before) + " message(s) entered.";
      draw();
    };
    wire();
    return;
  } else if (state.screen === "sysop") {
    lines.push("SYSOP AREA");
    lines.push("");
    lines.push("Callers: " + USERS.map(x => x[0] + " (" + x[2] + ")").join(", "));
    lines.push("Areas:   " + AREAS.map(x => x[0]).join(", "));
    lines.push("Base:    " + state.msgs.length + " messages, top number " +
      core.topId(state.msgs));
    lines.push("\n  Q  back");
    controls.innerHTML = '<button data-k="Q">Q &mdash; BACK</button>';
  } else if (state.screen === "goodbye") {
    lines.push("NO CARRIER");
    lines.push("");
    lines.push("Reload the page to dial in again.");
    controls.innerHTML = "";
  }
  el.textContent = lines.join("\n") + note;
  wire();
}

function wire() {
  const buttons = controls.querySelectorAll ? controls.querySelectorAll("button[data-k]") : [];
  for (const b of buttons) b.onclick = () => press(b.getAttribute("data-k"));
}

document.addEventListener("keydown", ev => {
  if (ev.metaKey || ev.ctrlKey || ev.altKey) return;
  const active = document.activeElement;
  if (active && ["INPUT", "TEXTAREA", "SELECT"].includes(active.tagName)) return;
  const k = ev.key.toUpperCase();
  if (STEP.some(e => e[1] === k)) { ev.preventDefault(); press(k); }
});

draw();

// the same handle the headless harness drives the board by
const api = { core, data, press, attempt, state: () => state, text: () => el.textContent };
if (typeof window !== "undefined") window.__bbs = api;

// the page checks itself against the values Lean computed
const log = [];
let allOk = true;
checkAll(core, data, (what, cond) => {
  if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what);
});
document.getElementById("log").innerHTML =
  '<span class="' + (allOk ? "hi" : "bad") + '">' +
  (allOk ? log.length + " checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");
</script>
</body>
</html>
"##

/-- The headless harness. -/
def bbsSelfTest : String :=
  "// Emitted by RequestProject/NixWars/BbsPage.lean. Run: node www/bbs-selftest.mjs\n" ++
  "import fs from \"node:fs\";\nimport vm from \"node:vm\";\n" ++
  bbsData ++ bbsCoreInline ++ bbsChecksInline ++ r##"
let fails = 0, n = 0;
function check(what, cond) {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); } else console.log("ok   " + what);
}
const core = { hash, login, level, canRead, canPost, topId, markOf, unread, readAll,
  post, step, run, ancestors, dropRender, importOne, importAll, outbox };
const data = { USERS, AREAS, SEED, MARKS0, STEP, DOORS, GOLD, SYSOP_LEVEL };
checkAll(core, data, check);

// the page ships the same tables and the same core
const dir = new URL("./", import.meta.url);
const html = fs.readFileSync(new URL("./bbs.html", dir), "utf8");
check("the page carries the callers Lean emitted", html.includes("const USERS = "));
check("the page carries the menu machine Lean emitted", html.includes("const STEP = "));
check("the page runs the same interpreter as this harness",
  html.includes("function step(table, lvl, screen, key)"));
check("the page runs the same checks as this harness",
  html.includes("function checkAll(core, data, check)"));
for (const d of DOORS)
  check("the door " + d[1] + " hands over to a page that exists",
    fs.existsSync(new URL("./" + d[3], dir)));

// and the page is actually dialled: its script is run against a stub DOM and
// the board is driven through it, exactly as a caller would
const mkEl = () => ({
  tagName: "DIV", innerHTML: "", textContent: "", value: "", onclick: null,
  setAttribute() {}, getAttribute() { return null; },
  querySelectorAll() { return []; }, querySelector() { return null; },
  addEventListener() {}
});
const byId = new Map();
const documentStub = {
  getElementById(id) { if (!byId.has(id)) byId.set(id, mkEl()); return byId.get(id); },
  querySelectorAll() { return []; }, querySelector() { return null; },
  addEventListener() {}, activeElement: null, createElement: mkEl
};
const windowStub = {};
const sandbox = { document: documentStub, window: windowStub, console, Math, Number,
  String, Object, Array, Set, Map, JSON };
vm.createContext(sandbox);
const script = html.match(/<script type="module">([\s\S]*?)<\/script>/)[1];
let pageErr = null;
try { vm.runInContext(script, sandbox, { filename: "bbs.html" }); } catch (e) { pageErr = e; }
check("the page's own script runs", pageErr === null, pageErr ? String(pageErr) : "");
const bbs = windowStub.__bbs;
check("the page hands the harness its board", !!bbs);
if (bbs) {
  const pageLog = byId.get("log").innerHTML;
  check("the page prints its own self-check and passes it",
    pageLog.includes("checks pass") && !pageLog.includes("FAIL"),
    pageLog.split("\n").filter(l => l.includes("FAIL")).join(" | "));
  check("a wrong secret does not get in", bbs.attempt("GUEST", "monster") === false);
  check("GUEST gets in", bbs.attempt("GUEST", "guest") === true);
  check("GUEST lands on the main menu", bbs.state().screen === "main");
  bbs.press("S");
  check("GUEST pressing S stays on the main menu", bbs.state().screen === "main");
  check("and is not shown the sysop area", !bbs.text().includes("SYSOP AREA"));
  bbs.press("M"); bbs.press("R");
  check("GUEST can read an area", bbs.state().screen === "reading");
  check("the messages of the area are on the screen", bbs.text().includes("WELCOME TO NIXWARS BBS"));
  bbs.press("Q"); bbs.press("Q");
  bbs.press("E");
  check("the mail room opens", bbs.state().screen === "mail");
  check("the far node starts empty", bbs.state().far.msgs.length === 0);
  const deliver = byId.get("deliver");
  check("the mail room wires up DELIVER", typeof deliver.onclick === "function");
  if (typeof deliver.onclick === "function") {
    deliver.onclick();
    check("delivering the packet enters it at the far node",
      JSON.stringify(bbs.state().far.msgs) === JSON.stringify(GOLD.far[1]));
    byId.get("deliver").onclick();
    check("delivering it again changes nothing at the far node",
      JSON.stringify(bbs.state().far.msgs) === JSON.stringify(GOLD.far[1]));
  }
  bbs.press("Q"); bbs.press("G");
  check("hanging up drops the carrier", bbs.state().screen === "goodbye");
  bbs.press("L"); bbs.press("S");
  check("and nothing brings it back", bbs.state().screen === "goodbye");
}

console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the board and its harness. -/
def writeBbsPage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/bbs.html" bbsPage
  IO.FS.writeFile "www/bbs-selftest.mjs" bbsSelfTest

#eval writeBbsPage

end BbsPage

end NixWars
