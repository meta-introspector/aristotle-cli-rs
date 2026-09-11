/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import RequestProject.Imported.OutputFinal3.LiftObstruction
import RequestProject.Imported.OutputFinal3.GroupA5

/-!
# `PSL₂(𝔽₅) ≅ A₅`

This module proves the classical exceptional isomorphism

  `ArtinA5Even.psl2F5_equiv_alternating : PSL₂(𝔽₅) ≃* A₅`,

which Mathlib does not contain.  It is a statement of pure finite group theory: nothing
here mentions the Doud–Moore quintic, no Galois representation is constructed, and no
analytic object of any kind appears.

## Strategy

`SL₂(𝔽₅)` has order `120` and contains the *binary tetrahedral* subgroup `2.A₄ ≅ SL₂(𝔽₃)`
of order `24`, here written down as an explicit list of `24` matrices
(`ArtinA5Even.binTetList`) and checked to be a subgroup by exhaustive evaluation.  Its
index is `5`, so the action on the coset space gives a homomorphism

  `ψ : SL₂(𝔽₅) →* Perm (Fin 5)`

whose kernel is the normal core of the subgroup.  Two explicit conjugations suffice to show
that this core is exactly `{±1}`, the centre; hence the induced map `PSL₂(𝔽₅) → Perm (Fin 5)`
is injective and its image has order `60`.  A subgroup of `S₅` of order divisible by `15`
contains `A₅` (`ArtinA5Even.alternating_le_of_fifteen_dvd`, proved from the simplicity of
`A₅`), and both groups have `60` elements, so the image *is* `A₅`.

## Non-claims

Nothing in this file is an arithmetic statement.  In particular, this isomorphism is **not**
composed with `ArtinA5Even.gal1951_equiv_alternating`: matching the conjugacy classes of the
Galois group of `f₁₉₅₁` with those of a subgroup of `PGL₂` is a separate problem, and is not
addressed here.  No Maass form, no `L`-function, no modularity, no `axiom`.
-/

namespace ArtinA5Even

open Matrix Subgroup Equiv

set_option maxRecDepth 100000

/-! ## The binary tetrahedral subgroup `2.A₄ ⊂ SL₂(𝔽₅)`

The `24` elements below are the closure of the quaternion group
`{±1, ±i, ±j, ±k}` (with `i = !![2,0;0,3]`, `j = !![0,4;1,0]`) together with the order-three
element `!![4,1;2,2]`. -/

/-- The `24` elements of the binary tetrahedral subgroup `SL₂(𝔽₃) ⊂ SL₂(𝔽₅)`. -/
def binTetList : List SL2F5 :=
  [⟨!![0,1;4,0], by decide⟩, ⟨!![0,2;2,0], by decide⟩, ⟨!![0,3;3,0], by decide⟩,
   ⟨!![0,4;1,0], by decide⟩, ⟨!![1,0;0,1], by decide⟩, ⟨!![1,1;2,3], by decide⟩,
   ⟨!![1,2;1,3], by decide⟩, ⟨!![1,3;4,3], by decide⟩, ⟨!![1,4;3,3], by decide⟩,
   ⟨!![2,0;0,3], by decide⟩, ⟨!![2,1;2,4], by decide⟩, ⟨!![2,2;1,4], by decide⟩,
   ⟨!![2,3;4,4], by decide⟩, ⟨!![2,4;3,4], by decide⟩, ⟨!![3,0;0,2], by decide⟩,
   ⟨!![3,1;2,1], by decide⟩, ⟨!![3,2;1,1], by decide⟩, ⟨!![3,3;4,1], by decide⟩,
   ⟨!![3,4;3,1], by decide⟩, ⟨!![4,0;0,4], by decide⟩, ⟨!![4,1;2,2], by decide⟩,
   ⟨!![4,2;1,2], by decide⟩, ⟨!![4,3;4,2], by decide⟩, ⟨!![4,4;3,2], by decide⟩]

set_option maxHeartbeats 1000000 in
theorem binTetList_mul : ∀ a ∈ binTetList, ∀ b ∈ binTetList, a * b ∈ binTetList := by decide

theorem binTetList_inv : ∀ a ∈ binTetList, a⁻¹ ∈ binTetList := by decide

theorem binTetList_one : (1 : SL2F5) ∈ binTetList := by decide

theorem binTetList_nodup : binTetList.Nodup := by decide

/-- The binary tetrahedral subgroup `2.A₄ ≅ SL₂(𝔽₃)` of `SL₂(𝔽₅)`, of order `24`. -/
def binTet : Subgroup SL2F5 where
  carrier := {A | A ∈ binTetList}
  mul_mem' ha hb := binTetList_mul _ ha _ hb
  one_mem' := binTetList_one
  inv_mem' ha := binTetList_inv _ ha

theorem mem_binTet {A : SL2F5} : A ∈ binTet ↔ A ∈ binTetList := by
  simp [binTet]

/-- `|2.A₄| = 24`. -/
theorem card_binTet : Nat.card binTet = 24 := by
  have hset : (binTet : Set SL2F5) = ↑binTetList.toFinset :=
    (List.coe_toFinset binTetList).symm
  have h : Nat.card ((binTet : Set SL2F5)) = 24 := by
    rw [Nat.card_coe_set_eq, hset, Set.ncard_eq_toFinset_card']
    simp
    rfl
  exact h

/-- `2.A₄` has index `5` in `SL₂(𝔽₅)`. -/
theorem index_binTet : binTet.index = 5 := by
  have h := Subgroup.card_mul_index binTet
  rw [card_binTet, card_SL2F5] at h
  omega

/-- The coset space `SL₂(𝔽₅) / 2.A₄` has five elements. -/
theorem card_quotient_binTet : Nat.card (SL2F5 ⧸ binTet) = 5 := index_binTet

/-! ## The normal core of `2.A₄` is the centre -/

/-- First test conjugator. -/
def conj₁ : SL2F5 := ⟨!![0,1;4,1], by decide⟩

/-- Second test conjugator. -/
def conj₂ : SL2F5 := ⟨!![0,1;4,2], by decide⟩

/-- Two explicit conjugations already cut the binary tetrahedral subgroup down to `{±1}`. -/
theorem binTet_core_aux :
    ∀ g ∈ binTetList, conj₁ * g * conj₁⁻¹ ∈ binTetList → conj₂ * g * conj₂⁻¹ ∈ binTetList →
      g = 1 ∨ g = -1 := by decide

/-- **The normal core of the binary tetrahedral subgroup is the centre `{±1}`.** -/
theorem normalCore_binTet : binTet.normalCore = Subgroup.center SL2F5 := by
  apply le_antisymm
  · intro g hg
    have hg' : ∀ b : SL2F5, b * g * b⁻¹ ∈ binTet := hg
    have h1 : g ∈ binTetList := by
      have := hg' 1
      rw [mem_binTet] at this
      simpa using this
    have h2 : conj₁ * g * conj₁⁻¹ ∈ binTetList := mem_binTet.mp (hg' _)
    have h3 : conj₂ * g * conj₂⁻¹ ∈ binTetList := mem_binTet.mp (hg' _)
    rcases binTet_core_aux g h1 h2 h3 with h | h
    · exact h ▸ Subgroup.one_mem _
    · exact mem_center_SL2_iff.mpr (Or.inr h)
  · intro g hg
    show ∀ b : SL2F5, b * g * b⁻¹ ∈ binTet
    intro b
    rcases mem_center_SL2_iff.mp hg with rfl | rfl
    · rw [mul_one, mul_inv_cancel, mem_binTet]
      exact binTetList_one
    · have hb : b * (-1 : SL2F5) * b⁻¹ = -1 := by
        rw [mul_neg_one, neg_mul, mul_inv_cancel]
      rw [hb, mem_binTet]
      decide

/-! ## The permutation representation on the five cosets -/

/-- The action of `SL₂(𝔽₅)` on the five cosets of the binary tetrahedral subgroup. -/
noncomputable def permRepF5 : SL2F5 →* Perm (SL2F5 ⧸ binTet) :=
  MulAction.toPermHom SL2F5 (SL2F5 ⧸ binTet)

/-- A relabelling of the five cosets by `Fin 5`. -/
noncomputable def cosetEquivFin : (SL2F5 ⧸ binTet) ≃ Fin 5 :=
  Finite.equivFinOfCardEq card_quotient_binTet

/-- The permutation representation of `SL₂(𝔽₅)` on five letters. -/
noncomputable def permRepFin5 : SL2F5 →* Perm (Fin 5) :=
  (Equiv.permCongrHom cosetEquivFin).toMonoidHom.comp permRepF5

/-- The kernel of the five-point permutation representation is the centre `{±1}`. -/
theorem ker_permRepFin5 : permRepFin5.ker = Subgroup.center SL2F5 := by
  have hker : permRepF5.ker = Subgroup.center SL2F5 := by
    rw [permRepF5, ← Subgroup.normalCore_eq_ker]
    exact normalCore_binTet
  rw [← hker]
  ext g
  simp only [MonoidHom.mem_ker, permRepFin5, MonoidHom.coe_comp, Function.comp_apply,
    MulEquiv.coe_toMonoidHom, map_eq_one_iff _ (Equiv.permCongrHom cosetEquivFin).injective]

/-- The image of `SL₂(𝔽₅)` in `S₅` has `60` elements. -/
theorem card_range_permRepFin5 : Nat.card permRepFin5.range = 60 := by
  have h1 : Nat.card (SL2F5 ⧸ permRepFin5.ker) = Nat.card permRepFin5.range :=
    Nat.card_congr (QuotientGroup.quotientKerEquivRange permRepFin5).toEquiv
  have h2 : Nat.card (SL2F5 ⧸ permRepFin5.ker) = permRepFin5.ker.index := rfl
  rw [ker_permRepFin5] at h1 h2
  have h3 := Subgroup.card_mul_index (Subgroup.center SL2F5)
  rw [card_center_SL2F5, card_SL2F5] at h3
  omega

/-- **The image of `SL₂(𝔽₅)` in `S₅` is exactly `A₅`.** -/
theorem range_permRepFin5 : permRepFin5.range = alternatingGroup (Fin 5) := by
  have hle : alternatingGroup (Fin 5) ≤ permRepFin5.range :=
    alternating_le_of_fifteen_dvd (by rw [card_range_permRepFin5]; norm_num)
  have e1 : (permRepFin5.range : Set (Perm (Fin 5))).ncard = 60 := by
    rw [← Nat.card_coe_set_eq]; exact card_range_permRepFin5
  have e2 : (alternatingGroup (Fin 5) : Set (Perm (Fin 5))).ncard = 60 := by
    rw [← Nat.card_coe_set_eq]; exact card_alternatingGroup_five
  have hcards : (permRepFin5.range : Set (Perm (Fin 5))).ncard ≤
      (alternatingGroup (Fin 5) : Set (Perm (Fin 5))).ncard := by
    rw [e1, e2]
  have hset : (alternatingGroup (Fin 5) : Set (Perm (Fin 5))) =
      (permRepFin5.range : Set (Perm (Fin 5))) :=
    Set.eq_of_subset_of_ncard_le hle hcards (Set.toFinite _)
  exact (SetLike.coe_set_eq.mp hset).symm

/-- **`PSL₂(𝔽₅) ≅ A₅`.**

The exceptional isomorphism between the projective special linear group over the field with
five elements and the alternating group on five letters.  This is a purely group-theoretic
statement; it is not combined with the Galois group of `f₁₉₅₁` anywhere. -/
noncomputable def psl2F5_equiv_alternating : PSL2F5 ≃* alternatingGroup (Fin 5) :=
  (QuotientGroup.quotientMulEquivOfEq ker_permRepFin5.symm).trans
    ((QuotientGroup.quotientKerEquivRange permRepFin5).trans
      (MulEquiv.subgroupCongr range_permRepFin5))

/-- `PSL₂(𝔽₅) ≅ A₅`, stated as an inhabited type of isomorphisms. -/
theorem nonempty_psl2F5_equiv_alternating :
    Nonempty (PSL2F5 ≃* alternatingGroup (Fin 5)) :=
  ⟨psl2F5_equiv_alternating⟩

end ArtinA5Even
