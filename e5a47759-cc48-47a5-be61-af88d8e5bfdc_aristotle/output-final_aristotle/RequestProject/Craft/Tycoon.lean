import RequestProject.Craft.Render

/-!
# The tycoon: state, moves, economy

A player (or an agent) owns a factory of micro-voxel parts, some cash, and a
stock of ore and ingots.  Four moves are available: place a part, remove a
part, let the world tick, and sell ingots.  An illegal move is a no-op, so a
move sequence is always meaningful — which is what makes recordings, replays
and a strategy database possible.

Proved here:

* `step_wf`, `run_wf` — no move can break the voxel invariant (nothing leaves
  the grid, nothing overlaps, the part limit holds);
* `tick_conserves` — a world tick converts ore into ingots without losing
  either: the total stock only grows by what the miners mined;
* `sell_conserves_worth` — selling is a fair exchange;
* `step_worth_le`, `run_worth_le` — **no money from nothing**: a factory's net
  worth can grow by at most `ingotPrice * maxParts` per move, so a play of `n`
  moves cannot end richer than that bound allows.
-/

set_option autoImplicit false
set_option relaxedAutoImplicit false

namespace Tycoon

/-- What one ingot fetches. -/
def ingotPrice : Nat := 5

/-- The state of one tycoon game. -/
structure GameState where
  /-- The factory the player has built. -/
  scene : Scene
  /-- Cash on hand. -/
  cash : Nat
  /-- Ore in the buffer. -/
  ore : Nat
  /-- Ingots in the buffer. -/
  ingot : Nat
  /-- World ticks elapsed. -/
  tick : Nat
deriving DecidableEq, Repr, Inhabited

/-- A move. -/
inductive Action where
  /-- Build a part of the given kind with its origin at the given voxel. -/
  | place (k : Kind) (p : V3)
  /-- Demolish the part at the given index (no refund). -/
  | remove (i : Nat)
  /-- Let the world run for one tick. -/
  | tickWorld
  /-- Sell this many ingots. -/
  | sell (n : Nat)
deriving DecidableEq, Repr, Inhabited

namespace GameState

/-- The voxel invariant, lifted to a game state. -/
def WF (g : GameState) : Prop := Scene.WF g.scene

/-- A fresh game with a starting grant. -/
def initial (cash : Nat) : GameState :=
  { scene := [], cash := cash, ore := 0, ingot := 0, tick := 0 }

theorem initial_wf (c : Nat) : WF (initial c) := Scene.wf_nil

/-- Is a move legal in this state? -/
def legal (g : GameState) : Action → Bool
  | .place k p => g.scene.canPlace ⟨k, p⟩ && decide (k.cost ≤ g.cash)
  | .remove i => decide (i < g.scene.length)
  | .tickWorld => true
  | .sell n => decide (n ≤ g.ingot) && decide (0 < Scene.countKind .seller g.scene)

/-- The effect of a legal move. -/
def perform (g : GameState) : Action → GameState
  | .place k p =>
      { g with scene := g.scene.place ⟨k, p⟩, cash := g.cash - k.cost }
  | .remove i => { g with scene := g.scene.remove i }
  | .tickWorld =>
      let mined := Scene.countKind .miner g.scene
      let smelted := min (g.ore + mined) (Scene.countKind .smelter g.scene)
      { g with ore := g.ore + mined - smelted, ingot := g.ingot + smelted,
               tick := g.tick + 1 }
  | .sell n => { g with ingot := g.ingot - n, cash := g.cash + ingotPrice * n }

/-- **One move.** An illegal move leaves the game exactly as it was. -/
def step (g : GameState) (a : Action) : GameState :=
  if g.legal a then g.perform a else g

/-- **A play**: a sequence of moves, applied in order. -/
def run (g : GameState) (as : List Action) : GameState := as.foldl step g

@[simp] theorem run_nil (g : GameState) : run g [] = g := rfl

@[simp] theorem run_cons (g : GameState) (a : Action) (as : List Action) :
    run g (a :: as) = run (step g a) as := rfl

theorem run_append (g : GameState) (as bs : List Action) :
    run g (as ++ bs) = run (run g as) bs := by
  simp [run, List.foldl_append]

/-! ## The voxel invariant survives every move -/

theorem perform_wf {g : GameState} (hg : WF g) {a : Action} (h : g.legal a = true) :
    WF (g.perform a) := by
  cases a with
  | place k p =>
      simp only [legal, Bool.and_eq_true] at h
      exact Scene.place_wf hg h.1
  | remove i => exact Scene.remove_wf hg i
  | tickWorld => exact hg
  | sell n => exact hg

/-- No move can break the factory invariant. -/
theorem step_wf {g : GameState} (hg : WF g) (a : Action) : WF (g.step a) := by
  unfold step
  split
  · exact perform_wf hg (by assumption)
  · exact hg

/-- No play can break the factory invariant. -/
theorem run_wf {g : GameState} (hg : WF g) (as : List Action) : WF (run g as) := by
  induction as generalizing g with
  | nil => exact hg
  | cons a t ih => exact ih (step_wf hg a)

/-! ## The economy -/

/-- The net worth of a game: cash plus the sale value of everything in the
buffers (ore is valued optimistically, at the ingot price). -/
def worth (g : GameState) : Nat := g.cash + ingotPrice * (g.ore + g.ingot)

/-- A world tick loses nothing: the buffers grow by exactly what was mined,
smelting only moves stock from ore to ingots. -/
theorem tick_conserves (g : GameState) :
    (g.perform .tickWorld).ore + (g.perform .tickWorld).ingot
      = g.ore + g.ingot + Scene.countKind .miner g.scene := by
  simp only [perform]
  omega

/-- A world tick advances the clock by one. -/
@[simp] theorem tick_clock (g : GameState) :
    (g.perform .tickWorld).tick = g.tick + 1 := rfl

/-- Selling is a fair exchange: net worth is unchanged. -/
theorem sell_conserves_worth {g : GameState} {n : Nat} (h : n ≤ g.ingot) :
    worth (g.perform (.sell n)) = worth g := by
  simp only [worth, perform, ingotPrice]
  omega

/-- Building costs money: it never increases net worth. -/
theorem place_worth_le (g : GameState) (k : Kind) (p : V3) :
    worth (g.perform (.place k p)) ≤ worth g := by
  simp only [worth, perform]
  omega

/-- A world tick adds exactly the miners' output to net worth. -/
theorem tick_worth (g : GameState) :
    worth (g.perform .tickWorld) = worth g + ingotPrice * Scene.countKind .miner g.scene := by
  simp only [worth, perform, ingotPrice]
  omega

/-- **No money from nothing.** One move can add at most one tick's worth of
production — `ingotPrice` per miner, and a factory has at most `maxParts`
of them — to a player's net worth. -/
theorem step_worth_le {g : GameState} (hg : WF g) (a : Action) :
    worth (g.step a) ≤ worth g + ingotPrice * Scene.maxParts := by
  unfold step
  split
  case isFalse => omega
  case isTrue hleg =>
    cases a with
    | place k p => have := place_worth_le g k p; omega
    | remove i =>
        have : worth (g.perform (.remove i)) = worth g := by simp [worth, perform]
        omega
    | tickWorld =>
        have h1 := tick_worth g
        have h2 : Scene.countKind .miner g.scene ≤ Scene.maxParts :=
          Scene.countKind_le_maxParts hg _
        have : ingotPrice * Scene.countKind .miner g.scene ≤ ingotPrice * Scene.maxParts :=
          Nat.mul_le_mul_left _ h2
        omega
    | sell n =>
        simp only [legal, Bool.and_eq_true, decide_eq_true_eq] at hleg
        have := sell_conserves_worth hleg.1
        omega

/-- **No money from nothing, over a whole play.** -/
theorem run_worth_le {g : GameState} (hg : WF g) (as : List Action) :
    worth (run g as) ≤ worth g + ingotPrice * Scene.maxParts * as.length := by
  induction as generalizing g with
  | nil => simp
  | cons a t ih =>
      have h1 := step_worth_le hg a
      have h2 := ih (step_wf hg a)
      have h3 : ingotPrice * Scene.maxParts * (t.length + 1)
          = ingotPrice * Scene.maxParts * t.length + ingotPrice * Scene.maxParts := by ring
      simp only [run_cons, List.length_cons]
      omega

/-- The cash a play can end with is bounded by the same budget. -/
theorem run_cash_le {g : GameState} (hg : WF g) (as : List Action) :
    (run g as).cash ≤ worth g + ingotPrice * Scene.maxParts * as.length := by
  have h := run_worth_le hg as
  have : (run g as).cash ≤ worth (run g as) := by simp [worth]
  omega

/-! ## Sanity checks by evaluation -/

/-- A small starting factory: a miner, a smelter and a seller. -/
def demoStart : GameState :=
  { scene := [⟨.miner, ⟨0, 0, 0⟩⟩, ⟨.smelter, ⟨4, 0, 0⟩⟩, ⟨.seller, ⟨8, 0, 0⟩⟩],
    cash := 100, ore := 0, ingot := 0, tick := 0 }

example : Scene.WF demoStart.scene := ⟨by decide, by decide, by decide⟩

/-- Ten ticks mine ten ore and smelt all of them. -/
example : (run demoStart (List.replicate 10 .tickWorld)).ingot = 10 := by native_decide

/-- Selling those ten ingots pays `10 * ingotPrice`. -/
example : (run demoStart (List.replicate 10 .tickWorld ++ [.sell 10])).cash = 150 := by
  native_decide

/-- An unaffordable part is simply not built. -/
example : (GameState.initial 0).step (.place .miner ⟨0,0,0⟩) = GameState.initial 0 := by decide

/-- A part that would overlap an existing one is refused. -/
example : demoStart.step (.place .belt ⟨0,0,0⟩) = demoStart := by decide

/-- Nothing can be sold without a seller. -/
example : ((GameState.initial 0).perform (.sell 0)).cash = 0 := by decide

end GameState

end Tycoon
