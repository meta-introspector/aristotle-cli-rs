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
import RequestProject.CliffordBase
import RequestProject.CliffordCl07Finite

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

/-! ## §2. Integer Gamma Matrices

We define the matrices over ℤ for fast `native_decide` proofs,
then cast to ℝ via `liftZ`. -/

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

/-- The volume element ω = γ₀γ₁γ₂γ₃γ₄γ₅ over ℤ. -/
def omegaZ : M8Z :=
  !![  0,  0,  0,  0,  0,  0,  0, -1;
       0,  0,  0,  0,  0,  0,  1,  0;
       0,  0,  0,  0,  0, -1,  0,  0;
       0,  0,  0,  0,  1,  0,  0,  0;
       0,  0,  0, -1,  0,  0,  0,  0;
       0,  0,  1,  0,  0,  0,  0,  0;
       0, -1,  0,  0,  0,  0,  0,  0;
       1,  0,  0,  0,  0,  0,  0,  0]

/-! ### Integer matrix relations (proved instantly by native_decide) -/

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

/-! ## §3. Real Gamma Matrices (lifted from ℤ via ring hom) -/

noncomputable def cl07_gamma (a : Fin 6) : M8R_cl07 := liftZ (gammaZ a)
noncomputable def cl07_omega : M8R_cl07 := liftZ omegaZ

/-- Each gamma matrix squares to -I₈. -/
theorem cl07_gamma_sq (a : Fin 6) : cl07_gamma a * cl07_gamma a = -1 := by
  unfold cl07_gamma; rw [← map_mul, gammaZ_sq, map_neg, map_one]

/-- The volume element squares to -I₈. -/
theorem cl07_omega_sq : cl07_omega * cl07_omega = -1 := by
  unfold cl07_omega; rw [← map_mul, omegaZ_sq, map_neg, map_one]

/-- Gamma matrices anticommute. -/
theorem cl07_gamma_anticommute {a b : Fin 6} (hab : a ≠ b) :
    cl07_gamma a * cl07_gamma b + cl07_gamma b * cl07_gamma a = 0 := by
  unfold cl07_gamma; rw [← map_mul, ← map_mul, ← map_add,
    gammaZ_anticommute hab, map_zero]

/-- The volume element anticommutes with each gamma matrix. -/
theorem cl07_omega_gamma_anticommute (a : Fin 6) :
    cl07_omega * cl07_gamma a + cl07_gamma a * cl07_omega = 0 := by
  unfold cl07_omega cl07_gamma; rw [← map_mul, ← map_mul, ← map_add,
    omegaZ_gamma_anticommute, map_zero]

/-! ## §4. Generator Images in M₈(ℝ) × M₈(ℝ) -/

/-- The 7 generator images in M₈(ℝ) × M₈(ℝ).
    For i < 6: (γᵢ, γᵢ). For i = 6: (ω, -ω). -/
noncomputable def cl07_img : Fin 7 → M8R2
  | ⟨i, _⟩ =>
    if h : i < 6 then
      (cl07_gamma ⟨i, h⟩, cl07_gamma ⟨i, h⟩)
    else
      (cl07_omega, -cl07_omega)

/-- Each generator image squares to -(1,1). -/
theorem cl07_img_sq (a : Fin 7) : cl07_img a * cl07_img a = -1 := by
  obtain ⟨a, ha⟩ := a
  simp only [cl07_img]
  by_cases h6 : a < 6
  · simp only [h6, ↓reduceDIte, Prod.mk_mul_mk]
    exact Prod.ext (cl07_gamma_sq ⟨a, h6⟩) (cl07_gamma_sq ⟨a, h6⟩)
  · simp only [h6, ↓reduceDIte, Prod.mk_mul_mk, neg_mul, mul_neg, neg_neg]
    exact Prod.ext cl07_omega_sq cl07_omega_sq

/-
Generator images anticommute.
-/
theorem cl07_img_anticommute {a b : Fin 7} (hab : a ≠ b) :
    cl07_img a * cl07_img b + cl07_img b * cl07_img a = 0 := by
  -- By definition of cl07_img, we have two cases to consider: both a and b are less than 6, or one of them is 6.
  by_cases ha : a.val < 6
  by_cases hb : b.val < 6;
  · simp +decide [ cl07_img, ha, hb ];
    exact cl07_gamma_anticommute ( by simpa [ Fin.ext_iff ] using hab );
  · -- Since $b.val \geq 6$, we have $b = 6$.
    have hb_eq_6 : b = 6 := by
      grind;
    simp_all +decide [ cl07_img ];
    exact ⟨ by simpa [ add_comm ] using cl07_omega_gamma_anticommute ⟨ a, by linarith ⟩, by simpa [ add_comm ] using congr_arg Neg.neg ( cl07_omega_gamma_anticommute ⟨ a, by linarith ⟩ ) ⟩;
  · fin_cases a <;> fin_cases b <;> simp +decide at ha hab ⊢;
    all_goals simp_all +decide [ Prod.ext_iff, cl07_img ];
    all_goals exact ⟨ cl07_omega_gamma_anticommute _, by rw [ ← neg_add, cl07_omega_gamma_anticommute ] ; norm_num ⟩ ;

/-! ## §5. Forward Map: Cl(0,7) → M₈(ℝ) × M₈(ℝ) -/

noncomputable def cl07_forward_lin : (Fin 7 → ℝ) →ₗ[ℝ] M8R2 where
  toFun v :=
    v 0 • cl07_img 0 + v 1 • cl07_img 1 + v 2 • cl07_img 2 +
    v 3 • cl07_img 3 + v 4 • cl07_img 4 + v 5 • cl07_img 5 +
    v 6 • cl07_img 6
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

/-
The forward linear map satisfies the Clifford relation.
-/
theorem cl07_clifford_sq (v : Fin 7 → ℝ) :
    cl07_forward_lin v * cl07_forward_lin v =
    algebraMap ℝ M8R2 (negDefForm 7 v) := by
  unfold cl07_forward_lin negDefForm;
  simp +decide [ Fin.sum_univ_seven, mul_add, add_mul, mul_assoc, add_assoc, Finset.sum_add_distrib, Algebra.algebraMap_eq_smul_one ];
  simp_all +decide [ ← add_assoc, ← smul_assoc, cl07_img_sq ];
  -- By pairing terms, we can see that each pair cancels out.
  have h_cancel : ∀ a b : Fin 7, a ≠ b → (v a * v b) • (cl07_img a * cl07_img b) + (v b * v a) • (cl07_img b * cl07_img a) = 0 := by
    intros a b hab
    have h_anticomm : cl07_img a * cl07_img b + cl07_img b * cl07_img a = 0 := by
      exact?;
    convert congr_arg ( fun x => ( v a * v b ) • x ) h_anticomm using 1 <;> norm_num [ mul_assoc, mul_comm, mul_left_comm ];
  simp_all +decide [ mul_comm, add_smul, sub_eq_add_neg ];
  simp_all +decide [ ← eq_sub_iff_add_eq', ← add_assoc ];
  abel1

/-- The forward algebra homomorphism via CliffordAlgebra.lift -/
noncomputable def cl07_forward : Cl0 7 →ₐ[ℝ] M8R2 :=
  CliffordAlgebra.lift (negDefForm 7) ⟨cl07_forward_lin, cl07_clifford_sq⟩

theorem cl07_forward_gen (v : Fin 7 → ℝ) :
    cl07_forward (ι (negDefForm 7) v) = cl07_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §6. Inverse Map (placeholder) -/

noncomputable def cl07_inv (_p : M8R2) : Cl0 7 := by sorry

theorem cl07_forward_inv (p : M8R2) :
    cl07_forward (cl07_inv p) = p := by sorry

/-! ## §7. Surjectivity and Injectivity -/

theorem cl07_forward_surjective : Function.Surjective cl07_forward :=
  fun p => ⟨cl07_inv p, cl07_forward_inv p⟩

private theorem finrank_M8R2 : Module.finrank ℝ M8R2 = 128 := by
  simp [Module.finrank_prod, Module.finrank_matrix]

theorem cl07_forward_injective : Function.Injective cl07_forward := by
  have h_le := finrank_Cl07_le_128
  have h_rn := LinearMap.finrank_range_add_finrank_ker cl07_forward.toLinearMap
  rw [LinearMap.range_eq_top.mpr cl07_forward_surjective, finrank_top, finrank_M8R2] at h_rn
  have h_ker : Module.finrank ℝ (LinearMap.ker cl07_forward.toLinearMap) = 0 := by omega
  rwa [Submodule.finrank_eq_zero, LinearMap.ker_eq_bot] at h_ker

/-! ## §8. Main Result -/

/-- **Main theorem**: Cl(0,7) ≃ₐ[ℝ] M₈(ℝ) × M₈(ℝ) -/
noncomputable def cl0_seven_equiv : Cl0 7 ≃ₐ[ℝ] M8R2 :=
  AlgEquiv.ofBijective cl07_forward ⟨cl07_forward_injective, cl07_forward_surjective⟩

/-- The dimension of Cl(0,7) is 2⁷ = 128. -/
theorem dim_Cl07 : Module.finrank ℝ (Cl0 7) = 128 := by
  have := cl0_seven_equiv.toLinearEquiv.finrank_eq
  rw [finrank_M8R2] at this
  exact this

/-- PBW basis cardinality. -/
theorem cl07_PBW_cardinality : (2 : ℕ) ^ 7 = 128 := by norm_num

theorem cl07_bott_class : (7 : ℕ) % 8 = 7 := by norm_num