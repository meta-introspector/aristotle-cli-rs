/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The six Sylow 5-subgroups of `A₅` and the 6-point permutation representation.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinCharacter

/-!
# The 6-point action of `A₅` on its Sylow 5-subgroups

The character `χ_{π₆}` of the 6-point permutation representation of `A₅` — the
one that carries the five-dimensional representation `ρ₅`, and with it the
conductor of the sextic field `K₆` — was recorded in
`RequestProject/A5ArtinConductor.lean` as a table.  Here the 6-point set is
realised concretely as the set of the six Sylow 5-subgroups of `A₅`, with `A₅`
acting on it by conjugation, and the table becomes a fixed-point count.

* `cyc5 i` — six 5-cycles, one for each Sylow 5-subgroup;
* `syl5 i = {1, cᵢ, cᵢ², cᵢ³, cᵢ⁴}` — the six subgroups, pairwise distinct, each
  of order `5` (`card_syl5`, `syl5_injective`), each a genuine subgroup
  (`syl5Subgroup`) of `A₅` (`syl5Subgroup_le_alternatingGroup`);
* `mem_syl5_of_pow_five` — every element of order dividing `5` lies in one of
  the six, so these are *all* the Sylow 5-subgroups;
* `act6 g` — the induced action on the index set `Fin 6`, characterised by
  `syl5 (act6 g i) = conjSyl g (syl5 i)` (`act6_spec`, for every `g` in `A₅`);
  it is a group action (`act6_one`, `act6_mul`) by permutations of `Fin 6`
  (`act6_injective`);
* `chiPerm6_eq_card_fixed` — `χ_{π₆}(c)` is the number of Sylow 5-subgroups
  fixed by `rep c`;
* `chi5_eq_sub`, `chi5_eq_card_fixed_sub_one` — the derived form
  `χ₅ = χ_{π₆} − 1`.
-/

namespace A5Artin

open Cls IRep Equiv

set_option maxRecDepth 100000

/-! ## 1. The six Sylow 5-subgroups -/

/-- Six 5-cycles of `A₅`, one from each Sylow 5-subgroup: a 5-cycle written as
`(0 a b c d)` lies in the same subgroup as exactly one 5-cycle of the form
`(0 1 x y z)`. -/
def cyc5 : Fin 6 → Perm (Fin 5)
  | 0 => List.formPerm [0, 1, 2, 3, 4]
  | 1 => List.formPerm [0, 1, 2, 4, 3]
  | 2 => List.formPerm [0, 1, 3, 2, 4]
  | 3 => List.formPerm [0, 1, 3, 4, 2]
  | 4 => List.formPerm [0, 1, 4, 2, 3]
  | 5 => List.formPerm [0, 1, 4, 3, 2]

/-- The six Sylow 5-subgroups of `A₅`, as `Finset`s. -/
def syl5 (i : Fin 6) : Finset (Perm (Fin 5)) :=
  {1, cyc5 i, cyc5 i ^ 2, cyc5 i ^ 3, cyc5 i ^ 4}

theorem card_syl5 (i : Fin 6) : (syl5 i).card = 5 := by revert i; decide

theorem syl5_injective : Function.Injective syl5 := by decide

theorem one_mem_syl5 (i : Fin 6) : (1 : Perm (Fin 5)) ∈ syl5 i := by revert i; decide

theorem mul_mem_syl5 (i : Fin 6) : ∀ a ∈ syl5 i, ∀ b ∈ syl5 i, a * b ∈ syl5 i := by
  revert i; decide

theorem inv_mem_syl5 (i : Fin 6) : ∀ a ∈ syl5 i, a⁻¹ ∈ syl5 i := by revert i; decide

/-- The `i`-th Sylow 5-subgroup as a genuine subgroup of `Equiv.Perm (Fin 5)`. -/
def syl5Subgroup (i : Fin 6) : Subgroup (Perm (Fin 5)) where
  carrier := ↑(syl5 i)
  mul_mem' {a b} ha hb := by
    simp only [Finset.mem_coe] at *
    exact mul_mem_syl5 i a ha b hb
  one_mem' := by simpa using one_mem_syl5 i
  inv_mem' {a} ha := by
    simp only [Finset.mem_coe] at *
    exact inv_mem_syl5 i a ha

@[simp] theorem mem_syl5Subgroup {i : Fin 6} {x : Perm (Fin 5)} :
    x ∈ syl5Subgroup i ↔ x ∈ syl5 i := Iff.rfl

theorem syl5Subgroup_le_alternatingGroup (i : Fin 6) :
    syl5Subgroup i ≤ alternatingGroup (Fin 5) := by
  intro x hx
  rw [mem_syl5Subgroup] at hx
  rw [← mem_A5finset]
  revert hx
  revert x
  revert i
  decide

theorem card_syl5Subgroup (i : Fin 6) : Nat.card (syl5Subgroup i) = 5 := by
  have h : Nat.card (syl5Subgroup i) = (syl5 i).card := by
    simp [syl5Subgroup, Nat.card_eq_fintype_card]
  rw [h, card_syl5]

/-! ## 2. Conjugation, and the action on the index set -/

/-- The conjugate `g S g⁻¹` of a set of permutations. -/
def conjSyl (g : Perm (Fin 5)) (S : Finset (Perm (Fin 5))) : Finset (Perm (Fin 5)) :=
  S.image fun x => g * x * g⁻¹

theorem conjSyl_one (S : Finset (Perm (Fin 5))) : conjSyl 1 S = S := by
  simp [conjSyl]

theorem conjSyl_mul (g h : Perm (Fin 5)) (S : Finset (Perm (Fin 5))) :
    conjSyl (g * h) S = conjSyl g (conjSyl h S) := by
  simp only [conjSyl, Finset.image_image]
  refine Finset.image_congr ?_
  intro x _
  simp [mul_assoc]

/-- The action of `A₅` on the index set of its Sylow 5-subgroups: `act6 g i` is
the index of `g · (syl5 i) · g⁻¹`. -/
def act6 (g : Perm (Fin 5)) (i : Fin 6) : Fin 6 :=
  ((List.finRange 6).find? fun j => syl5 j = conjSyl g (syl5 i)).getD i

/-- Every permutation whose fifth power is the identity lies in one of the six
subgroups: `syl5` lists *all* the Sylow 5-subgroups of `A₅`. -/
theorem mem_syl5_of_pow_five {g : Perm (Fin 5)} (hg : g ^ 5 = 1) : ∃ i, g ∈ syl5 i := by
  revert hg
  revert g
  decide +kernel

/-- The defining property of `act6`: conjugation by `g` carries the `i`-th Sylow
5-subgroup to the `act6 g i`-th one. -/
theorem act6_spec (g : Perm (Fin 5)) (i : Fin 6) : syl5 (act6 g i) = conjSyl g (syl5 i) := by
  revert i
  revert g
  decide +kernel

theorem act6_one (i : Fin 6) : act6 1 i = i := by
  apply syl5_injective
  rw [act6_spec, conjSyl_one]

theorem act6_mul (g h : Perm (Fin 5)) (i : Fin 6) : act6 (g * h) i = act6 g (act6 h i) := by
  apply syl5_injective
  rw [act6_spec, act6_spec, act6_spec, conjSyl_mul]

theorem act6_injective (g : Perm (Fin 5)) : Function.Injective (act6 g) := by
  intro i j hij
  have h : act6 g⁻¹ (act6 g i) = act6 g⁻¹ (act6 g j) := by rw [hij]
  rwa [← act6_mul, ← act6_mul, inv_mul_cancel, act6_one, act6_one] at h

/-! ## 3. The character of the 6-point representation -/

/-- The character of the 6-point permutation representation is the number of
Sylow 5-subgroups fixed by the class representative: the table `chiPerm6` is a
theorem. -/
theorem chiPerm6_eq_card_fixed (c : Cls) :
    chiPerm6 c = ((Finset.univ.filter fun i : Fin 6 => act6 (rep c) i = i).card : ℝ) := by
  cases c
  · rw [show (Finset.univ.filter fun i : Fin 6 => act6 (rep c1) i = i).card = 6 from by decide]
    norm_num [chiPerm6]
  · rw [show (Finset.univ.filter fun i : Fin 6 => act6 (rep c2) i = i).card = 2 from by decide]
    norm_num [chiPerm6]
  · rw [show (Finset.univ.filter fun i : Fin 6 => act6 (rep c3) i = i).card = 0 from by decide]
    norm_num [chiPerm6]
  · rw [show (Finset.univ.filter fun i : Fin 6 => act6 (rep c5A) i = i).card = 1 from by decide]
    norm_num [chiPerm6]
  · rw [show (Finset.univ.filter fun i : Fin 6 => act6 (rep c5B) i = i).card = 1 from by decide]
    norm_num [chiPerm6]

/-- The five-dimensional character is the 6-point permutation character minus
the trivial one. -/
theorem chi5_eq_sub (c : Cls) : chi5 c = chiPerm6 c - chi1 c := by
  rw [chiPerm6_eq c]; ring

/-- Hence `χ₅(c) = #{Sylow 5-subgroups fixed by rep c} − 1`, with no table on
either side. -/
theorem chi5_eq_card_fixed_sub_one (c : Cls) :
    chi5 c = ((Finset.univ.filter fun i : Fin 6 => act6 (rep c) i = i).card : ℝ) - 1 := by
  rw [chi5_eq_sub, chiPerm6_eq_card_fixed]; rfl

end A5Artin
