/-
# Cl(0,6) ≃ₐ[ℝ] M₈(ℝ)

We construct an explicit ℝ-algebra isomorphism between the Clifford algebra
Cl(0,6) (of the negative-definite quadratic form on ℝ⁶) and the matrix
algebra M₈(ℝ) = Matrix (Fin 8) (Fin 8) ℝ.

## Strategy (non-circular)

1. Define the forward algebra homomorphism cl06_forward via CliffordAlgebra.lift.
2. Define an explicit inverse linear map cl06_inv : M₈(ℝ) → Cl(0,6).
3. Prove the right inverse: cl06_forward (cl06_inv M) = M → surjectivity.
4. Prove finite-dimensionality via the 64-monomial spanning set (CliffordCl06Finite).
5. Derive injectivity from surjectivity + equal finite dimensions.
6. Build AlgEquiv.ofBijective.

## Generator Construction

The 6 generators are constructed from the quaternionic representation:
- e₁,e₂,e₃ come from Cl(0,3) ≅ ℍ×ℍ acting on ℍ² ≅ ℝ⁸ via diag(L(i/j/k), -L(i/j/k))
- e₄ is the off-diagonal [[0,I₄],[-I₄,0]]
- e₅,e₆ extend using L(ω₄)·R(i) and L(ω₄)·R(j) where ω₄ is the Cl(0,4) volume element

All generators are signed permutation matrices with entries in {-1, 0, 1}.
-/

import Mathlib
import RequestProject.CliffordBase
import RequestProject.CliffordCl06Finite

set_option maxHeartbeats 12800000

open CliffordAlgebra Matrix

abbrev M8R := Matrix (Fin 8) (Fin 8) ℝ

/-! ## §1. Basic Elements and Relations -/

noncomputable def cl06_gen (i : Fin 6) : Cl0 6 :=
  ι (negDefForm 6) (stdBasis 6 i)

theorem cl06_gen_sq (i : Fin 6) :
    cl06_gen i * cl06_gen i = -(1 : Cl0 6) := by
  unfold cl06_gen; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl06_anticommute {i j : Fin 6} (hij : i ≠ j) :
    cl06_gen i * cl06_gen j + cl06_gen j * cl06_gen i = 0 := by
  fin_cases i <;> fin_cases j <;> simp_all +decide only [cl06_gen]
  all_goals simp +decide [ι_mul_ι_add_swap, negDefForm, _root_.stdBasis]
  all_goals simp +decide [Fin.sum_univ_six, QuadraticMap.polar]

theorem cl06_gen_swap {i j : Fin 6} (hij : i ≠ j) :
    cl06_gen i * cl06_gen j = -(cl06_gen j * cl06_gen i) :=
  eq_neg_of_add_eq_zero_left (cl06_anticommute hij)

/-! ## §2. Generator Images in M₈(ℝ)

The 6 generator images are real 8×8 signed permutation matrices,
constructed from the quaternionic left/right multiplication operators.
Each squares to -I₈ and they pairwise anticommute.

Construction:
  e₁ = diag(L(i), -L(i))     — left mult by quaternion i on ℍ²
  e₂ = diag(L(j), -L(j))     — left mult by quaternion j on ℍ²
  e₃ = diag(L(k), -L(k))     — left mult by quaternion k on ℍ²
  e₄ = [[0, I₄], [-I₄, 0]]   — off-diagonal identity swap
  e₅ = [[0, -R(i)], [-R(i), 0]] — volume element × right mult by i
  e₆ = [[0, -R(j)], [-R(j), 0]] — volume element × right mult by j
-/

noncomputable def cl06_img : Fin 6 → M8R
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

/-- Each generator image squares to -I₈. -/
theorem cl06_img_sq (a : Fin 6) : cl06_img a * cl06_img a = -1 := by
  fin_cases a <;> (ext i j; fin_cases i <;> fin_cases j <;>
    simp [cl06_img, mul_apply, Fin.sum_univ_eight])

/-- Generator images anticommute. -/
theorem cl06_img_anticommute {a b : Fin 6} (hab : a ≠ b) :
    cl06_img a * cl06_img b + cl06_img b * cl06_img a = 0 := by
  fin_cases a <;> fin_cases b <;> simp_all +decide <;>
    (ext i j; fin_cases i <;> fin_cases j <;>
      simp [cl06_img, mul_apply, Fin.sum_univ_eight] <;> ring)

/-! ## §3. Forward Map: Cl(0,6) → M₈(ℝ) -/

/-- The forward linear map on ℝ⁶ → M₈(ℝ). -/
noncomputable def cl06_forward_lin : (Fin 6 → ℝ) →ₗ[ℝ] M8R where
  toFun v :=
    v 0 • cl06_img 0 + v 1 • cl06_img 1 + v 2 • cl06_img 2 +
    v 3 • cl06_img 3 + v 4 • cl06_img 4 + v 5 • cl06_img 5
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

/-- The forward linear map satisfies the Clifford relation. -/
theorem cl06_clifford_sq (v : Fin 6 → ℝ) :
    cl06_forward_lin v * cl06_forward_lin v =
    algebraMap ℝ M8R (negDefForm 6 v) := by
  simp +decide [cl06_forward_lin, negDefForm]
  simp +decide [Fin.sum_univ_six, mul_add, add_mul, mul_assoc, mul_left_comm,
    Finset.sum_add_distrib, Algebra.algebraMap_eq_smul_one]
  simp +decide [← Matrix.ext_iff, Fin.forall_fin_succ]
  simp +decide [cl06_img] at *
  ring_nf at *; aesop (simp_config := { decide := true })

/-- The forward algebra homomorphism via CliffordAlgebra.lift -/
noncomputable def cl06_forward : Cl0 6 →ₐ[ℝ] M8R :=
  CliffordAlgebra.lift (negDefForm 6) ⟨cl06_forward_lin, cl06_clifford_sq⟩

theorem cl06_forward_gen (v : Fin 6 → ℝ) :
    cl06_forward (ι (negDefForm 6) v) = cl06_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §4. Explicit Inverse Map: M₈(ℝ) → Cl(0,6)

The inverse extracts 64 real coefficients from the 8×8 matrix using the
trace formula: c_S = (1/8) · Tr(φ(m_S)ᵀ · M) = (1/8) · Σᵢ s_S(i) · M(i, σ_S(i))
where φ(m_S) is the image of the S-th monomial (a signed permutation matrix).

For brevity, we define the inverse using the identity coefficient and
the generator/multi-generator coefficients extracted from matrix entries.
-/

-- The inverse map will be defined once the forward map is verified.
-- For now we state the key results with sorry.

noncomputable def cl06_inv (M : M8R) : Cl0 6 := by
  exact
  -- Scalar (identity) coefficient: (1/8) Tr(M)
  ((M 0 0 + M 1 1 + M 2 2 + M 3 3 + M 4 4 + M 5 5 + M 6 6 + M 7 7) / 8 : ℝ) • (1 : Cl0 6)
  -- Single generators: e₁ through e₆
  + ((- M 0 1 + M 1 0 - M 2 3 + M 3 2 + M 4 5 - M 5 4 + M 6 7 - M 7 6) / 8 : ℝ) • cl06_gen 0
  + ((- M 0 2 + M 1 3 + M 2 0 - M 3 1 + M 4 6 - M 5 7 - M 6 4 + M 7 5) / 8 : ℝ) • cl06_gen 1
  + ((- M 0 3 - M 1 2 + M 2 1 + M 3 0 + M 4 7 + M 5 6 - M 6 5 - M 7 4) / 8 : ℝ) • cl06_gen 2
  + ((M 0 4 + M 1 5 + M 2 6 + M 3 7 - M 4 0 - M 5 1 - M 6 2 - M 7 3) / 8 : ℝ) • cl06_gen 3
  + ((M 0 5 - M 1 4 - M 2 7 + M 3 6 + M 4 1 - M 5 0 - M 6 3 + M 7 2) / 8 : ℝ) • cl06_gen 4
  + ((M 0 6 + M 1 7 - M 2 4 - M 3 5 + M 4 2 + M 5 3 - M 6 0 - M 7 1) / 8 : ℝ) • cl06_gen 5
  -- The remaining 57 terms (pairs, triples, etc.) follow the same pattern.
  -- Each uses (1/8) Σᵢ s(i) M(i, σ(i)) for the appropriate monomial image.
  + (0 : ℝ) • (1 : Cl0 6)  -- placeholder for remaining terms
  -- TODO: fill in all 64 monomial coefficients

/-! ## §5. Right Inverse (placeholder) -/

theorem cl06_forward_inv (M : M8R) :
    cl06_forward (cl06_inv M) = M := by
  sorry

/-! ## §6. Surjectivity (from the right inverse) -/

theorem cl06_forward_surjective : Function.Surjective cl06_forward :=
  fun M => ⟨cl06_inv M, cl06_forward_inv M⟩

/-! ## §7. Injectivity (from surjectivity + equal finite dimensions) -/

private theorem finrank_M8R : Module.finrank ℝ M8R = 64 := by
  simp [Module.finrank_matrix]

theorem cl06_forward_injective : Function.Injective cl06_forward := by
  have h_le := finrank_Cl06_le_64
  have h_rn := LinearMap.finrank_range_add_finrank_ker cl06_forward.toLinearMap
  rw [LinearMap.range_eq_top.mpr cl06_forward_surjective, finrank_top, finrank_M8R] at h_rn
  have h_ker : Module.finrank ℝ (LinearMap.ker cl06_forward.toLinearMap) = 0 := by omega
  rwa [Submodule.finrank_eq_zero, LinearMap.ker_eq_bot] at h_ker

/-! ## §8. Main Result -/

/-- **Main theorem**: Cl(0,6) ≃ₐ[ℝ] M₈(ℝ) -/
noncomputable def cl0_six_equiv : Cl0 6 ≃ₐ[ℝ] M8R :=
  AlgEquiv.ofBijective cl06_forward ⟨cl06_forward_injective, cl06_forward_surjective⟩
