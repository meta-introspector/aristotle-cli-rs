/-
# Cl(0,5) ≃ₐ[ℝ] M₄(ℂ)

We construct an explicit ℝ-algebra isomorphism between the Clifford algebra
Cl(0,5) (of the negative-definite quadratic form on ℝ⁵) and the matrix
algebra M₄(ℂ) = Matrix (Fin 4) (Fin 4) ℂ.

## Strategy (non-circular)

1. Define the forward algebra homomorphism cl05_forward via CliffordAlgebra.lift.
2. Define an explicit inverse linear map cl05_inv : M₄(ℂ) → Cl(0,5).
3. Prove the right inverse: cl05_forward (cl05_inv M) = M → surjectivity.
4. Prove finite-dimensionality via the 32-monomial spanning set (CliffordCl05Finite).
5. Derive injectivity from surjectivity + equal finite dimensions.
6. Build AlgEquiv.ofBijective.

No step depends on the equivalence being proved — the dependency graph is acyclic.
-/

import Mathlib
import RequestProject.CliffordBase
import RequestProject.CliffordCl05Finite

set_option maxHeartbeats 6400000

open CliffordAlgebra Matrix Complex

abbrev M4C := Matrix (Fin 4) (Fin 4) ℂ

/-! ## §1. Basic Elements and Relations -/

noncomputable def cl05_gen (i : Fin 5) : Cl0 5 :=
  ι (negDefForm 5) (stdBasis 5 i)

theorem cl05_gen_sq (i : Fin 5) :
    cl05_gen i * cl05_gen i = -(1 : Cl0 5) := by
  unfold cl05_gen; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl05_anticommute {i j : Fin 5} (hij : i ≠ j) :
    cl05_gen i * cl05_gen j + cl05_gen j * cl05_gen i = 0 := by
  fin_cases i <;> fin_cases j <;> simp_all +decide only [cl05_gen]
  all_goals simp +decide [ι_mul_ι_add_swap, negDefForm, _root_.stdBasis]
  all_goals simp +decide [Fin.sum_univ_five, QuadraticMap.polar]

theorem cl05_gen_swap {i j : Fin 5} (hij : i ≠ j) :
    cl05_gen i * cl05_gen j = -(cl05_gen j * cl05_gen i) :=
  eq_neg_of_add_eq_zero_left (cl05_anticommute hij)

/-! ## §2. Generator Images in M₄(ℂ) -/

/-- The 5 generator images in M₄(ℂ), using i times standard gamma matrices. -/
noncomputable def cl05_img : Fin 5 → M4C
  | 0 => !![0, 0, 0, I; 0, 0, I, 0; 0, I, 0, 0; I, 0, 0, 0]
  | 1 => !![0, 0, 0, 1; 0, 0, -1, 0; 0, 1, 0, 0; -1, 0, 0, 0]
  | 2 => !![0, 0, I, 0; 0, 0, 0, -I; I, 0, 0, 0; 0, -I, 0, 0]
  | 3 => !![0, 0, 1, 0; 0, 0, 0, 1; -1, 0, 0, 0; 0, -1, 0, 0]
  | 4 => !![I, 0, 0, 0; 0, I, 0, 0; 0, 0, -I, 0; 0, 0, 0, -I]

/-- Each generator image squares to -I₄. -/
theorem cl05_img_sq (a : Fin 5) : cl05_img a * cl05_img a = -1 := by
  fin_cases a <;> (ext i j; fin_cases i <;> fin_cases j <;>
    simp [cl05_img, mul_apply, Fin.sum_univ_four])

/-- Generator images anticommute. -/
theorem cl05_img_anticommute {a b : Fin 5} (hab : a ≠ b) :
    cl05_img a * cl05_img b + cl05_img b * cl05_img a = 0 := by
  fin_cases a <;> fin_cases b <;> simp_all +decide <;>
    (ext i j; fin_cases i <;> fin_cases j <;>
      simp [cl05_img, mul_apply, Fin.sum_univ_four] <;> ring)

/-! ## §3. Forward Map: Cl(0,5) → M₄(ℂ) -/

/-- The forward linear map on ℝ⁵ → M₄(ℂ). -/
noncomputable def cl05_forward_lin : (Fin 5 → ℝ) →ₗ[ℝ] M4C where
  toFun v :=
    v 0 • cl05_img 0 + v 1 • cl05_img 1 + v 2 • cl05_img 2 +
    v 3 • cl05_img 3 + v 4 • cl05_img 4
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

/-- The forward linear map satisfies the Clifford relation. -/
theorem cl05_clifford_sq (v : Fin 5 → ℝ) :
    cl05_forward_lin v * cl05_forward_lin v =
    algebraMap ℝ M4C (negDefForm 5 v) := by
  simp +decide [cl05_forward_lin, negDefForm]
  simp +decide [Fin.sum_univ_five, mul_add, add_mul, mul_assoc, mul_left_comm,
    Finset.sum_add_distrib, Algebra.algebraMap_eq_smul_one]
  simp +decide [← Matrix.ext_iff, Fin.forall_fin_succ]
  simp +decide [cl05_img] at *
  ring_nf at *; aesop (simp_config := { decide := true })

/-- The forward algebra homomorphism via CliffordAlgebra.lift -/
noncomputable def cl05_forward : Cl0 5 →ₐ[ℝ] M4C :=
  CliffordAlgebra.lift (negDefForm 5) ⟨cl05_forward_lin, cl05_clifford_sq⟩

theorem cl05_forward_gen (v : Fin 5 → ℝ) :
    cl05_forward (ι (negDefForm 5) v) = cl05_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §4. Explicit Inverse Map: M₄(ℂ) → Cl(0,5)

The inverse extracts 32 real coefficients from the matrix and maps them
to the corresponding Clifford basis monomials. All coefficients are ±1/4,
verified by inverting the 32×32 basis-image matrix. -/

noncomputable def cl05_inv (M : M4C) : Cl0 5 :=
  (((M 0 0).re + (M 1 1).re + (M 2 2).re + (M 3 3).re) / 4 : ℝ) • (1 : Cl0 5)
  + (((M 0 3).im + (M 1 2).im + (M 2 1).im + (M 3 0).im) / 4 : ℝ) • cl05_gen 0
  + (((M 0 3).re - (M 1 2).re + (M 2 1).re - (M 3 0).re) / 4 : ℝ) • cl05_gen 1
  + (((M 0 2).im - (M 1 3).im + (M 2 0).im - (M 3 1).im) / 4 : ℝ) • cl05_gen 2
  + (((M 0 2).re + (M 1 3).re - (M 2 0).re - (M 3 1).re) / 4 : ℝ) • cl05_gen 3
  + (((M 0 0).im + (M 1 1).im - (M 2 2).im - (M 3 3).im) / 4 : ℝ) • cl05_gen 4
  + ((-(M 0 0).im + (M 1 1).im - (M 2 2).im + (M 3 3).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1)
  + (((M 0 1).re - (M 1 0).re + (M 2 3).re - (M 3 2).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 2)
  + ((-(M 0 1).im - (M 1 0).im + (M 2 3).im + (M 3 2).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 3)
  + (((M 0 3).re + (M 1 2).re - (M 2 1).re - (M 3 0).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 4)
  + ((-(M 0 1).im - (M 1 0).im - (M 2 3).im - (M 3 2).im) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 2)
  + ((-(M 0 1).re + (M 1 0).re + (M 2 3).re - (M 3 2).re) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 3)
  + ((-(M 0 3).im + (M 1 2).im + (M 2 1).im - (M 3 0).im) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 4)
  + ((-(M 0 0).im + (M 1 1).im + (M 2 2).im - (M 3 3).im) / 4 : ℝ) • (cl05_gen 2 * cl05_gen 3)
  + (((M 0 2).re - (M 1 3).re - (M 2 0).re + (M 3 1).re) / 4 : ℝ) • (cl05_gen 2 * cl05_gen 4)
  + ((-(M 0 2).im - (M 1 3).im - (M 2 0).im - (M 3 1).im) / 4 : ℝ) • (cl05_gen 3 * cl05_gen 4)
  + (((M 0 2).re + (M 1 3).re + (M 2 0).re + (M 3 1).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 2)
  + ((-(M 0 2).im + (M 1 3).im + (M 2 0).im - (M 3 1).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 3)
  + (((M 0 0).re - (M 1 1).re - (M 2 2).re + (M 3 3).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 4)
  + (((M 0 3).re - (M 1 2).re - (M 2 1).re + (M 3 0).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 2 * cl05_gen 3)
  + (((M 0 1).im - (M 1 0).im - (M 2 3).im + (M 3 2).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 2 * cl05_gen 4)
  + (((M 0 1).re + (M 1 0).re + (M 2 3).re + (M 3 2).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 3).im - (M 1 2).im + (M 2 1).im + (M 3 0).im) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 2 * cl05_gen 3)
  + (((M 0 1).re + (M 1 0).re - (M 2 3).re - (M 3 2).re) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 2 * cl05_gen 4)
  + ((-(M 0 1).im + (M 1 0).im - (M 2 3).im + (M 3 2).im) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 3 * cl05_gen 4)
  + (((M 0 0).re - (M 1 1).re + (M 2 2).re - (M 3 3).re) / 4 : ℝ) • (cl05_gen 2 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 0).re - (M 1 1).re + (M 2 2).re + (M 3 3).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 2 * cl05_gen 3)
  + ((-(M 0 2).im - (M 1 3).im + (M 2 0).im + (M 3 1).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 2 * cl05_gen 4)
  + ((-(M 0 2).re + (M 1 3).re - (M 2 0).re + (M 3 1).re) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 3).im + (M 1 2).im - (M 2 1).im + (M 3 0).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 2 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 3).re - (M 1 2).re - (M 2 1).re - (M 3 0).re) / 4 : ℝ) • (cl05_gen 1 * cl05_gen 2 * cl05_gen 3 * cl05_gen 4)
  + ((-(M 0 0).im - (M 1 1).im - (M 2 2).im - (M 3 3).im) / 4 : ℝ) • (cl05_gen 0 * cl05_gen 1 * cl05_gen 2 * cl05_gen 3 * cl05_gen 4)

/-! ## §5. Right Inverse: cl05_forward ∘ cl05_inv = id -/

/-
The forward map applied to the inverse gives the identity on M₄(ℂ).
-/
theorem cl05_forward_inv (M : M4C) :
    cl05_forward (cl05_inv M) = M := by
  revert M;
  intro M
  unfold cl05_inv cl05_forward
  simp [cl05_forward_gen, cl05_gen] at *;
  simp +decide [ cl05_forward_lin, _root_.stdBasis ];
  simp +decide [ cl05_img ];
  simp +decide [ ← Matrix.ext_iff, Fin.forall_fin_succ ] at *;
  simp +decide [ Complex.ext_iff ] at *;
  grind

/-! ## §6. Surjectivity (from the right inverse) -/

theorem cl05_forward_surjective : Function.Surjective cl05_forward :=
  fun M => ⟨cl05_inv M, cl05_forward_inv M⟩

/-! ## §7. Injectivity (from surjectivity + equal finite dimensions) -/

private theorem finrank_M4C : Module.finrank ℝ M4C = 32 := by
  simp [Module.finrank_matrix, Complex.finrank_real_complex]

/-
The forward map is injective.
    Since Cl(0,5) is finite-dimensional (CliffordCl05Finite) with finrank ≤ 32,
    and cl05_forward is surjective onto the 32-dimensional M₄(ℂ),
    the finranks must be equal, so surjective → injective.
-/
theorem cl05_forward_injective : Function.Injective cl05_forward := by
  have h_le := finrank_Cl05_le_32
  have h_rn := LinearMap.finrank_range_add_finrank_ker cl05_forward.toLinearMap
  rw [LinearMap.range_eq_top.mpr cl05_forward_surjective, finrank_top, finrank_M4C] at h_rn
  have h_ker : Module.finrank ℝ (LinearMap.ker cl05_forward.toLinearMap) = 0 := by omega
  rwa [Submodule.finrank_eq_zero, LinearMap.ker_eq_bot] at h_ker

/-! ## §8. Main Result -/

/-- **Main theorem**: Cl(0,5) ≃ₐ[ℝ] M₄(ℂ) -/
noncomputable def cl0_five_equiv : Cl0 5 ≃ₐ[ℝ] M4C :=
  AlgEquiv.ofBijective cl05_forward ⟨cl05_forward_injective, cl05_forward_surjective⟩