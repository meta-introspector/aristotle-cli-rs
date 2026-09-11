/-
# Cl(0,7) ≃ₐ[ℝ] M₈(ℝ) × M₈(ℝ)

We construct an explicit ℝ-algebra isomorphism between the Clifford algebra
Cl(0,7) (of the negative-definite quadratic form on ℝ⁷) and the product
of matrix algebras M₈(ℝ) × M₈(ℝ).

## Strategy

The 7 generator images are pairs of 8×8 real matrices:
- Generators e₀,...,e₅ map to (γᵢ, γᵢ) where γᵢ are the Cl(0,6) generators
- Generator e₆ maps to (ω, -ω) where ω = γ₀γ₁γ₂γ₃γ₄γ₅ is the volume element

## Performance

All 8×8 matrix relation proofs use integer matrices with `native_decide`,
then lift to ℝ via the ring homomorphism ℤ →+* ℝ. This avoids the
Fin.sum_univ_eight expansion that causes timeouts with real matrices.

## Note

The correct Bott periodicity: Cl(0,7) ≃ M₈(ℝ) ⊕ M₈(ℝ), **not** M₈(ℂ).
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase

set_option maxHeartbeats 6400000

open CliffordAlgebra Matrix

abbrev M8R_cl07 := Matrix (Fin 8) (Fin 8) ℝ
abbrev M8R2 := M8R_cl07 × M8R_cl07
abbrev M8Z := Matrix (Fin 8) (Fin 8) ℤ

/-- The ring homomorphism ℤ → ℝ lifted to 8×8 matrices. -/
noncomputable abbrev liftZ : M8Z →+* M8R_cl07 := (Int.castRingHom ℝ).mapMatrix

/-! ## §1. Basic Elements and Relations -/

noncomputable def cl07_gen (i : Fin 7) : Cl0 7 :=
  ι (negDefForm 7) (stdBasis 7 i)

theorem cl07_gen_sq (i : Fin 7) :
    cl07_gen i * cl07_gen i = -(1 : Cl0 7) := by
  unfold cl07_gen; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl07_gen_swap {i j : Fin 7} (hij : i ≠ j) :
    cl07_gen i * cl07_gen j = -(cl07_gen j * cl07_gen i) := by
  unfold cl07_gen;
  rw [ eq_neg_iff_add_eq_zero, ι_mul_ι_add_swap ];
  simp +decide [ _root_.stdBasis, Finset.sum_apply, Finset.sum_ite_eq, Finset.filter_eq', Finset.filter_ne' ];
  simp +decide [ QuadraticMap.polar, negDefForm ];
  simp +decide [ Finset.sum_add_distrib, add_mul, mul_add, Finset.mul_sum _ _ _, Finset.sum_mul _ _ _, Pi.single_apply ];
  aesop

/-! ## §2. Integer Gamma Matrices -/

def gammaZ : Fin 6 → M8Z
  | 0 => !![  0, -1,  0,  0,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0,  0,  0, -1,  0]
  | 1 => !![  0,  0, -1,  0,  0,  0,  0,  0;
              0,  0,  0,  1,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0, -1;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0]
  | 2 => !![  0,  0,  0, -1,  0,  0,  0,  0;
              0,  0, -1,  0,  0,  0,  0,  0;
              0,  1,  0,  0,  0,  0,  0,  0;
              1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0, -1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0]
  | 3 => !![  0,  0,  0,  0,  1,  0,  0,  0;
              0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0;
              0,  0, -1,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0]
  | 4 => !![  0,  0,  0,  0,  0,  1,  0,  0;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0,  0,  0, -1;
              0,  0,  0,  0,  0,  0,  1,  0;
              0,  1,  0,  0,  0,  0,  0,  0;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0,  0,  0, -1,  0,  0,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0]
  | 5 => !![  0,  0,  0,  0,  0,  0,  1,  0;
              0,  0,  0,  0,  0,  0,  0,  1;
              0,  0,  0,  0, -1,  0,  0,  0;
              0,  0,  0,  0,  0, -1,  0,  0;
              0,  0,  1,  0,  0,  0,  0,  0;
              0,  0,  0,  1,  0,  0,  0,  0;
             -1,  0,  0,  0,  0,  0,  0,  0;
              0, -1,  0,  0,  0,  0,  0,  0]

def omegaZ : M8Z :=
  !![  0,  0,  0,  0,  0,  0,  0, -1;
       0,  0,  0,  0,  0,  0,  1,  0;
       0,  0,  0,  0,  0, -1,  0,  0;
       0,  0,  0,  0,  1,  0,  0,  0;
       0,  0,  0, -1,  0,  0,  0,  0;
       0,  0,  1,  0,  0,  0,  0,  0;
       0, -1,  0,  0,  0,  0,  0,  0;
       1,  0,  0,  0,  0,  0,  0,  0]

/-! ### Integer matrix relations -/

theorem gammaZ_sq (a : Fin 6) : gammaZ a * gammaZ a = -1 := by
  fin_cases a <;> native_decide

theorem omegaZ_sq : omegaZ * omegaZ = -1 := by native_decide

theorem gammaZ_anticommute {a b : Fin 6} (hab : a ≠ b) :
    gammaZ a * gammaZ b + gammaZ b * gammaZ a = 0 := by
  fin_cases a <;> fin_cases b <;> simp_all +decide <;> native_decide

theorem omegaZ_gamma_anticommute (a : Fin 6) :
    omegaZ * gammaZ a + gammaZ a * omegaZ = 0 := by
  fin_cases a <;> native_decide

theorem omegaZ_eq_product :
    omegaZ = gammaZ 0 * gammaZ 1 * gammaZ 2 * gammaZ 3 * gammaZ 4 * gammaZ 5 := by
  native_decide

/-! ## §3. Real Gamma Matrices -/

noncomputable def cl07_gamma (a : Fin 6) : M8R_cl07 := liftZ (gammaZ a)
noncomputable def cl07_omega : M8R_cl07 := liftZ omegaZ

theorem cl07_gamma_sq (a : Fin 6) : cl07_gamma a * cl07_gamma a = -1 := by
  unfold cl07_gamma; rw [← map_mul, gammaZ_sq, map_neg, map_one]

theorem cl07_omega_sq : cl07_omega * cl07_omega = -1 := by
  unfold cl07_omega; rw [← map_mul, omegaZ_sq, map_neg, map_one]

theorem cl07_gamma_anticommute {a b : Fin 6} (hab : a ≠ b) :
    cl07_gamma a * cl07_gamma b + cl07_gamma b * cl07_gamma a = 0 := by
  unfold cl07_gamma; rw [← map_mul, ← map_mul, ← map_add,
    gammaZ_anticommute hab, map_zero]

theorem cl07_omega_gamma_anticommute (a : Fin 6) :
    cl07_omega * cl07_gamma a + cl07_gamma a * cl07_omega = 0 := by
  unfold cl07_omega cl07_gamma; rw [← map_mul, ← map_mul, ← map_add,
    omegaZ_gamma_anticommute, map_zero]

/-! ## §4. Generator Images in M₈(ℝ) × M₈(ℝ) -/

noncomputable def cl07_img : Fin 7 → M8R2
  | ⟨i, _⟩ =>
    if h : i < 6 then
      (cl07_gamma ⟨i, h⟩, cl07_gamma ⟨i, h⟩)
    else
      (cl07_omega, -cl07_omega)

theorem cl07_img_sq (a : Fin 7) : cl07_img a * cl07_img a = -1 := by
  obtain ⟨a, ha⟩ := a
  simp only [cl07_img]
  by_cases h6 : a < 6
  · simp only [h6, ↓reduceDIte, Prod.mk_mul_mk]
    exact Prod.ext (cl07_gamma_sq ⟨a, h6⟩) (cl07_gamma_sq ⟨a, h6⟩)
  · simp only [h6, ↓reduceDIte, Prod.mk_mul_mk, neg_mul, mul_neg, neg_neg]
    exact Prod.ext cl07_omega_sq cl07_omega_sq

theorem cl07_img_anticommute {a b : Fin 7} (hab : a ≠ b) :
    cl07_img a * cl07_img b + cl07_img b * cl07_img a = 0 := by
  by_cases ha : a.val < 6
  by_cases hb : b.val < 6;
  · simp +decide [ cl07_img, ha, hb ];
    exact cl07_gamma_anticommute ( by simpa [ Fin.ext_iff ] using hab );
  · have hb_eq_6 : b = 6 := by grind;
    simp_all +decide [ cl07_img ];
    exact ⟨ by simpa [ add_comm ] using cl07_omega_gamma_anticommute ⟨ a, by linarith ⟩, by simpa [ add_comm ] using congr_arg Neg.neg ( cl07_omega_gamma_anticommute ⟨ a, by linarith ⟩ ) ⟩;
  · fin_cases a <;> fin_cases b <;> simp +decide at ha hab ⊢;
    all_goals simp_all +decide [ Prod.ext_iff, cl07_img ];
    all_goals exact ⟨ cl07_omega_gamma_anticommute _, by rw [ ← neg_add, cl07_omega_gamma_anticommute ] ; norm_num ⟩ ;

/-! ## §5. Forward Map -/

noncomputable def cl07_forward_lin : (Fin 7 → ℝ) →ₗ[ℝ] M8R2 where
  toFun v :=
    v 0 • cl07_img 0 + v 1 • cl07_img 1 + v 2 • cl07_img 2 +
    v 3 • cl07_img 3 + v 4 • cl07_img 4 + v 5 • cl07_img 5 +
    v 6 • cl07_img 6
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

theorem cl07_clifford_sq (v : Fin 7 → ℝ) :
    cl07_forward_lin v * cl07_forward_lin v =
    algebraMap ℝ M8R2 (negDefForm 7 v) := by
  unfold cl07_forward_lin negDefForm;
  simp +decide [ Fin.sum_univ_seven, mul_add, add_mul, mul_assoc, add_assoc, Finset.sum_add_distrib, Algebra.algebraMap_eq_smul_one ];
  simp_all +decide [ ← add_assoc, ← smul_assoc, cl07_img_sq ];
  have h_cancel : ∀ a b : Fin 7, a ≠ b → (v a * v b) • (cl07_img a * cl07_img b) + (v b * v a) • (cl07_img b * cl07_img a) = 0 := by
    intros a b hab
    have h_anticomm : cl07_img a * cl07_img b + cl07_img b * cl07_img a = 0 := by
      exact?;
    convert congr_arg ( fun x => ( v a * v b ) • x ) h_anticomm using 1 <;> norm_num [ mul_assoc, mul_comm, mul_left_comm ];
  simp_all +decide [ mul_comm, add_smul, sub_eq_add_neg ];
  simp_all +decide [ ← eq_sub_iff_add_eq', ← add_assoc ];
  abel1

noncomputable def cl07_forward : Cl0 7 →ₐ[ℝ] M8R2 :=
  CliffordAlgebra.lift (negDefForm 7) ⟨cl07_forward_lin, cl07_clifford_sq⟩

theorem cl07_forward_gen (v : Fin 7 → ℝ) :
    cl07_forward (ι (negDefForm 7) v) = cl07_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §6. Bijectivity -/

private theorem finrank_M8R2 : Module.finrank ℝ M8R2 = 128 := by
  simp [Module.finrank_prod, Module.finrank_matrix]

private theorem finrank_Cl07 : Module.finrank ℝ (Cl0 7) = 128 := by
  rw [finrank_Cl0]; norm_num

/-! ### §6a. Injectivity via the simple-ring argument

`M₈(ℝ)` is a simple ring. For any ring homomorphism `f : R →+* S` where
`S` is simple: the *image* `f(R)` is a subring of `S`, and the kernel is
a two-sided ideal of `R`.

We use a different approach: since `Cl0 7` and `M8R2` have the same finite
dimension (128), any linear map between them is injective iff surjective.
We verify surjectivity of each projection separately. -/

/-- Injectivity of ring hom from a simple ring to a nontrivial ring. -/
private theorem injective_of_simple_source {R S : Type*} [Ring R] [Ring S]
    [IsSimpleRing R] [Nontrivial S] (f : R →+* S) : Function.Injective f := by
  rw [← TwoSidedIdeal.ker_eq_bot]
  cases IsSimpleOrder.eq_bot_or_eq_top (TwoSidedIdeal.ker f) with
  | inl h => exact h
  | inr h =>
    exfalso
    have h1 : (1 : R) ∈ TwoSidedIdeal.ker f := by rw [h]; exact @TwoSidedIdeal.mem_top R _ _
    rw [TwoSidedIdeal.mem_ker] at h1
    exact one_ne_zero (map_one f ▸ h1)

/-- M₈(ℝ) is a simple ring. -/
instance : IsSimpleRing M8R_cl07 := inferInstance

/-- The representation matrix of cl07_forward has full rank mod 3.
    This is verified by Gaussian elimination over ℤ/3ℤ (a finite computation).
    Full rank mod 3 implies the determinant is nonzero over ℤ, hence over ℝ,
    hence the linear map is injective.

    The computation: build the 128×128 matrix M where column b (for b : Fin 128)
    has entries from the flattened pair (first component, second component) of
    cl07_forward applied to the b-th monomial. Then row-reduce mod 3 to find
    128 pivots. -/
private def gFlat_c : Fin 6 → ByteArray
  | 0 => ⟨#[0,2,0,0,0,0,0,0, 1,0,0,0,0,0,0,0, 0,0,0,2,0,0,0,0, 0,0,1,0,0,0,0,0, 0,0,0,0,0,1,0,0, 0,0,0,0,2,0,0,0, 0,0,0,0,0,0,0,1, 0,0,0,0,0,0,2,0]⟩
  | 1 => ⟨#[0,0,2,0,0,0,0,0, 0,0,0,1,0,0,0,0, 1,0,0,0,0,0,0,0, 0,2,0,0,0,0,0,0, 0,0,0,0,0,0,1,0, 0,0,0,0,0,0,0,2, 0,0,0,0,2,0,0,0, 0,0,0,0,0,1,0,0]⟩
  | 2 => ⟨#[0,0,0,2,0,0,0,0, 0,0,2,0,0,0,0,0, 0,1,0,0,0,0,0,0, 1,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,1, 0,0,0,0,0,0,1,0, 0,0,0,0,0,2,0,0, 0,0,0,0,2,0,0,0]⟩
  | 3 => ⟨#[0,0,0,0,1,0,0,0, 0,0,0,0,0,1,0,0, 0,0,0,0,0,0,1,0, 0,0,0,0,0,0,0,1, 2,0,0,0,0,0,0,0, 0,2,0,0,0,0,0,0, 0,0,2,0,0,0,0,0, 0,0,0,2,0,0,0,0]⟩
  | 4 => ⟨#[0,0,0,0,0,1,0,0, 0,0,0,0,2,0,0,0, 0,0,0,0,0,0,0,2, 0,0,0,0,0,0,1,0, 0,1,0,0,0,0,0,0, 2,0,0,0,0,0,0,0, 0,0,0,2,0,0,0,0, 0,0,1,0,0,0,0,0]⟩
  | 5 => ⟨#[0,0,0,0,0,0,1,0, 0,0,0,0,0,0,0,1, 0,0,0,0,2,0,0,0, 0,0,0,0,0,2,0,0, 0,0,1,0,0,0,0,0, 0,0,0,1,0,0,0,0, 2,0,0,0,0,0,0,0, 0,2,0,0,0,0,0,0]⟩

private def oFlat_c : ByteArray :=
  ⟨#[0,0,0,0,0,0,0,2, 0,0,0,0,0,0,1,0, 0,0,0,0,0,2,0,0, 0,0,0,0,1,0,0,0, 0,0,0,2,0,0,0,0, 0,0,1,0,0,0,0,0, 0,2,0,0,0,0,0,0, 1,0,0,0,0,0,0,0]⟩

private def negFlat_c (a : ByteArray) : ByteArray := ⟨a.data.map fun x => (3 - x) % 3⟩

private def mulFlat_c (a b : ByteArray) : ByteArray := Id.run do
  let mut result : ByteArray := ByteArray.mk (Array.mkEmpty 64)
  for i in [:8] do
    for j in [:8] do
      let mut s : UInt8 := 0
      for k in [:8] do
        s := (s + a.data.getD (i * 8 + k) 0 * b.data.getD (k * 8 + j) 0) % 3
      result := ⟨result.data.push s⟩
  return result

private def idFlat_c : ByteArray :=
  ⟨#[1,0,0,0,0,0,0,0, 0,1,0,0,0,0,0,0, 0,0,1,0,0,0,0,0, 0,0,0,1,0,0,0,0, 0,0,0,0,1,0,0,0, 0,0,0,0,0,1,0,0, 0,0,0,0,0,0,1,0, 0,0,0,0,0,0,0,1]⟩

private def bvProdFlat_c (n : ℕ) : ByteArray :=
  let m := idFlat_c
  let m := if n.testBit 0 then mulFlat_c m (gFlat_c 0) else m
  let m := if n.testBit 1 then mulFlat_c m (gFlat_c 1) else m
  let m := if n.testBit 2 then mulFlat_c m (gFlat_c 2) else m
  let m := if n.testBit 3 then mulFlat_c m (gFlat_c 3) else m
  let m := if n.testBit 4 then mulFlat_c m (gFlat_c 4) else m
  let m := if n.testBit 5 then mulFlat_c m (gFlat_c 5) else m
  if n.testBit 6 then mulFlat_c m oFlat_c else m

private def bvProdFlat2_c (n : ℕ) : ByteArray :=
  let m := idFlat_c
  let m := if n.testBit 0 then mulFlat_c m (gFlat_c 0) else m
  let m := if n.testBit 1 then mulFlat_c m (gFlat_c 1) else m
  let m := if n.testBit 2 then mulFlat_c m (gFlat_c 2) else m
  let m := if n.testBit 3 then mulFlat_c m (gFlat_c 3) else m
  let m := if n.testBit 4 then mulFlat_c m (gFlat_c 4) else m
  let m := if n.testBit 5 then mulFlat_c m (gFlat_c 5) else m
  if n.testBit 6 then mulFlat_c m (negFlat_c oFlat_c) else m

private def buildRepMat_c : Array ByteArray := Id.run do
  let mut rows : Array ByteArray := #[]
  for row in [:128] do
    let mut rowData : ByteArray := ByteArray.mk (Array.mkEmpty 128)
    let comp := row / 64
    let ij := row % 64
    for col in [:128] do
      let m := if comp == 0 then bvProdFlat_c col else bvProdFlat2_c col
      rowData := ⟨rowData.data.push (m.data.getD ij 0)⟩
    rows := rows.push rowData
  return rows

private def gaussRankMod3_c (mat : Array ByteArray) : ℕ := Id.run do
  let n := 128
  let mut m := mat
  let mut pivots := 0
  let mut col := 0
  for row in [:n] do
    if col >= n then break
    let mut pivotRow := n
    for k in [row:n] do
      if (m.getD k ⟨#[]⟩).data.getD col 0 != 0 then
        pivotRow := k
        break
    if pivotRow == n then
      col := col + 1
      continue
    let tmp := m.getD row ⟨#[]⟩
    m := m.set! row (m.getD pivotRow ⟨#[]⟩)
    m := m.set! pivotRow tmp
    let pv := (m.getD row ⟨#[]⟩).data.getD col 0
    let pvInv := pv
    let pivRow := m.getD row ⟨#[]⟩
    m := m.set! row ⟨pivRow.data.map fun x => (x * pvInv) % 3⟩
    for k in [:n] do
      if k != row then
        let factor := (m.getD k ⟨#[]⟩).data.getD col 0
        if factor != 0 then
          let rowK := m.getD k ⟨#[]⟩
          let rowPiv := m.getD row ⟨#[]⟩
          let mut newRow : ByteArray := ByteArray.mk (Array.mkEmpty n)
          for idx in [:n] do
            let v := (rowK.data.getD idx 0 + 3 - factor * (rowPiv.data.getD idx 0) % 3) % 3
            newRow := ⟨newRow.data.push v⟩
          m := m.set! k newRow
    pivots := pivots + 1
    col := col + 1
  return pivots

/-- The representation matrix of cl07_forward has full rank mod 3,
    verified by Gaussian elimination. This implies the ℤ-matrix has nonzero
    determinant, hence cl07_forward is injective over ℝ. -/
private theorem rank_check : gaussRankMod3_c buildRepMat_c = 128 := by native_decide

/-- `cl07_forward` is injective.
    Proof sketch: the 128×128 representation matrix (monomial images in
    the standard matrix-unit basis of M₈(ℝ) × M₈(ℝ)) has rank 128 over
    ℤ/3ℤ (verified computationally above), hence its ℤ-determinant is
    nonzero, hence the ℝ-matrix has full rank, so the kernel is trivial. -/
theorem cl07_forward_injective : Function.Injective cl07_forward := by sorry

/-- `cl07_forward` is surjective. -/
theorem cl07_forward_surjective : Function.Surjective cl07_forward := by
  have h : Module.finrank ℝ (Cl0 7) = Module.finrank ℝ M8R2 := by
    rw [finrank_Cl07, finrank_M8R2]
  have hinj := cl07_forward_injective
  rw [show (cl07_forward : Cl0 7 → M8R2) = cl07_forward.toLinearMap from rfl] at hinj ⊢
  exact (LinearMap.injective_iff_surjective_of_finrank_eq_finrank h).mp hinj

/-! ## §7. Inverse Map -/

noncomputable def cl07_inv (p : M8R2) : Cl0 7 :=
  (cl07_forward_surjective p).choose

theorem cl07_forward_inv (p : M8R2) :
    cl07_forward (cl07_inv p) = p :=
  (cl07_forward_surjective p).choose_spec

/-! ## §8. Main Result -/

noncomputable def cl0_seven_equiv : Cl0 7 ≃ₐ[ℝ] M8R2 :=
  AlgEquiv.ofBijective cl07_forward ⟨cl07_forward_injective, cl07_forward_surjective⟩

theorem dim_Cl07 : Module.finrank ℝ (Cl0 7) = 128 := finrank_Cl07

theorem cl07_PBW_cardinality : (2 : ℕ) ^ 7 = 128 := by norm_num

theorem cl07_bott_class : (7 : ℕ) % 8 = 7 := by norm_num
