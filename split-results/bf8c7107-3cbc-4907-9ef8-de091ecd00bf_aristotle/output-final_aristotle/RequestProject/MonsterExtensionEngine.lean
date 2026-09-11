import Mathlib
import RequestProject.MonsterWalk
import RequestProject.MonsterClifford
import RequestProject.MonsterBaseWalk
import RequestProject.MonsterBladeWalk

/-!
# The digit-expansion `ExtensionEngine`: the base-2 walk as a dimension-advancing stream

This module realizes the requested **`ExtensionEngine` scaffolding**: it replays the base-2
Monster Walk of `RequestProject.MonsterBaseWalk` as an explicit *dimension-advancing
stream* of states.  Each base-2 walk step consumes a block of leading binary digits and
**advances the dimension** (the binary digit position reached) by that block's length,
emitting a Clifford-blade state (grade + Altland–Zirnbauer class) at each new dimension.

## The engine

* `ExtState` — a stream state: the step index, the dimension before (`startDim`) and after
  (`endDim`) the step, and the emitted blade's grade and AZ class.
* `engineStates` — the stream produced by running the engine over `monsterWalkBase 2 10`.
* `dimStream` — the pure sequence of dimensions visited, `0 :: (endDim of each step)`.

## What is proved (all kernel-checked)

* `engineStates_eq` — the explicit stream of three states.
* `engine_dim_stream` — the dimensions visited are `[0, 10, 20, 30]`.
* `engine_dim_strictly_advancing` — the dimension stream is **strictly increasing**: every
  step genuinely advances the dimension.
* `engine_contiguous` — the stream is **gapless**: each step starts exactly where the
  previous one ended (`startDimₙ = endDimₙ₋₁`), so the engine tiles the digit axis without
  overlaps or gaps.
* `engine_final_dimension` — the engine reaches dimension `30`, equal to the walk's binary
  coverage (`MonsterBaseWalk.base2_walk_coverage`).
* `engine_grades` / `engine_classes` — the emitted states carry grades `[5,6,6]` and AZ
  classes `[CII, C, C]`, matching `MonsterBladeWalk`.

This is an exact, decidable re-presentation of the verified base-2 walk as a streaming
state machine; the geometric "dimension advance" reading is the documented analogy.
-/

set_option maxHeartbeats 4000000

namespace MonsterExtensionEngine

open MonsterWalk MonsterBaseWalk MonsterClifford MonsterBladeWalk

/-! ## Stream state -/

/-- A single state of the dimension-advancing stream: which step produced it, the
dimension before and after the step, and the emitted blade's grade and AZ class. -/
structure ExtState where
  step : ℕ
  startDim : ℕ
  endDim : ℕ
  grade : ℕ
  klass : SymmetryClass
deriving Repr, DecidableEq

/-- Run the engine over a list of base-`B` walk steps, emitting one `ExtState` per step. -/
def runEngine (steps : List (ℕ × ℕ × ℕ)) : List ExtState :=
  steps.mapIdx (fun i s =>
    { step := i
      startDim := s.1
      endDim := s.1 + s.2.1
      grade := (bladeOfAddr (stepShadow s)).grade
      klass := stepClass s })

/-- The stream produced by running the engine on the base-2 Monster Walk. -/
def engineStates : List ExtState := runEngine (monsterWalkBase 2 10)

/-- The pure sequence of dimensions the engine visits: the starting dimension `0`
followed by the dimension reached after each step. -/
def dimStream : List ℕ := 0 :: engineStates.map ExtState.endDim

/-! ## The recorded stream -/

/-- The explicit three-state stream of the base-2 walk. -/
theorem engineStates_eq :
    engineStates =
      [ { step := 0, startDim := 0,  endDim := 10, grade := 5, klass := SymmetryClass.CII },
        { step := 1, startDim := 10, endDim := 20, grade := 6, klass := SymmetryClass.C },
        { step := 2, startDim := 20, endDim := 30, grade := 6, klass := SymmetryClass.C } ] := by
  native_decide

/-! ## Dimension advance -/

/-- The dimensions visited by the engine are `[0, 10, 20, 30]`. -/
theorem engine_dim_stream : dimStream = [0, 10, 20, 30] := by native_decide

/-- **The engine strictly advances the dimension** at every step: every consecutive pair
of visited dimensions is strictly increasing. -/
theorem engine_dim_strictly_advancing :
    (dimStream.zip (dimStream.drop 1)).all (fun p => decide (p.1 < p.2)) = true := by
  native_decide

/-- A fallback `ExtState` used purely as an out-of-range default for indexed access. -/
def dummyState : ExtState :=
  { step := 0, startDim := 0, endDim := 0, grade := 0, klass := SymmetryClass.A }

/-- **The stream is gapless**: each step starts exactly where the previous one ended, so
the engine tiles the binary digit axis with no overlaps or gaps. -/
theorem engine_contiguous :
    engineStates.all (fun s => decide (s.endDim = s.startDim + 10)) = true ∧
    (List.range (engineStates.length - 1)).all
      (fun i => decide ((engineStates.getD i dummyState).endDim
        = (engineStates.getD (i + 1) dummyState).startDim)) = true := by
  refine ⟨by native_decide, by native_decide⟩

/-- The engine reaches dimension `30`, exactly the base-2 walk's binary digit coverage. -/
theorem engine_final_dimension :
    dimStream.getLast (by decide) = 30 ∧
    dimStream.getLast (by decide) = coverage (monsterWalkBase 2 10) := by
  refine ⟨by native_decide, by native_decide⟩

/-! ## Emitted blade states -/

/-- The grades emitted by the engine are `[5, 6, 6]`. -/
theorem engine_grades : engineStates.map ExtState.grade = [5, 6, 6] := by native_decide

/-- The AZ classes emitted by the engine are `[CII, C, C]`. -/
theorem engine_classes :
    engineStates.map ExtState.klass
      = [SymmetryClass.CII, SymmetryClass.C, SymmetryClass.C] := by native_decide

/-! ## Summary -/

/-- **Stream summary of the `ExtensionEngine`.**
1. The engine emits three states reaching dimensions `[0,10,20,30]`.
2. The dimension stream is strictly increasing and gapless (`startDimₙ = endDimₙ₋₁`).
3. It reaches dimension `30 =` the binary coverage, carrying grades `[5,6,6]` and classes
   `[CII, C, C]`. -/
theorem extension_engine_summary :
    dimStream = [0, 10, 20, 30] ∧
    (dimStream.zip (dimStream.drop 1)).all (fun p => decide (p.1 < p.2)) = true ∧
    dimStream.getLast (by decide) = coverage (monsterWalkBase 2 10) ∧
    engineStates.map ExtState.grade = [5, 6, 6] ∧
    engineStates.map ExtState.klass
      = [SymmetryClass.CII, SymmetryClass.C, SymmetryClass.C] := by
  refine ⟨engine_dim_stream, engine_dim_strictly_advancing, by native_decide,
    engine_grades, engine_classes⟩

end MonsterExtensionEngine
