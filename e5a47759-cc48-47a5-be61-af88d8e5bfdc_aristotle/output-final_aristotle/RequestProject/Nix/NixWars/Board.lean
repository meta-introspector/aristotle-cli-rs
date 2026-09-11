import RequestProject.Nix.NixWars.Wasm
import RequestProject.Nix.NixWars.DashMachine
import RequestProject.Nix.NixWars.MarketMachine
import RequestProject.Nix.NixWars.LordMachine
import RequestProject.Nix.NixWars.WumpusMachine
import RequestProject.Nix.NixWars.Zx81Door
import RequestProject.Nix.NixWars.TournamentMachine
import RequestProject.Nix.NixWars.TycoonMachine
import RequestProject.Nix.NixWars.MemeMachine
import RequestProject.Nix.NixWars.HyperspaceMachine
import RequestProject.Nix.NixWars.OracleMachine
import RequestProject.Nix.NixWars.VoteMachine
import RequestProject.Nix.NixWars.QbertMachine
import RequestProject.Nix.NixWars.FrontierMachine
import RequestProject.Nix.NixWars.InvadersMachine

/-!
# The board: every door in one WebAssembly module

`Wasm.lean` compiles any `DoorIR` and proves the compiled code computes its
table; `Machine.lean`, `DashMachine.lean`, `MarketMachine.lean`, `LordMachine.lean`,
`WumpusMachine.lean` and `Zx81Door.lean` prove those tables are the games. Here
the six are put together: one module, one exported function per command per
door, and one theorem per door saying the module *is* that game.

Adding a further door means adding a `DoorIR` to `boardIR` — no new transport
code, no new compiler, no new proof about the machine. Legend of the Red Shard,
Hunt the Wumpus and the ZX81 were all added exactly that way.
-/

namespace NixWars
namespace Wasm

/-! ## The doors -/

/-- The commands of NixWars, with the names the page uses. -/
def nixWarsTags : List (String × Tag) :=
  [("warp", .warp), ("scan", .scan), ("status", .status),
   ("jnav", .jnav), ("unlock", .unlock), ("quit", .quit)]

/-- NixWars as compiled code. -/
def nixWarsIR : DoorIR :=
  ⟨"nixwars", 5, nixWarsTags.map (fun p => (p.1, stepIR p.2))⟩

/-- Monster Dash as compiled code. -/
def dashIR : DoorIR :=
  ⟨"dash", 4, dashTagsWithNames.map (fun p => (p.1, dashStepIR p.2))⟩

/-- The Shard Market as compiled code. -/
def marketIR : DoorIR :=
  ⟨"market", 4, marketTagsWithNames.map (fun p => (p.1, marketStepIR p.2))⟩

/-- Legend of the Red Shard as compiled code. -/
def lordIR : DoorIR :=
  ⟨"lord", 5, lordTagsWithNames.map (fun p => (p.1, lordStepIR p.2))⟩

/-- Hunt the Wumpus as compiled code. -/
def huntIR : DoorIR :=
  ⟨"hunt", 5, huntTagsWithNames.map (fun p => (p.1, huntStepIR p.2))⟩

/-- The ZX81 door as compiled code. -/
def zx81IR : DoorIR :=
  ⟨"zx81", 2, tapeTagsWithNames.map (fun p => (p.1, tapeStepIR p.2))⟩

/-- The FRENS Tournament as compiled code. -/
def lobbyIR : DoorIR :=
  ⟨"frens", 5, lobbyTagsWithNames.map (fun p => (p.1, lobbyStepIR p.2))⟩

/-- The Combinator Tycoon as compiled code. -/
def tycoonIR : DoorIR :=
  ⟨"tycoon", 5, tycoonTagsWithNames.map (fun p => (p.1, tycoonStepIR p.2))⟩

/-- The Meme Breeding Pool as compiled code. -/
def memeIR : DoorIR :=
  ⟨"meme", 5, memeTagsWithNames.map (fun p => (p.1, memeStepIR p.2))⟩

/-- 8D Hyperspace as compiled code. -/
def hyperIR : DoorIR :=
  ⟨"hyper", 8, hyperTagsWithNames.map (fun p => (p.1, hyperStepIR p.2))⟩

/-- The Provenance Oracle as compiled code. -/
def oracleIR : DoorIR :=
  ⟨"oracle", 4, oracleTagsWithNames.map (fun p => (p.1, oracleStepIR p.2))⟩

/-- The Assembly as compiled code. -/
def voteIR : DoorIR :=
  ⟨"vote", 4, voteTagsWithNames.map (fun p => (p.1, ballotStepIR p.2))⟩

/-- Monster Cubes as compiled code. -/
def qbertIR : DoorIR :=
  ⟨"qbert", 13, qbertTagsWithNames.map (fun p => (p.1, qbertStepIR p.2))⟩

/-- The Frontier Run as compiled code. -/
def frontierIR : DoorIR :=
  ⟨"frontier", 8, frontierTagsWithNames.map (fun p => (p.1, frontierStepIR p.2))⟩

/-- Shard Invaders as compiled code. -/
def invadersIR : DoorIR :=
  ⟨"invaders", 10, invadersTagsWithNames.map (fun p => (p.1, invadersStepIR p.2))⟩

/-- The board: every door the BBS runs. -/
def boardIR : List DoorIR :=
  [nixWarsIR, dashIR, marketIR, lordIR, huntIR, zx81IR, lobbyIR, tycoonIR, memeIR, hyperIR,
   oracleIR, voteIR, qbertIR, frontierIR, invadersIR]

/-- **The module the page ships.** -/
def board : Module := boardModule boardIR

theorem board_hasHelpers : HasHelpers board := boardModule_hasHelpers boardIR

/-- Index of a NixWars command in the module. -/
def nixTagIndex : Tag → Nat
  | .warp => 2
  | .scan => 3
  | .status => 4
  | .jnav => 5
  | .unlock => 6
  | .quit => 7

/-- Index of a Monster Dash command in the module. -/
def dashTagIndex : DashTag → Nat
  | .left => 8
  | .right => 9
  | .tick => 10

/-- Index of a Shard Market command in the module. -/
def marketTagIndex : MarketTag → Nat
  | .buy => 11
  | .sell => 12
  | .hold => 13

/-- Index of a Legend of the Red Shard command in the module. -/
def lordTagIndex : LordTag → Nat
  | .attack => 14
  | .heal => 15
  | .flee => 16
  | .rest => 17

/-- Index of a Hunt the Wumpus command in the module. -/
def huntTagIndex : HuntTag → Nat
  | .move => 18
  | .shoot => 19
  | .sense => 20

/-- Index of a ZX81 door command in the module. -/
def tapeTagIndex : TapeTag → Nat
  | .step => 21
  | .fast => 22
  | .reset => 23
  | .load => 24

/-- Index of a FRENS Tournament command in the module. -/
def lobbyTagIndex : LobbyTag → Nat
  | .claim => 25
  | .pass => 26
  | .crown => 27

/-- Index of a Combinator Tycoon command in the module. -/
def tycoonTagIndex : TycoonTag → Nat
  | .mine => 28
  | .forge => 29
  | .run => 30
  | .dump => 31

/-- Index of a Meme Breeding Pool command in the module. -/
def memeTagIndex : MemeTag → Nat
  | .breed => 32
  | .mutate => 33
  | .select => 34

/-- Index of an 8D Hyperspace command in the module. -/
def hyperTagIndex : HyperTag → Nat
  | .fwd => 35
  | .back => 36
  | .home => 37
  | .fix => 38

/-- Index of a Provenance Oracle command in the module. -/
def oracleTagIndex : OracleTag → Nat
  | .witness => 39
  | .lift => 40
  | .mint => 41
  | .audit => 42

/-- Index of an Assembly command in the module. -/
def voteTagIndex : VoteTag → Nat
  | .aye => 43
  | .nay => 44
  | .tally => 45
  | .next => 46

/-- Index of a Monster Cubes command in the module. -/
def qbertTagIndex : QbertTag → Nat
  | .dl => 47
  | .dr => 48
  | .ul => 49
  | .ur => 50

/-- Index of a Frontier Run command in the module. -/
def frontierTagIndex : FrontierTag → Nat
  | .turnTo => 51
  | .thrust => 52
  | .brake => 53
  | .fly => 54
  | .dock => 55

/-- Index of a Shard Invaders command in the module. -/
def invadersTagIndex : InvadersTag → Nat
  | .left => 56
  | .right => 57
  | .fire => 58
  | .tick => 59

/-! ## Nothing overflows -/

/-- Under the operating bound nothing in the NixWars table can overflow. -/
theorem bnd_stepIR (tag : Tag) : ∀ e ∈ stepIR tag, e.bnd B < W := by
  cases tag <;> simp [stepIR, warpIR, guardIR, idIR, Expr.bnd, B, W]

/-- Under the operating bound nothing in the Monster Dash table can overflow.
The multiplication in `turn % 3` is the tight one: `3 * B` still fits. -/
theorem bnd_dashStepIR (tag : DashTag) : ∀ e ∈ dashStepIR tag, e.bnd B < W := by
  cases tag <;> simp [dashStepIR, eqIR, modIR, obstacleIR, Expr.bnd, B, W]

/-- Under the operating bound nothing in the Shard Market table can overflow:
the only sum of two unknowns is `credits + price`, and `2 * B` still fits. -/
theorem bnd_marketStepIR (tag : MarketTag) : ∀ e ∈ marketStepIR tag, e.bnd B < W := by
  cases tag <;> simp [marketStepIR, nextPriceIR, eqIR, Expr.bnd, B, W]

/-- Under the operating bound nothing in the Legend of the Red Shard table can
overflow: the widest term is `gold + 2 * level`, and `3 * B` still fits. -/
theorem bnd_lordStepIR (tag : LordTag) : ∀ e ∈ lordStepIR tag, e.bnd B < W := by
  cases tag <;> simp [lordStepIR, lordGuard, lordAliveIR, lordWinIR, minIR, Expr.bnd, B, W]

/-- Under the operating bound nothing in the Hunt the Wumpus table can
overflow: the wumpus's creep is built from comparisons, not from a modulo. -/
theorem bnd_huntStepIR (tag : HuntTag) : ∀ e ∈ huntStepIR tag, e.bnd B < W := by
  cases tag <;> simp [huntStepIR, creepIR, eqIR, Expr.bnd, B, W]

/-- Under the operating bound nothing in the ZX81 table can overflow: the only
sum of two unknowns is `cycles + arg`, and `2 * B` still fits. -/
theorem bnd_tapeStepIR (tag : TapeTag) : ∀ e ∈ tapeStepIR tag, e.bnd B < W := by
  cases tag <;> simp [tapeStepIR, Expr.bnd, B, W]

/-- Under the operating bound nothing in the FRENS Tournament table can
overflow: a purse only ever gains the crown bonus, and `B + 47` still fits. -/
theorem bnd_lobbyStepIR (tag : LobbyTag) : ∀ e ∈ lobbyStepIR tag, e.bnd B < W := by
  cases tag <;>
    simp [lobbyStepIR, payIR, isSeatIR, nextSeatIR, seatMultiplierIR, eqIR, Expr.bnd, B, W]

theorem length_lobbyStepIR (tag : LobbyTag) : (lobbyStepIR tag).length = 5 := by
  cases tag <;> rfl

/-- Under the operating bound nothing in the Combinator Tycoon table can
overflow: the widest term is `cash + 2 * min raw forges`, and `3 * B` still
fits. -/
theorem bnd_tycoonStepIR (tag : TycoonTag) : ∀ e ∈ tycoonStepIR tag, e.bnd B < W := by
  cases tag <;> simp [tycoonStepIR, convertedIR, minIR, Expr.bnd, B, W]

/-- Under the operating bound nothing in the Meme Breeding Pool table can
overflow: crossover halves the sum of two fitnesses, and `2 * B + 1` still
fits. -/
theorem bnd_memeStepIR (tag : MemeTag) : ∀ e ∈ memeStepIR tag, e.bnd B < W := by
  cases tag <;> simp [memeStepIR, childFitnessIR, childCyclesIR, Expr.bnd, B, W]

/-- Under the operating bound nothing in the 8D Hyperspace table can overflow:
every axis only ever gains one. -/
theorem bnd_hyperStepIR (tag : HyperTag) : ∀ e ∈ hyperStepIR tag, e.bnd B < W := by
  cases tag <;> simp [hyperStepIR, axisIR, bumpUpIR, bumpDownIR, eqIR, Expr.bnd, B, W]

theorem length_tycoonStepIR (tag : TycoonTag) : (tycoonStepIR tag).length = 5 := by
  cases tag <;> rfl

theorem length_memeStepIR (tag : MemeTag) : (memeStepIR tag).length = 5 := by
  cases tag <;> rfl

theorem length_hyperStepIR (tag : HyperTag) : (hyperStepIR tag).length = 8 := by
  cases tag <;> rfl

/-- Under the operating bound nothing in the Provenance Oracle table can
overflow: the guards are zero or one, and the widest term is `bounty + 59`. -/
theorem bnd_oracleStepIR (tag : OracleTag) : ∀ e ∈ oracleStepIR tag, e.bnd B < W := by
  cases tag <;>
    simp [oracleStepIR, canLiftIR, canMintIR, andIR, hasEvidenceIR, ltIR, eqIR, Expr.bnd, B, W]

theorem length_oracleStepIR (tag : OracleTag) : (oracleStepIR tag).length = 4 := by
  cases tag <;> rfl

/-- Under the operating bound nothing in the Assembly table can overflow: the
widest term is `ayes + nays`, and `2 * B + 1` still fits. -/
theorem bnd_ballotStepIR (tag : VoteTag) : ∀ e ∈ ballotStepIR tag, e.bnd B < W := by
  cases tag <;> simp [ballotStepIR, hasVoterIR, hasQuorumIR, ltIR, Expr.bnd, B, W]

theorem length_ballotStepIR (tag : VoteTag) : (ballotStepIR tag).length = 4 := by
  cases tag <;> rfl

theorem length_stepIR (tag : Tag) : (stepIR tag).length = 5 := by
  cases tag <;> rfl

theorem length_lordStepIR (tag : LordTag) : (lordStepIR tag).length = 5 := by
  cases tag <;> rfl

theorem length_huntStepIR (tag : HuntTag) : (huntStepIR tag).length = 5 := by
  cases tag <;> rfl

theorem length_tapeStepIR (tag : TapeTag) : (tapeStepIR tag).length = 2 := by
  cases tag <;> rfl

theorem length_dashStepIR (tag : DashTag) : (dashStepIR tag).length = 4 := by
  cases tag <;> rfl

theorem length_marketStepIR (tag : MarketTag) : (marketStepIR tag).length = 4 := by
  cases tag <;> rfl

/-! ## The module is the games -/

/-- Where each NixWars command sits in the module. -/
theorem board_nix_func (tag : Tag) :
    ∃ nm, board[nixTagIndex tag]? = some ⟨nm, 6, 5, compileProg (stepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- Where each Monster Dash command sits in the module. -/
theorem board_dash_func (tag : DashTag) :
    ∃ nm, board[dashTagIndex tag]? = some ⟨nm, 5, 4, compileProg (dashStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- Where each Shard Market command sits in the module. -/
theorem board_market_func (tag : MarketTag) :
    ∃ nm, board[marketTagIndex tag]? = some ⟨nm, 5, 4, compileProg (marketStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- Where each Legend of the Red Shard command sits in the module. -/
theorem board_lord_func (tag : LordTag) :
    ∃ nm, board[lordTagIndex tag]? = some ⟨nm, 6, 5, compileProg (lordStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- Where each Hunt the Wumpus command sits in the module. -/
theorem board_hunt_func (tag : HuntTag) :
    ∃ nm, board[huntTagIndex tag]? = some ⟨nm, 6, 5, compileProg (huntStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- Where each ZX81 command sits in the module. -/
theorem board_zx81_func (tag : TapeTag) :
    ∃ nm, board[tapeTagIndex tag]? = some ⟨nm, 3, 2, compileProg (tapeStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- **The module is NixWars.** Calling the exported function of a command, on
the serialized ship and the command's numeric argument, returns exactly the
serialized successor state — under the 32-bit stack-machine semantics, wrapping
arithmetic included. -/
theorem wasm_step_correct (tag : Tag) (s : Ship) (v : Nat)
    (hs : ∀ x ∈ shipSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (nixTagIndex tag) (v :: shipSerialize s)
      = some (shipSerialize (shipStep s (tag.cmd v))) := by
  obtain ⟨nm, hfn⟩ := board_nix_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_stepIR])
    (shipSerialize s) v rfl hs hv (bnd_stepIR tag)]
  rw [stepIR_correct tag s v]

/-- **The module is Monster Dash**, on the same terms and by the same route. -/
theorem wasm_dash_step_correct (tag : DashTag) (s : Dash) (v : Nat)
    (hs : ∀ x ∈ dashSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (dashTagIndex tag) (v :: dashSerialize s)
      = some (dashSerialize (dashStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_dash_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_dashStepIR])
    (dashSerialize s) v rfl hs hv (bnd_dashStepIR tag)]
  rw [dashStepIR_correct tag s v]

/-- **The module is the Shard Market**, on the same terms and by the same
route. -/
theorem wasm_market_step_correct (tag : MarketTag) (s : Market) (v : Nat)
    (hs : ∀ x ∈ marketSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (marketTagIndex tag) (v :: marketSerialize s)
      = some (marketSerialize (marketStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_market_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_marketStepIR])
    (marketSerialize s) v rfl hs hv (bnd_marketStepIR tag)]
  rw [marketStepIR_correct tag s v]

/-- A free hop in NixWars, on the module. -/
example : callExport board (nixTagIndex .warp) (99 :: shipSerialize initialShip)
    = some (shipSerialize (shipStep initialShip (.warp 99))) :=
  wasm_step_correct .warp initialShip 99 (by decide) (by decide)

/-- A tick in Monster Dash, on the module. -/
example : callExport board (dashTagIndex .tick) (0 :: dashSerialize initialDash)
    = some (dashSerialize (dashStep initialDash .tick)) :=
  wasm_dash_step_correct .tick initialDash 0 (by decide) (by decide)

/-- **The module is Legend of the Red Shard**, on the same terms and by the
same route. -/
theorem wasm_lord_step_correct (tag : LordTag) (s : Hero) (v : Nat)
    (hs : ∀ x ∈ lordSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (lordTagIndex tag) (v :: lordSerialize s)
      = some (lordSerialize (lordStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_lord_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_lordStepIR])
    (lordSerialize s) v rfl hs hv (bnd_lordStepIR tag)]
  rw [lordStepIR_correct tag s v]

/-- **The module is Hunt the Wumpus**, on the same terms and by the same
route. -/
theorem wasm_hunt_step_correct (tag : HuntTag) (s : Hunt) (v : Nat)
    (hs : ∀ x ∈ huntSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (huntTagIndex tag) (v :: huntSerialize s)
      = some (huntSerialize (huntStep s (tag.cmd v))) := by
  obtain ⟨nm, hfn⟩ := board_hunt_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_huntStepIR])
    (huntSerialize s) v rfl hs hv (bnd_huntStepIR tag)]
  rw [huntStepIR_correct tag s v]

/-- **The module is the ZX81 door**, on the same terms and by the same route.
With `machine_step`, that means the shipped WebAssembly advances the emulated
Z80 by exactly one cycle. -/
theorem wasm_zx81_step_correct (tag : TapeTag) (s : Tape) (v : Nat)
    (hs : ∀ x ∈ tapeSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (tapeTagIndex tag) (v :: tapeSerialize s)
      = some (tapeSerialize (tapeStep s (tag.cmd v))) := by
  obtain ⟨nm, hfn⟩ := board_zx81_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_tapeStepIR])
    (tapeSerialize s) v rfl hs hv (bnd_tapeStepIR tag)]
  rw [tapeStepIR_correct tag s v]

/-- Where each FRENS Tournament command sits in the module. -/
theorem board_lobby_func (tag : LobbyTag) :
    ∃ nm, board[lobbyTagIndex tag]? = some ⟨nm, 6, 5, compileProg (lobbyStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- **The module is the FRENS Tournament**, on the same terms and by the same
route: the players read off the branches and the pull requests play inside the
shipped WebAssembly. -/
theorem wasm_lobby_step_correct (tag : LobbyTag) (s : Lobby) (v : Nat)
    (hs : ∀ x ∈ lobbySerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (lobbyTagIndex tag) (v :: lobbySerialize s)
      = some (lobbySerialize (lobbyStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_lobby_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_lobbyStepIR])
    (lobbySerialize s) v rfl hs hv (bnd_lobbyStepIR tag)]
  rw [lobbyStepIR_correct tag s v]

/-- A claim in the FRENS Tournament, on the module. -/
example : callExport board (lobbyTagIndex .claim) (0 :: lobbySerialize freshLobby)
    = some (lobbySerialize (lobbyStep freshLobby .claim)) :=
  wasm_lobby_step_correct .claim freshLobby 0 (by decide) (by decide)

/-- A trade on the Shard Market, on the module. -/
example : callExport board (marketTagIndex .buy) (0 :: marketSerialize initialMarket)
    = some (marketSerialize (marketStep initialMarket .buy)) :=
  wasm_market_step_correct .buy initialMarket 0 (by decide) (by decide)

/-- A blow struck in Legend of the Red Shard, on the module. -/
example : callExport board (lordTagIndex .attack) (0 :: lordSerialize initialHero)
    = some (lordSerialize (lordStep initialHero .attack)) :=
  wasm_lord_step_correct .attack initialHero 0 (by decide) (by decide)

/-- An arrow loosed in Hunt the Wumpus, on the module. -/
example : callExport board (huntTagIndex .shoot) (48 :: huntSerialize initialHunt)
    = some (huntSerialize (huntStep initialHunt (.shoot 48))) :=
  wasm_hunt_step_correct .shoot initialHunt 48 (by decide) (by decide)

/-- One Z80 cycle, on the module. -/
example : callExport board (tapeTagIndex .step) (0 :: tapeSerialize initialTape)
    = some (tapeSerialize (tapeStep initialTape .step)) :=
  wasm_zx81_step_correct .step initialTape 0 (by decide) (by decide)

/-- Where each Combinator Tycoon command sits in the module. -/
theorem board_tycoon_func (tag : TycoonTag) :
    ∃ nm, board[tycoonTagIndex tag]? = some ⟨nm, 6, 5, compileProg (tycoonStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- Where each Meme Breeding Pool command sits in the module. -/
theorem board_meme_func (tag : MemeTag) :
    ∃ nm, board[memeTagIndex tag]? = some ⟨nm, 6, 5, compileProg (memeStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- Where each 8D Hyperspace command sits in the module. -/
theorem board_hyper_func (tag : HyperTag) :
    ∃ nm, board[hyperTagIndex tag]? = some ⟨nm, 9, 8, compileProg (hyperStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- **The module is the Combinator Tycoon**, on the same terms and by the same
route: the hackathon's factory floor runs inside the shipped WebAssembly. -/
theorem wasm_tycoon_step_correct (tag : TycoonTag) (s : Tycoon) (v : Nat)
    (hs : ∀ x ∈ tycoonSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (tycoonTagIndex tag) (v :: tycoonSerialize s)
      = some (tycoonSerialize (tycoonStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_tycoon_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_tycoonStepIR])
    (tycoonSerialize s) v rfl hs hv (bnd_tycoonStepIR tag)]
  rw [tycoonStepIR_correct tag s v]

/-- **The module is the Meme Breeding Pool**, on the same terms and by the same
route. -/
theorem wasm_meme_step_correct (tag : MemeTag) (s : MemePool) (v : Nat)
    (hs : ∀ x ∈ memeSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (memeTagIndex tag) (v :: memeSerialize s)
      = some (memeSerialize (memeStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_meme_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_memeStepIR])
    (memeSerialize s) v rfl hs hv (bnd_memeStepIR tag)]
  rw [memeStepIR_correct tag s v]

/-- **The module is 8D Hyperspace**, on the same terms and by the same route:
the eight-dimensional flight is eight numbers stepped by the shipped
WebAssembly. -/
theorem wasm_hyper_step_correct (tag : HyperTag) (s : Position) (v : Nat)
    (hs : ∀ x ∈ hyperSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (hyperTagIndex tag) (v :: hyperSerialize s)
      = some (hyperSerialize (hyperStep s (tag.cmd v))) := by
  obtain ⟨nm, hfn⟩ := board_hyper_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_hyperStepIR])
    (hyperSerialize s) v rfl hs hv (bnd_hyperStepIR tag)]
  rw [hyperStepIR_correct tag s v]

/-- A second on the factory floor, on the module. -/
example : callExport board (tycoonTagIndex .run) (0 :: tycoonSerialize initialTycoon)
    = some (tycoonSerialize (tycoonStep initialTycoon .run)) :=
  wasm_tycoon_step_correct .run initialTycoon 0 (by decide) (by decide)

/-- A crossover in the breeding pool, on the module. -/
example : callExport board (memeTagIndex .breed) (0 :: memeSerialize initialPool)
    = some (memeSerialize (memeStep initialPool .breed)) :=
  wasm_meme_step_correct .breed initialPool 0 (by decide) (by decide)

/-- Where each Provenance Oracle command sits in the module. -/
theorem board_oracle_func (tag : OracleTag) :
    ∃ nm, board[oracleTagIndex tag]? = some ⟨nm, 5, 4, compileProg (oracleStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- **The module is the Provenance Oracle**, on the same terms and by the same
route: the chain `assembly → C → Scheme → seed` is climbed inside the shipped
WebAssembly. -/
theorem wasm_oracle_step_correct (tag : OracleTag) (s : Provenance) (v : Nat)
    (hs : ∀ x ∈ oracleSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (oracleTagIndex tag) (v :: oracleSerialize s)
      = some (oracleSerialize (oracleStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_oracle_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_oracleStepIR])
    (oracleSerialize s) v rfl hs hv (bnd_oracleStepIR tag)]
  rw [oracleStepIR_correct tag s v]

/-- A step along the fifth axis of hyperspace, on the module. -/
example : callExport board (hyperTagIndex .fwd) (4 :: hyperSerialize origin)
    = some (hyperSerialize (hyperStep origin (.fwd 4))) :=
  wasm_hyper_step_correct .fwd origin 4 (by decide) (by decide)

/-- Where each Assembly command sits in the module. -/
theorem board_vote_func (tag : VoteTag) :
    ∃ nm, board[voteTagIndex tag]? = some ⟨nm, 5, 4, compileProg (ballotStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- **The module is the Assembly**, on the same terms and by the same route: the
community vote of the 23-node network is counted inside the shipped
WebAssembly. -/
theorem wasm_vote_step_correct (tag : VoteTag) (s : Ballot) (v : Nat)
    (hs : ∀ x ∈ ballotSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (voteTagIndex tag) (v :: ballotSerialize s)
      = some (ballotSerialize (ballotStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_vote_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_ballotStepIR])
    (ballotSerialize s) v rfl hs hv (bnd_ballotStepIR tag)]
  rw [ballotStepIR_correct tag s v]

/-- A witness at the assembly layer, on the module. -/
example : callExport board (oracleTagIndex .witness) (0 :: oracleSerialize initialProvenance)
    = some (oracleSerialize (oracleStep initialProvenance .witness)) :=
  wasm_oracle_step_correct .witness initialProvenance 0 (by decide) (by decide)

/-- A node voting for the proposal, on the module. -/
example : callExport board (voteTagIndex .aye) (0 :: ballotSerialize initialBallot)
    = some (ballotSerialize (ballotStep initialBallot .aye)) :=
  wasm_vote_step_correct .aye initialBallot 0 (by decide) (by decide)

/-! ## The two cabinets of the arcade room -/

/-- Under the operating bound nothing in the Monster Cubes table can overflow:
every entry is a field, a literal or a comparison of two of them. -/
theorem bnd_qbertStepIR (tag : QbertTag) : ∀ e ∈ qbertStepIR tag, e.bnd B < W := by
  cases tag <;>
    simp [qbertStepIR, qbertProg, condEqIR, pairEqIR, andIR, eqIR, ltIR, Expr.bnd, B, W]

theorem length_qbertStepIR (tag : QbertTag) : (qbertStepIR tag).length = 13 := by
  cases tag <;> rfl

/-- Under the operating bound nothing in the Frontier Run table can overflow:
the widest term is a coordinate plus the throttle, and `2 * B` still fits. -/
theorem bnd_frontierStepIR (tag : FrontierTag) : ∀ e ∈ frontierStepIR tag, e.bnd B < W := by
  cases tag <;>
    simp [frontierStepIR, frontierAxisIR, frontierUpIR, frontierDownIR, frontierFlyOkIR,
      frontierAtStationIR, andIR, eqIR, ltIR, Expr.bnd, B, W]

theorem bnd_invadersStepIR (tag : InvadersTag) : ∀ e ∈ invadersStepIR tag, e.bnd B < W := by
  cases tag <;>
    simp [invadersStepIR, invGuard, invKill, invLandedIR, invRightIR, invRoomRightIR,
      invRoomLeftIR, eqIR, ltIR, Expr.bnd, B, W]

theorem length_invadersStepIR (tag : InvadersTag) : (invadersStepIR tag).length = 10 := by
  cases tag <;> rfl

theorem length_frontierStepIR (tag : FrontierTag) : (frontierStepIR tag).length = 8 := by
  cases tag <;> rfl

/-- Where each Monster Cubes command sits in the module. -/
theorem board_qbert_func (tag : QbertTag) :
    ∃ nm, board[qbertTagIndex tag]? = some ⟨nm, 14, 13, compileProg (qbertStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- Where each Frontier Run command sits in the module. -/
theorem board_frontier_func (tag : FrontierTag) :
    ∃ nm, board[frontierTagIndex tag]? = some ⟨nm, 9, 8, compileProg (frontierStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- **The module is Monster Cubes**, on the same terms and by the same route:
the Q*bert cabinet in the arcade room is stepped by the shipped WebAssembly. -/
theorem wasm_qbert_step_correct (tag : QbertTag) (s : Qbert) (v : Nat)
    (hs : ∀ x ∈ qbertSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (qbertTagIndex tag) (v :: qbertSerialize s)
      = some (qbertSerialize (qbertStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_qbert_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_qbertStepIR])
    (qbertSerialize s) v rfl hs hv (bnd_qbertStepIR tag)]
  rw [qbertStepIR_correct tag s v]

/-- **The module is the Frontier Run**, on the same terms and by the same
route: the 3D flight is eight numbers stepped by the shipped WebAssembly. -/
theorem wasm_frontier_step_correct (tag : FrontierTag) (s : Frontier) (v : Nat)
    (hs : ∀ x ∈ frontierSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (frontierTagIndex tag) (v :: frontierSerialize s)
      = some (frontierSerialize (frontierStep s (tag.cmd v))) := by
  obtain ⟨nm, hfn⟩ := board_frontier_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_frontierStepIR])
    (frontierSerialize s) v rfl hs hv (bnd_frontierStepIR tag)]
  rw [frontierStepIR_correct tag s v]

/-- Where each Shard Invaders command sits in the module. -/
theorem board_invaders_func (tag : InvadersTag) :
    ∃ nm, board[invadersTagIndex tag]? = some ⟨nm, 11, 10, compileProg (invadersStepIR tag)⟩ := by
  cases tag <;> exact ⟨_, rfl⟩

/-- **The module is Shard Invaders**, on the same terms and by the same route:
the second cabinet of the arcade room is stepped by the shipped WebAssembly. -/
theorem wasm_invaders_step_correct (tag : InvadersTag) (s : Invaders) (v : Nat)
    (hs : ∀ x ∈ invadersSerialize s, x ≤ B) (hv : v ≤ B) :
    callExport board (invadersTagIndex tag) (v :: invadersSerialize s)
      = some (invadersSerialize (invadersStep s tag.cmd)) := by
  obtain ⟨nm, hfn⟩ := board_invaders_func tag
  rw [callExport_runIR board_hasHelpers hfn rfl (by simp [length_invadersStepIR])
    (invadersSerialize s) v rfl hs hv (bnd_invadersStepIR tag)]
  rw [invadersStepIR_correct tag s v]

/-- A shot from the gun, on the module. -/
example : callExport board (invadersTagIndex .fire) (0 :: invadersSerialize initialInvaders)
    = some (invadersSerialize (invadersStep initialInvaders .fire)) :=
  wasm_invaders_step_correct .fire initialInvaders 0 (by decide) (by decide)

/-- A hop down the pyramid, on the module. -/
example : callExport board (qbertTagIndex .dl) (0 :: qbertSerialize initialQbert)
    = some (qbertSerialize (qbertStep initialQbert .dl)) :=
  wasm_qbert_step_correct .dl initialQbert 0 (by decide) (by decide)

/-- A hop of the 3D flight, on the module. -/
example : callExport board (frontierTagIndex .fly) (0 :: frontierSerialize initialFrontier)
    = some (frontierSerialize (frontierStep initialFrontier .fly)) :=
  wasm_frontier_step_correct .fly initialFrontier 0 (by decide) (by decide)

end Wasm
end NixWars
