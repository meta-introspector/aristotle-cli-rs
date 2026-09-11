/-
# The 26d Bosonic String and the Dimensional Descent `26 → 4`

This file expands the minicharged-sector / moonshine glue layer "upward" to the
**26-dimensional bosonic string** and then **walks the spacetime dimension down
from 26 to 4 in steps**, exactly as requested.

## What this file does

1. **§1.** Records the critical bosonic-string data (central charge `26`, the
   `24` transverse / light-cone dimensions tied to the Leech lattice / `V♮`, and
   the residual `2` longitudinal+ghost dimensions tied to the `II₁,₁` root
   lattice of the Monster Lie algebra).
2. **§2.** Builds the 26d bosonic string as a `PhysSector` / `SheafSection`,
   sharing the *same* supersingular / `Cl(15)` arithmetic skeleton as the 4d
   minicharged sectors of `MinichargedGlue`.
3. **§3–§5.** Defines a `DimWalker` that carries a fixed anomaly/PTE charge
   multiset (Table I No. 1, `A = {0,4,7,11}`, `B = {1,2,9,10}`) together with a
   running spacetime dimension `D` and a count of compactified ("internal")
   dimensions.  A single step `compactify` reduces `D` by one (compactify one
   circle) while moving one dimension into the internal CFT.  Walking 22 steps
   takes `D : 26 → 4`.
4. **Proved invariants (all machine-checked):**
   * the descent itinerary is exactly `[26, 25, …, 4]`;
   * the total central charge is conserved, `D + (internal) = 26`, at every step;
   * the carried PTE/anomaly charges never change and remain a genuine degree-3
     PTE / anomaly-free solution at every dimension;
   * the milestone dimensions `26` (bosonic critical), `10` (superstring
     critical) and `4` (observed spacetime) all occur on the descent.

## Honesty / scope

As with the rest of the glue layer, **no new physical theorem is asserted.**
The `PhysSector`/`SheafSection`/`DimWalker` structures are purely organizational,
the steps are interpretive (compactification bookkeeping), and the only genuinely
*proved* content is the finite arithmetic/combinatorial coherence of the descent
(dimension counting, central-charge conservation, and invariance of the carried
PTE solution).
-/

import Mathlib
import RequestProject.PTE
import RequestProject.Moonshine
import RequestProject.Physics.MinichargedGlue

namespace BosonicStringDescent

open MoonshineOntology MinichargedGlue

/-! ## §1. Critical bosonic-string data

The critical dimension of the bosonic string is `26`.  In light-cone gauge there
are `24 = 26 - 2` transverse oscillators — the rank of the Leech lattice and the
central charge of the Monster VOA `V♮` — while the remaining `2` dimensions are
the longitudinal+ghost pair, carrying the signature `(1,1)` of the `II₁,₁` root
lattice of the Monster Lie algebra. -/

/-- The central charge of the critical bosonic string. -/
def bosonicCentralCharge : ℕ := 26

/-- The number of transverse (light-cone) dimensions of the critical bosonic
string: `26 - 2 = 24`, the rank of the Leech lattice / central charge of `V♮`. -/
def transverseDim : ℕ := 24

/-- The longitudinal + ghost dimension count, carrying the `(1,1)` signature of
the Monster Lie algebra's `II₁,₁` root lattice. -/
def longGhostDim : ℕ := 2

/-- `26 = 24 + 2`: the critical dimension splits into transverse (Leech / `V♮`)
plus longitudinal+ghost (`II₁,₁`). -/
theorem bosonic_dim_split :
    bosonicCentralCharge = transverseDim + longGhostDim := by decide

/-- A human-readable label for the physically distinguished spacetime
dimensions met along the descent. -/
def dimLabel : ℕ → String
  | 26 => "bosonic string critical dimension"
  | 10 => "superstring critical dimension"
  | 4  => "observed spacetime dimension"
  | _  => "compactification step"

/-! ## §2. The 26d bosonic string as a sheaf section

The bosonic string sector reuses the *same* arithmetic skeleton (the 15
supersingular primes, the `Cl(15)` blade hypercube, the CRT orbifold lift
`116427`) as the 4d minicharged sectors.  Only the interpretation of the
worldsheet/fiber data changes; the glue is the shared arithmetic. -/

/-- The 26d bosonic string sector as a `PhysSector`, sharing the supersingular /
`Cl(15)` arithmetic skeleton with the minicharged sectors. -/
def BosonicSector : PhysSector where
  dim4_QFT      := U1H_U1X_Model
  anomaly_poly  := AnomalyPoly_U1H_U1X
  pte_data      := PTE_Degree3_Data
  worldsheet_VA := Vnat
  ss_primes     := Moonshine.ssPrimes.toFinset
  blade_space   := Moonshine.Blade
  crt_orbifold  := 116427
  glue_map      := anomaly_to_VA

/-- The 26d bosonic string sheaf section, placed over the Monster VOA `V♮`. -/
def BosonicSection : SheafSection where
  base_point := MonsterBasePoint.Vnat
  fiber      := BosonicSector

/-- The bosonic string section shares the minicharged section's arithmetic
skeleton (same supersingular primes and blade space). -/
theorem bosonic_arithEq_minicharged :
    arithEq BosonicSection MinichargedSection := ⟨rfl, rfl⟩

/-- The bosonic string section carries the same PTE-solution data type. -/
theorem bosonic_pteEq_minicharged :
    pteEq BosonicSection MinichargedSection := rfl

/-- The bosonic string section carries the Oggorial as its supersingular
product. -/
theorem bosonic_ss_product :
    sectorSupersingularProduct BosonicSection = 1618964990108856390 := by
  unfold sectorSupersingularProduct BosonicSection BosonicSector
  native_decide

/-! ## §3. The dimensional descent walker

A `DimWalker` carries a fixed anomaly/PTE charge multiset together with the
current spacetime dimension `D` and the number of compactified ("internal")
dimensions.  The invariant `D + internal = 26` records that the total worldsheet
central charge stays critical throughout. -/

/-- A walker descending the spacetime dimension while carrying a fixed
anomaly/PTE solution and tracking how many dimensions have been compactified. -/
structure DimWalker where
  /-- The anomaly/PTE charge data carried unchanged down the dimensional ladder. -/
  charges : AnomalyPoly_U1H_U1X
  /-- The current (noncompact) spacetime dimension `D`. -/
  spacetimeDim : ℕ
  /-- The number of compactified / internal dimensions. -/
  internalDim : ℕ

/-- One descent step: compactify a single dimension on a circle.  The spacetime
dimension drops by one, one dimension moves into the internal CFT, and the
carried charges are untouched. -/
def compactify (w : DimWalker) : DimWalker where
  charges := w.charges
  spacetimeDim := w.spacetimeDim - 1
  internalDim := w.internalDim + 1

/-- The starting walker: the critical bosonic string in `D = 26`, no
compactified dimensions yet, carrying Table I No. 1 charges. -/
def startWalker : DimWalker where
  charges := tableNo1Anomaly
  spacetimeDim := 26
  internalDim := 0

/-- Walk the dimension all the way down: 22 compactification steps take
`D : 26 → 4`. -/
def walkDown : DimWalker := compactify^[22] startWalker

/-! ## §4. The descent itinerary and conservation laws -/

/-- After `n` steps, the carried charges are still exactly the starting charges. -/
theorem descend_charges (n : ℕ) :
    (compactify^[n] startWalker).charges = tableNo1Anomaly := by
  induction n with
  | zero => rfl
  | succ k ih => rw [Function.iterate_succ', Function.comp_apply]; exact ih

/-- After `n` steps the spacetime dimension is `26 - n`. -/
theorem descend_spacetime (n : ℕ) :
    (compactify^[n] startWalker).spacetimeDim = 26 - n := by
  induction n with
  | zero => rfl
  | succ k ih =>
      rw [Function.iterate_succ', Function.comp_apply]
      show (compactify^[k] startWalker).spacetimeDim - 1 = 26 - (k + 1)
      rw [ih]; omega

/-- After `n` steps, `n` dimensions have been compactified. -/
theorem descend_internal (n : ℕ) :
    (compactify^[n] startWalker).internalDim = n := by
  induction n with
  | zero => rfl
  | succ k ih =>
      rw [Function.iterate_succ', Function.comp_apply]
      show (compactify^[k] startWalker).internalDim + 1 = k + 1
      rw [ih]

/-- **Central-charge conservation.**  At every step `n ≤ 26` of the descent the
total dimension (spacetime + internal) stays critical, equal to `26`. -/
theorem descend_total (n : ℕ) (hn : n ≤ 26) :
    (compactify^[n] startWalker).spacetimeDim +
      (compactify^[n] startWalker).internalDim = 26 := by
  rw [descend_spacetime, descend_internal]; omega

/-- The descent reaches `D = 4` after exactly 22 steps. -/
theorem walkDown_spacetime : walkDown.spacetimeDim = 4 := by
  unfold walkDown; rw [descend_spacetime]

/-- At `D = 4`, exactly 22 dimensions have been compactified. -/
theorem walkDown_internal : walkDown.internalDim = 22 := by
  unfold walkDown; rw [descend_internal]

/-- The final state is still critical: `4 + 22 = 26`. -/
theorem walkDown_total : walkDown.spacetimeDim + walkDown.internalDim = 26 := by
  rw [walkDown_spacetime, walkDown_internal]

/-- The carried charges are unchanged at the bottom of the descent. -/
theorem walkDown_charges : walkDown.charges = tableNo1Anomaly := by
  unfold walkDown; exact descend_charges 22

/-- The sequence of spacetime dimensions visited during the descent. -/
def descentItinerary : List ℕ :=
  (List.range 23).map (fun k => (compactify^[k] startWalker).spacetimeDim)

/-- **The descent itinerary is exactly `26, 25, …, 5, 4`.** -/
theorem descentItinerary_eq :
    descentItinerary =
      [26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14,
       13, 12, 11, 10, 9, 8, 7, 6, 5, 4] := by
  have : descentItinerary = (List.range 23).map (fun k => 26 - k) := by
    unfold descentItinerary
    exact List.map_congr_left (fun k _ => descend_spacetime k)
  rw [this]; decide

/-! ## §5. The carried PTE solution survives the whole descent -/

/-- The carried `A` multiset stays `{0,4,7,11}` from `D = 26` down to `D = 4`. -/
theorem descend_charges_A (n : ℕ) :
    (compactify^[n] startWalker).charges.A = [0, 4, 7, 11] := by
  rw [descend_charges]; rfl

/-- The carried `B` multiset stays `{1,2,9,10}` from `D = 26` down to `D = 4`. -/
theorem descend_charges_B (n : ℕ) :
    (compactify^[n] startWalker).charges.B = [1, 2, 9, 10] := by
  rw [descend_charges]; rfl

/-- At every dimension on the descent the carried charges remain a genuine
degree-3 PTE / anomaly-free solution (Table I No. 1). -/
theorem descend_isPTE (n : ℕ) :
    PTE.IsPTE (compactify^[n] startWalker).charges.A
      (compactify^[n] startWalker).charges.B 3 := by
  rw [descend_charges_A, descend_charges_B]; exact PTE.table_no1

/-! ## §6. Milestone dimensions on the ladder

The three physically distinguished dimensions — `26` (bosonic critical), `10`
(superstring critical) and `4` (observed spacetime) — all lie on the descent. -/

/-- `D = 26` is the start of the descent (step 0). -/
theorem milestone_26 : (compactify^[0] startWalker).spacetimeDim = 26 := by
  rw [descend_spacetime]

/-- `D = 10` (the superstring critical dimension) is reached after 16 steps. -/
theorem milestone_10 : (compactify^[16] startWalker).spacetimeDim = 10 := by
  rw [descend_spacetime]

/-- `D = 4` (the observed spacetime dimension) is reached after 22 steps. -/
theorem milestone_4 : (compactify^[22] startWalker).spacetimeDim = 4 := by
  rw [descend_spacetime]

/-- All three milestone dimensions occur in the descent itinerary. -/
theorem milestones_in_itinerary :
    26 ∈ descentItinerary ∧ 10 ∈ descentItinerary ∧ 4 ∈ descentItinerary := by
  rw [descentItinerary_eq]; refine ⟨?_, ?_, ?_⟩ <;> decide

/-- **Descent coherence.**  Putting it together: walking the spacetime dimension
down from `26` to `4` in 22 unit steps keeps the carried PTE charges fixed
(`tableNo1Anomaly`), traces the itinerary `26, 25, …, 4`, and conserves the total
(critical) central charge `D + internal = 26` throughout. -/
theorem descent_coherent :
    walkDown.charges = tableNo1Anomaly ∧
    walkDown.spacetimeDim = 4 ∧
    walkDown.internalDim = 22 ∧
    walkDown.spacetimeDim + walkDown.internalDim = 26 ∧
    descentItinerary =
      [26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14,
       13, 12, 11, 10, 9, 8, 7, 6, 5, 4] :=
  ⟨walkDown_charges, walkDown_spacetime, walkDown_internal,
   walkDown_total, descentItinerary_eq⟩

end BosonicStringDescent
