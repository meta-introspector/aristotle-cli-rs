/-
# Weighted Subgroup Lattice
This file formalizes the mathematical content of the Magma SLat procedure,
which computes the weighted subgroup lattice of a finite group.

## Main definitions
- `Subgroup.conjBy`: the conjugate gHg⁻¹ of a subgroup H by an element g
- `SubgroupConj`: two subgroups are conjugate
- `conjugates`: the set of all conjugates of a subgroup (orbit under conjugation)
- `IsMaximalIn`: H is a maximal proper subgroup of K
- `maximalConjugatesIn`: conjugates of H that are maximal in K
- `inclusionWeight`: cardinality of maximalConjugatesIn

## Main results
- `SubgroupConj.equivalence`: conjugacy is an equivalence relation
- `SubgroupConj.card_eq`: conjugate subgroups have the same cardinality
- `numConjugates_eq_index_normalizer`: |conjugates H| = [G : N_G(H)]
- `normalizer_conjBy`: N_G(gHg⁻¹) = gN_G(H)g⁻¹
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

/-- Two subgroups are conjugate if one is the image of the other under conjugation. -/
def SubgroupConj (H K : Subgroup G) : Prop :=
  ∃ g : G, H.conjBy g = K

theorem SubgroupConj.refl (H : Subgroup G) : SubgroupConj H H := by
  -- The identity element is in G, and conjugating H by the identity element gives H itself.
  use 1
  simp [Subgroup.conjBy];
  -- The identity map sends every element to itself, so the image of H under the identity map is H itself.
  ext; simp [MonoidHom.id]

theorem SubgroupConj.symm {H K : Subgroup G} (h : SubgroupConj H K) :
    SubgroupConj K H := by
  -- By definition of conjugacy, if $H$ is conjugate to $K$ via $g$, then $K$ is conjugate to $H$ via $g^{-1}$.
  obtain ⟨g, hg⟩ := h;
  use g⁻¹;
  simp [hg, Subgroup.conjBy];
  rw [ ← hg, Subgroup.conjBy ];
  -- By definition of conjugation, we know that $(g⁻¹) * (g * h * g⁻¹) * g = h$ for any $h \in H$.
  ext h
  simp [MulAut.conj];
  -- By simplifying, we can see that $g⁻¹ * (g * a * g⁻¹) * g = a$.
  simp [mul_assoc, mul_inv_cancel_left, mul_inv_cancel_right]

theorem SubgroupConj.trans {H K L : Subgroup G} (h₁ : SubgroupConj H K)
    (h₂ : SubgroupConj K L) : SubgroupConj H L := by
  -- By definition of conjugacy, there exist elements $g$ and $h$ such that $H = gKg^{-1}$ and $K = hLh^{-1}$.
  obtain ⟨g, hg⟩ := h₁
  obtain ⟨h, hh⟩ := h₂;
  -- By transitivity of conjugacy, if H is conjugate to K and K is conjugate to L, then H is conjugate to L.
  use h * g;
  -- By definition of conjugation, we have $(H.conjBy g).conjBy h = H.conjBy (h * g)$.
  have h_conj_assoc : (H.conjBy g).conjBy h = H.conjBy (h * g) := by
    ext; simp [Subgroup.conjBy];
  grobner

/-- Conjugacy of subgroups is an equivalence relation. -/
theorem SubgroupConj.equivalence : Equivalence (SubgroupConj (G := G)) :=
  ⟨SubgroupConj.refl, SubgroupConj.symm, SubgroupConj.trans⟩

theorem SubgroupConj.card_eq {H K : Subgroup G} (h : SubgroupConj H K) :
    Nat.card H = Nat.card K := by
  -- Since conjugation by a fixed element is an automorphism of the group, the cardinality of H is equal to the cardinality of K.
  have h_bij : Nonempty (H ≃ K) := by
    -- Since conjugation by g is an automorphism of the group, the image of a subgroup under this automorphism should have the same cardinality as the original subgroup.
    have h_iso : Nonempty (↥H ≃ ↥(H.map (MulAut.conj h.choose).toMonoidHom)) := by
      refine' ⟨ Equiv.ofBijective ( fun x => ⟨ _, Set.mem_image_of_mem _ x.2 ⟩ ) ⟨ fun x y hxy => _, fun x => _ ⟩ ⟩ <;> aesop;
    have := h.choose_spec;
    exact this ▸ h_iso;
  exact Nat.card_congr h_bij.some

/-! ## The conjugacy class of a subgroup -/

/-- The set of all conjugates of a subgroup H in G. -/
def conjugates (H : Subgroup G) : Set (Subgroup G) :=
  {K : Subgroup G | SubgroupConj H K}

/-! ## Normalizer and number of conjugates -/

/-
The number of conjugates of H equals the index of its normalizer (orbit-stabilizer).
-/
theorem numConjugates_eq_index_normalizer [Finite G] (H : Subgroup G) :
    Nat.card (conjugates H) = H.normalizer.index := by
  rw [ ← Nat.card_congr ];
  rw [ Subgroup.index_eq_card ];
  refine' Equiv.ofBijective ( fun x => ⟨ _, _, rfl ⟩ ) ⟨ _, _ ⟩;
  exact Quotient.out x;
  · intro x y hxy
    simp [Subgroup.conjBy] at hxy;
    rw [ ← Quotient.out_eq' x, ← Quotient.out_eq' y ];
    rw [ QuotientGroup.eq ];
    intro h; simp_all +decide [ Subgroup.mem_normalizer_iff, SetLike.ext_iff ] ;
    constructor <;> intro hh <;> specialize hxy ( Quotient.out x * ( ( Quotient.out x ) ⁻¹ * Quotient.out y * h * ( ( Quotient.out y ) ⁻¹ * Quotient.out x ) ) * ( Quotient.out x ) ⁻¹ ) <;> simp_all +decide [ mul_assoc ];
    · obtain ⟨ k, hk, hk' ⟩ := hxy; simp_all +decide [ ← mul_assoc ] ;
      simp +decide [ ← hk', mul_assoc, hk ];
    · exact hxy.mp ⟨ _, hh, by group ⟩;
  · intro ⟨ K, hK ⟩;
    obtain ⟨ g, rfl ⟩ := hK;
    refine' ⟨ QuotientGroup.mk g, _ ⟩;
    simp +decide [ Subgroup.conjBy ];
    -- Since $g$ and $g'$ are in the same coset of $N_G(H)$, we have $g' = gh$ for some $h \in N_G(H)$.
    obtain ⟨h, hh⟩ : ∃ h : G, Quotient.out (g : G ⧸ H.normalizer) = g * h ∧ h ∈ H.normalizer := by
      have := QuotientGroup.eq.1 ( Quotient.out_eq' ( g : G ⧸ H.normalizer ) );
      exact ⟨ ( ( Quotient.out ( g : G ⧸ H.normalizer ) ) ⁻¹ * g ) ⁻¹, by group, by simpa using Subgroup.inv_mem _ this ⟩;
    simp +decide [ hh, map_map ];
    ext x; simp +decide [ hh.2 ] ;
    constructor <;> rintro ⟨ y, hy, rfl ⟩;
    · exact ⟨ h * y * h⁻¹, by simpa [ mul_assoc ] using hh.2 y |>.1 hy, rfl ⟩;
    · exact ⟨ h⁻¹ * y * h, by simpa [ mul_assoc ] using hh.2 ( h⁻¹ * y * h ) |>.2 ( by simpa [ mul_assoc ] using hy ), by group ⟩

/-! ## Maximal subgroups -/

/-- H is maximal in K if H < K with no subgroup strictly between. -/
def IsMaximalIn (H K : Subgroup G) : Prop :=
  H < K ∧ ∀ L : Subgroup G, H ≤ L → L ≤ K → L = H ∨ L = K

/-
Conjugation by a normalizer element preserves maximality.
-/
theorem IsMaximalIn.conj {H K : Subgroup G} (hHK : IsMaximalIn H K)
    (g : G) (hg : g ∈ K.normalizer) :
    IsMaximalIn (H.conjBy g) K := by
  refine' ⟨ _, fun L hL hLK => _ ⟩;
  · refine' lt_of_le_of_ne _ _;
    · rintro _ ⟨ x, hx, rfl ⟩;
      exact hg x |>.1 ( hHK.1.le hx ) |> fun h => by simpa [ mul_assoc ] using h;
    · simp_all +decide [ IsMaximalIn, SetLike.ext_iff ];
      obtain ⟨ x, hx ⟩ := SetLike.exists_of_lt hHK.1;
      refine' ⟨ g * x * g⁻¹, _ ⟩ ; simp_all +decide [ Subgroup.conjBy ];
      exact hg x |>.1 hx.1;
  · -- By maximality of H in K, we have g⁻¹Lg = H or g⁻¹Lg = K.
    have h_max : (H.map (MulAut.conj g).toMonoidHom) ≤ L → (L.map (MulAut.conj g⁻¹).toMonoidHom = H ∨ L.map (MulAut.conj g⁻¹).toMonoidHom = K) := by
      intro h;
      apply hHK.2;
      · intro x hx;
        exact ⟨ g * x * g⁻¹, h ( Set.mem_image_of_mem _ hx ), by simp +decide [ mul_assoc ] ⟩;
      · intro x hx;
        obtain ⟨ y, hy, rfl ⟩ := hx;
        have := hg ( g⁻¹ * y * g ) ; simp_all +decide [ mul_assoc ] ;
        exact hLK hy;
    cases' h_max hL with h h <;> [ left; right ] <;> refine' le_antisymm _ _ <;> simp_all +decide [ SetLike.le_def ];
    · intro x hx; replace h := SetLike.ext_iff.mp h ( g⁻¹ * x * g ) ; simp_all +decide [ mul_assoc, Subgroup.mem_map ] ;
      exact ⟨ _, h, by simp +decide [ mul_assoc ] ⟩;
    · intro x hx; replace h := SetLike.ext_iff.mp h ( g⁻¹ * x * g ) ; simp_all +decide [ mul_assoc ] ;
      have := hg ( g⁻¹ * ( x * g ) ) ; simp_all +decide [ mul_assoc, Subgroup.mul_mem_cancel_left, Subgroup.mul_mem_cancel_right ] ;

/-! ## Weighted inclusion counts -/

/-- The set of conjugates of H that are maximal subgroups of K. -/
def maximalConjugatesIn (H K : Subgroup G) : Set (Subgroup G) :=
  {L : Subgroup G | SubgroupConj H L ∧ IsMaximalIn L K}

/-- The inclusion weight: the number of conjugates of H that are maximal in K. -/
def inclusionWeight (H K : Subgroup G) : ℕ :=
  Nat.card (maximalConjugatesIn H K)

/-! ## Normalizer conjugation -/

/-
The normalizer of gHg⁻¹ is gN_G(H)g⁻¹.
-/
theorem normalizer_conjBy (H : Subgroup G) (g : G) :
    (H.conjBy g).normalizer = H.normalizer.conjBy g := by
  unfold Subgroup.conjBy;
  grind +suggestions

/-
Conjugate subgroups have the same normalizer index.
-/
theorem normalizer_index_conj_eq (H : Subgroup G) (g : G) :
    (H.conjBy g).normalizer.index = H.normalizer.index := by
  have h_conj : (H.conjBy g).normalizer = H.normalizer.conjBy g := by
    exact normalizer_conjBy H g;
  rw [ h_conj ];
  convert Subgroup.index_map_equiv H.normalizer ( MulAut.conj g ) using 1

end