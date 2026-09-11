/-
# Weighted Subgroup Lattice

This file formalizes the mathematical content of the Magma `SLat` procedure,
which computes the weighted subgroup lattice of a finite group.

The weighted subgroup lattice consists of:
- Conjugacy classes of subgroups (represented by canonical representatives)
- For each class, the number of conjugates (= index of normalizer in G)
- For each inclusion pair (H maximal in K, up to conjugacy), a weight
  counting the number of G-conjugates of H that are maximal in K

## Main definitions

- `SubgroupConj`: two subgroups are conjugate if one is the image of the other
  under an inner automorphism
- `conjugates`: the set of all conjugates of a subgroup
- `IsMaximalIn`: H is a maximal proper subgroup of K
- `maximalConjugatesIn`: the set of conjugates of H that are maximal in K
- `inclusionWeight`: the weight associated to a maximal inclusion pair

## Main results

- `SubgroupConj.equivalence`: conjugacy is an equivalence relation
- `SubgroupConj.card_eq`: conjugate subgroups have the same cardinality
- `numConjugates_eq_index_normalizer`: |conjugates H| = [G : N_G(H)]
- `normalizer_index_conj_eq`: conjugate subgroups have equal normalizer indices
-/

import Mathlib

noncomputable section

open Subgroup

variable {G : Type*} [Group G]

/-! ## Conjugation of subgroups -/

/-- The conjugate of a subgroup H by an element g, i.e., gHg⁻¹. -/
def Subgroup.conjBy (H : Subgroup G) (g : G) : Subgroup G :=
  H.map (MulAut.conj g).toMonoidHom

/-- Two subgroups are conjugate if one is the image of the other under conjugation by
some element of the group. This is the key equivalence relation used to partition
subgroups into conjugacy classes in the lattice computation. -/
def SubgroupConj (H K : Subgroup G) : Prop :=
  ∃ g : G, H.conjBy g = K

/-
Conjugacy of subgroups is reflexive.
-/
theorem SubgroupConj.refl (H : Subgroup G) : SubgroupConj H H := by
  -- Take g to be the identity element in G.
  use 1; simp [Subgroup.conjBy];
  aesop

/-
Conjugacy of subgroups is symmetric.
-/
theorem SubgroupConj.symm {H K : Subgroup G} (h : SubgroupConj H K) :
    SubgroupConj K H := by
  obtain ⟨ g, rfl ⟩ := h;
  use g⁻¹;
  unfold Subgroup.conjBy;
  simp +decide [ ← mul_assoc, SetLike.ext_iff ]

/-
Conjugacy of subgroups is transitive.
-/
theorem SubgroupConj.trans {H K L : Subgroup G} (h₁ : SubgroupConj H K)
    (h₂ : SubgroupConj K L) : SubgroupConj H L := by
  obtain ⟨ g₁, rfl ⟩ := h₁
  obtain ⟨ g₂, rfl ⟩ := h₂
  use g₂ * g₁;
  unfold Subgroup.conjBy;
  ext; simp +decide [ mul_assoc ] ;

/-- Conjugacy of subgroups is an equivalence relation. -/
theorem SubgroupConj.equivalence : Equivalence (SubgroupConj (G := G)) :=
  ⟨SubgroupConj.refl, SubgroupConj.symm, SubgroupConj.trans⟩

/-
Conjugate subgroups have the same cardinality.
-/
theorem SubgroupConj.card_eq {H K : Subgroup G} (h : SubgroupConj H K) :
    Nat.card H = Nat.card K := by
  obtain ⟨ g, hg ⟩ := h;
  rw [ ← hg ];
  fapply Nat.card_congr;
  refine' Equiv.ofBijective ( fun y => ⟨ g * y * g⁻¹, y, y.2, by simp +decide ⟩ ) ⟨ fun y => _, fun y => _ ⟩ <;> aesop

/-! ## The conjugacy class of a subgroup -/

/-- The set of all conjugates of a subgroup H in G. This is the orbit of H
under the conjugation action. -/
def conjugates (H : Subgroup G) : Set (Subgroup G) :=
  {K : Subgroup G | SubgroupConj H K}

/-! ## Normalizer and number of conjugates -/

/-
The number of conjugates of H in G equals the index of its normalizer.
This is the orbit-stabilizer theorem specialized to the conjugation action on
subgroups. It corresponds to the Magma expression
`Truncate(#G / #Normalizer(G, H))`.
-/
theorem numConjugates_eq_index_normalizer [Finite G] (H : Subgroup G) :
    Nat.card (conjugates H) = H.normalizer.index := by
  fapply Nat.card_congr;
  refine' Equiv.ofBijective ( fun x => QuotientGroup.mk ( Classical.choose x.2 ) ) ⟨ _, _ ⟩;
  · intro x y hxy;
    -- If the cosets are equal, then there exists some $n \in N_G(H)$ such that $g = hn$ for some $h \in G$.
    obtain ⟨n, hn⟩ : ∃ n ∈ H.normalizer, Classical.choose x.2 = Classical.choose y.2 * n := by
      rw [ QuotientGroup.eq ] at hxy ; aesop;
    have h_conj : H.conjBy (Classical.choose x.2) = H.conjBy (Classical.choose y.2) := by
      ext h;
      simp +decide [ hn.2, Subgroup.conjBy ];
      constructor <;> rintro ⟨ x, hx, rfl ⟩;
      · exact ⟨ n * x * n⁻¹, by simpa [ mul_assoc ] using hn.1 x |>.1 hx, by group ⟩;
      · have := hn.1 ( n⁻¹ * x * n ) ; simp_all +decide [ mul_assoc, Subgroup.mul_mem_cancel_left, Subgroup.mul_mem_cancel_right ] ;
        exact ⟨ n⁻¹ * ( x * n ), this, by group ⟩;
    exact Subtype.ext ( Classical.choose_spec x.2 ▸ Classical.choose_spec y.2 ▸ h_conj );
  · intro x;
    obtain ⟨ g, rfl ⟩ := QuotientGroup.mk_surjective x;
    refine' ⟨ ⟨ _, ⟨ g, rfl ⟩ ⟩, _ ⟩;
    rw [ QuotientGroup.eq ];
    have := Classical.choose_spec ( show ∃ g' : G, H.conjBy g' = H.conjBy g from ⟨ g, rfl ⟩ );
    intro h; replace this := SetLike.ext_iff.mp this ( g * h * g⁻¹ ) ; simp_all +decide [ mul_assoc, Subgroup.mem_map ] ;
    simp_all +decide [ Subgroup.conjBy, mul_assoc ];
    simp_all +decide [ ← mul_assoc, eq_inv_mul_iff_mul_eq ];
    constructor <;> intro hh <;> simp_all +decide [ mul_assoc, Subgroup.mul_mem_cancel_left, Subgroup.mul_mem_cancel_right ];
    · obtain ⟨ x, hx, hx' ⟩ := this; simp_all +decide [ ← mul_assoc ] ;
      simp +decide [ ← hx', mul_assoc, hx ];
    · exact this.mp ⟨ _, hh, by group ⟩

/-! ## Maximal subgroups -/

/-- A subgroup H is maximal in K if H is a proper subgroup of K and there is no
subgroup strictly between them. This captures the maximality relation used in the
`SLat` procedure when it computes `MaximalSubgroups`. -/
def IsMaximalIn (H K : Subgroup G) : Prop :=
  H < K ∧ ∀ L : Subgroup G, H ≤ L → L ≤ K → L = H ∨ L = K

/-
If H is maximal in K, then any conjugate of H by an element normalizing K
is also maximal in K. This is key for counting maximal subgroup inclusions
within a conjugacy class.
-/
theorem IsMaximalIn.conj {H K : Subgroup G} (hHK : IsMaximalIn H K)
    (g : G) (hg : g ∈ K.normalizer) :
    IsMaximalIn (H.conjBy g) K := by
  constructor;
  · simp_all +decide [ lt_iff_le_and_ne, Subgroup.conjBy ];
    constructor;
    · intro x hx;
      obtain ⟨ y, hy, rfl ⟩ := hx;
      exact hg y |>.1 ( hHK.1.1 hy );
    · intro h;
      have := hHK.1.2;
      contrapose! this;
      intro x hx; replace h := SetLike.ext_iff.mp h ( g * x * g⁻¹ ) ; simp_all +decide [ mul_assoc ] ;
      simpa [ mul_assoc ] using hg x |>.1 hx;
  · intro L hL₁ hL₂;
    have hL_conj : (Subgroup.map (MulAut.conj g⁻¹).toMonoidHom L) = H ∨ (Subgroup.map (MulAut.conj g⁻¹).toMonoidHom L) = K := by
      refine' hHK.2 _ _ _;
      · intro x hx;
        exact ⟨ g * x * g⁻¹, hL₁ ( by simpa [ Subgroup.conjBy ] using hx ), by simp +decide [ mul_assoc ] ⟩;
      · intro x hx;
        obtain ⟨ y, hy, rfl ⟩ := hx;
        have := hg ( g⁻¹ * y * g ) ; simp_all +decide [ mul_assoc, Subgroup.mul_mem_cancel_left, Subgroup.mul_mem_cancel_right ] ;
        exact hL₂ hy;
    cases' hL_conj with h h;
    · left;
      convert congr_arg ( Subgroup.map ( MulAut.conj g ).toMonoidHom ) h using 1;
      ext x; simp +decide [ mul_assoc ] ;
    · have hL_conj : L = Subgroup.map (MulAut.conj g).toMonoidHom K := by
        rw [ ← h ];
        ext x; simp +decide [ mul_assoc ] ;
      refine' Or.inr ( le_antisymm hL₂ _ );
      intro x hx;
      exact hL_conj.symm ▸ ⟨ g⁻¹ * x * g, by simpa [ mul_assoc ] using hg ( g⁻¹ * x * g ) |>.2 ( by simpa [ mul_assoc ] using hx ), by simp +decide [ mul_assoc ] ⟩

/-! ## Weighted inclusion counts -/

/-- The set of conjugates of H that are maximal subgroups of K. The cardinality of
this set gives the weight in the subgroup lattice. -/
def maximalConjugatesIn (H K : Subgroup G) : Set (Subgroup G) :=
  {L : Subgroup G | SubgroupConj H L ∧ IsMaximalIn L K}

/-- The inclusion weight: the number of conjugates of H that are maximal in K.
This corresponds to the `weight` field accumulated in the Magma `SLat` procedure. -/
def inclusionWeight (H K : Subgroup G) : ℕ :=
  Nat.card (maximalConjugatesIn H K)

/-! ## Properties of conjugacy class sizes -/

/-
Conjugate subgroups have conjugate normalizers.
-/
theorem normalizer_conjBy (H : Subgroup G) (g : G) :
    (H.conjBy g).normalizer = H.normalizer.conjBy g := by
  ext x;
  unfold Subgroup.conjBy;
  constructor;
  · intro hx;
    refine' ⟨ g⁻¹ * x * g, _, _ ⟩ <;> simp_all +decide [ mul_assoc, Subgroup.mem_normalizer_iff ];
    intro h; specialize hx ( g * ( h * g⁻¹ ) ) ; simp_all +decide [ ← mul_assoc ] ;
    constructor <;> intro h <;> simp_all +decide [ mul_assoc, eq_inv_mul_iff_mul_eq ];
    · obtain ⟨ y, hy, hy' ⟩ := h; simp_all +decide [ ← mul_assoc ] ;
      convert hy using 1 ; simp +decide [ ← hy', mul_assoc ];
      simp +decide [ ← mul_assoc, ← hy' ];
    · exact ⟨ _, h, by group ⟩;
  · rintro ⟨ y, hy, rfl ⟩;
    intro h; constructor <;> intro hh;
    · obtain ⟨ k, hk, rfl ⟩ := hh;
      exact ⟨ y * k * y⁻¹, hy k |>.1 hk, by simp +decide [ mul_assoc ] ⟩;
    · simp_all +decide [ ← mul_assoc, Subgroup.mem_map ];
      obtain ⟨ x, hx, hx' ⟩ := hh; use y⁻¹ * x * y; simp_all +decide [ mul_assoc, Subgroup.mul_mem_cancel_left, Subgroup.mul_mem_cancel_right ] ;
      have := hy ( g⁻¹ * ( h * g ) ) ; simp_all +decide [ mul_assoc, Subgroup.mul_mem_cancel_left, Subgroup.mul_mem_cancel_right ] ;

/-
Conjugate subgroups have the same normalizer index, hence the same number of
conjugates. This justifies treating conjugacy classes uniformly in the lattice.
-/
theorem normalizer_index_conj_eq (H : Subgroup G) (g : G) :
    (H.conjBy g).normalizer.index = H.normalizer.index := by
  convert Subgroup.index_map_equiv ( H.normalizer ) ( MulAut.conj g ) using 1;
  rw [ normalizer_conjBy ];
  rfl

/-! ## Weight formula

The adjusted weight formula from the Magma `SLat` procedure is:
If class `a[1]` contains K and class `a[2]` contains H, with H maximal in K,
then the raw weight `a[3]` counts how many G-conjugates of H sit maximally inside K.
The adjusted weight is:
  `[G : N_G(K)] * a[3] / [G : N_G(H)]`

This normalization accounts for the fact that we're counting inclusions between
conjugacy classes rather than individual subgroups: each conjugate of K contributes
the same number of maximal subgroups conjugate to H, and the adjusted weight gives
this per-copy count.

Mathematically, for a fixed K:
  inclusionWeight H K = |{gHg⁻¹ : g ∈ G, gHg⁻¹ maximal in K}|

And the adjusted weight satisfies:
  adjustedWeight = inclusionWeight H K * [G:N_G(K)] / [G:N_G(H)]
                 = (number of conjugates of K in which a fixed conjugate of H is maximal)
-/

end