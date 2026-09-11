import RequestProject.Craft.Replay

/-!
# Agents

An **agent** is a policy: a function from a position to the move it wants to
play.  A human player produces the same thing, one move at a time, so agents
and players are interchangeable — `simulate` runs an agent for `n` moves, and
`recordOf` packages that run as an ordinary `Recording`, indistinguishable from
a recording of a human game.

Proved here:

* `simulate_eq_run` — simulating an agent is the same as replaying the list of
  moves it chose, so `recordOf_final`: **an agent's game replays exactly**;
* `simulate_wf` — an agent cannot break the voxel invariant either;
* `simulate_worth_le` — an agent is bound by the same economy: no policy, however
  clever, beats the `no money from nothing` bound;
* two example agents, and `builder_beats_idler`: the building agent really does
  finish richer than the idle one on a concrete game (checked by evaluation).
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-- An agent: it looks at the position and names its move. -/
abbrev Policy := GameState → Action

namespace Policy

/-- The moves an agent plays in its first `n` turns from a position. -/
def actionsOf (pol : Policy) (g : GameState) : Nat → List Action
  | 0 => []
  | n + 1 => pol g :: actionsOf pol (g.step (pol g)) n

/-- Running an agent for `n` turns. -/
def simulate (pol : Policy) (g : GameState) : Nat → GameState
  | 0 => g
  | n + 1 => simulate pol (g.step (pol g)) n

@[simp] theorem actionsOf_length (pol : Policy) (g : GameState) (n : Nat) :
    (actionsOf pol g n).length = n := by
  induction n generalizing g with
  | zero => rfl
  | succ m ih => simp [actionsOf, ih]

/-- **An agent's game is an ordinary game.** Simulating the agent gives the
same position as replaying the moves it chose. -/
theorem simulate_eq_run (pol : Policy) (g : GameState) (n : Nat) :
    simulate pol g n = GameState.run g (actionsOf pol g n) := by
  induction n generalizing g with
  | zero => rfl
  | succ m ih => simp [simulate, actionsOf, ih]

/-- The recording of an agent playing `n` turns. -/
def recordOf (pol : Policy) (g : GameState) (n : Nat) : Recording :=
  { init := g, moves := actionsOf pol g n }

/-- **Record and replay an agent**: replaying its recording lands on exactly the
position the simulation reached. -/
theorem recordOf_final (pol : Policy) (g : GameState) (n : Nat) :
    (recordOf pol g n).final = simulate pol g n :=
  (simulate_eq_run pol g n).symm

@[simp] theorem recordOf_length (pol : Policy) (g : GameState) (n : Nat) :
    (recordOf pol g n).moves.length = n := by
  simp [recordOf]

/-- An agent cannot break the voxel invariant. -/
theorem simulate_wf {pol : Policy} {g : GameState} (hg : g.WF) (n : Nat) :
    (simulate pol g n).WF := by
  rw [simulate_eq_run]
  exact GameState.run_wf hg _

/-- An agent is bound by the same economy as a player. -/
theorem simulate_worth_le {pol : Policy} {g : GameState} (hg : g.WF) (n : Nat) :
    GameState.worth (simulate pol g n)
      ≤ GameState.worth g + ingotPrice * Scene.maxParts * n := by
  rw [simulate_eq_run]
  have := GameState.run_worth_le hg (actionsOf pol g n)
  simpa using this

end Policy

/-! ## Two example agents -/

/-- The grid positions the example agents build on: a 2-spaced floor lattice. -/
def buildSpots : List V3 :=
  (List.range 8).flatMap (fun i => (List.range 8).map (fun j => V3.mk (2 * i) 0 (2 * j)))

/-- The first lattice position where a part of this kind would fit. -/
def freeSpot (g : GameState) (k : Kind) : Option V3 :=
  buildSpots.find? (fun p => g.scene.canPlace ⟨k, p⟩)

/-- Build there if there is room, otherwise just let the world tick. -/
def placeOr (g : GameState) (k : Kind) : Action :=
  match freeSpot g k with
  | some p => .place k p
  | none => .tickWorld

/-- The idle agent: it never builds, it only watches the clock. -/
def idleBot : Policy := fun _ => .tickWorld

/-- A simple tycoon agent: buy a seller first, then grow the factory up to six
mining lines, keeping smelters in step with miners, and cash out whenever ten
ingots have piled up. -/
def buildBot : Policy := fun g =>
  if Scene.countKind .seller g.scene = 0 then
    (if 50 ≤ g.cash then placeOr g .seller else .tickWorld)
  else if 10 ≤ g.ingot then .sell g.ingot
  else if Scene.countKind .smelter g.scene < Scene.countKind .miner g.scene then
    (if 35 ≤ g.cash then placeOr g .smelter else .tickWorld)
  else if Scene.countKind .miner g.scene < 6 then
    (if 20 ≤ g.cash then placeOr g .miner else .tickWorld)
  else .tickWorld

/-- A more cautious agent: it builds the smallest workable shop — one seller,
one miner, one smelter — and never reinvests. -/
def frugalBot : Policy := fun g =>
  if Scene.countKind .seller g.scene = 0 then
    (if 50 ≤ g.cash then placeOr g .seller else .tickWorld)
  else if 10 ≤ g.ingot then .sell g.ingot
  else if Scene.countKind .miner g.scene = 0 then
    (if 20 ≤ g.cash then placeOr g .miner else .tickWorld)
  else if Scene.countKind .smelter g.scene = 0 then
    (if 35 ≤ g.cash then placeOr g .smelter else .tickWorld)
  else .tickWorld

/-- The position both example agents start from. -/
def startPos : GameState := GameState.initial 150

theorem startPos_wf : startPos.WF := GameState.initial_wf 150

/-- The idle agent earns nothing. -/
theorem idler_earns_nothing :
    (Policy.simulate idleBot startPos 120).cash = 150 := by native_decide

/-- **The building agent really does play better**, on a 120-move game from the
standard start. -/
theorem builder_beats_idler :
    (Policy.simulate idleBot startPos 120).cash
      < (Policy.simulate buildBot startPos 120).cash := by native_decide

/-- The two building agents differ, so there is something to learn: reinvesting
finishes far ahead of the minimal shop. -/
theorem builder_beats_frugal :
    (Policy.simulate frugalBot startPos 120).cash
      < (Policy.simulate buildBot startPos 120).cash := by native_decide

/-- Both agents stay inside the rules. -/
theorem builder_wf : (Policy.simulate buildBot startPos 120).WF :=
  Policy.simulate_wf startPos_wf 120

end Tycoon
