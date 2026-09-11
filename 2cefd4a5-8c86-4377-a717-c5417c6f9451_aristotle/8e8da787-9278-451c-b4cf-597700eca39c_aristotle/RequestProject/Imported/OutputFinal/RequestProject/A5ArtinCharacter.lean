/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The permutation characters of `A₅` as honest fixed-point counts.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinSubgroup

/-!
# Permutation characters as fixed-point counts

`RequestProject/A5ArtinConductor.lean` records the characters `χ_{π₅}`,
`χ_{π₆}`, `χ_{π₁₂}` and `χ_{reg}` of the permutation representations of `A₅` as
tables.  Here the two characters that the conductor computation actually uses
for `ρ₄` and `ρ₅`, and the character of the regular representation, are *proved*
to be fixed-point counts of genuine actions of the class representatives
`A5Artin.rep` of `RequestProject/A5ArtinPerm.lean`:

* `chiPerm5_eq_card_fixed` — `χ_{π₅}(c)` is the number of fixed points of
  `rep c` on `Fin 5`;
* `chiReg_eq_card_fixed` — `χ_{reg}(c)` is the number of fixed points of right
  translation by `repA c` on `A₅` (so `60` at the identity class and `0`
  elsewhere);
* `chi4_eq_sub` and `chi4_eq_card_fixed_sub_one` — the derived form
  `χ₄ = χ_{π₅} − 1` of the standard four-dimensional character, no longer a
  table.
-/

namespace A5Artin

open Cls IRep Equiv

/-! ## 1. The five-point representation -/

/-- The set of fixed points of a permutation of `Fin n`. -/
def fixedPts {n : ℕ} (g : Perm (Fin n)) : Finset (Fin n) :=
  Finset.univ.filter fun i => g i = i

set_option maxRecDepth 10000 in
/-- The character of the 5-point permutation representation is the number of
fixed points of the class representative: the table `chiPerm5` is a theorem. -/
theorem chiPerm5_eq_card_fixed (c : Cls) :
    chiPerm5 c = ((fixedPts (rep c)).card : ℝ) := by
  cases c
  · rw [show (fixedPts (rep c1)).card = 5 from by decide]; norm_num [chiPerm5]
  · rw [show (fixedPts (rep c2)).card = 1 from by decide]; norm_num [chiPerm5]
  · rw [show (fixedPts (rep c3)).card = 2 from by decide]; norm_num [chiPerm5]
  · rw [show (fixedPts (rep c5A)).card = 0 from by decide]; norm_num [chiPerm5]
  · rw [show (fixedPts (rep c5B)).card = 0 from by decide]; norm_num [chiPerm5]

/-! ## 2. The regular representation -/

/-- The character of the regular representation is the number of fixed points of
right translation on `A₅`: the whole group at the identity class, nothing
elsewhere. -/
theorem chiReg_eq_card_fixed (c : Cls) :
    chiReg c =
      ((Finset.univ.filter fun g : alternatingGroup (Fin 5) => g * repA c = g).card : ℝ) := by
  have hcard : ∀ c : Cls, repA c ≠ 1 →
      (Finset.univ.filter fun g : alternatingGroup (Fin 5) => g * repA c = g) = ∅ := by
    intro c hc
    refine Finset.filter_eq_empty_iff.2 ?_
    intro g _ hg
    exact hc (by simpa using mul_left_cancel (a := g) (by simpa using hg))
  have hne : ∀ c : Cls, c ≠ c1 → repA c ≠ 1 := by
    intro c hc h1
    have h := orderOf_repA c
    rw [h1, orderOf_one] at h
    cases c
    · exact hc rfl
    all_goals simp [ord] at h
  cases c
  · have h1 : repA c1 = 1 := rfl
    have : (Finset.univ.filter fun g : alternatingGroup (Fin 5) => g * repA c1 = g)
        = Finset.univ := by
      refine Finset.filter_true_of_mem ?_
      intro g _
      rw [h1, mul_one]
    rw [this, Finset.card_univ, card_A5]
    norm_num [chiReg]
  · rw [hcard _ (hne _ (by decide))]; norm_num [chiReg]
  · rw [hcard _ (hne _ (by decide))]; norm_num [chiReg]
  · rw [hcard _ (hne _ (by decide))]; norm_num [chiReg]
  · rw [hcard _ (hne _ (by decide))]; norm_num [chiReg]

/-! ## 3. `χ₄` in derived form -/

/-- The standard four-dimensional character is the permutation character minus
the trivial one. -/
theorem chi4_eq_sub (c : Cls) : chi4 c = chiPerm5 c - chi1 c := by
  rw [chiPerm5_eq c]; ring

/-- Hence `χ₄(c) = #{fixed points of rep c} − 1`, with no table on either
side. -/
theorem chi4_eq_card_fixed_sub_one (c : Cls) :
    chi4 c = ((fixedPts (rep c)).card : ℝ) - 1 := by
  rw [chi4_eq_sub, chiPerm5_eq_card_fixed]; rfl

end A5Artin
