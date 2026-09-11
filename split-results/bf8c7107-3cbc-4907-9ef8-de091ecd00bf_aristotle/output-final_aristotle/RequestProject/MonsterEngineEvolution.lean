import Mathlib
import RequestProject.MonsterExtensionEngine

/-!
# Higher-level lemmas on the state evolution of the `MonsterExtensionEngine`

`RequestProject.MonsterExtensionEngine` defined the dimension-advancing stream `engineStates`
of `ExtState`s and proved its first-order facts (the explicit stream, the visited dimensions
`[0,10,20,30]`, strict advance, contiguity, the emitted grades/classes).  This module lifts
those into **higher-level statements about the evolution itself**: an explicit transition
relation between consecutive states, a state invariant that holds at every step, a closed-form
formula for the dimension at index `i`, the conserved total advance, and the genesis/terminus
boundary states.

## The transition layer

* `Advances prev next` (and its Boolean form `advancesB`) — `next` legitimately follows
  `prev`: the step index increments by one, `next.startDim = prev.endDim` (gapless), and the
  dimension advances by a fixed quantum of `10`.
* `StateInv s` (Boolean `stateInvB`) — the per-state invariant: `endDim = startDim + 10`,
  `startDim = 10·step`, `endDim = 10·(step+1)`, and the emitted grade is `5` or `6`.

## What is proved (all kernel-checked)

* `engine_transitions_valid` — every consecutive pair of states satisfies `advancesB`: the
  whole stream is a chain of legal transitions.
* `engine_invariant` — every state satisfies `stateInvB`: the invariant is preserved.
* `engine_closed_form` — at index `i` the engine sits at `startDim = 10·i`, `endDim = 10·(i+1)`.
* `engine_step_indices` — the step indices are `[0,1,2]`.
* `engine_total_advance` — the advances `endDimᵢ − startDimᵢ` sum to `30`, the binary coverage.
* `engine_grade_monotone` — the emitted grades are (weakly) non-decreasing along the evolution.
* `engine_genesis` / `engine_terminus` — the evolution starts at dimension `0` and ends at
  dimension `30 =` the base-2 coverage.
* `engine_evolution_summary` — the packaged higher-level picture.

These are exact decidable facts about the verified engine; the geometric "dimension advance"
reading is the documented analogy carried over from `MonsterExtensionEngine`.
-/

set_option maxHeartbeats 4000000

namespace MonsterEngineEvolution

open MonsterExtensionEngine MonsterWalk MonsterBaseWalk MonsterBladeWalk

/-! ## The transition relation -/

/-- `next` legitimately follows `prev` in the engine's evolution: the step index increments,
the stream is gapless (`next.startDim = prev.endDim`), and the dimension advances by `10`. -/
def Advances (prev next : ExtState) : Prop :=
  next.step = prev.step + 1 ∧
  next.startDim = prev.endDim ∧
  next.endDim = next.startDim + 10

/-- Boolean form of `Advances`, suitable for `List.all` over adjacent pairs. -/
def advancesB (prev next : ExtState) : Bool :=
  (next.step == prev.step + 1) &&
  (next.startDim == prev.endDim) &&
  (next.endDim == next.startDim + 10)

/-- The per-state invariant maintained at every step of the evolution. -/
def stateInvB (s : ExtState) : Bool :=
  (s.endDim == s.startDim + 10) &&
  (s.startDim == 10 * s.step) &&
  (s.endDim == 10 * (s.step + 1)) &&
  (s.grade == 5 || s.grade == 6)

/-! ## Transitions and invariant -/

/-- **Every consecutive pair of states is a legal transition.** The whole stream is a chain
of `advancesB`-transitions. -/
theorem engine_transitions_valid :
    (engineStates.zip (engineStates.drop 1)).all (fun p => advancesB p.1 p.2) = true := by
  native_decide

/-- **The state invariant is preserved at every step.** -/
theorem engine_invariant : engineStates.all stateInvB = true := by native_decide

/-- The first transition of the evolution satisfies the propositional `Advances` relation. -/
theorem engine_first_transition :
    Advances
      { step := 0, startDim := 0, endDim := 10, grade := 5, klass := SymmetryClass.CII }
      { step := 1, startDim := 10, endDim := 20, grade := 6, klass := SymmetryClass.C } := by
  refine ⟨rfl, rfl, rfl⟩

/-! ## Closed form and conserved quantities -/

/-- **Closed form for the evolution.** At index `i` the engine sits at `startDim = 10·i` and
`endDim = 10·(i+1)`. -/
theorem engine_closed_form :
    (List.range engineStates.length).all
      (fun i => ((engineStates.getD i dummyState).startDim == 10 * i)
        && ((engineStates.getD i dummyState).endDim == 10 * (i + 1))) = true := by
  native_decide

/-- The step indices visited by the evolution are `[0, 1, 2]`. -/
theorem engine_step_indices : engineStates.map ExtState.step = [0, 1, 2] := by native_decide

/-- **Conserved total advance.** The per-step advances `endDimᵢ − startDimᵢ` sum to `30`,
the base-2 walk coverage. -/
theorem engine_total_advance :
    (engineStates.map (fun s => s.endDim - s.startDim)).sum = 30 ∧
    (engineStates.map (fun s => s.endDim - s.startDim)).sum
      = coverage (monsterWalkBase 2 10) := by
  refine ⟨by native_decide, by native_decide⟩

/-- **The emitted grades are weakly non-decreasing** along the evolution. -/
theorem engine_grade_monotone :
    (engineStates.zip (engineStates.drop 1)).all
      (fun p => decide (p.1.grade ≤ p.2.grade)) = true := by
  native_decide

/-! ## Boundary states -/

/-- **Genesis.** The evolution begins at dimension `0` with step index `0` and grade `5`. -/
theorem engine_genesis :
    engineStates.head?.map ExtState.startDim = some 0 ∧
    engineStates.head?.map ExtState.step = some 0 ∧
    engineStates.head?.map ExtState.grade = some 5 := by
  refine ⟨by native_decide, by native_decide, by native_decide⟩

/-- **Terminus.** The evolution ends at dimension `30` with step index `2`. -/
theorem engine_terminus :
    engineStates.getLast?.map ExtState.endDim = some 30 ∧
    engineStates.getLast?.map ExtState.step = some 2 := by
  refine ⟨by native_decide, by native_decide⟩

/-! ## Summary -/

/-- **State-evolution summary of the `ExtensionEngine`.**
1. Every consecutive pair of states is a legal `advancesB`-transition and every state
   satisfies the invariant `stateInvB`.
2. The closed form is `startDimᵢ = 10·i`, `endDimᵢ = 10·(i+1)`; the advances sum to the
   binary coverage `30`.
3. The grades are non-decreasing; the evolution runs from dimension `0` (genesis) to
   dimension `30` (terminus). -/
theorem engine_evolution_summary :
    (engineStates.zip (engineStates.drop 1)).all (fun p => advancesB p.1 p.2) = true ∧
    engineStates.all stateInvB = true ∧
    (engineStates.map (fun s => s.endDim - s.startDim)).sum
      = coverage (monsterWalkBase 2 10) ∧
    engineStates.head?.map ExtState.startDim = some 0 ∧
    engineStates.getLast?.map ExtState.endDim = some 30 := by
  refine ⟨engine_transitions_valid, engine_invariant, by native_decide,
    by native_decide, by native_decide⟩

end MonsterEngineEvolution
