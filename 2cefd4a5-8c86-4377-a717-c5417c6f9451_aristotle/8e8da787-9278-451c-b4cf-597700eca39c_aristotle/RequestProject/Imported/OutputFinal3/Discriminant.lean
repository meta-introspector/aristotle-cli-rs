/-
Copyright (c) 2026. Released under Apache 2.0 license.
-/
import Mathlib

/-!
# The discriminant of a quintic as a square of a product of root differences

This file provides the elementary bridge between `Polynomial.discr` and the Galois action on the
roots, in the only case we need: a monic quintic that splits into distinct linear factors.

For `F = ∏ i : Fin 5, (X - C (r i))` over a field `L` we set

  `rootDiffProd r = ∏ i, ∏ j > i, (r j - r i)`

(the Vandermonde determinant of `r`) and prove

* `ArtinA5Even.discr_eq_rootDiffProd_sq` : `F.discr = (rootDiffProd r) ^ 2`;
* `ArtinA5Even.rootDiffProd_comp_perm` : `rootDiffProd (r ∘ π) = sign π * rootDiffProd r`;
* `ArtinA5Even.rootDiffProd_ne_zero` : `rootDiffProd r ≠ 0` when `r` is injective;
* `ArtinA5Even.discr_map_of_monic_five` : `discr` commutes with a ring homomorphism, for monic
  quintics.

Together these say: for a monic quintic with a square discriminant, every field automorphism
permutes the roots by an *even* permutation.  Nothing here is specific to the polynomial
`f₁₉₅₁`.
-/

namespace ArtinA5Even

open Polynomial Equiv Finset

/-- The Vandermonde product `∏_{i < j} (r j - r i)` of the differences of five elements; its
square is the discriminant of `∏ i, (X - C (r i))`. -/
noncomputable def rootDiffProd {L : Type*} [CommRing L] (r : Fin 5 → L) : L :=
  ∏ i, ∏ j ∈ Finset.Ioi i, (r j - r i)

section CommRing

variable {L : Type*} [CommRing L]

/-- Permuting the five elements multiplies `rootDiffProd` by the sign of the permutation. -/
theorem rootDiffProd_comp_perm (r : Fin 5 → L) (π : Perm (Fin 5)) :
    rootDiffProd (r ∘ π) = ((Perm.sign π : ℤ) : L) * rootDiffProd r := by
  have h1 := Matrix.det_vandermonde (r ∘ π)
  have h2 := Matrix.det_vandermonde r
  have h3 : Matrix.vandermonde (r ∘ π) = (Matrix.vandermonde r).submatrix π id := by
    ext i j; simp [Matrix.vandermonde]
  rw [rootDiffProd, rootDiffProd, ← h1, h3, Matrix.det_permute, h2]

/-- The `20` off-diagonal differences multiply up to the square of the Vandermonde product. -/
theorem prod_erase_eq_rootDiffProd_sq (r : Fin 5 → L) :
    ∏ i : Fin 5, ∏ j ∈ Finset.univ.erase i, (r i - r j) = (rootDiffProd r) ^ 2 := by
  have hsplit : ∀ i : Fin 5, ∏ j ∈ Finset.univ.erase i, (r i - r j)
      = (∏ j ∈ Finset.Iio i, (r i - r j)) * (∏ j ∈ Finset.Ioi i, (r i - r j)) := by
    intro i
    rw [← Finset.prod_union (by simp [Finset.disjoint_left]; omega)]
    congr 1
    ext j
    simp [Finset.mem_erase]
  -- the differences `r i - r j` with `j < i` reassemble to the Vandermonde product
  have hA : ∏ i : Fin 5, ∏ j ∈ Finset.Iio i, (r i - r j) = rootDiffProd r := by
    refine Finset.prod_comm' (t' := Finset.univ) (s' := fun j => Finset.Ioi j) ?_
    intro x y
    simp [Finset.mem_Iio, Finset.mem_Ioi]
  -- and those with `j > i` do too, the ten sign changes cancelling
  have hB : ∏ i : Fin 5, ∏ j ∈ Finset.Ioi i, (r i - r j) = rootDiffProd r := by
    have hneg : ∀ i : Fin 5, ∏ j ∈ Finset.Ioi i, (r i - r j)
        = (-1 : L) ^ (Finset.Ioi i).card * ∏ j ∈ Finset.Ioi i, (r j - r i) := by
      intro i
      rw [← Finset.prod_const, ← Finset.prod_mul_distrib]
      exact Finset.prod_congr rfl fun j _ => by ring
    rw [Finset.prod_congr rfl fun i _ => hneg i, Finset.prod_mul_distrib, rootDiffProd]
    norm_num [Fin.prod_univ_five, show (Finset.Ioi (0 : Fin 5)).card = 4 from by decide,
      show (Finset.Ioi (1 : Fin 5)).card = 3 from by decide,
      show (Finset.Ioi (2 : Fin 5)).card = 2 from by decide,
      show (Finset.Ioi (3 : Fin 5)).card = 1 from by decide,
      show (Finset.Ioi (4 : Fin 5)).card = 0 from by decide]
  rw [Finset.prod_congr rfl fun i _ => hsplit i, Finset.prod_mul_distrib, hA, hB, sq]

/-- The Vandermonde product commutes with ring homomorphisms. -/
theorem map_rootDiffProd {M : Type*} [CommRing M] {G : Type*} [FunLike G L M]
    [RingHomClass G L M] (φ : G) (r : Fin 5 → L) :
    φ (rootDiffProd r) = rootDiffProd (φ ∘ r) := by
  simp [rootDiffProd, map_prod, map_sub, Function.comp]

end CommRing

/-- For an injective family the Vandermonde product is nonzero. -/
theorem rootDiffProd_ne_zero {L : Type*} [Field L] {r : Fin 5 → L} (hinj : Function.Injective r) :
    rootDiffProd r ≠ 0 := by
  rw [rootDiffProd, Finset.prod_ne_zero_iff]
  intro i _
  rw [Finset.prod_ne_zero_iff]
  intro j hj
  have : i ≠ j := ne_of_lt (Finset.mem_Ioi.mp hj)
  exact sub_ne_zero.mpr fun h => this (hinj h.symm)

/-- **The discriminant of a split monic quintic is the square of the Vandermonde product of its
roots.** -/
theorem discr_eq_rootDiffProd_sq {L : Type*} [Field L] {r : Fin 5 → L}
    (hinj : Function.Injective r) {F : L[X]} (hF : F = ∏ i, (X - C (r i))) :
    F.discr = (rootDiffProd r) ^ 2 := by
  classical
  have hm : F.Monic := by rw [hF]; exact monic_prod_of_monic _ _ fun i _ => monic_X_sub_C _
  have hdeg : F.natDegree = 5 := by
    rw [hF, natDegree_prod _ _ fun i _ => X_sub_C_ne_zero _]
    simp
  have hsplit : F.Splits := by
    rw [hF]; exact Splits.prod fun i _ => Splits.X_sub_C _
  have hroots : F.roots = Multiset.map r Finset.univ.val := by
    rw [hF, show (∏ i, (X - C (r i)))
        = (Multiset.map (fun a => X - C a) (Multiset.map r Finset.univ.val)).prod by
      rw [Multiset.map_map]; rfl]
    exact roots_multiset_prod_X_sub_C _
  have h1 := resultant_deriv (f := F) (by rw [degree_eq_natDegree hm.ne_zero, hdeg]; norm_num)
  rw [hdeg, hm.leadingCoeff] at h1
  norm_num at h1
  have h2 := resultant_eq_prod_eval F (derivative F) 4
    (by have := natDegree_derivative_le F; omega) hsplit
  rw [hdeg, hm.leadingCoeff, one_pow, one_mul, h1] at h2
  rw [h2, hroots, Multiset.map_map, ← prod_erase_eq_rootDiffProd_sq r,
    Finset.prod_eq_multiset_prod]
  congr 1
  refine Multiset.map_congr rfl fun i _ => ?_
  have hmem : r i ∈ F.roots := by
    rw [hroots]; exact Multiset.mem_map_of_mem _ (by simp)
  show eval (r i) (derivative F) = _
  rw [hsplit.eval_root_derivative hm hmem, hroots, ← Multiset.map_erase _ hinj, Multiset.map_map]
  rfl

/-- The discriminant of a monic quintic commutes with base change along a ring homomorphism. -/
theorem discr_map_of_monic_five {R S : Type*} [CommRing R] [CommRing S] [Nontrivial R]
    [Nontrivial S] {f : R[X]}
    (hm : f.Monic) (hdeg : f.natDegree = 5) (φ : R →+* S) :
    (f.map φ).discr = φ f.discr := by
  have hmapdeg : (f.map φ).natDegree = 5 := by rw [hm.natDegree_map, hdeg]
  have hmapm : (f.map φ).Monic := hm.map φ
  have h1 := resultant_deriv (f := f)
    (by rw [degree_eq_natDegree hm.ne_zero, hdeg]; norm_num)
  have h2 := resultant_deriv (f := f.map φ)
    (by rw [degree_eq_natDegree hmapm.ne_zero, hmapdeg]; norm_num)
  rw [hdeg, hm.leadingCoeff] at h1
  rw [hmapdeg, hmapm.leadingCoeff] at h2
  norm_num at h1 h2
  rw [← h2, derivative_map, resultant_map_map, h1]

end ArtinA5Even
