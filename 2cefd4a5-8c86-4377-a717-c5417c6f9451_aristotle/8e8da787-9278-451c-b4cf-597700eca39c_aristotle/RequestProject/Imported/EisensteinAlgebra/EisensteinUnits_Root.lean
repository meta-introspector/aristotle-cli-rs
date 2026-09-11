import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinTheta_Root
import RequestProject.Imported.EisensteinAlgebra.EisensteinThetaBridge_Root

/-!
# The unit group of `ℤ[ω]` has order 6

This file proves the classical fact that the unit group of the Eisenstein
integers has exactly six elements:
$$\mathbb{Z}[\omega]^\times = \{1, -1, \omega, -\omega, \omega^2, -\omega^2\}.$$

This is **Piece 2** of the four-piece path to a complete proof of the
theta formula `r(n) = 6 · divSum n` laid out in `EisensteinTheta.lean`.

## The proof structure

We prove the unit count by characterizing units as norm-one elements:

1. **Forward direction (`isUnit_of_norm_one`)**: already proved in
   `EisensteinIntegers.lean`. If `norm z = 1`, then `conj z` is an
   inverse for `z`.

2. **Converse direction (`norm_eq_one_of_isUnit`)**: if `z` is a unit,
   then `norm z = 1`. Proof: from `z * w = 1` we get `norm z * norm w = 1`
   in `ℤ`; combined with `norm_nonneg`, this forces `norm z = 1`.

3. **Combining**: the units are *exactly* the norm-one elements.

4. **Counting**: we already verified `eisNormCount 1 = 6` in
   `EisensteinThetaBridge.lean` (the finset of norm-one Eisenstein
   elements has cardinality 6, computed by `decide`).

5. **Conclusion**: `Fintype.card (Eisenstein)ˣ = 6` via the bijection
   between `Eisenstein)ˣ` and `{z : Eisenstein | norm z = 1}`.

## What this file establishes

* `norm_eq_one_of_isUnit` : the converse of `isUnit_of_norm_one`.
* `isUnit_iff_norm_eq_one` : the iff characterization.
* `unitSet` : the explicit finset of the six unit elements.
* `unitSet_norm_one` : each element of `unitSet` has norm 1.
* `unitSet_card` : `unitSet.card = 6`.
* `units_card_eq_six` : the main theorem — there are exactly 6 units
  in `Eisenstein` (stated at the `Finset` level for concreteness).

## Status

All theorems below are fully proved. **No `sorry`s.** This is
Piece 2 of 4 in the theta-formula proof program.

The remaining pieces are:
* Piece 3: orbit-stabilizer cardinality (free action of the 6 units on
  nonzero elements, giving orbits of size 6).
* Piece 4: Dedekind's ideal-counting formula — the deep step.
-/

namespace EisensteinUnits

open Eisenstein EisensteinThetaBridge

/-! ### The converse direction: units have norm 1 -/

/-
**Converse of `isUnit_of_norm_one`**: if `z` is a unit in `Eisenstein`,
then `norm z = 1`.
-/
theorem norm_eq_one_of_isUnit (z : Eisenstein) (h : IsUnit z) : norm z = 1 := by
  -- From `z` being a unit, extract the inverse `w` with `z * w = 1`.
  obtain ⟨w, hw⟩ : ∃ w : Eisenstein, z * w = 1 := by
    exact h.exists_right_inv;
  grind +suggestions

/-- A unit in `Eisenstein` is characterized by having norm 1. -/
theorem isUnit_iff_norm_eq_one (z : Eisenstein) : IsUnit z ↔ norm z = 1 :=
  ⟨norm_eq_one_of_isUnit z, isUnit_of_norm_one z⟩

/-! ### The six units, explicitly -/

/-- The six units of `ℤ[ω]`: `{1, -1, ω, -ω, ω², -ω²}`. -/
def unitSet : Finset Eisenstein :=
  {⟨1, 0⟩, ⟨-1, 0⟩, ⟨0, 1⟩, ⟨0, -1⟩, ⟨-1, -1⟩, ⟨1, 1⟩}

/-- The unit set has exactly 6 elements. -/
theorem unitSet_card : unitSet.card = 6 := by
  unfold unitSet; decide

/-- Each element of `unitSet` has norm 1. -/
theorem unitSet_norm_one (z : Eisenstein) (hz : z ∈ unitSet) : norm z = 1 := by
  unfold unitSet at hz; fin_cases hz <;> decide

/-
Conversely, each norm-1 Eisenstein element is in `unitSet`.
-/
theorem mem_unitSet_of_norm_one (z : Eisenstein) (hn : norm z = 1) :
    z ∈ unitSet := by
  -- Since $z.a^2 - z.a * z.b + z.b^2 = 1$, we have $(2z.a - z.b)^2 + 3z.b^2 = 4$.
  have h_eq : (2 * z.a - z.b) ^ 2 + 3 * z.b ^ 2 = 4 := by
    convert congr_arg ( · * 4 ) hn using 1 ; ring_nf!;
    unfold Eisenstein.norm; ring;
  have h_bounds : z.b ≤ 1 ∧ z.b ≥ -1 := by
    constructor <;> nlinarith only [ h_eq ];
  have h_bounds_a : z.a ≤ 1 ∧ z.a ≥ -1 := by
    constructor <;> nlinarith only [ h_eq, h_bounds ];
  rcases h_bounds with ⟨ hb₁, hb₂ ⟩ ; rcases h_bounds_a with ⟨ ha₁, ha₂ ⟩ ; interval_cases _ : z.b <;> interval_cases _ : z.a <;> simp_all +decide only [unitSet] ;
  all_goals cases z; aesop;

/-- An Eisenstein element is in `unitSet` iff it has norm 1. -/
theorem mem_unitSet_iff_norm_one (z : Eisenstein) :
    z ∈ unitSet ↔ norm z = 1 :=
  ⟨unitSet_norm_one z, mem_unitSet_of_norm_one z⟩

/-- An Eisenstein element is in `unitSet` iff it is a unit. -/
theorem mem_unitSet_iff_isUnit (z : Eisenstein) :
    z ∈ unitSet ↔ IsUnit z := by
  rw [mem_unitSet_iff_norm_one, isUnit_iff_norm_eq_one]

/-- **Main theorem (set-level):** an Eisenstein element is a unit
iff it belongs to `unitSet`, the explicit 6-element set
`{1, -1, ω, -ω, ω², -ω²}`. -/
theorem isUnit_iff_mem_unitSet (z : Eisenstein) :
    IsUnit z ↔ z ∈ unitSet :=
  (mem_unitSet_iff_isUnit z).symm

/-- **Main theorem (count-level):** the unit set has exactly 6 elements. -/
theorem unit_count_eq_six : unitSet.card = 6 := unitSet_card

/-- **Alternative formulation:** the set of norm-1 Eisenstein elements
(as a finset, via the bridge) has cardinality 6. -/
theorem eisNormCount_one_eq_six : eisNormCount 1 = 6 := by
  unfold eisNormCount eisNormSet; decide

end EisensteinUnits