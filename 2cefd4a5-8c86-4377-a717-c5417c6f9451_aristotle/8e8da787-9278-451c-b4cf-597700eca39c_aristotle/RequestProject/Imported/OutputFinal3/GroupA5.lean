/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import Mathlib

/-!
# A group-theoretic step towards `Gal(f₁₉₅₁) ≅ A₅`

The only fact about finite groups needed for the identification of the Galois group of the
Doud–Moore quintic is the following: a subgroup of `A₅` whose order is divisible by `15` is
all of `A₅`.

Indeed, the Galois group of an irreducible quintic acts transitively on the five roots, so its
order is divisible by `5`; the factorisation of the quintic modulo a prime with an irreducible
cubic factor forces `3` to divide the order as well; and a square discriminant puts the group
inside `A₅`.

The proof below uses only the simplicity of `A₅` (`alternatingGroup.isSimpleGroup_five`):
a subgroup `H` of order divisible by `15` has index `1`, `2` or `4`, and an index `n > 1`
subgroup would give a nontrivial permutation representation of `A₅` on `n ≤ 4` points.
-/

namespace ArtinA5Even

open Equiv

/-- The alternating group on five letters has `60` elements. -/
theorem card_alternatingGroup_five : Nat.card (alternatingGroup (Fin 5)) = 60 := by
  have h := two_mul_card_alternatingGroup (α := Fin 5)
  rw [Nat.card_eq_fintype_card]
  have : Fintype.card (Perm (Fin 5)) = 120 := by simp [Fintype.card_perm, Nat.factorial]
  omega

/-- **A subgroup of `A₅` of order divisible by `15` is the whole of `A₅`.** -/
theorem subgroup_eq_top_of_fifteen_dvd {H : Subgroup (alternatingGroup (Fin 5))}
    (h15 : 15 ∣ Nat.card H) : H = ⊤ := by
  classical
  by_contra hne
  -- The index of `H` is at most `4`.
  have hcard : Nat.card H * H.index = 60 := by
    rw [H.card_mul_index, card_alternatingGroup_five]
  have hindex_le : H.index ≤ 4 := by
    obtain ⟨k, hk⟩ := h15
    rw [hk] at hcard
    nlinarith [Nat.one_le_iff_ne_zero.mpr (show k ≠ 0 by rintro rfl; simp at hcard)]
  have hindex_ne_one : H.index ≠ 1 := fun h => hne (Subgroup.index_eq_one.mp h)
  have hindex_pos : 0 < H.index := by
    rcases Nat.eq_zero_or_pos H.index with h | h
    · rw [h] at hcard; omega
    · exact h
  -- The action on the cosets of `H`.
  set φ := MulAction.toPermHom (alternatingGroup (Fin 5)) (alternatingGroup (Fin 5) ⧸ H) with hφ
  have hker : φ.ker = H.normalCore := (Subgroup.normalCore_eq_ker H).symm
  rcases alternatingGroup.isSimpleGroup_five.eq_bot_or_eq_top_of_normal φ.ker inferInstance with
    hk | hk
  · -- faithful action on at most `4` points: impossible, `|A₅| = 60 > 24`
    have hinj : Function.Injective φ := (MonoidHom.ker_eq_bot_iff φ).mp hk
    have hle : Nat.card (alternatingGroup (Fin 5)) ≤
        Nat.card (Perm (alternatingGroup (Fin 5) ⧸ H)) := Nat.card_le_card_of_injective φ hinj
    have hqcard : Nat.card (alternatingGroup (Fin 5) ⧸ H) = H.index := rfl
    have hfin : Finite (alternatingGroup (Fin 5) ⧸ H) := by
      have : Finite (alternatingGroup (Fin 5)) := inferInstance
      infer_instance
    have hperm : Nat.card (Perm (alternatingGroup (Fin 5) ⧸ H)) = (H.index).factorial := by
      rw [Nat.card_perm, hqcard]
    rw [card_alternatingGroup_five, hperm] at hle
    interval_cases h : H.index <;> simp_all [Nat.factorial]
  · -- the kernel is everything, so `H.normalCore = ⊤`, forcing `H = ⊤`
    rw [hker] at hk
    exact hne (top_le_iff.mp (hk ▸ H.normalCore_le))

/-- **A subgroup of `S₅` of order divisible by `15` contains `A₅`.**

The intersection with `A₅` is the kernel of the sign character restricted to `H`, so it has
index dividing `2` in `H`; since `15` is odd its order is still divisible by `15`, and
`subgroup_eq_top_of_fifteen_dvd` identifies it with `A₅`. -/
theorem alternating_le_of_fifteen_dvd {H : Subgroup (Perm (Fin 5))}
    (h15 : 15 ∣ Nat.card H) : alternatingGroup (Fin 5) ≤ H := by
  classical
  set φ : H →* ℤˣ := (Perm.sign).comp H.subtype with hφ
  have hker_index : φ.ker.index ∣ 2 := by
    rw [Subgroup.index_ker]
    have h := Subgroup.card_subgroup_dvd_card φ.range
    simpa using h
  have hmul : Nat.card φ.ker * φ.ker.index = Nat.card H := Subgroup.card_mul_index _
  have h15k : 15 ∣ Nat.card φ.ker := by
    rcases (Nat.dvd_prime Nat.prime_two).mp hker_index with h | h
    · rw [h, mul_one] at hmul; exact hmul ▸ h15
    · rw [h] at hmul
      have h2 : 15 ∣ Nat.card φ.ker * 2 := hmul ▸ h15
      exact Nat.Coprime.dvd_of_dvd_mul_right (by norm_num) h2
  set M := φ.ker.map H.subtype with hM
  have hMle : M ≤ alternatingGroup (Fin 5) := by
    rintro x hx
    obtain ⟨y, hy, rfl⟩ := hx
    exact Perm.mem_alternatingGroup.mpr hy
  have hMH : M ≤ H := Subgroup.map_subtype_le _
  have hcardM : Nat.card M = Nat.card φ.ker :=
    (Nat.card_congr (Subgroup.equivMapOfInjective _ _ Subtype.val_injective).toEquiv).symm
  have htop : M.subgroupOf (alternatingGroup (Fin 5)) = ⊤ := by
    refine subgroup_eq_top_of_fifteen_dvd ?_
    rw [Nat.card_congr (Subgroup.subgroupOfEquivOfLe hMle).toEquiv, hcardM]
    exact h15k
  refine le_trans ?_ hMH
  intro x hx
  have hmem : (⟨x, hx⟩ : alternatingGroup (Fin 5)) ∈ M.subgroupOf (alternatingGroup (Fin 5)) := by
    rw [htop]; trivial
  simpa [Subgroup.mem_subgroupOf] using hmem

end ArtinA5Even
