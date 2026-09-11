/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Grounding the Euler factors of `RequestProject/A5Artin.lean` in the actual
permutation representations: the five-point representation of `A₅` and the
regular representation.
-/
import Mathlib
import RequestProject.Imported.OutputFinal.RequestProject.A5Artin

/-!
# The Euler factors of `A₅` as honest determinants

`RequestProject/A5Artin.lean` records the local Artin factors of the
irreducible representations of `A₅` as an explicit table, and proves the
factorisation identities

* `permPoly5 c T = (1 - T) * E4 c T`,
* `regPoly c T = (1 - T) * (E3E3b c T)^3 * (E4 c T)^4 * (E5 c T)^5`

class by class.  In this file we show that the two left-hand sides of those
identities really *are* the characteristic-polynomial-type invariants
`det(1 - ρ(g) T)` of the corresponding representations of `A₅`, so that the
identities become statements about representations and not about a table.

Main definitions and results:

* `A5Artin.eulerOf σ T = det (1 - T • P_σ)`, the local factor of the
  permutation representation attached to a permutation `σ`;
* `A5Artin.eulerOf_permCongr`, `A5Artin.eulerOf_prodCongr_refl`: invariance
  under relabelling, and the block-diagonal product rule;
* `A5Artin.eulerOf_finRotate_*`: the cyclic factors `1 - T^d` for `d = 1,2,3,5`;
* `A5Artin.eulerOf_mulRight`: for the regular representation of a finite group
  `G`, `det(1 - T ρ_reg(g)) = (1 - T^d)^{|G|/d}` with `d = orderOf g`;
* `A5Artin.rep`: explicit representatives of the five conjugacy classes of
  `A₅` inside `Equiv.Perm (Fin 5)`, with their orders;
* `A5Artin.eulerOf_rep`: `det(1 - T ρ₅pt(rep c)) = permPoly5 c T`;
* `A5Artin.permPoly5_det_eq`: hence `det(1 - T ρ₅pt(rep c)) = (1 - T) E4 c T`;
* `A5Artin.eulerOf_regular_eq_regPoly` and `A5Artin.regPoly_det_eq`: the same
  for the regular representation of `A₅` and the full Artin factorisation.
-/

namespace A5Artin

open Matrix Equiv Cls

/-- The local factor `det(1 - T · P_σ)` of the permutation representation
attached to a permutation `σ` of a finite set. -/
def eulerOf {n : Type*} [Fintype n] [DecidableEq n] {R : Type*} [CommRing R]
    (σ : Perm n) (T : R) : R :=
  Matrix.det (1 - T • σ.permMatrix R)

section General

variable {R : Type*} [CommRing R]

/-- The local factor only depends on the permutation up to relabelling of the
underlying set. -/
theorem eulerOf_permCongr {n m : Type*} [Fintype n] [DecidableEq n] [Fintype m] [DecidableEq m]
    (e : n ≃ m) (σ : Perm n) (T : R) :
    eulerOf (e.permCongr σ) T = eulerOf σ T := by
  unfold eulerOf
  have h : (1 - T • (e.permCongr σ).permMatrix R)
      = (1 - T • σ.permMatrix R).submatrix e.symm e.symm := by
    ext i j
    simp [Matrix.one_apply, PEquiv.toMatrix_apply, Equiv.toPEquiv_apply, Matrix.submatrix,
      Equiv.permCongr_apply, Equiv.eq_symm_apply]
  rw [h, Matrix.det_submatrix_equiv_self]

/-- A permutation acting on a product `α × ι` through the first factor only has
a block-diagonal matrix, so its local factor is a power. -/
theorem eulerOf_prodCongr_refl {α ι : Type*} [Fintype α] [DecidableEq α]
    [Fintype ι] [DecidableEq ι] (σ : Perm α) (T : R) :
    eulerOf (Equiv.prodCongr σ (Equiv.refl ι) : Perm (α × ι)) T
      = (eulerOf σ T) ^ (Fintype.card ι) := by
  unfold eulerOf
  have h : (1 - T • Equiv.Perm.permMatrix R (Equiv.prodCongr σ (Equiv.refl ι) : Perm (α × ι)))
      = Matrix.blockDiagonal (fun _ : ι => (1 - T • σ.permMatrix R)) := by
    ext ⟨i, k⟩ ⟨j, l⟩
    by_cases hkl : k = l <;>
      simp [Matrix.one_apply, PEquiv.toMatrix_apply, Equiv.toPEquiv_apply,
        Matrix.blockDiagonal_apply, hkl, Prod.ext_iff]
  rw [h, Matrix.det_blockDiagonal, Finset.prod_const, Finset.card_univ]

/-- The value of the rotation `finRotate d`, for `d > 0`. -/
theorem finRotate_val {d : ℕ} (hd : 0 < d) (k : Fin d) :
    ((finRotate d k : Fin d) : ℕ) = ((k : ℕ) + 1) % d := by
  obtain ⟨m, rfl⟩ := Nat.exists_eq_succ_of_ne_zero hd.ne'
  rw [finRotate_succ_apply]
  simp [Fin.val_add]

theorem eulerOf_finRotate_one (T : R) : eulerOf (finRotate 1) T = 1 - T ^ 1 := by
  unfold eulerOf
  have h : (1 - T • (finRotate 1).permMatrix R) = !![1 - T] := by
    ext i j
    fin_cases i; fin_cases j; simp
  rw [h]
  simp

theorem eulerOf_finRotate_two (T : R) : eulerOf (finRotate 2) T = 1 - T ^ 2 := by
  unfold eulerOf
  have h : (1 - T • (finRotate 2).permMatrix R) = !![1, -T; -T, 1] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PEquiv.toMatrix_apply, Equiv.toPEquiv_apply]
  rw [h, Matrix.det_fin_two_of]
  ring

set_option maxRecDepth 4000 in
theorem eulerOf_finRotate_three (T : R) : eulerOf (finRotate 3) T = 1 - T ^ 3 := by
  unfold eulerOf
  have h : (1 - T • (finRotate 3).permMatrix R) = !![1, -T, 0; 0, 1, -T; -T, 0, 1] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PEquiv.toMatrix_apply, Equiv.toPEquiv_apply]
  rw [h]
  simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove, Fin.succ, Fin.castSucc,
    Fin.castAdd, Fin.castLE]
  ring

set_option maxRecDepth 8000 in
theorem eulerOf_finRotate_five (T : R) : eulerOf (finRotate 5) T = 1 - T ^ 5 := by
  unfold eulerOf
  have h : (1 - T • (finRotate 5).permMatrix R)
      = !![1, -T, 0, 0, 0; 0, 1, -T, 0, 0; 0, 0, 1, -T, 0; 0, 0, 0, 1, -T; -T, 0, 0, 0, 1] := by
    ext i j
    fin_cases i <;> fin_cases j <;>
      simp [PEquiv.toMatrix_apply, Equiv.toPEquiv_apply]
  rw [h]
  simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove, Fin.succ, Fin.castSucc,
    Fin.castAdd, Fin.castLE]
  ring

end General

section RegularRepresentation

variable {R : Type*} [CommRing R] {G : Type*} [Group G] [Fintype G] [DecidableEq G]

/-- Writing a finite group as `⟨g⟩ × (a set of coset representatives)`:
the map `(k, q) ↦ q.out * g ^ k` is a bijection
`Fin (orderOf g) × G ⧸ ⟨g⟩ ≃ G`, and it intertwines the rotation of the first
factor with right translation by `g`. -/
noncomputable def cosetEquiv (g : G) :
    Fin (orderOf g) × (G ⧸ Subgroup.zpowers g) ≃ G := by
  refine Equiv.ofBijective (fun p => (Quotient.out p.2) * g ^ (p.1 : ℕ)) ⟨?_, ?_⟩
  · rintro ⟨k, q⟩ ⟨k', q'⟩ h
    simp only at h
    have hq : q = q' := by
      have hmk : ((Quotient.out q : G) : G ⧸ Subgroup.zpowers g)
          = ((Quotient.out q' : G) : G ⧸ Subgroup.zpowers g) := by
        rw [QuotientGroup.eq]
        have h' : (Quotient.out q' : G) = (Quotient.out q : G) * g ^ (k : ℕ) * (g ^ (k' : ℕ))⁻¹ := by
          rw [h]; group
        rw [h']
        have hcalc : (Quotient.out q : G)⁻¹ *
            ((Quotient.out q : G) * g ^ (k : ℕ) * (g ^ (k' : ℕ))⁻¹)
            = g ^ (k : ℕ) * (g ^ (k' : ℕ))⁻¹ := by group
        rw [hcalc]
        exact Subgroup.mul_mem _ (Subgroup.npow_mem_zpowers g _)
          (Subgroup.inv_mem _ (Subgroup.npow_mem_zpowers g _))
      simpa using hmk
    subst hq
    have hp : g ^ (k : ℕ) = g ^ (k' : ℕ) := mul_left_cancel h
    have hkk := pow_injOn_Iio_orderOf (x := g) k.2 k'.2 hp
    simp [Fin.ext_iff, hkk]
  · intro x
    obtain ⟨n, hn⟩ : ∃ n : ℕ, g ^ n = (Quotient.out ((x : G ⧸ Subgroup.zpowers g)) : G)⁻¹ * x := by
      have hmem : ((Quotient.out ((x : G ⧸ Subgroup.zpowers g)) : G))⁻¹ * x
          ∈ Subgroup.zpowers g := by
        rw [← QuotientGroup.eq]; simp
      obtain ⟨m, hm⟩ := mem_powers_iff_mem_zpowers.2 hmem
      exact ⟨m, hm⟩
    refine ⟨⟨⟨n % orderOf g, Nat.mod_lt _ (orderOf_pos g)⟩, (x : G ⧸ Subgroup.zpowers g)⟩, ?_⟩
    simp only [pow_mod_orderOf, hn]
    group

omit [DecidableEq G] in
theorem cosetEquiv_apply (g : G) (p : Fin (orderOf g) × (G ⧸ Subgroup.zpowers g)) :
    cosetEquiv g p = (Quotient.out p.2) * g ^ (p.1 : ℕ) := rfl

omit [DecidableEq G] in
/-- Right translation by `g` is, in the coordinates of `cosetEquiv`, the
rotation of the cyclic factor. -/
theorem mulRight_eq_permCongr (g : G) :
    (Equiv.mulRight g : Perm G)
      = (cosetEquiv g).permCongr
          (Equiv.prodCongr (finRotate (orderOf g)) (Equiv.refl (G ⧸ Subgroup.zpowers g))) := by
  have key : ∀ p : Fin (orderOf g) × (G ⧸ Subgroup.zpowers g),
      cosetEquiv g (Equiv.prodCongr (finRotate (orderOf g))
          (Equiv.refl (G ⧸ Subgroup.zpowers g)) p) = cosetEquiv g p * g := by
    rintro ⟨k, q⟩
    simp only [cosetEquiv_apply, Equiv.prodCongr_apply, Equiv.coe_refl, Prod.map_apply, id_eq]
    rw [finRotate_val (orderOf_pos g) k, pow_mod_orderOf, pow_succ, mul_assoc]
  ext x
  simp only [Equiv.coe_mulRight, Equiv.permCongr_apply]
  rw [key ((cosetEquiv g).symm x), Equiv.apply_symm_apply]

/-- The local factor of the **regular representation** of a finite group at an
element `g` of order `d`: it is `(1 - T^d)^{|G|/d}`, because right translation
by `g` decomposes `G` into `|G|/d` cycles of length `d`.  The cyclic factor
`det(1 - T · P_{finRotate d}) = 1 - T^d` is supplied as a hypothesis (it is
proved above for the orders `1, 2, 3, 5` occurring in `A₅`). -/
theorem eulerOf_mulRight (g : G) (T : R)
    (hrot : eulerOf (finRotate (orderOf g)) T = 1 - T ^ orderOf g) :
    eulerOf (Equiv.mulRight g : Perm G) T
      = (1 - T ^ orderOf g) ^ (Fintype.card G / orderOf g) := by
  classical
  rw [mulRight_eq_permCongr g, eulerOf_permCongr, eulerOf_prodCongr_refl, hrot]
  congr 1
  have hcard : Nat.card G = Nat.card (G ⧸ Subgroup.zpowers g) * Nat.card (Subgroup.zpowers g) :=
    Subgroup.card_eq_card_quotient_mul_card_subgroup _
  have hz : Nat.card (Subgroup.zpowers g) = orderOf g := Nat.card_zpowers g
  have hpos : 0 < orderOf g := orderOf_pos g
  have : Fintype.card (G ⧸ Subgroup.zpowers g) = Nat.card (G ⧸ Subgroup.zpowers g) :=
    (Nat.card_eq_fintype_card).symm
  rw [this]
  have hG : Fintype.card G = Nat.card G := (Nat.card_eq_fintype_card).symm
  rw [hG, hcard, hz, Nat.mul_div_cancel _ hpos]

end RegularRepresentation

section FivePoint

variable {R : Type*} [CommRing R]

/-- Explicit representatives of the five conjugacy classes of `A₅`, inside
`Equiv.Perm (Fin 5)`. -/
def rep : Cls → Perm (Fin 5)
  | c1 => 1
  | c2 => (Equiv.swap 0 1) * (Equiv.swap 2 3)
  | c3 => (Equiv.swap 0 1) * (Equiv.swap 0 2)
  | c5A => finRotate 5
  | c5B => (finRotate 5) ^ 2

theorem rep_mem_alternatingGroup (c : Cls) : rep c ∈ alternatingGroup (Fin 5) := by
  cases c
  · exact Subgroup.one_mem _
  · show (Equiv.swap 0 1 * Equiv.swap 2 3 : Perm (Fin 5)) ∈ alternatingGroup (Fin 5)
    rw [Equiv.Perm.mem_alternatingGroup, map_mul, Equiv.Perm.sign_swap (by decide),
      Equiv.Perm.sign_swap (by decide)]
    decide
  · show (Equiv.swap 0 1 * Equiv.swap 0 2 : Perm (Fin 5)) ∈ alternatingGroup (Fin 5)
    rw [Equiv.Perm.mem_alternatingGroup, map_mul, Equiv.Perm.sign_swap (by decide),
      Equiv.Perm.sign_swap (by decide)]
    decide
  · show finRotate 5 ∈ alternatingGroup (Fin 5)
    rw [Equiv.Perm.mem_alternatingGroup, sign_finRotate]
    decide
  · show (finRotate 5) ^ 2 ∈ alternatingGroup (Fin 5)
    rw [Equiv.Perm.mem_alternatingGroup, map_pow, sign_finRotate]
    decide

theorem orderOf_rep (c : Cls) : orderOf (rep c) = ord c := by
  haveI h2 : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
  haveI h3 : Fact (Nat.Prime 3) := ⟨Nat.prime_three⟩
  haveI h5 : Fact (Nat.Prime 5) := ⟨by norm_num⟩
  cases c
  · simp [rep, ord]
  · show orderOf (rep c2) = 2
    exact orderOf_eq_prime (by decide) (by decide)
  · show orderOf (rep c3) = 3
    exact orderOf_eq_prime (by decide) (by decide)
  · show orderOf (rep c5A) = 5
    exact orderOf_eq_prime (by decide) (by decide)
  · show orderOf (rep c5B) = 5
    exact orderOf_eq_prime (by decide) (by decide)

set_option maxRecDepth 40000 in
set_option maxHeartbeats 1000000 in
/-- The local factor of the five-point permutation representation of `A₅` at a
representative of each conjugacy class is the polynomial `permPoly5`. -/
theorem eulerOf_rep (c : Cls) (T : R) : eulerOf (rep c) T = permPoly5 c T := by
  cases c
  · unfold eulerOf
    have h : (1 - T • (rep c1).permMatrix R)
        = !![1 - T, 0, 0, 0, 0; 0, 1 - T, 0, 0, 0; 0, 0, 1 - T, 0, 0; 0, 0, 0, 1 - T, 0;
            0, 0, 0, 0, 1 - T] := by
      ext i j
      fin_cases i <;> fin_cases j <;> simp [rep]
    rw [h]
    simp only [permPoly5]
    simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove, Fin.succ, Fin.castSucc,
      Fin.castAdd, Fin.castLE]
    ring
  · unfold eulerOf
    have h : (1 - T • (rep c2).permMatrix R)
        = !![1, -T, 0, 0, 0; -T, 1, 0, 0, 0; 0, 0, 1, -T, 0; 0, 0, -T, 1, 0;
            0, 0, 0, 0, 1 - T] := by
      ext i j
      fin_cases i <;> fin_cases j <;>
        simp [rep, PEquiv.toMatrix_apply, Equiv.toPEquiv_apply, Equiv.swap_apply_def,
          -Matrix.permMatrix_mul]
    rw [h]
    simp only [permPoly5]
    simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove, Fin.succ, Fin.castSucc,
      Fin.castAdd, Fin.castLE]
    ring
  · unfold eulerOf
    have h : (1 - T • (rep c3).permMatrix R)
        = !![1, 0, -T, 0, 0; -T, 1, 0, 0, 0; 0, -T, 1, 0, 0; 0, 0, 0, 1 - T, 0;
            0, 0, 0, 0, 1 - T] := by
      ext i j
      fin_cases i <;> fin_cases j <;>
        simp [rep, PEquiv.toMatrix_apply, Equiv.toPEquiv_apply, Equiv.swap_apply_def,
          -Matrix.permMatrix_mul]
    rw [h]
    simp only [permPoly5]
    simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove, Fin.succ, Fin.castSucc,
      Fin.castAdd, Fin.castLE]
    ring
  · have h : rep c5A = finRotate 5 := rfl
    rw [h, eulerOf_finRotate_five]
    simp [permPoly5]
  · unfold eulerOf
    have h : (1 - T • (rep c5B).permMatrix R)
        = !![1, 0, -T, 0, 0; 0, 1, 0, -T, 0; 0, 0, 1, 0, -T; -T, 0, 0, 1, 0;
            0, -T, 0, 0, 1] := by
      have e0 : (finRotate 5 ^ 2) 0 = 2 := rfl
      have e1 : (finRotate 5 ^ 2) 1 = 3 := rfl
      have e2 : (finRotate 5 ^ 2) 2 = 4 := rfl
      have e3 : (finRotate 5 ^ 2) 3 = 0 := rfl
      have e4 : (finRotate 5 ^ 2) 4 = 1 := rfl
      ext i j
      fin_cases i <;> fin_cases j <;>
        simp [rep, PEquiv.toMatrix_apply, Equiv.toPEquiv_apply, e0, e1, e2, e3, e4,
          -Matrix.permMatrix_mul]
    rw [h]
    simp only [permPoly5]
    simp [Matrix.det_succ_row_zero, Fin.sum_univ_succ, Fin.succAbove, Fin.succ, Fin.castSucc,
      Fin.castAdd, Fin.castLE]
    ring

/-- **`ζ_K = ζ · L(ρ₄)` at the level of the representation.**  The local factor
of the five-point permutation representation of `A₅` factors as the trivial
factor `1 - T` times the local factor `E4` of the standard four-dimensional
representation. -/
theorem permPoly5_det_eq (c : Cls) (T : R) :
    Matrix.det (1 - T • (rep c).permMatrix R) = (1 - T) * E4 c T := by
  rw [show Matrix.det (1 - T • (rep c).permMatrix R) = eulerOf (rep c) T from rfl,
    eulerOf_rep, permPoly5_eq]

end FivePoint

section RegularA5

variable {R : Type*} [CommRing R]

/-- `A₅` has 60 elements. -/
theorem card_A5 : Fintype.card (alternatingGroup (Fin 5)) = 60 := by
  have h : 2 * Fintype.card (alternatingGroup (Fin 5)) = 120 := by
    rw [two_mul_card_alternatingGroup, Fintype.card_perm, Fintype.card_fin]
    decide
  omega

/-- The representatives of the five classes, viewed inside `A₅`. -/
def repA (c : Cls) : alternatingGroup (Fin 5) := ⟨rep c, rep_mem_alternatingGroup c⟩

theorem orderOf_repA (c : Cls) : orderOf (repA c) = ord c := by
  rw [← orderOf_rep c]
  exact (orderOf_injective (alternatingGroup (Fin 5)).subtype Subtype.coe_injective _).symm

/-- The local factor of the **regular representation** of `A₅` at a
representative of each conjugacy class is the polynomial `regPoly`. -/
theorem eulerOf_regular_eq_regPoly (c : Cls) (T : R) :
    eulerOf (Equiv.mulRight (repA c) : Perm (alternatingGroup (Fin 5))) T = regPoly c T := by
  have hord := orderOf_repA c
  have hrot : eulerOf (finRotate (orderOf (repA c))) T = 1 - T ^ orderOf (repA c) := by
    rw [hord]
    cases c
    · exact eulerOf_finRotate_one T
    · exact eulerOf_finRotate_two T
    · exact eulerOf_finRotate_three T
    · exact eulerOf_finRotate_five T
    · exact eulerOf_finRotate_five T
  rw [eulerOf_mulRight _ T hrot, hord, card_A5]
  cases c <;> simp [regPoly, ord]

/-- **The Artin factorisation of `ζ_N`, at the level of the representation.**
The local factor of the regular representation of `A₅` factors as
`(1 - T) · (E3·E3')³ · E4⁴ · E5⁵`, i.e.
`ζ_N(s) = ζ(s) L(ρ₃,s)³ L(ρ₃',s)³ L(ρ₄,s)⁴ L(ρ₅,s)⁵`. -/
theorem regPoly_det_eq (c : Cls) (T : R) :
    Matrix.det (1 - T • (Equiv.mulRight (repA c) :
        Perm (alternatingGroup (Fin 5))).permMatrix R)
      = (1 - T) * (E3E3b c T) ^ 3 * (E4 c T) ^ 4 * (E5 c T) ^ 5 := by
  rw [show Matrix.det (1 - T • (Equiv.mulRight (repA c) :
      Perm (alternatingGroup (Fin 5))).permMatrix R)
      = eulerOf (Equiv.mulRight (repA c) : Perm (alternatingGroup (Fin 5))) T from rfl,
    eulerOf_regular_eq_regPoly, regPoly_eq]

end RegularA5

end A5Artin
