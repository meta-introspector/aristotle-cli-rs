import RequestProject.Nix.NixWars.Monster.FlyPage

/-!
# The front door: `www/index.html`

Everything in `www/` is a room of the same system, but until now the system had
no lobby: opening the directory itself gave nothing.  This file is the lobby —
the BBS main menu, emitted from Lean like every other page, one line per room,
with the letter you would have pressed on a real board.

The menu is a Lean list, `rooms`, and three things about it are proved rather
than eyeballed: the keys are distinct (`rooms_keys_nodup`), the files are
distinct (`rooms_files_nodup`), and every room is an HTML page
(`rooms_files_html`).  `www/index-selftest.mjs` closes the loop against the
directory on disk: every room the menu names is a file that exists and is not
empty, every page in `www/` is on the menu, and the emitted `index.html` links
each of them exactly once.  So the lobby cannot drift from the building.
-/

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

namespace NixWars

namespace Index

/-! ## The rooms -/

/-- Which part of the building a room is in.  The menu is grouped by these, so
a visitor meets four short lists rather than one long one. -/
inductive Zone
  /-- The way in. -/
  | start
  /-- Rooms you play. -/
  | play
  /-- Rooms you watch. -/
  | watch
  /-- Rooms you take apart. -/
  | workshop
  deriving DecidableEq

/-- The heading a zone is listed under. -/
def Zone.heading : Zone → String
  | .start => "START HERE"
  | .play => "PLAY"
  | .watch => "WATCH"
  | .workshop => "TAKE IT APART"

/-- The zones, in the order the menu shows them. -/
def zoneOrder : List Zone := [.start, .play, .watch, .workshop]

/-- A room of the board: the key that opens it on the menu, the file it lives
in, its name on the menu, one line about it and the part of the building it is
in. -/
structure Room where
  /-- The letter the menu lists it under. -/
  key : Char
  /-- The page, relative to `www/`. -/
  file : String
  /-- Its name on the menu. -/
  title : String
  /-- One line about it. -/
  blurb : String
  /-- The part of the building it is in. -/
  zone : Zone
  deriving DecidableEq

/-- The menu: every page `www/` ships, in the order a visitor should meet
them. -/
def rooms : List Room :=
  [⟨'0', "tape.html", "THE TAPE ROOM",
     "how to play each of the fifteen doors, recorded as a tape you can step through, and every game you play written down as a code you can paste, share and replay — the game rides in the address bar", .start⟩,
   ⟨'A', "nixwars.html", "NIXWARS",
     "the board itself: fifteen doors, played in the browser by a WebAssembly module Lean emitted and proved correct", .play⟩,
   ⟨'B', "arcade.html", "THE ARCADE",
     "twenty-two cabinets in one room, every door of the board and the annexes besides", .play⟩,
   ⟨'C', "filled-arcade.html", "THE FILLED ARCADE",
     "the whole arcade in a single file: the board, the free-flight cabinet, the workshop, the training theatre, the betting floor and the broadcast desk", .play⟩,
   ⟨'D', "arcade-3d.html", "THE ARCADE IN 3D",
     "all fifteen doors again, played in WebGL over their voxel scenes, on a phone", .play⟩,
   ⟨'R', "voxel-arcade.html", "THE MERGED ARCADE",
     "all fifteen games standing in one voxel hall, with one score between them: every cabinet keeps its state while you play the others, every point earned anywhere is a shard in the same purse, and a cabinet opens when the merged total reaches what it asks at the door", .play⟩,
   ⟨'S', "nested-worlds.html", "NESTED WORLDS",
     "the trading game played in the world itself: every shard bought comes off that world's own shelf and every credit paid goes to its house, and standing in one of its cabinets is another whole world with its own market and its own cabinets — a game inside the game, drawn at a quarter of the size inside the cabinet it stands in, with an exchange between the two that is proved not to be a money pump", .play⟩,
   ⟨'E', "fly.html", "FLY THE VOXEL WORLD",
     "the ship flown through the stack of grids over the Monster's fifteen primes, from a 71-cell ring to 1 618 964 990 108 856 390 cells — flown by its own WebAssembly module", .play⟩,
   ⟨'F', "frontier.html", "FRONTIER RUN",
     "the free-flight cabinet, full screen: heading, throttle, fuel and the run to the station", .play⟩,
   ⟨'G', "frontier-voxel.html", "THE VOXEL FRONTIER",
     "the frontier run merged with the voxel view: a market of prices read off eight warehouses, a shipyard, ships as tokens, a recorder and UUCP sync — flown by mouse, keys, keypad, joystick or the tilt of a phone", .play⟩,
   ⟨'H', "empire.html", "EMPIRE",
     "the two-empire ledger game, played in the page itself: every command rides in the link, so a game is kept and handed over as one address", .play⟩,
   ⟨'I', "empire-campaign.html", "EMPIRE: THE CAMPAIGN",
     "the same page carrying the seventy-eight command campaign already played", .play⟩,
   ⟨'J', "blackhole.html", "THE GRAVITY WELL",
     "seven sunk cabinets, one cartridge and seven clocks, with a reaction test", .play⟩,
   ⟨'Q', "bbs.html", "THE BBS",
     "the board behind the board: log in, read the message areas, post and reply, watch the callers log, and open the doors through the drop file the board hands them — the menu is a Lean table and the sysop's area will not open without the level", .play⟩,
   ⟨'W', "fly-worlds.html", "FLYING THE IRREP WORLDS",
     "the game modelled as a ship in the worlds the paths page walks: your place is an address in a box of prime axes, every axis is a circle you can fly right round, ×p drops you into the finer world with one more axis and ÷p leaves an axis behind, and the autopilot plans the flight to any cell of any of the worlds — proved always to land", .play⟩,
   ⟨'K', "video.html", "THE FILM",
     "fifteen scenes in three chapters — the board, how to play it, and the tape — as an animated SVG, MPEG-1 reels and MP4 copies", .watch⟩,
   ⟨'L', "well-video.html", "THE WELL, RECORDED",
     "the gravity-well experiment run and filmed, as an animated SVG", .watch⟩,
   ⟨'M', "transport.html", "THE FREIGHT TAPE",
     "the demo replayed cabinet by cabinet, with swipe, joystick, autopilot and a clickable route map", .watch⟩,
   ⟨'N', "voxel-world.html", "THE VOXEL WORLD",
     "the world itself: a slider from the point to the finest grid, the 194 irreducibles drawn as voxels", .workshop⟩,
   ⟨'O', "pantograph.html", "THE BRASS CARD SHOP",
     "the shop, the pin barrel, and a loom you can crank to watch a deck punch itself", .workshop⟩,
   ⟨'T', "cans.html", "THE CAN OPENER",
     "every thing in the world in a labelled tin, flown into: the fifteen cabinets and every field of their state, the 194 rows of the Monster's table and the divisor each one names, the opening position of the empire game - each of them a cube on a shelf of the same box, and each of them one flight from the next", .workshop⟩,
   ⟨'P', "empire-move1.html", "EMPIRE: MOVE ONE",
     "the same game one command in: play on here, the link carries the whole game, and another player's link joins with yours", .workshop⟩,
   ⟨'U', "irrep-world.html", "THE PROJECTED WORLD",
     "every atom of the game projected into the irrep you are in: a can's number taken modulo 71, 59 and 47 is its address, and with 3529 cans in 196883 cells each one gets a cell of its own — move the world and everything translates together, or change irrep and the same cans are re-addressed by the same primes reordered, by other primes, or by more of them", .workshop⟩,
   ⟨'V', "moonshine.html", "THE PATHS BETWEEN THE WORLDS",
     "how you get from one irrep world to the next: divide axes out and multiply others in — from 71 × 59 × 47 = 196883 you divide by 47 and multiply by 41, 31 and 4, keeping the shared 4189, and arrive at 21296876 — and those words of divides and multiplies join exactly the worlds the q-expansion of J is built from, which is the Monster connection to the geometry of the game", .workshop⟩,
   ⟨'X', "holo.html", "THE HOLOGRAPHIC ARCHIVE",
     "the knowledge base as one static file: each concept is a cell at its own byte offset, fetched on its own by a single range request and decoded without the rest — links move your coordinate, the shells R0, R1, R2 are the batches to fetch next, no fact is stored twice, and the eleven concepts are addressed by M11, whose Cayley graph turns out to be the cheapest description of their links", .workshop⟩]

theorem rooms_length : rooms.length = 25 := rfl

/-- The rooms of one zone, in menu order. -/
def roomsIn (z : Zone) : List Room := rooms.filter (fun r => r.zone = z)

/-- Grouping loses nothing: every room is listed under exactly one heading, and
the four lists together are the whole menu. -/
theorem zones_partition_rooms :
    (zoneOrder.flatMap roomsIn) = rooms := by decide

/-- The way in is a single room. -/
theorem start_zone_is_the_tape_room :
    roomsIn .start = [rooms.head (by decide)] := by decide

/-- No heading is empty. -/
theorem zones_nonempty : ∀ z ∈ zoneOrder, roomsIn z ≠ [] := by decide

/-- No two rooms answer to the same key. -/
theorem rooms_keys_nodup : (rooms.map Room.key).Nodup := by decide

/-- No two rooms are the same page. -/
theorem rooms_files_nodup : (rooms.map Room.file).Nodup := by decide

/-- Every room is an HTML page. -/
theorem rooms_files_html : ∀ r ∈ rooms, ".html".toList <:+ r.file.toList := by decide

/-- Every room has a key, a name and a line about it. -/
theorem rooms_nonempty_fields :
    ∀ r ∈ rooms, r.file ≠ "" ∧ r.title ≠ "" ∧ r.blurb ≠ "" := by decide

/-! ## The page -/

/-- The rooms as a JSON array, so the page and the self-test read the same
list. -/
def roomsJson : String :=
  "[" ++ String.intercalate ",\n" (rooms.map (fun r =>
    "[\"" ++ r.key.toString ++ "\",\"" ++ r.file ++ "\",\"" ++ r.title ++ "\",\"" ++
      r.blurb ++ "\",\"" ++ r.zone.heading ++ "\"]")) ++ "]"

/-- One row of the menu. -/
def roomRow (r : Room) : String :=
  "<tr class=\"room\"><td class=\"k\">" ++ r.key.toString ++ "</td>" ++
  "<td class=\"t\"><a href=\"" ++ r.file ++ "\">" ++ r.title ++ "</a></td>" ++
  "<td class=\"b\">" ++ r.blurb ++ "</td></tr>\n"

/-- One heading, and the rooms under it. -/
def zoneRows (z : Zone) : String :=
  "<tr class=\"zone\"><td colspan=\"3\">" ++ z.heading ++ "</td></tr>\n" ++
  String.join ((roomsIn z).map roomRow)

/-- The whole menu, grouped. -/
def menuRows : String := String.join (zoneOrder.map zoneRows)

/-- The lobby. -/
def indexPage : String :=
  r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
<meta name="theme-color" content="#04070d">
<title>NixWars &mdash; main menu</title>
<style>
:root { color-scheme: dark; }
body { margin: 0; background: #04070d; color: #cfe6ff;
  font: 15px/1.5 ui-monospace, SFMono-Regular, Menlo, Consolas, monospace; }
.wrap { max-width: 62rem; margin: 0 auto; padding: 1.25rem 1rem 4rem; }
h1 { font-size: 1.4rem; letter-spacing: .18em; margin: .2rem 0 .1rem; color: #eaf6ff; }
.sub { color: #7fa6c8; margin: 0 0 1.2rem; }
pre.banner { color: #6ef2c0; margin: 0 0 1rem; font-size: 12px; line-height: 1.15;
  overflow-x: auto; }
table { border-collapse: collapse; width: 100%; }
td { border-top: 1px solid #16283c; padding: .5rem .4rem; vertical-align: top; }
td.k { color: #ffd479; width: 2.2rem; text-align: center; font-weight: 700; }
td.t { white-space: nowrap; }
td.b { color: #8fb3d0; }
a { color: #6ef2c0; text-decoration: none; }
a:hover, a:focus { text-decoration: underline; }
tr:target td, tr.hot td { background: #0b1726; }
tr.zone td { color: #ffd479; letter-spacing: .16em; font-size: .8rem;
  padding-top: 1.2rem; border-top: 0; }
.hero { border: 1px solid #1f6f52; background: #06131a; border-radius: .4rem;
  padding: .9rem 1rem; margin: 0 0 1.4rem; }
.hero .go { display: inline-block; color: #04070d; background: #6ef2c0;
  padding: .45rem .8rem; border-radius: .3rem; font-weight: 700;
  letter-spacing: .12em; }
.hero .go:hover { text-decoration: none; background: #9dffda; }
.hero p { margin: .7rem 0 0; }
h2 { font-size: .95rem; letter-spacing: .16em; color: #ffd479; margin: 1.6rem 0 .4rem; }
.small { color: #7fa6c8; font-size: 13px; }
#log { white-space: pre-wrap; color: #8fb3d0; font-size: 12.5px; }
.ok { color: #6ef2c0; } .bad { color: #ff7b7b; }
@media (max-width: 40rem) { td.b { display: none; } td.t { white-space: normal; } }
</style>
</head>
<body>
<div class="wrap">
<pre class="banner">
 _  _ _____  ___      ___   ___  ___
| \| |_ _\ \/ / \    / /_\ | _ \/ __|
| .` || | >  <\ \/\/ / _ \|   /\__ \
|_|\_|___/_/\_\\_/\_/_/ \_\_|_\|___/
</pre>
<h1>MAIN MENU</h1>
<p class="sub">A board with fifteen doors, and the rooms around it. Every page here was
emitted by the Lean development in this repository and carries its own self-check. Press a
letter, or click.</p>
<div class="hero">
<a class="go" href="tape.html">PRESS 0 &mdash; THE TAPE ROOM</a>
<p class="small">Play any of the fifteen doors, watch the door play you the line Lean proved
wins it, and share whatever you play as a short code that rides in the address bar.
Everything else on this menu is a variation on that.</p>
</div>
<table id="menu"><tbody>
"##
  ++ menuRows ++
  r##"</tbody></table>

<h2>SELF-CHECK</h2>
<pre id="log"></pre>
<p class="small">The board runs entirely in the page: no server, no network. The proofs
behind it are in <code>RequestProject/</code>; <code>README.md</code> is the tour.</p>
</div>
<script>
const ROOMS = "##
  ++ roomsJson ++ r##";

// keys open rooms, as on a real board
const byKey = {};
for (const r of ROOMS) byKey[r[0].toUpperCase()] = r[1];
document.addEventListener("keydown", ev => {
  if (ev.metaKey || ev.ctrlKey || ev.altKey) return;
  const dest = byKey[ev.key.toUpperCase()];
  if (dest) { ev.preventDefault(); window.location.href = dest; }
});

// the page checks itself: the menu it draws is the list Lean emitted
const log = [];
let allOk = true;
function check(what, cond) {
  if (!cond) allOk = false;
  log.push((cond ? "  ok   " : "  FAIL ") + what);
}
const rows = Array.from(document.querySelectorAll("#menu tbody tr.room"));
check(ROOMS.length + " rooms on the menu", rows.length === ROOMS.length);
check("every row links its room", rows.every((tr, i) =>
  tr.querySelector("a") && tr.querySelector("a").getAttribute("href") === ROOMS[i][1]));
const heads = Array.from(document.querySelectorAll("#menu tbody tr.zone"))
  .map(tr => tr.textContent.trim());
const under = [];
let head = "";
for (const tr of document.querySelectorAll("#menu tbody tr")) {
  if (tr.classList.contains("zone")) head = tr.textContent.trim();
  else under.push(head);
}
check("every room sits under its own heading",
  under.length === ROOMS.length && under.every((h, i) => h === ROOMS[i][4]));
check("the headings are the ones Lean listed, in order",
  heads.join("|") === Array.from(new Set(ROOMS.map(r => r[4]))).join("|"));
check("the way in is the tape room",
  document.querySelector(".hero a.go").getAttribute("href") === "tape.html");
check("every key is distinct", new Set(ROOMS.map(r => r[0])).size === ROOMS.length);
check("every room is a distinct page", new Set(ROOMS.map(r => r[1])).size === ROOMS.length);
check("every room is an .html page", ROOMS.every(r => r[1].endsWith(".html")));
check("every room is named and described",
  ROOMS.every(r => r[2].length > 0 && r[3].length > 0));
document.getElementById("log").innerHTML =
  "<span class=\"" + (allOk ? "ok" : "bad") + "\">" +
  (allOk ? "all checks pass" : "CHECKS FAILED") + "</span>\n" + log.join("\n");
</script>
</body>
</html>
"##

/-- The headless harness: the lobby against the directory on disk. -/
def indexSelfTest : String :=
  "// Emitted by RequestProject/NixWars/Index.lean. Run: node www/index-selftest.mjs\n" ++
  "import fs from \"node:fs\";\n" ++
  "const ROOMS = " ++ roomsJson ++ ";\n" ++
  r##"
let fails = 0, n = 0;
function check(what, cond) {
  n++;
  if (!cond) { fails++; console.log("FAIL " + what); } else console.log("ok   " + what);
}
const dir = new URL("./", import.meta.url);
const html = fs.readFileSync(new URL("./index.html", dir), "utf8");

check(ROOMS.length + " rooms on the menu", ROOMS.length === "## ++ toString rooms.length ++ r##");
check("every key is distinct", new Set(ROOMS.map(r => r[0])).size === ROOMS.length);
check("every room is a distinct page", new Set(ROOMS.map(r => r[1])).size === ROOMS.length);
check("every room is an .html page", ROOMS.every(r => r[1].endsWith(".html")));
check("every room is named and described",
  ROOMS.every(r => r[2].length > 0 && r[3].length > 0));

// the rooms exist, and are not empty
for (const [key, file, title] of ROOMS) {
  const path = new URL("./" + file, dir);
  const there = fs.existsSync(path) && fs.statSync(path).size > 0;
  check(key + " — " + title + " (" + file + ") is a page that exists", there);
}

// the lobby links each of them, exactly once, under the heading Lean gave it
const menu = html.split("<table id=\"menu\">")[1].split("</table>")[0];
check("the menu links every room exactly once", ROOMS.every(([, file]) =>
  menu.split("href=\"" + file + "\"").length === 2));
const headings = Array.from(menu.matchAll(/<tr class="zone"><td colspan="3">([^<]*)</g))
  .map(m => m[1]);
check("the headings are the ones Lean listed, in order",
  headings.join("|") === Array.from(new Set(ROOMS.map(r => r[4]))).join("|"));
let head = "", placed = [];
for (const m of menu.matchAll(/<tr class="(zone|room)"><td[^>]*>([^<]*)</g)) {
  if (m[1] === "zone") head = m[2]; else placed.push(head);
}
check("every room sits under its own heading",
  placed.length === ROOMS.length && placed.every((h, i) => h === ROOMS[i][4]));
check("the way in is the tape room",
  html.includes("<a class=\"go\" href=\"tape.html\">"));

// and no page in www/ is missing from the menu
const pages = fs.readdirSync(dir).filter(f => f.endsWith(".html") && f !== "index.html");
const listed = new Set(ROOMS.map(r => r[1]));
const orphans = pages.filter(f => !listed.has(f));
check("no page is missing from the menu" + (orphans.length ? " (" + orphans.join(", ") + ")" : ""),
  orphans.length === 0);

console.log(n + " checks, " + fails + " failures");
process.exit(fails === 0 ? 0 : 1);
"##

/-- Write the lobby and its harness. -/
def writeIndexPage : IO Unit := do
  IO.FS.createDirAll "www"
  IO.FS.writeFile "www/index.html" indexPage
  IO.FS.writeFile "www/index-selftest.mjs" indexSelfTest

#eval writeIndexPage

end Index

end NixWars
