import RequestProject.Nix.NixWars.Autopilots

/-!
# Instructions for an agent: one card per cabinet

An agent that cannot see the arcade's screen can still play it, because every
cabinet is a pure function on a vector of numbers and the shipped WebAssembly
module exports that function. What such an agent needs is a *card* per cabinet:
the export prefix, the layout of the state vector, the vector to start from, a
line of play, and the vector that line ends in.

`Card` is that card, and `agentCards` carries one for each of the fifteen
doors. The lines of play are not folklore: each one is a run the Lean
development proves reaches the cabinet's goal (`agentCards_win`, and the
per-door theorems it collects), and each one is replayed here *through the
shipped module itself* — `agentCards_replay` says that calling the module's
exports by name, in the order the card gives, with the card's arguments, from
the card's start vector, lands exactly on the card's finish vector.

`www/agent-cards.json` is the same data as JSON, for an agent working outside
Lean; `www/agent-play.mjs` replays it against the module extracted from
`www/filled-arcade.html`, and `www/AGENT-PLAY.md` is the prose version.
-/

set_option maxRecDepth 1000000

namespace NixWars
namespace Agents

open Wasm

/-! ## Cards -/

/-- One command of a cabinet, as an agent sends it: the export's tag and the
numeric argument (`0` where the command takes none). -/
structure Move where
  /-- The tag: the export is `<door>_<tag>`. -/
  tag : String
  /-- The command's numeric argument. -/
  arg : Nat
  deriving Repr, DecidableEq, Inhabited

/-- Everything an agent needs in order to play one cabinet. -/
structure Card where
  /-- The export prefix of the door, e.g. `invaders`. -/
  door : String
  /-- The number on the coin door. -/
  doorNo : Nat
  /-- The name on the marquee. -/
  marquee : String
  /-- What each slot of the state vector means. -/
  fields : List String
  /-- The vector to start from. -/
  start : List Nat
  /-- The line of play. -/
  moves : List Move
  /-- The vector that line ends in. -/
  finish : List Nat
  /-- What winning means at this cabinet, in words. -/
  goal : String
  deriving Repr, Inhabited

/-! ## Playing a card on the shipped module -/

/-- Where an export lives in the module, by name. -/
def exportIndex (nm : String) : Option Nat :=
  Wasm.board.findIdx? (fun f => f.name == nm)

/-- One command, sent to the module: the argument goes first, then the state
vector, exactly as the page calls it. -/
def wasmCall (door : String) (m : Move) (st : List Nat) : Option (List Nat) :=
  match exportIndex (door ++ "_" ++ m.tag) with
  | none => none
  | some i => Wasm.callExport Wasm.board i (m.arg :: st)

/-- A whole line of play, sent to the module. -/
def wasmPlay (door : String) : List Move → List Nat → Option (List Nat)
  | [], st => some st
  | m :: ms, st =>
      match wasmCall door m st with
      | none => none
      | some st' => wasmPlay door ms st'

/-! ## Turning a door's commands into moves -/

/-- NixWars: `warp` carries the distance. -/
def shipMove : ShipCmd → Move
  | .warp d => ⟨"warp", d⟩
  | .scan => ⟨"scan", 0⟩
  | .status => ⟨"status", 0⟩
  | .jnav => ⟨"jnav", 0⟩
  | .unlock => ⟨"unlock", 0⟩
  | .quit => ⟨"quit", 0⟩

/-- Shard Dash. -/
def dashMove : DashCmd → Move
  | .left => ⟨"left", 0⟩
  | .right => ⟨"right", 0⟩
  | .tick => ⟨"tick", 0⟩

/-- The Shard Market. -/
def marketMove : MarketCmd → Move
  | .buy => ⟨"buy", 0⟩
  | .sell => ⟨"sell", 0⟩
  | .hold => ⟨"hold", 0⟩

/-- Lord of the Shards. -/
def lordMove : LordCmd → Move
  | .attack => ⟨"attack", 0⟩
  | .heal => ⟨"heal", 0⟩
  | .flee => ⟨"flee", 0⟩
  | .rest => ⟨"rest", 0⟩

/-- Hunt the Wumpus: `move` and `shoot` carry a room. -/
def huntMove : HuntCmd → Move
  | .move r => ⟨"move", r⟩
  | .shoot r => ⟨"shoot", r⟩
  | .sense => ⟨"sense", 0⟩

/-- The ZX81: `fast` carries a cycle count, `load` a ROM number. -/
def tapeMove : TapeCmd → Move
  | .step => ⟨"step", 0⟩
  | .fast n => ⟨"fast", n⟩
  | .reset => ⟨"reset", 0⟩
  | .load i => ⟨"load", i⟩

/-- The Lobby. -/
def lobbyMove : LobbyCmd → Move
  | .claim => ⟨"claim", 0⟩
  | .pass => ⟨"pass", 0⟩
  | .crown => ⟨"crown", 0⟩

/-- Shard Tycoon. -/
def tycoonMove : TycoonCmd → Move
  | .mine => ⟨"mine", 0⟩
  | .forge => ⟨"forge", 0⟩
  | .run => ⟨"run", 0⟩
  | .dump => ⟨"dump", 0⟩

/-- The Meme Lab. -/
def memeMove : MemeCmd → Move
  | .breed => ⟨"breed", 0⟩
  | .mutate => ⟨"mutate", 0⟩
  | .select => ⟨"select", 0⟩

/-- Hyperspace: `fwd` and `back` carry an axis. -/
def hyperMove : HyperCmd → Move
  | .fwd d => ⟨"fwd", d⟩
  | .back d => ⟨"back", d⟩
  | .home => ⟨"home", 0⟩
  | .fix => ⟨"fix", 0⟩

/-- The Oracle. -/
def oracleMove : OracleCmd → Move
  | .witness => ⟨"witness", 0⟩
  | .lift => ⟨"lift", 0⟩
  | .mint => ⟨"mint", 0⟩
  | .audit => ⟨"audit", 0⟩

/-- The Assembly. -/
def voteMove : VoteCmd → Move
  | .aye => ⟨"aye", 0⟩
  | .nay => ⟨"nay", 0⟩
  | .tally => ⟨"tally", 0⟩
  | .next => ⟨"next", 0⟩

/-- Monster Cubes. -/
def qbertMove : QbertCmd → Move
  | .dl => ⟨"dl", 0⟩
  | .dr => ⟨"dr", 0⟩
  | .ul => ⟨"ul", 0⟩
  | .ur => ⟨"ur", 0⟩

/-- The Frontier Run: `turn` carries the heading. -/
def frontierMove : FrontierCmd → Move
  | .turnTo h => ⟨"turn", h⟩
  | .thrust => ⟨"thrust", 0⟩
  | .brake => ⟨"brake", 0⟩
  | .fly => ⟨"fly", 0⟩
  | .dock => ⟨"dock", 0⟩

/-- Shard Invaders. -/
def invadersMove : InvadersCmd → Move
  | .left => ⟨"left", 0⟩
  | .right => ⟨"right", 0⟩
  | .fire => ⟨"fire", 0⟩
  | .tick => ⟨"tick", 0⟩

/-! ## The lines of play

Each is either a run already proved winning elsewhere in the development, or a
run proved winning just below. -/

/-- Door 1: the ship's autopilot, ninety-nine light-years a jump. -/
def shipPlan : List ShipCmd := Controls.pilot nixWars Controls.shipAuto initialShip 270

/-- Door 2: the runner's autopilot, forty commands. -/
def dashPlan : List DashCmd := Controls.pilot monsterDash Controls.dashAuto initialDash 40

/-- Door 3: buy at 47, hold through 59, sell at 71. -/
def marketPlan : List MarketCmd := [.buy, .hold, .sell]

/-- Door 4: nine blows take the hero from level one to level three. -/
def lordPlan : List LordCmd := List.replicate 9 .attack

/-- Door 5: wait a turn, then put an arrow into the shard the wumpus creeps
onto. -/
def huntPlan : List HuntCmd := [.move 17, .shoot 48]

/-- Door 6: load the banner ROM and run thirty cycles. -/
def tapePlan : List TapeCmd := [.load 0, .fast 30]

/-- Door 7: two claims, the crown, and a claim. -/
def lobbyPlan : List LobbyCmd := [.claim, .claim, .crown, .claim]

/-- Door 8: three mines, three forges, and eleven shifts. -/
def tycoonPlan : List TycoonCmd :=
  [.mine, .mine, .mine, .forge, .forge, .forge] ++ List.replicate 11 .run

/-- Door 9: mutate the challenger, breed, and repeat; then select. -/
def memePlan : List MemeCmd := [.mutate, .mutate, .breed, .mutate, .mutate, .breed, .select]

/-- Door 10: walk the whole ring of axis three and come home. -/
def hyperPlan : List HyperCmd := List.replicate 8 (.fwd 3)

/-- Door 11: three witnesses a layer, up the chain, and mint. -/
def oraclePlan : List OracleCmd :=
  [.witness, .witness, .witness, .lift, .witness, .witness, .witness, .lift,
   .witness, .witness, .witness, .lift, .witness, .witness, .witness, .mint]

/-- Door 12: twelve ayes carry the proposal. -/
def votePlan : List VoteCmd := List.replicate 12 .aye ++ [.tally]

/-- Door 13: the cabinet's autopilot, eleven hops. -/
def qbertPlan : List QbertCmd := Controls.qbertAutoPlan

/-- Door 14: the flight plan to the station. -/
def frontierPlan : List FrontierCmd := frontierFlightPlan

/-- Door 15: the gun's autopilot, nine commands. -/
def invadersPlan : List InvadersCmd := Controls.invadersAutoPlan

/-! ## What the lines of play achieve -/

/-- **Door 1 arrives at Sgr A*** — on the fuel it left Sol with. -/
theorem ship_plan_arrives :
    (nixWars.run initialShip shipPlan : Ship).dist = 0 ∧
      (nixWars.run initialShip shipPlan : Ship).fuel = 100 :=
  ⟨Controls.shipAuto_arrives, Controls.shipAuto_fuel⟩

/-- **Door 2 keeps all three lives** and scores twenty-four. -/
theorem dash_plan_survives :
    (monsterDash.run initialDash dashPlan : Dash).lives = 3 ∧
      (monsterDash.run initialDash dashPlan : Dash).score = 24 :=
  ⟨Controls.dashAuto_no_deaths 40, Controls.dashAuto_score⟩

/-- **Door 3 turns a profit**: a hundred credits become a hundred and
twenty-four, with nothing left on the books. -/
theorem market_plan_profits :
    shardMarket.run initialMarket marketPlan =
      { credits := 124, held := 0, price := 47, turn := 3 } := by
  rfl

/-- **Door 4 climbs two levels** and the hero lives. -/
theorem lord_plan_levels :
    redShard.run initialHero lordPlan =
      { hp := 13, gold := 16, level := 3, foe := 11, turn := 9 } := by
  rfl

/-- **Door 5 kills the wumpus.** -/
theorem hunt_plan_kills :
    wumpusHunt.run initialHunt huntPlan =
      { room := 17, wumpus := wumpusSlain, arrows := 2, alive := true, turn := 2 } :=
  hunt_winnable

/-- **Door 6 prints the banner.** -/
theorem tape_plan_prints :
    Zx81.screenRow (machine (zx81Door.run initialTape tapePlan)) 0
      = "NIXWARS         ".toList := by
  have h : zx81Door.run initialTape tapePlan = { rom := 0, cycles := 30 } := by rfl
  rw [h]
  exact Zx81.banner_prints.2

/-- **Door 7 pays the crown** to the seat standing on shard 47. -/
theorem lobby_plan_crowns :
    frensTournament.run freshLobby lobbyPlan =
      { seat := 0, mmc0 := 3, mmc1 := 2, mmc2 := 47, mmc3 := 2 } := by
  rfl

/-- **Door 8 makes money**: the factory ends richer than its seed funding, with
three mines and three forges standing. -/
theorem tycoon_plan_profits :
    combinatorTycoon.run initialTycoon tycoonPlan =
      { cash := 106, raw := 3, mines := 3, forges := 3, tick := 17 } := by
  rfl

/-- **Door 9 breeds a fitter champion**: fitness three becomes fitness five. -/
theorem meme_plan_improves :
    memeBreeding.run initialPool memePlan =
      { champFit := 5, champCyc := 509, chalFit := 4, chalCyc := 639, gen := 2 } := by
  rfl

/-- **Door 10 walks the ring home**: eight steps along an axis return the ship
to where it started. -/
theorem hyper_plan_returns : hyperspace.run origin hyperPlan = origin := by
  rfl

/-- **Door 11 mints a seed** and collects the bounty. -/
theorem oracle_plan_mints :
    provenanceOracle.run initialProvenance oraclePlan =
      { layer := 0, evidence := 0, seeds := 1, bounty := 59 } := by
  rfl

/-- **Door 12 carries the proposal**: twelve ayes are the quorum. -/
theorem vote_plan_passes :
    assembly.run initialBallot votePlan = { ayes := 12, nays := 0, round := 0, passed := 1 } := by
  rfl

/-- **Door 13 paints the pyramid**, and keeps all three lives. -/
theorem qbert_plan_clears :
    QbertCleared (monsterCubes.run initialQbert qbertPlan) ∧
      (monsterCubes.run initialQbert qbertPlan : Qbert).lives = 3 := by
  constructor
  · exact qbert_run_cleared
  · exact qbert_run_score.2

/-- **Door 14 docks at the station**, on a full tank. -/
theorem frontier_plan_docks :
    frontierRun.run initialFrontier frontierPlan =
      { x := 6, y := 4, z := 2, hdg := 4, speed := 0, fuel := 71, docked := 1, turn := 12 } :=
  frontier_winnable

/-- **Door 15 clears the sky**, without letting the rank drop a row — and no
shorter line of play could. -/
theorem invaders_plan_clears :
    InvadersCleared (shardInvaders.run initialInvaders invadersPlan) ∧
      (shardInvaders.run initialInvaders invadersPlan : Invaders).dy = 0 ∧
      ∀ cs : List InvadersCmd,
        InvadersCleared (shardInvaders.run initialInvaders cs) → 9 ≤ cs.length := by
  refine ⟨?_, ?_, Controls.invaders_clearing_length_ge_nine⟩
  · exact Controls.invadersAuto_clears
  · exact Controls.invadersAuto_no_drop

/-! ## The cards themselves -/

/-- Door 1: NixWars. -/
def nixwarsCard : Card :=
  { door := "nixwars", doorNo := 1, marquee := "NIXWARS", fields := fieldNames,
    start := shipSerialize initialShip,
    moves := shipPlan.map shipMove,
    finish := shipSerialize (nixWars.run initialShip shipPlan),
    goal := "close the 26673 light-years to Sgr A*: field dist reaches 0" }

/-- Door 2: Shard Dash. -/
def dashCard : Card :=
  { door := "dash", doorNo := 2, marquee := "SHARD DASH", fields := dashFieldNames,
    start := dashSerialize initialDash,
    moves := dashPlan.map dashMove,
    finish := dashSerialize (monsterDash.run initialDash dashPlan),
    goal := "keep all three lives while the score climbs: field lives stays 3" }

/-- Door 3: the Shard Market. -/
def marketCard : Card :=
  { door := "market", doorNo := 3, marquee := "SHARD MARKET", fields := marketFieldNames,
    start := marketSerialize initialMarket,
    moves := marketPlan.map marketMove,
    finish := marketSerialize (shardMarket.run initialMarket marketPlan),
    goal := "end with more credits than you started and nothing held" }

/-- Door 4: Lord of the Shards. -/
def lordCard : Card :=
  { door := "lord", doorNo := 4, marquee := "LORD OF THE SHARDS", fields := lordFieldNames,
    start := lordSerialize initialHero,
    moves := lordPlan.map lordMove,
    finish := lordSerialize (redShard.run initialHero lordPlan),
    goal := "climb the ladder alive: field level rises, field hp stays above 0" }

/-- Door 5: Hunt the Wumpus. -/
def huntCard : Card :=
  { door := "hunt", doorNo := 5, marquee := "HUNT THE WUMPUS", fields := huntFieldNames,
    start := huntSerialize initialHunt,
    moves := huntPlan.map huntMove,
    finish := huntSerialize (wumpusHunt.run initialHunt huntPlan),
    goal := "slay the wumpus and live: field wumpus reaches 71, field alive stays 1" }

/-- Door 6: the ZX81. -/
def zx81Card : Card :=
  { door := "zx81", doorNo := 6, marquee := "ZX81", fields := tapeFieldNames,
    start := tapeSerialize initialTape,
    moves := tapePlan.map tapeMove,
    finish := tapeSerialize (zx81Door.run initialTape tapePlan),
    goal := "run the banner ROM until NIXWARS stands on the top line of the screen" }

/-- Door 7: the Lobby. -/
def lobbyCard : Card :=
  { door := "frens", doorNo := 7, marquee := "THE LOBBY", fields := lobbyFieldNames,
    start := lobbySerialize freshLobby,
    moves := lobbyPlan.map lobbyMove,
    finish := lobbySerialize (frensTournament.run freshLobby lobbyPlan),
    goal := "take the crown for the seat on shard 47: field mmc2 reaches 47" }

/-- Door 8: Shard Tycoon. -/
def tycoonCard : Card :=
  { door := "tycoon", doorNo := 8, marquee := "SHARD TYCOON", fields := tycoonFieldNames,
    start := tycoonSerialize initialTycoon,
    moves := tycoonPlan.map tycoonMove,
    finish := tycoonSerialize (combinatorTycoon.run initialTycoon tycoonPlan),
    goal := "end richer than the seed funding of 100, with mines and forges standing" }

/-- Door 9: the Meme Lab. -/
def memeCard : Card :=
  { door := "meme", doorNo := 9, marquee := "MEME LAB", fields := memeFieldNames,
    start := memeSerialize initialPool,
    moves := memePlan.map memeMove,
    finish := memeSerialize (memeBreeding.run initialPool memePlan),
    goal := "breed a fitter champion: field champfit rises" }

/-- Door 10: Hyperspace. -/
def hyperCard : Card :=
  { door := "hyper", doorNo := 10, marquee := "HYPERSPACE", fields := hyperFieldNames,
    start := hyperSerialize origin,
    moves := hyperPlan.map hyperMove,
    finish := hyperSerialize (hyperspace.run origin hyperPlan),
    goal := "walk a whole axis of the manifold and come back to the origin" }

/-- Door 11: the Oracle. -/
def oracleCard : Card :=
  { door := "oracle", doorNo := 11, marquee := "THE ORACLE", fields := oracleFieldNames,
    start := oracleSerialize initialProvenance,
    moves := oraclePlan.map oracleMove,
    finish := oracleSerialize (provenanceOracle.run initialProvenance oraclePlan),
    goal := "close a provenance chain: field seeds reaches 1 and the bounty is paid" }

/-- Door 12: the Assembly. -/
def voteCard : Card :=
  { door := "vote", doorNo := 12, marquee := "THE ASSEMBLY", fields := voteFieldNames,
    start := ballotSerialize initialBallot,
    moves := votePlan.map voteMove,
    finish := ballotSerialize (assembly.run initialBallot votePlan),
    goal := "carry a proposal: twelve ayes are the quorum, field passed reaches 1" }

/-- Door 13: Monster Cubes. -/
def qbertCard : Card :=
  { door := "qbert", doorNo := 13, marquee := "MONSTER CUBES", fields := qbertFieldNames,
    start := qbertSerialize initialQbert,
    moves := qbertPlan.map qbertMove,
    finish := qbertSerialize (monsterCubes.run initialQbert qbertPlan),
    goal := "paint all ten cubes without losing a life: fields c0..c9 all reach 1" }

/-- Door 14: the Frontier Run. -/
def frontierCard : Card :=
  { door := "frontier", doorNo := 14, marquee := "FRONTIER RUN", fields := frontierFieldNames,
    start := frontierSerialize initialFrontier,
    moves := frontierPlan.map frontierMove,
    finish := frontierSerialize (frontierRun.run initialFrontier frontierPlan),
    goal := "dock at the station at (6,4,2): field docked reaches 1" }

/-- Door 15: Shard Invaders. -/
def invadersCard : Card :=
  { door := "invaders", doorNo := 15, marquee := "SHARD INVADERS", fields := invadersFieldNames,
    start := invadersSerialize initialInvaders,
    moves := invadersPlan.map invadersMove,
    finish := invadersSerialize (shardInvaders.run initialInvaders invadersPlan),
    goal := "shoot all five invaders down before the rank lands: fields a0..a4 all reach 0" }

/-- **The cards: one per door.** -/
def agentCards : List Card :=
  [nixwarsCard, dashCard, marketCard, lordCard, huntCard, zx81Card, lobbyCard, tycoonCard,
   memeCard, hyperCard, oracleCard, voteCard, qbertCard, frontierCard, invadersCard]

/-- There is a card for every door on the board. -/
theorem agentCards_length : agentCards.length = Wasm.boardIR.length := by rfl

/-- The cards name the doors of the board, in order. -/
theorem agentCards_doors : agentCards.map Card.door = Wasm.boardIR.map Wasm.DoorIR.name := by
  rfl

/-! ## The cards play on the shipped module

Each card is replayed here through the very WebAssembly the page ships: the
exports are looked up by name, called with the card's arguments in the card's
order, and the vector they leave behind is the card's finish vector. -/

/-- Every card replays on the module. -/
def cardsReplay : Bool :=
  agentCards.all (fun c => wasmPlay c.door c.moves c.start == some c.finish)

theorem cardsReplay_eq_true : cardsReplay = true := by rfl

/-- **The cards play, on the shipped WebAssembly.** Following a card's moves
through the module's own exports lands exactly on the card's finish vector — so
an agent driving the module from outside Lean sees what Lean says it will. -/
theorem agentCards_replay (c : Card) (hc : c ∈ agentCards) :
    wasmPlay c.door c.moves c.start = some c.finish := by
  have h := cardsReplay_eq_true
  unfold cardsReplay at h
  rw [List.all_eq_true] at h
  have := h c hc
  simpa using this

/-! ## The cards are JSON -/

/-- A list of numbers, as JSON. -/
def jsonNats (ns : List Nat) : String :=
  "[" ++ String.intercalate "," (ns.map toString) ++ "]"

/-- A list of strings, as JSON. -/
def jsonStrings (ss : List String) : String :=
  "[" ++ String.intercalate "," (ss.map (fun s => "\"" ++ s ++ "\"")) ++ "]"

/-- A line of play, as JSON. -/
def jsonMoves (ms : List Move) : String :=
  "[" ++ String.intercalate ","
    (ms.map (fun m => "[\"" ++ m.tag ++ "\"," ++ toString m.arg ++ "]")) ++ "]"

/-- One card, as JSON. -/
def jsonCard (c : Card) : String :=
  "{\"door\":\"" ++ c.door ++ "\",\"doorNo\":" ++ toString c.doorNo ++
  ",\"marquee\":\"" ++ c.marquee ++ "\",\"fields\":" ++ jsonStrings c.fields ++
  ",\"start\":" ++ jsonNats c.start ++ ",\"moves\":" ++ jsonMoves c.moves ++
  ",\"finish\":" ++ jsonNats c.finish ++ ",\"goal\":\"" ++ c.goal ++ "\"}"

/-- All the cards, as JSON. -/
def agentCardsJson : String :=
  "{\"cards\":[" ++ String.intercalate ",\n" (agentCards.map jsonCard) ++ "]}\n"

/-- Writing the cards out for agents working outside Lean. -/
def writeAgentCards : IO Unit :=
  IO.FS.writeFile "www/agent-cards.json" agentCardsJson

#eval writeAgentCards

end Agents
end NixWars
