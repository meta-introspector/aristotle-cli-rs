/-
# The 10d Superstring and the Dimensional Descent `10 → 4`

This file continues the dimensional ladder of `BosonicStringDescent` one stage
*lower*: from the **10-dimensional critical superstring** down to the observed
**4-dimensional spacetime**, reusing the *same* `DimWalker` / `compactify`
framework.  It connects the bosonic layer (`26 → 4`) to the 4d minicharged /
PTE physics already glued in `MinichargedGlue`.

## What this file does

1. **§1.** Records the critical superstring data (central charge `10`, the `8`
   transverse / light-cone dimensions, and the residual `2` longitudinal+ghost
   dimensions), with the proved split `10 = 8 + 2`.
2. **§2.** Reuses the `BosonicStringDescent.DimWalker` carrying the *fixed*
   anomaly/PTE charge multiset (Table I No. 1, `A = {0,4,7,11}`,
   `B = {1,2,9,10}`).  General lemmas describe `compactify` iterated from an
   *arbitrary* walker.
3. **§3–§5.** A `superstringStartWalker` in `D = 10` is walked down by `6`
   `compactify` steps to `D = 4`.
4. **Proved invariants (all machine-checked):**
   * the descent itinerary is exactly `[10, 9, 8, 7, 6, 5, 4]`;
   * the total central charge is conserved, `D + (internal) = 10`, at every step
     — the superstring stays critical all the way down;
   * the spacetime/internal split matches the dimension count at every step;
   * the carried PTE/anomaly charges never change and remain a genuine degree-3
     PTE / anomaly-free solution at every dimension.

## Honesty / scope

As with the rest of the glue layer, **no new physical theorem is asserted.**
The `DimWalker` structure is purely organizational, the steps are interpretive
(compactification bookkeeping), and the only genuinely *proved* content is the
finite arithmetic/combinatorial coherence of the descent (dimension counting,
central-charge conservation, and invariance of the carried PTE solution).
-/

import Mathlib
import RequestProject.PTE
import RequestProject.Moonshine
import RequestProject.Physics.MinichargedGlue
import RequestProject.Physics.BosonicStringDescent

namespace SuperstringDescent

open MinichargedGlue BosonicStringDescent

/-! ## §1. Critical superstring data

The critical dimension of the superstring is `10`.  In light-cone gauge there
are `8 = 10 - 2` transverse oscillators, while the remaining `2` dimensions are
the longitudinal+ghost pair. -/

/-- The central charge (critical dimension) of the superstring. -/
def superstringCentralCharge : ℕ := 10

/-- The number of transverse (light-cone) dimensions of the critical
superstring: `10 - 2 = 8`. -/
def superstringTransverseDim : ℕ := 8

/-- The longitudinal + ghost dimension count. -/
def superstringLongGhostDim : ℕ := 2

/-- `10 = 8 + 2`: the critical superstring dimension splits into transverse plus
longitudinal+ghost. -/
theorem superstring_dim_split :
    superstringCentralCharge =
      superstringTransverseDim + superstringLongGhostDim := by decide

/-- The superstring critical dimension `10` lies on the bosonic descent ladder
of `BosonicStringDescent`, reached after `16` of its steps. -/
theorem superstring_on_bosonic_ladder :
    (compactify^[16] startWalker).spacetimeDim = superstringCentralCharge :=
  BosonicStringDescent.milestone_10

/-! ## §2. General `compactify` lemmas (from an arbitrary walker)

These describe iterating `compactify` from *any* `DimWalker`, so they apply to
both the bosonic start (`D = 26`) and the superstring start (`D = 10`). -/

/-- Iterating `compactify` never changes the carried charges. -/
theorem iterate_charges (w : DimWalker) (n : ℕ) :
    (compactify^[n] w).charges = w.charges := by
  induction n with
  | zero => rfl
  | succ k ih => rw [Function.iterate_succ', Function.comp_apply]; exact ih

/-- After `n` `compactify` steps the spacetime dimension drops by `n`. -/
theorem iterate_spacetime (w : DimWalker) (n : ℕ) :
    (compactify^[n] w).spacetimeDim = w.spacetimeDim - n := by
  induction n with
  | zero => simp
  | succ k ih =>
      rw [Function.iterate_succ', Function.comp_apply]
      show (compactify^[k] w).spacetimeDim - 1 = w.spacetimeDim - (k + 1)
      rw [ih]; omega

/-- After `n` `compactify` steps the internal dimension grows by `n`. -/
theorem iterate_internal (w : DimWalker) (n : ℕ) :
    (compactify^[n] w).internalDim = w.internalDim + n := by
  induction n with
  | zero => simp
  | succ k ih =>
      rw [Function.iterate_succ', Function.comp_apply]
      show (compactify^[k] w).internalDim + 1 = w.internalDim + (k + 1)
      rw [ih]; omega

/-! ## §3. The superstring descent walker -/

/-- The starting walker: the critical superstring in `D = 10`, no compactified
dimensions yet, carrying Table I No. 1 charges. -/
def superstringStartWalker : DimWalker where
  charges := tableNo1Anomaly
  spacetimeDim := 10
  internalDim := 0

/-- Walk the dimension all the way down: `6` compactification steps take
`D : 10 → 4`. -/
def superstringWalkDown : DimWalker := compactify^[6] superstringStartWalker

/-! ## §4. The descent itinerary and conservation laws -/

/-- After `n` steps, the carried charges are still exactly the starting charges. -/
theorem ss_descend_charges (n : ℕ) :
    (compactify^[n] superstringStartWalker).charges = tableNo1Anomaly :=
  iterate_charges superstringStartWalker n

/-- After `n` steps the spacetime dimension is `10 - n`. -/
theorem ss_descend_spacetime (n : ℕ) :
    (compactify^[n] superstringStartWalker).spacetimeDim = 10 - n :=
  iterate_spacetime superstringStartWalker n

/-- After `n` steps, `n` dimensions have been compactified. -/
theorem ss_descend_internal (n : ℕ) :
    (compactify^[n] superstringStartWalker).internalDim = n := by
  rw [iterate_internal]; simp [superstringStartWalker]

/-- **Central-charge conservation.**  At every step `n ≤ 10` of the descent the
total dimension (spacetime + internal) stays critical, equal to `10`. -/
theorem ss_descend_total (n : ℕ) (hn : n ≤ 10) :
    (compactify^[n] superstringStartWalker).spacetimeDim +
      (compactify^[n] superstringStartWalker).internalDim = 10 := by
  rw [ss_descend_spacetime, ss_descend_internal]; omega

/-- The descent reaches `D = 4` after exactly `6` steps. -/
theorem superstringWalkDown_spacetime : superstringWalkDown.spacetimeDim = 4 := by
  unfold superstringWalkDown; rw [ss_descend_spacetime]

/-- At `D = 4`, exactly `6` dimensions have been compactified. -/
theorem superstringWalkDown_internal : superstringWalkDown.internalDim = 6 := by
  unfold superstringWalkDown; rw [ss_descend_internal]

/-- The final state is still critical: `4 + 6 = 10`. -/
theorem superstringWalkDown_total :
    superstringWalkDown.spacetimeDim + superstringWalkDown.internalDim = 10 := by
  rw [superstringWalkDown_spacetime, superstringWalkDown_internal]

/-- The carried charges are unchanged at the bottom of the descent. -/
theorem superstringWalkDown_charges :
    superstringWalkDown.charges = tableNo1Anomaly := by
  unfold superstringWalkDown; exact ss_descend_charges 6

/-- The sequence of spacetime dimensions visited during the superstring descent. -/
def superstringItinerary : List ℕ :=
  (List.range 7).map (fun k => (compactify^[k] superstringStartWalker).spacetimeDim)

/-- **The superstring descent itinerary is exactly `10, 9, 8, 7, 6, 5, 4`.** -/
theorem superstringItinerary_eq :
    superstringItinerary = [10, 9, 8, 7, 6, 5, 4] := by
  have : superstringItinerary = (List.range 7).map (fun k => 10 - k) := by
    unfold superstringItinerary
    exact List.map_congr_left (fun k _ => ss_descend_spacetime k)
  rw [this]; decide

/-! ## §5. The carried PTE solution survives the whole descent -/

/-- The carried `A` multiset stays `{0,4,7,11}` from `D = 10` down to `D = 4`. -/
theorem ss_descend_charges_A (n : ℕ) :
    (compactify^[n] superstringStartWalker).charges.A = [0, 4, 7, 11] := by
  rw [ss_descend_charges]; rfl

/-- The carried `B` multiset stays `{1,2,9,10}` from `D = 10` down to `D = 4`. -/
theorem ss_descend_charges_B (n : ℕ) :
    (compactify^[n] superstringStartWalker).charges.B = [1, 2, 9, 10] := by
  rw [ss_descend_charges]; rfl

/-- At every dimension on the descent the carried charges remain a genuine
degree-3 PTE / anomaly-free solution (Table I No. 1). -/
theorem ss_descend_isPTE (n : ℕ) :
    PTE.IsPTE (compactify^[n] superstringStartWalker).charges.A
      (compactify^[n] superstringStartWalker).charges.B 3 := by
  rw [ss_descend_charges_A, ss_descend_charges_B]; exact PTE.table_no1

/-! ## §6. Milestone dimensions and the link to the 4d sector

The two physically distinguished dimensions on this lower ladder — `10`
(superstring critical) and `4` (observed spacetime) — both lie on the descent,
and the bottom of the descent matches the 4d minicharged sector's PTE data. -/

/-- `D = 10` is the start of the descent (step 0). -/
theorem ss_milestone_10 :
    (compactify^[0] superstringStartWalker).spacetimeDim = 10 := by
  rw [ss_descend_spacetime]

/-- `D = 4` (the observed spacetime dimension) is reached after `6` steps. -/
theorem ss_milestone_4 :
    (compactify^[6] superstringStartWalker).spacetimeDim = 4 := by
  rw [ss_descend_spacetime]

/-- Both milestone dimensions occur in the superstring descent itinerary. -/
theorem ss_milestones_in_itinerary :
    10 ∈ superstringItinerary ∧ 4 ∈ superstringItinerary := by
  rw [superstringItinerary_eq]; refine ⟨?_, ?_⟩ <;> decide

/-- The superstring descent `[10, …, 4]` is the lower tail of the bosonic
descent `[26, …, 4]`: every dimension visited by the superstring walker is also
visited by the bosonic walker. -/
theorem superstring_itinerary_subset_bosonic :
    ∀ d ∈ superstringItinerary, d ∈ BosonicStringDescent.descentItinerary := by
  rw [superstringItinerary_eq, BosonicStringDescent.descentItinerary_eq]
  decide

/-- **Superstring descent coherence.**  Walking the spacetime dimension down
from `10` to `4` in `6` unit steps keeps the carried PTE charges fixed
(`tableNo1Anomaly`), traces the itinerary `10, 9, …, 4`, conserves the total
(critical) central charge `D + internal = 10` throughout, and ends on the same
PTE solution that the 4d minicharged sector carries. -/
theorem superstring_descent_coherent :
    superstringWalkDown.charges = tableNo1Anomaly ∧
    superstringWalkDown.spacetimeDim = 4 ∧
    superstringWalkDown.internalDim = 6 ∧
    superstringWalkDown.spacetimeDim + superstringWalkDown.internalDim = 10 ∧
    superstringItinerary = [10, 9, 8, 7, 6, 5, 4] ∧
    PTE.IsPTE superstringWalkDown.charges.A superstringWalkDown.charges.B 3 :=
  ⟨superstringWalkDown_charges, superstringWalkDown_spacetime,
   superstringWalkDown_internal, superstringWalkDown_total,
   superstringItinerary_eq, by
    rw [superstringWalkDown]; exact ss_descend_isPTE 6⟩

end SuperstringDescent
