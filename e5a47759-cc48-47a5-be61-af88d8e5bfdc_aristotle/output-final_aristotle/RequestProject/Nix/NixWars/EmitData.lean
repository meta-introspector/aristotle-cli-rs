import RequestProject.Nix.NixWars.WasmBinary
import RequestProject.Nix.NixWars.Arcade
import RequestProject.Nix.NixWars.ControlsJs
import RequestProject.Nix.NixWars.KeymapJs

/-!
# The data the page carries

Everything the browser page needs, printed from the Lean definitions: the
transition tables of the doors, the base-64 alphabet, the morse table, the
numbers-station digits, the SLIP / PPP framing constants, the WebAssembly
module and its test vectors, the ZX81 and its checkpoints, the roster, the
controls and the keymap.  `Emit.lean` wraps `emittedData` in the page itself;
this file is only the data, so that neither file is unmanageably long.
-/

set_option maxRecDepth 100000

namespace NixWars

/-! ## JSON printing of the emitted tables -/

/-- An expression as JSON. -/
def Expr.toJson : Expr → String
  | .lit n => "[\"lit\"," ++ toString n ++ "]"
  | .fld i => "[\"fld\"," ++ toString i ++ "]"
  | .arg => "[\"arg\"]"
  | .add a b => "[\"add\"," ++ a.toJson ++ "," ++ b.toJson ++ "]"
  | .mul a b => "[\"mul\"," ++ a.toJson ++ "," ++ b.toJson ++ "]"
  | .sub a b => "[\"sub\"," ++ a.toJson ++ "," ++ b.toJson ++ "]"
  | .div a b => "[\"div\"," ++ a.toJson ++ "," ++ b.toJson ++ "]"
  | .le a b => "[\"le\"," ++ a.toJson ++ "," ++ b.toJson ++ "]"
  | .cond c a b => "[\"cond\"," ++ c.toJson ++ "," ++ a.toJson ++ "," ++ b.toJson ++ "]"

/-- A compiled program as JSON. -/
def progToJson (prog : List Expr) : String :=
  "[" ++ String.intercalate "," (prog.map Expr.toJson) ++ "]"

/-- A compiled command table as JSON. -/
def tableToJson (table : List (String × List Expr)) : String :=
  "{" ++ String.intercalate ","
    (table.map (fun p => "\"" ++ p.1 ++ "\":" ++ progToJson p.2)) ++ "}"

/-- A morse letter as a string of `.` and `-`. -/
def morseString (l : List MorseSym) : String :=
  String.ofList (l.map (fun s => match s with
    | .dot => '.'
    | .dash => '-'
    | .gap => ' '))

/-- The morse table as JSON. -/
def morseTableJson : String :=
  "[" ++ String.intercalate ","
    (morseTable.map (fun l => "\"" ++ morseString l ++ "\"")) ++ "]"

/-- A list of strings as a JSON array. -/
def stringsToJson (l : List String) : String :=
  "[" ++ String.intercalate "," (l.map (fun s => "\"" ++ s ++ "\"")) ++ "]"

/-- A list of numbers as a JSON array. -/
def natsToJson (l : List Nat) : String :=
  "[" ++ String.intercalate "," (l.map toString) ++ "]"

/-- The NixWars session the page starts from. -/
def initialSession : Session :=
  { user := 71, shard := 17, game := 1, state := initialShip }

/-- The Monster Dash session the page starts from. Same player, same shard,
next game id. -/
def initialDashSession : GameSession monsterDash :=
  { user := 71, shard := 17, game := 2, state := initialDash }

/-- The Shard Market session the page starts from. -/
def initialMarketSession : GameSession shardMarket :=
  { user := 71, shard := 17, game := 3, state := initialMarket }

/-- The Legend of the Red Shard session the page starts from. -/
def initialLordSession : GameSession redShard :=
  { user := 71, shard := 17, game := 4, state := initialHero }

/-- The Hunt the Wumpus session the page starts from. -/
def initialHuntSession : GameSession wumpusHunt :=
  { user := 71, shard := 17, game := 5, state := initialHunt }

/-- The ZX81 session the page starts from. -/
def initialZx81Session : GameSession zx81Door :=
  { user := 71, shard := 17, game := 6, state := initialTape }

/-- The FRENS Tournament session the page starts from: the lobby sits on the
crown shard, where `nydiokar` was placed by the upstream registry. -/
def initialLobbySession : GameSession frensTournament :=
  { user := 71, shard := 47, game := 7, state := freshLobby }

/-- The Combinator Tycoon session the page starts from. -/
def initialTycoonSession : GameSession combinatorTycoon :=
  { user := 71, shard := 17, game := 8, state := initialTycoon }

/-- The Meme Breeding Pool session the page starts from. -/
def initialMemeSession : GameSession memeBreeding :=
  { user := 71, shard := 17, game := 9, state := initialPool }

/-- The 8D Hyperspace session the page starts from: the ship at the origin of
the Monster manifold. -/
def initialHyperSession : GameSession hyperspace :=
  { user := 71, shard := 17, game := 10, state := origin }

/-- The Provenance Oracle session the page starts from: an empty desk at the
assembly layer. -/
def initialOracleSession : GameSession provenanceOracle :=
  { user := 71, shard := 17, game := 11, state := initialProvenance }

/-- The Assembly session the page starts from: an empty floor, first round. -/
def initialVoteSession : GameSession assembly :=
  { user := 71, shard := 17, game := 12, state := initialBallot }

/-- The Monster Cubes session the page starts from: the player on the apex of
the pyramid. -/
def initialQbertSession : GameSession monsterCubes :=
  { user := 71, shard := 17, game := 13, state := initialQbert }

/-- The Frontier Run session the page starts from: a fresh ship at the origin
of the cube of space. -/
def initialFrontierSession : GameSession frontierRun :=
  { user := 71, shard := 17, game := 14, state := initialFrontier }

/-- The Shard Invaders session the page starts from: the gun at the left of the
floor, five invaders in the rank. -/
def initialInvadersSession : GameSession shardInvaders :=
  { user := 71, shard := 17, game := 15, state := initialInvaders }

/-- One door as JSON: its game id, its field names, the session it starts from,
and its compiled command table. The table is `Wasm.DoorIR.table`, the very list
the WebAssembly module was compiled from. -/
def doorJson (gameId : Nat) (fields : List String) (init : List Nat)
    (d : Wasm.DoorIR) : String :=
  "{\"game\":" ++ toString gameId ++ ",\"fields\":" ++ stringsToJson fields ++
    ",\"init\":" ++ natsToJson init ++ ",\"prog\":" ++ tableToJson d.table ++ "}"

/-- Every door on the board, as JSON. -/
def doorsJson : String :=
  "{\"nixwars\":" ++
    doorJson 1 fieldNames (sessionSerialize initialSession) Wasm.nixWarsIR ++
  ",\"dash\":" ++
    doorJson 2 dashFieldNames (gsSerialize initialDashSession) Wasm.dashIR ++
  ",\"market\":" ++
    doorJson 3 marketFieldNames (gsSerialize initialMarketSession) Wasm.marketIR ++
  ",\"lord\":" ++
    doorJson 4 lordFieldNames (gsSerialize initialLordSession) Wasm.lordIR ++
  ",\"hunt\":" ++
    doorJson 5 huntFieldNames (gsSerialize initialHuntSession) Wasm.huntIR ++
  ",\"zx81\":" ++
    doorJson 6 tapeFieldNames (gsSerialize initialZx81Session) Wasm.zx81IR ++
  ",\"frens\":" ++
    doorJson 7 lobbyFieldNames (gsSerialize initialLobbySession) Wasm.lobbyIR ++
  ",\"tycoon\":" ++
    doorJson 8 tycoonFieldNames (gsSerialize initialTycoonSession) Wasm.tycoonIR ++
  ",\"meme\":" ++
    doorJson 9 memeFieldNames (gsSerialize initialMemeSession) Wasm.memeIR ++
  ",\"hyper\":" ++
    doorJson 10 hyperFieldNames (gsSerialize initialHyperSession) Wasm.hyperIR ++
  ",\"oracle\":" ++
    doorJson 11 oracleFieldNames (gsSerialize initialOracleSession) Wasm.oracleIR ++
  ",\"vote\":" ++
    doorJson 12 voteFieldNames (gsSerialize initialVoteSession) Wasm.voteIR ++
  ",\"qbert\":" ++
    doorJson 13 qbertFieldNames (gsSerialize initialQbertSession) Wasm.qbertIR ++
  ",\"frontier\":" ++
    doorJson 14 frontierFieldNames (gsSerialize initialFrontierSession) Wasm.frontierIR ++
  ",\"invaders\":" ++
    doorJson 15 invadersFieldNames (gsSerialize initialInvadersSession) Wasm.invadersIR ++ "}"

/-! ## Self-test vectors for the WebAssembly module

The page runs the emitted module against these before it does anything else.
The expected values are computed here, in Lean, by the transition table — and
`Wasm.wasm_step_correct` says the module must agree with it. -/

/-- NixWars commands, arguments and states the page checks the module on. -/
def nixWasmVectors : List (Tag × Nat × List Nat) :=
  [(.warp, 99, shipSerialize initialShip),
   (.warp, 5000, shipSerialize initialShip),
   (.warp, 999999, shipSerialize initialShip),
   (.scan, 0, shipSerialize initialShip),
   (.status, 0, shipSerialize initialShip),
   (.unlock, 0, shipSerialize initialShip),
   (.jnav, 0, shipSerialize initialShip),
   (.jnav, 0, [26670, 100, 10000, 0, 1]),
   (.jnav, 0, [500, 0, 10000, 7, 1]),
   (.quit, 0, [1, 2, 3, 4, 1])]

/-- Monster Dash vectors: dodging, being hit, the edges of the track, and a
finished run. -/
def dashWasmVectors : List (DashTag × Nat × List Nat) :=
  [(.tick, 0, dashSerialize initialDash),
   (.tick, 0, [0, 0, 3, 0]),
   (.tick, 0, [2, 5, 1, 2]),
   (.tick, 0, [1, 9, 0, 4]),
   (.left, 0, [0, 0, 3, 0]),
   (.left, 0, [2, 0, 3, 0]),
   (.right, 0, [2, 0, 3, 0]),
   (.right, 0, [1, 0, 3, 5])]

/-- Shard Market vectors: an affordable buy, a buy that cannot be paid for, a
sell with and without stock, and the clock running on. -/
def marketWasmVectors : List (MarketTag × Nat × List Nat) :=
  [(.buy, 0, marketSerialize initialMarket),
   (.buy, 0, [10, 0, 47, 0]),
   (.sell, 0, [53, 1, 59, 1]),
   (.sell, 0, [53, 0, 59, 1]),
   (.hold, 0, [100, 0, 71, 2]),
   (.hold, 0, marketSerialize initialMarket)]

/-- Legend of the Red Shard vectors: a blow struck, a champion finished, a heal
afforded and refused, fleeing and resting, and a dead hero. -/
def lordWasmVectors : List (LordTag × Nat × List Nat) :=
  [(.attack, 0, lordSerialize initialHero),
   (.attack, 0, [16, 10, 1, 1, 4]),
   (.attack, 0, [1, 0, 2, 9, 3]),
   (.heal, 0, lordSerialize initialHero),
   (.heal, 0, [20, 3, 1, 5, 2]),
   (.heal, 0, [57, 40, 3, 8, 9]),
   (.flee, 0, [12, 4, 3, 11, 7]),
   (.rest, 0, [58, 4, 3, 11, 7]),
   (.rest, 0, [0, 4, 3, 11, 7])]

/-- Hunt the Wumpus vectors: walking, walking onto the wumpus, the ring
wrapping round, a hit, a miss and an empty quiver. -/
def huntWasmVectors : List (HuntTag × Nat × List Nat) :=
  [(.move, 18, huntSerialize initialHunt),
   (.move, 48, huntSerialize initialHunt),
   (.move, 99, [17, 70, 3, 1, 0]),
   (.move, 0, [17, 70, 3, 1, 0]),
   (.shoot, 48, huntSerialize initialHunt),
   (.shoot, 3, huntSerialize initialHunt),
   (.shoot, 48, [17, 47, 0, 1, 5]),
   (.sense, 0, [17, 47, 3, 1, 5]),
   (.move, 20, [17, 47, 3, 0, 9])]

/-- ZX81 vectors: one cycle, a fast-forward, a reset and a ROM change. -/
def zx81WasmVectors : List (TapeTag × Nat × List Nat) :=
  [(.step, 0, tapeSerialize initialTape),
   (.step, 0, [1, 39]),
   (.fast, 50, [0, 3]),
   (.reset, 0, [2, 400]),
   (.load, 2, [0, 17])]

/-- FRENS Tournament vectors: a claim from each seat, the crown taken from the
crown seat and from the wrong one, and a pass. -/
def lobbyWasmVectors : List (LobbyTag × Nat × List Nat) :=
  [(.claim, 0, lobbySerialize freshLobby),
   (.claim, 0, [1, 3, 0, 0, 0]),
   (.claim, 0, [2, 3, 2, 0, 0]),
   (.claim, 0, [3, 3, 2, 2, 0]),
   (.pass, 0, [3, 3, 2, 2, 2]),
   (.crown, 0, [2, 3, 2, 2, 2]),
   (.crown, 0, [0, 3, 2, 2, 2])]

/-- Combinator Tycoon vectors: a mine bought and refused, a foundry, a run with
and without stock, and a dump. -/
def tycoonWasmVectors : List (TycoonTag × Nat × List Nat) :=
  [(.mine, 0, tycoonSerialize initialTycoon),
   (.mine, 0, [3, 0, 2, 1, 9]),
   (.forge, 0, [30, 4, 2, 1, 9]),
   (.run, 0, [64, 0, 2, 2, 4]),
   (.run, 0, [64, 5, 2, 2, 5]),
   (.run, 0, [64, 5, 2, 0, 5]),
   (.dump, 0, [10, 7, 1, 1, 3])]

/-- Meme Breeding Pool vectors: a crossover the child wins and one it loses,
a mutation, and a selection that does and does not swap. -/
def memeWasmVectors : List (MemeTag × Nat × List Nat) :=
  [(.breed, 0, memeSerialize initialPool),
   (.breed, 0, [20, 100, 2, 900, 3]),
   (.mutate, 0, memeSerialize initialPool),
   (.mutate, 0, [5, 100, 9, 7, 1]),
   (.select, 0, [3, 468, 9, 200, 2]),
   (.select, 0, [9, 200, 3, 468, 2])]

/-- 8D Hyperspace vectors: a step along several axes, a wrap round a ring, a
step back, an axis that does not exist, going home and the fixed point. -/
def hyperWasmVectors : List (HyperTag × Nat × List Nat) :=
  [(.fwd, 0, hyperSerialize origin),
   (.fwd, 4, hyperSerialize origin),
   (.fwd, 7, [1, 2, 3, 4, 5, 6, 7, 7]),
   (.fwd, 9, [1, 2, 3, 4, 5, 6, 7, 7]),
   (.back, 0, [0, 2, 3, 4, 5, 6, 7, 7]),
   (.back, 3, [1, 2, 3, 4, 5, 6, 7, 7]),
   (.home, 0, [1, 2, 3, 4, 5, 6, 7, 7]),
   (.fix, 0, [1, 2, 3, 4, 5, 6, 7, 7])]

/-- Provenance Oracle vectors: a witness, a lift that is refused for want of
evidence and one that is taken, a lift at the top of the chain, a mint that is
refused below the seed layer and one that pays, and an audit. -/
def oracleWasmVectors : List (OracleTag × Nat × List Nat) :=
  [(.witness, 0, oracleSerialize initialProvenance),
   (.lift, 0, [0, 2, 0, 0]),
   (.lift, 0, [0, 3, 0, 0]),
   (.lift, 0, [3, 5, 1, 59]),
   (.mint, 0, [2, 4, 0, 0]),
   (.mint, 0, [3, 4, 1, 59]),
   (.audit, 0, [1, 1, 2, 118])]

/-- Assembly vectors: a vote for and against, a vote on a full floor, a tally
with and without a quorum, and the next round. -/
def voteWasmVectors : List (VoteTag × Nat × List Nat) :=
  [(.aye, 0, ballotSerialize initialBallot),
   (.nay, 0, [5, 3, 0, 0]),
   (.aye, 0, [12, 11, 2, 1]),
   (.tally, 0, [11, 4, 0, 0]),
   (.tally, 0, [12, 4, 0, 0]),
   (.next, 0, [12, 4, 0, 1])]

/-- Monster Cubes vectors: the three hops a fresh cabinet allows (two legal,
one off the apex), a fall off the base row, a hop onto a cube that is already
painted, and a frozen cabinet with no lives left. -/
def qbertWasmVectors : List (QbertTag × Nat × List Nat) :=
  [(.dl, 0, qbertSerialize initialQbert),
   (.dr, 0, qbertSerialize initialQbert),
   (.ul, 0, qbertSerialize initialQbert),
   (.dl, 0, [3, 0, 1, 1, 0, 1, 0, 0, 1, 0, 0, 0, 3]),
   (.ur, 0, [3, 3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2]),
   (.dr, 0, [0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0])]

/-- Shard Invaders vectors: the gun at each wall, a shot that hits, a shot that
misses, a slide, a bounce off the right wall, and a landed rank. -/
def invadersWasmVectors : List (InvadersTag × Nat × List Nat) :=
  [(.fire, 0, invadersSerialize initialInvaders),
   (.left, 0, invadersSerialize initialInvaders),
   (.right, 0, [7, 0, 0, 0, 1, 1, 1, 1, 1, 4]),
   (.fire, 0, [6, 1, 0, 2, 1, 1, 1, 1, 1, 9]),
   (.tick, 0, [0, 3, 0, 0, 1, 1, 1, 1, 1, 3]),
   (.tick, 0, [0, 0, 1, 4, 0, 1, 0, 1, 0, 8]),
   (.fire, 0, [2, 2, 0, 5, 1, 1, 1, 1, 1, 30])]

/-- Frontier Run vectors: a turn onto an axis and a turn refused, the throttle
up and down, a hop that wraps the cube, a hop on a dry tank, and a docking
followed by an undocking. -/
def frontierWasmVectors : List (FrontierTag × Nat × List Nat) :=
  [(.turnTo, 2, frontierSerialize initialFrontier),
   (.turnTo, 9, frontierSerialize initialFrontier),
   (.thrust, 0, frontierSerialize initialFrontier),
   (.brake, 0, [0, 0, 0, 0, 2, 10, 0, 4]),
   (.fly, 0, [15, 0, 0, 0, 3, 10, 0, 5]),
   (.fly, 0, [3, 0, 0, 1, 2, 1, 0, 6]),
   (.dock, 0, [6, 4, 2, 0, 0, 5, 0, 7]),
   (.dock, 0, [6, 4, 2, 0, 0, 71, 1, 8])]

/-- The name of a NixWars command, as exported. -/
def nixTagName : Tag → String
  | .warp => "warp" | .scan => "scan" | .status => "status"
  | .jnav => "jnav" | .unlock => "unlock" | .quit => "quit"

/-- The name of a Monster Dash command, as exported. -/
def dashTagName : DashTag → String
  | .left => "left" | .right => "right" | .tick => "tick"

/-- The name of a Shard Market command, as exported. -/
def marketTagName : MarketTag → String
  | .buy => "buy" | .sell => "sell" | .hold => "hold"

/-- The name of a Legend of the Red Shard command, as exported. -/
def lordTagName : LordTag → String
  | .attack => "attack" | .heal => "heal" | .flee => "flee" | .rest => "rest"

/-- The name of a Hunt the Wumpus command, as exported. -/
def huntTagName : HuntTag → String
  | .move => "move" | .shoot => "shoot" | .sense => "sense"

/-- The name of a ZX81 command, as exported. -/
def tapeTagName : TapeTag → String
  | .step => "step" | .fast => "fast" | .reset => "reset" | .load => "load"

/-- The name of a FRENS Tournament command, as exported. -/
def lobbyTagName : LobbyTag → String
  | .claim => "claim" | .pass => "pass" | .crown => "crown"

/-- The name of a Combinator Tycoon command, as exported. -/
def tycoonTagName : TycoonTag → String
  | .mine => "mine" | .forge => "forge" | .run => "run" | .dump => "dump"

/-- The name of a Meme Breeding Pool command, as exported. -/
def memeTagName : MemeTag → String
  | .breed => "breed" | .mutate => "mutate" | .select => "select"

/-- The name of an 8D Hyperspace command, as exported. -/
def hyperTagName : HyperTag → String
  | .fwd => "fwd" | .back => "back" | .home => "home" | .fix => "fix"

/-- The name of a Provenance Oracle command, as exported. -/
def oracleTagName : OracleTag → String
  | .witness => "witness" | .lift => "lift" | .mint => "mint" | .audit => "audit"

/-- The name of an Assembly command, as exported. -/
def voteTagName : VoteTag → String
  | .aye => "aye" | .nay => "nay" | .tally => "tally" | .next => "next"

/-- The name of a Monster Cubes command, as exported. -/
def qbertTagName : QbertTag → String
  | .dl => "dl" | .dr => "dr" | .ul => "ul" | .ur => "ur"

/-- The name of a Shard Invaders command, as exported. -/
def invadersTagName : InvadersTag → String
  | .left => "left" | .right => "right" | .fire => "fire" | .tick => "tick"

/-- The name of a Frontier Run command, as exported. -/
def frontierTagName : FrontierTag → String
  | .turnTo => "turn" | .thrust => "thrust" | .brake => "brake"
  | .fly => "fly" | .dock => "dock"

/-- The roster of players, as JSON: the handles found on the branches and pull
requests of the upstream repository, with their chain, shard and multiplier. -/
def frensJson : String :=
  "[" ++ String.intercalate ","
    (roster.map (fun f =>
      "{\"handle\":\"" ++ f.handle ++ "\",\"chain\":\"" ++ f.chain ++
      "\",\"shard\":" ++ toString f.shard ++ ",\"mult\":" ++ toString f.multiplier ++
      ",\"source\":\"" ++ f.source ++ "\"}")) ++ "]"

/-- The vectors as JSON: `[door, command, arg, state, expected]`. -/
def wasmVectorsJson : String :=
  let nix := nixWasmVectors.map (fun v =>
    "[\"nixwars\",\"" ++ nixTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (stepIR v.1) v.2.2 v.2.1) ++ "]")
  let dash := dashWasmVectors.map (fun v =>
    "[\"dash\",\"" ++ dashTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (dashStepIR v.1) v.2.2 v.2.1) ++ "]")
  let market := marketWasmVectors.map (fun v =>
    "[\"market\",\"" ++ marketTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (marketStepIR v.1) v.2.2 v.2.1) ++ "]")
  let lord := lordWasmVectors.map (fun v =>
    "[\"lord\",\"" ++ lordTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (lordStepIR v.1) v.2.2 v.2.1) ++ "]")
  let hunt := huntWasmVectors.map (fun v =>
    "[\"hunt\",\"" ++ huntTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (huntStepIR v.1) v.2.2 v.2.1) ++ "]")
  let zx81 := zx81WasmVectors.map (fun v =>
    "[\"zx81\",\"" ++ tapeTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (tapeStepIR v.1) v.2.2 v.2.1) ++ "]")
  let frens := lobbyWasmVectors.map (fun v =>
    "[\"frens\",\"" ++ lobbyTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (lobbyStepIR v.1) v.2.2 v.2.1) ++ "]")
  let tycoon := tycoonWasmVectors.map (fun v =>
    "[\"tycoon\",\"" ++ tycoonTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (tycoonStepIR v.1) v.2.2 v.2.1) ++ "]")
  let meme := memeWasmVectors.map (fun v =>
    "[\"meme\",\"" ++ memeTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (memeStepIR v.1) v.2.2 v.2.1) ++ "]")
  let hyper := hyperWasmVectors.map (fun v =>
    "[\"hyper\",\"" ++ hyperTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (hyperStepIR v.1) v.2.2 v.2.1) ++ "]")
  let oracle := oracleWasmVectors.map (fun v =>
    "[\"oracle\",\"" ++ oracleTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (oracleStepIR v.1) v.2.2 v.2.1) ++ "]")
  let vote := voteWasmVectors.map (fun v =>
    "[\"vote\",\"" ++ voteTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (ballotStepIR v.1) v.2.2 v.2.1) ++ "]")
  let qbert := qbertWasmVectors.map (fun v =>
    "[\"qbert\",\"" ++ qbertTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (qbertStepIR v.1) v.2.2 v.2.1) ++ "]")
  let frontier := frontierWasmVectors.map (fun v =>
    "[\"frontier\",\"" ++ frontierTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (frontierStepIR v.1) v.2.2 v.2.1) ++ "]")
  let invaders := invadersWasmVectors.map (fun v =>
    "[\"invaders\",\"" ++ invadersTagName v.1 ++ "\"," ++ toString v.2.1 ++ "," ++
      natsToJson v.2.2 ++ "," ++ natsToJson (runIR (invadersStepIR v.1) v.2.2 v.2.1) ++ "]")
  "[" ++ String.intercalate ","
    (nix ++ dash ++ market ++ lord ++ hunt ++ zx81 ++ frens ++ tycoon ++ meme ++ hyper ++
      oracle ++ vote ++ qbert ++ frontier ++ invaders) ++ "]"

/-! ## The ZX81

The emulator in the page is checked the same way: Lean runs the ROMs and prints
the processor state, a checksum of the memory and the screen at a handful of
checkpoints, and the page's emulator has to reproduce them. -/

/-- A character as a JSON string, escaping the two characters JSON reserves. -/
def jsonChar (c : Char) : String :=
  if c = '"' then "\"\\\"\""
  else if c = '\\' then "\"\\\\\""
  else "\"" ++ String.singleton c ++ "\""

/-- A line of the ZX81 screen as a JSON string. -/
def jsonLine (cs : List Char) : String :=
  "\"" ++ String.join (cs.map (fun c =>
    if c = '"' then "\\\"" else if c = '\\' then "\\\\" else String.singleton c)) ++ "\""

/-- The ZX81 character set as a JSON array of one-character strings. -/
def charTableJson : String :=
  "[" ++ String.intercalate "," (Zx81.charTable.map jsonChar) ++ "]"

/-- The ROMs the ZX81 door can load, as JSON. -/
def romsJson : String :=
  "[" ++ String.intercalate "," (Zx81.roms.map natsToJson) ++ "]"

/-- Everything the page needs to draw and drive the ZX81. -/
def zx81Json : String :=
  "{\"memSize\":" ++ toString Zx81.memSize ++ ",\"dfile\":" ++ toString Zx81.dfile ++
    ",\"cols\":" ++ toString Zx81.cols ++ ",\"rows\":" ++ toString Zx81.rows ++
    ",\"roms\":" ++ romsJson ++ ",\"names\":" ++
    stringsToJson ["BANNER", "COUNT", "FILL"] ++ ",\"chars\":" ++ charTableJson ++ "}"

/-- The processor state, memory checksum and screen at a checkpoint. -/
def cpuJson (s : Zx81.Cpu) : String :=
  "[" ++ String.intercalate ","
    [toString s.a, toString s.b, toString s.c, toString s.h, toString s.l, toString s.pc,
     (if s.zf then "1" else "0"), (if s.halted then "1" else "0"),
     toString (s.mem.foldl (· + ·) 0),
     "[" ++ String.intercalate "," ((Zx81.screen s).map jsonLine) ++ "]"] ++ "]"

/-- ROM and cycle count of each checkpoint. -/
def zx81Checkpoints : List (Nat × Nat) :=
  [(0, 0), (0, 5), (0, 30), (1, 10), (1, 40), (2, 100), (2, 400)]

/-- The checkpoints as JSON: `[rom, cycles, state]`. -/
def zx81VectorsJson : String :=
  "[" ++ String.intercalate "," (zx81Checkpoints.map (fun p =>
    "[" ++ toString p.1 ++ "," ++ toString p.2 ++ "," ++
      cpuJson (machine { rom := p.1, cycles := p.2 }) ++ "]")) ++ "]"

/-- All the data the page needs, as JavaScript constants. -/
def emittedData : String :=
  "const DOORS = " ++ doorsJson ++ ";\n" ++
  "const ALPHA = \"" ++ String.ofList urlTable ++ "\";\n" ++
  "const PREFIX = \"" ++ String.ofList urlPrefix ++ "\";\n" ++
  "const MORSE = " ++ morseTableJson ++ ";\n" ++
  "const NUMS = \"" ++ String.ofList numbersTable ++ "\";\n" ++

  "const SGR_A = " ++ toString sgrADistance ++ ";\n" ++
  "const SHARDS = " ++ toString numShards ++ ";\n" ++
  "const CROWN = " ++ toString crownShard ++ ";\n" ++
  "const SLIP = {term:" ++ toString slip.term.toNat ++ ",esc:" ++ toString slip.esc.toNat ++
    ",termCode:" ++ toString slip.termCode.toNat ++ ",escCode:" ++
    toString slip.escCode.toNat ++ "};\n" ++
  "const PPP = {term:" ++ toString ppp.term.toNat ++ ",esc:" ++ toString ppp.esc.toNat ++
    ",termCode:" ++ toString ppp.termCode.toNat ++ ",escCode:" ++
    toString ppp.escCode.toNat ++ "};\n" ++
  "const WASM = " ++ Wasm.wasmBytesJs ++ ";\n" ++
  "const WVEC = " ++ wasmVectorsJson ++ ";\n" ++
  "const ZX = " ++ zx81Json ++ ";\n" ++
  "const ZVEC = " ++ zx81VectorsJson ++ ";\n" ++
  "const FRENS = " ++ frensJson ++ ";\n" ++
  "const CTRL = " ++ Controls.controlsJson ++ ";\n" ++
  "const KMAP = " ++ Keys.keymapJson ++ ";\n"
end NixWars
