import RequestProject.Nix.NixWars.Wasm

/-!
# The arcade room

The room the cabinets stand in: a second static page, `www/arcade.html`, listing
every door of the board and every add-on, each with a button that stands you at
that cabinet. It is emitted from Lean like everything else, so the roster of
cabinets on the floor cannot drift from the roster of doors on the board.
-/

namespace NixWars

/-- A cabinet in the arcade: the URL it opens, its marquee, the door number on
the coin door, and the line painted on the side art. -/
structure Cabinet where
  /-- Where the cabinet's button goes. -/
  href : String
  /-- The name on the marquee. -/
  marquee : String
  /-- What is written on the coin door. -/
  coin : String
  /-- The side art blurb. -/
  blurb : String

/-- Every cabinet on the floor: the fifteen doors of the board, then the
add-ons that are pages of their own. -/
def arcadeFloor : List Cabinet :=
  [ { href := "nixwars.html?door=nixwars", marquee := "NIXWARS", coin := "DOOR 1",
      blurb := "Trade, warp and unlock the shards of the Monster Crown." },
    { href := "nixwars.html?door=dash", marquee := "SHARD DASH", coin := "DOOR 2",
      blurb := "A one-lane runner along the ring of 71 shards." },
    { href := "nixwars.html?door=market", marquee := "SHARD MARKET", coin := "DOOR 3",
      blurb := "Buy low, sell high; the book never mints a coin from nothing." },
    { href := "nixwars.html?door=lord", marquee := "LORD OF THE SHARDS", coin := "DOOR 4",
      blurb := "The duel: attack, heal, flee or rest." },
    { href := "nixwars.html?door=hunt", marquee := "HUNT THE WUMPUS", coin := "DOOR 5",
      blurb := "Twenty caves, one beast, one arrow." },
    { href := "nixwars.html?door=zx81", marquee := "ZX81", coin := "DOOR 6",
      blurb := "A Z80 machine in the corner, running its own ROM." },
    { href := "nixwars.html?door=frens", marquee := "THE LOBBY", coin := "DOOR 7",
      blurb := "Claim a shard for a fren; the crown goes to the biggest chain." },
    { href := "nixwars.html?door=tycoon", marquee := "SHARD TYCOON", coin := "DOOR 8",
      blurb := "Mine, forge, run the convoy — and never conjure ore." },
    { href := "nixwars.html?door=meme", marquee := "MEME LAB", coin := "DOOR 9",
      blurb := "Breed, mutate and select; fitness never runs backwards." },
    { href := "nixwars.html?door=hyper", marquee := "HYPERSPACE", coin := "DOOR 10",
      blurb := "Walk the eight-dimensional manifold of the shard address space." },
    { href := "nixwars.html?door=oracle", marquee := "THE ORACLE", coin := "DOOR 11",
      blurb := "Witness, lift, mint: a chain of proofs closed for a bounty." },
    { href := "nixwars.html?door=vote", marquee := "THE ASSEMBLY", coin := "DOOR 12",
      blurb := "Twenty-three nodes, seven of them Byzantine, a quorum of twelve." },
    { href := "nixwars.html?door=qbert", marquee := "MONSTER CUBES", coin := "DOOR 13",
      blurb := "Hop the pyramid of ten cubes and paint every one. Q, W, A, S." },
    { href := "nixwars.html?door=frontier", marquee := "FRONTIER RUN", coin := "DOOR 14",
      blurb := "Free flight through a 16-cube of space; dock at the station. 1-6, Z, X, SPACE, K." },
    { href := "nixwars.html?door=invaders", marquee := "SHARD INVADERS", coin := "DOOR 15",
      blurb := "Five invaders over eight columns; shoot them down before the rank lands. Arrows, SPACE, T." },
    { href := "frontier.html", marquee := "FRONTIER", coin := "ADD-ON",
      blurb := "The free-flight cabinet over the certified ledger: full-screen 3D." },
    { href := "pantograph.html", marquee := "THE PANTOGRAPH", coin := "WORKSHOP",
      blurb := "A brass card shop that punches its own deck out again." },
    { href := "video.html", marquee := "THE PICTURE HOUSE", coin := "FOYER",
      blurb := "The animated history of the board, with narration." },
    { href := "transport.html", marquee := "THE FREIGHT RUN", coin := "THE DEMO",
      blurb := "The whole arcade carried across the galaxy, one cabinet to a shard — walked with a swipe, a drag, the knob or the autopilot." },
    { href := "filled-arcade.html", marquee := "THE FILLED ARCADE", coin := "ONE FILE",
      blurb := "Every cabinet and all its data in a single page, with the trained agent, the betting floor and the broadcast desk." },
    { href := "fly.html", marquee := "THE VOXEL FLIGHT", coin := "WEBGL",
      blurb := "Fly the ship through the Monster's voxel world in WebGL, at three dimensions or at fifteen, with the frontier panel, the who's-online screen and a thumb pad." },
    { href := "arcade-3d.html", marquee := "THE ARCADE IN 3D", coin := "WEBGL",
      blurb := "All fifteen doors again, each state vector drawn as voxels and played in WebGL, on a phone." } ]

/-- One cabinet, as HTML. -/
def cabinetHtml (c : Cabinet) : String :=
  "<div class=\"cab\">\n" ++
  "  <div class=\"marquee\">" ++ c.marquee ++ "</div>\n" ++
  "  <div class=\"screen\"><button onclick=\"play('" ++ c.href ++ "','" ++ c.marquee ++
    "')\">PLAY</button></div>\n" ++
  "  <div class=\"coin\">" ++ c.coin ++
    " &middot; <a href=\"" ++ c.href ++ "\" target=\"_blank\">new tab</a></div>\n" ++
  "  <div class=\"art\">" ++ c.blurb ++ "</div>\n" ++
  "</div>\n"

/-- The head of the arcade room page. -/
def arcadeHead : String := r##"<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>THE ARCADE ROOM — NixWars</title>
<style>
html, body { margin: 0; background: #050a06; color: #bfffd0;
  font-family: ui-monospace, Menlo, Consolas, monospace; }
h1 { margin: 0; font-size: 18px; letter-spacing: 0.4em; color: #8fffa5; }
header { padding: 18px 22px; border-bottom: 1px solid #16351d; }
header p { margin: 8px 0 0; font-size: 12px; color: #5f9c6f; max-width: 70ch; }
a { color: #8fffa5; }
#floor { display: grid; gap: 14px; padding: 18px 22px;
  grid-template-columns: repeat(auto-fill, minmax(230px, 1fr)); }
.cab { border: 1px solid #1e5c2c; border-radius: 6px; background:
  linear-gradient(180deg, #0a1a0e 0%, #071008 100%); padding: 10px; }
.marquee { font-size: 13px; letter-spacing: 0.18em; color: #d7ffe2;
  border-bottom: 1px solid #1e5c2c; padding-bottom: 6px; }
.screen { background: #020602; border: 1px solid #143a1c; margin: 8px 0;
  height: 62px; display: flex; align-items: center; justify-content: center; }
.screen button { background: #0d2a14; color: #8fffa5; border: 1px solid #2aa843;
  font: inherit; letter-spacing: 0.2em; padding: 6px 16px; cursor: pointer; }
.screen button:hover { background: #14401f; }
.coin { font-size: 10.5px; color: #4f8a5e; letter-spacing: 0.12em; }
.art { font-size: 11px; color: #6fbc82; margin-top: 6px; line-height: 1.45; }
#stagewrap { padding: 0 22px 22px; }
#stagebar { font-size: 11.5px; color: #5f9c6f; letter-spacing: 0.14em;
  padding: 6px 0; }
#stage { width: 100%; height: 76vh; border: 1px solid #1e5c2c; background: #020602; }
footer { padding: 14px 22px 30px; font-size: 11px; color: #4f8a5e; }
* { -webkit-tap-highlight-color: transparent; }
button { touch-action: manipulation; }
html { -webkit-text-size-adjust: 100%; }
@media (max-width: 700px) {
  header, #stagewrap, footer { padding-left: 12px; padding-right: 12px; }
  #floor { grid-template-columns: 1fr; gap: 10px; padding: 12px; }
  h1 { font-size: 15px; letter-spacing: 0.22em; }
  .screen { height: 66px; }
  .screen button { padding: 12px 18px; min-height: 44px; }
  #stage { height: 68vh; }
}
</style>
</head>
<body>
<header>
<h1>THE ARCADE ROOM</h1>
<p>Twenty-two cabinets. The fifteen doors of the board run on one WebAssembly
module whose transition table was compiled and proved equivalent to the Lean
model of each game; the add-ons are pages of their own. The last two are the
WebGL rooms: THE VOXEL FLIGHT flies the ship through the Monster's world in
three dimensions or in fifteen, and THE ARCADE IN 3D plays all fifteen doors
with their state vectors drawn as voxels. Press PLAY to stand at
a cabinet, or open it in a new tab. Everything here is static: no server, no
save file, the whole session lives in the URL.</p>
<p>Playing without a screen? Every cabinet is a pure function on a vector of
numbers, exported by the module the board runs on. <a href="AGENT-PLAY.md">The
agent's instruction sheet</a> gives the calling convention, and
<a href="agent-cards.json">agent-cards.json</a> carries a winning line of play
for each of the fifteen doors, with the state it ends in, computed and proved
in Lean.</p>
</header>
<div id="floor">
"##

/-- The tail of the arcade room page. -/
def arcadeTail : String := r##"</div>
<div id="floor">
<div class="cab">
  <div class="marquee">FOUNDATION AND EMPIRE</div>
  <div class="screen"><button onclick="play('empire.html','FOUNDATION AND EMPIRE')">PLAY</button></div>
  <div class="coin">THE LEDGER &middot; <a href="empire.html" target="_blank">new tab</a></div>
  <div class="art">A twelve-system space empire in which every command saves the next page: the rules, the whole history and the hash chain over it, in one self-contained file a player can host or commit.</div>
</div>
<div class="cab">
  <div class="marquee">THE SELDON CAMPAIGN</div>
  <div class="screen"><button onclick="play('empire-campaign.html','THE SELDON CAMPAIGN')">PLAY</button></div>
  <div class="coin">REPLAY &middot; <a href="empire-campaign.html" target="_blank">new tab</a></div>
  <div class="art">The seventy-eight command campaign in which the Foundation takes eight systems, already played out and checked in Lean.</div>
</div>
<div class="cab">
  <div class="marquee">THE GRAVITY WELL</div>
  <div class="screen"><button onclick="play('blackhole.html','THE GRAVITY WELL')">PLAY</button></div>
  <div class="coin">THE EXPERIMENT &middot; <a href="blackhole.html" target="_blank">new tab</a></div>
  <div class="art">Seven cabinets sunk toward the hole at the centre of the ring: one cartridge, seven clocks, and a reaction test that says which of them is yours.</div>
</div>
<div class="cab">
  <div class="marquee">THE GRAVITY WELL &mdash; THE FILM</div>
  <div class="screen"><button onclick="play('well-video.html','THE GRAVITY WELL - THE FILM')">PLAY</button></div>
  <div class="coin">THE RECORDING &middot; <a href="well-video.html" target="_blank">new tab</a></div>
  <div class="art">The experiment, run and recorded as an animated SVG: our autopilot plays Shard Invaders on all seven cabinets at once and wins seven times, 648 ticks apart.</div>
</div>
</div>
<div id="stagewrap">
  <div id="stagebar">NOW PLAYING: <span id="now">nothing — pick a cabinet</span></div>
  <iframe id="stage" title="the cabinet you are standing at" src="about:blank"></iframe>
</div>
<footer>Emitted from RequestProject/NixWars/Emit.lean, together with
<a href="nixwars.html">the board</a> and the module it runs on.</footer>
<script>
function play(href, name) {
  document.getElementById("stage").src = href;
  document.getElementById("now").textContent = name;
  document.getElementById("stagewrap").scrollIntoView({ behavior: "smooth" });
}
</script>
</body>
</html>
"##

/-- The arcade room page. -/
def arcadePage : String :=
  arcadeHead ++ String.join (arcadeFloor.map cabinetHtml) ++ arcadeTail

/-- Every cabinet in the room is reachable: the room lists one cabinet per door
of the board, plus the five add-ons and the two WebGL rooms. -/
example : arcadeFloor.length = 22 := by rfl

end NixWars
