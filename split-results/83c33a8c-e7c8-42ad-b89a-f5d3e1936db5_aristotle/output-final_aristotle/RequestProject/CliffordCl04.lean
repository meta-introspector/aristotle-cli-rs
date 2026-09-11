/-
# Cl(0,4) ≃ₐ[ℝ] M₂(ℍ)

We construct an explicit ℝ-algebra isomorphism between the Clifford algebra
Cl(0,4) (of the negative-definite quadratic form on ℝ⁴) and the matrix
algebra M₂(ℍ) = Matrix (Fin 2) (Fin 2) (Quaternion ℝ).

## Generator images

The forward map sends:
- e₁ ↦ diag(i, -i)
- e₂ ↦ diag(j, -j)
- e₃ ↦ diag(k, -k)
- e₄ ↦ !![0, -1; 1, 0]

These satisfy eₐ² = -1 and eₐeᵦ = -eᵦeₐ for a ≠ b.
-/

import Mathlib
import RequestProject.CliffordCanonical
import RequestProject.CliffordCl04Finite

set_option maxHeartbeats 3200000

open CliffordAlgebra Matrix

abbrev M2H := Matrix (Fin 2) (Fin 2) (Quaternion ℝ)

/-! ## §1. Basic Elements and Relations -/

noncomputable def cl04_gen (i : Fin 4) : Cl0 4 :=
  ι (negDefForm 4) (stdBasis 4 i)

theorem cl04_gen_sq (i : Fin 4) :
    cl04_gen i * cl04_gen i = -(1 : Cl0 4) := by
  unfold cl04_gen; rw [ι_sq_scalar, negDefForm_basis]; simp

theorem cl04_anticommute {i j : Fin 4} (hij : i ≠ j) :
    cl04_gen i * cl04_gen j + cl04_gen j * cl04_gen i = 0 := by
  fin_cases i <;> fin_cases j <;> simp_all +decide only [cl04_gen] ;
  all_goals simp +decide [ ι_mul_ι_add_swap, negDefForm, _root_.stdBasis ] ;
  all_goals simp +decide [ Fin.sum_univ_four, QuadraticMap.polar ] ;

theorem cl04_gen_swap {i j : Fin 4} (hij : i ≠ j) :
    cl04_gen i * cl04_gen j = -(cl04_gen j * cl04_gen i) :=
  eq_neg_of_add_eq_zero_left (cl04_anticommute hij)

/-! ## §2. Forward Map: Cl(0,4) → M₂(ℍ) -/

noncomputable def qI : Quaternion ℝ := ⟨0, 1, 0, 0⟩
noncomputable def qJ : Quaternion ℝ := ⟨0, 0, 1, 0⟩
noncomputable def qK : Quaternion ℝ := ⟨0, 0, 0, 1⟩

/-
The forward linear map on the vector space ℝ⁴ → M₂(ℍ)
-/
noncomputable def cl04_forward_lin : (Fin 4 → ℝ) →ₗ[ℝ] M2H where
  toFun v :=
    v 0 • (!![qI, 0; 0, -qI] : M2H)
    + v 1 • (!![qJ, 0; 0, -qJ] : M2H)
    + v 2 • (!![qK, 0; 0, -qK] : M2H)
    + v 3 • (!![(0 : Quaternion ℝ), -1; 1, 0] : M2H)
  map_add' u v := by
    simp +decide [ add_smul, add_assoc, add_comm, add_left_comm ]
  map_smul' r v := by
    simp +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, ← smul_assoc ]

/-
The forward linear map satisfies the Clifford relation
-/
theorem cl04_clifford_sq (v : Fin 4 → ℝ) :
    cl04_forward_lin v * cl04_forward_lin v =
    algebraMap ℝ M2H (negDefForm 4 v) := by
  unfold cl04_forward_lin;
  ext i j;
  · fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, negDefForm ] <;> ring!;
    · simp +decide [ Fin.sum_univ_four, Algebra.algebraMap_eq_smul_one ] ; ring!;
      unfold qI; norm_num; ring;
    · erw [ Finset.sum_apply, Finset.sum_apply ] ; norm_num [ Algebra.algebraMap_eq_smul_one ];
    · erw [ Finset.sum_apply, Finset.sum_apply ] ; norm_num [ Algebra.algebraMap_eq_smul_one ];
    · simp +decide [ Fin.sum_univ_four, Algebra.algebraMap_eq_smul_one ] ; ring!;
      unfold qI; norm_num ; ring;
  · fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, negDefForm ] <;> ring!;
    · simp +decide [ Fin.sum_univ_succ, Algebra.algebraMap_eq_smul_one ] ; ring!;
      unfold qI; norm_num;
    · norm_num [ Fin.sum_univ_four, Matrix.mul_apply, Algebra.algebraMap_eq_smul_one ];
    · simp +decide [ Algebra.algebraMap_eq_smul_one ];
      simp +decide [ Fin.sum_univ_four ];
    · simp +decide [ Fin.sum_univ_four, Algebra.algebraMap_eq_smul_one ] ; ring!;
      unfold qI; norm_num;
  · fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, negDefForm ] <;> ring!;
    · simp +decide [ Fin.sum_univ_four, Algebra.algebraMap_eq_smul_one ] ; ring!;
      unfold qI qJ; norm_num;
    · simp +decide [ Algebra.algebraMap_eq_smul_one ];
      simp +decide [ Fin.sum_univ_four ];
    · simp_all +decide [ Fin.sum_univ_four, Algebra.algebraMap_eq_smul_one ];
    · simp +decide [ Fin.sum_univ_four, Algebra.algebraMap_eq_smul_one ] ; ring!;
      unfold qI qJ; norm_num;
  · fin_cases i <;> fin_cases j <;> simp +decide [ Matrix.mul_apply, negDefForm ] <;> ring!;
    · simp +decide [ Fin.sum_univ_four, Algebra.algebraMap_eq_smul_one ] ; ring!;
      unfold qI qK; norm_num;
    · simp +decide [ Algebra.algebraMap_eq_smul_one ];
      simp +decide [ Fin.sum_univ_four, Matrix.sum_apply ];
    · simp +decide [ Fin.sum_univ_four, Algebra.algebraMap_eq_smul_one ];
    · simp +decide [ Fin.sum_univ_four, qI, qJ, qK ] ; ring!;
      norm_num [ Algebra.algebraMap_eq_smul_one ]

/-- The forward algebra homomorphism via CliffordAlgebra.lift -/
noncomputable def cl04_forward : Cl0 4 →ₐ[ℝ] M2H :=
  CliffordAlgebra.lift (negDefForm 4) ⟨cl04_forward_lin, cl04_clifford_sq⟩

theorem cl04_forward_gen (v : Fin 4 → ℝ) :
    cl04_forward (ι (negDefForm 4) v) = cl04_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §2.5 Forward map on standard basis vectors -/

theorem cl04_forward_e0 : cl04_forward (cl04_gen 0) = !![qI, 0; 0, -qI] := by
  convert cl04_forward_gen ( stdBasis 4 0 ) using 1;
  unfold cl04_forward_lin;
  simp +decide [ _root_.stdBasis ]

theorem cl04_forward_e1 : cl04_forward (cl04_gen 1) = !![qJ, 0; 0, -qJ] := by
  convert cl04_forward_gen ( stdBasis 4 1 ) using 1;
  unfold cl04_forward_lin; simp +decide [ _root_.stdBasis ] ;

theorem cl04_forward_e2 : cl04_forward (cl04_gen 2) = !![qK, 0; 0, -qK] := by
  convert cl04_forward_gen ( stdBasis 4 2 ) using 1;
  unfold cl04_forward_lin _root_.stdBasis; norm_num [ Fin.ext_iff, Matrix.map_apply ] ;

theorem cl04_forward_e3 : cl04_forward (cl04_gen 3) =
    !![(0 : Quaternion ℝ), -1; 1, 0] := by
  convert cl04_forward_gen ( stdBasis 4 3 ) using 1;
  unfold cl04_forward_lin;
  simp +decide [ _root_.stdBasis ]

/-! ## §3. Inverse Linear Map: M₂(ℍ) → Cl(0,4)

The 16-dimensional inverse map sends each matrix component to
the appropriate Clifford algebra element. -/

noncomputable def cl04_inv (M : M2H) : Cl0 4 :=
  -- From diagonal entries:
  (((M 0 0).re + (M 1 1).re) / 2 : ℝ) • (1 : Cl0 4)
  + (((M 0 0).imI - (M 1 1).imI) / 2 : ℝ) • cl04_gen 0
  + (((M 0 0).imJ - (M 1 1).imJ) / 2 : ℝ) • cl04_gen 1
  + (((M 0 0).imK - (M 1 1).imK) / 2 : ℝ) • cl04_gen 2
  + (((M 0 0).imK + (M 1 1).imK) / 2 : ℝ) • (cl04_gen 0 * cl04_gen 1)
  + ((-(((M 0 0).imJ + (M 1 1).imJ)) / 2 : ℝ)) • (cl04_gen 0 * cl04_gen 2)
  + (((M 0 0).imI + (M 1 1).imI) / 2 : ℝ) • (cl04_gen 1 * cl04_gen 2)
  + (((M 1 1).re - (M 0 0).re) / 2 : ℝ) • (cl04_gen 0 * cl04_gen 1 * cl04_gen 2)
  -- From off-diagonal entries:
  + (((M 1 0).re - (M 0 1).re) / 2 : ℝ) • cl04_gen 3
  + ((-((M 0 1).imI + (M 1 0).imI) / 2 : ℝ)) • (cl04_gen 0 * cl04_gen 3)
  + ((-((M 0 1).imJ + (M 1 0).imJ) / 2 : ℝ)) • (cl04_gen 1 * cl04_gen 3)
  + ((-((M 0 1).imK + (M 1 0).imK) / 2 : ℝ)) • (cl04_gen 2 * cl04_gen 3)
  + ((((M 1 0).imK - (M 0 1).imK) / 2 : ℝ)) • (cl04_gen 0 * cl04_gen 1 * cl04_gen 3)
  + ((((M 0 1).imJ - (M 1 0).imJ) / 2 : ℝ)) • (cl04_gen 0 * cl04_gen 2 * cl04_gen 3)
  + ((((M 1 0).imI - (M 0 1).imI) / 2 : ℝ)) • (cl04_gen 1 * cl04_gen 2 * cl04_gen 3)
  + ((((M 0 1).re + (M 1 0).re) / 2 : ℝ)) • (cl04_gen 0 * cl04_gen 1 * cl04_gen 2 * cl04_gen 3)

/-! ## §4. Round-trip: inverse ∘ forward = id on generators -/

theorem cl04_inv_forward_gen (a : Fin 4) :
    cl04_inv (cl04_forward (cl04_gen a)) = cl04_gen a := by
  fin_cases a <;> simp +decide [ cl04_forward_e0, cl04_forward_e1, cl04_forward_e2, cl04_forward_e3 ] at *;
  · unfold cl04_inv cl04_gen;
    simp +decide [ qI ];
  · unfold cl04_inv; simp +decide [ qJ ] ;
  · unfold cl04_inv cl04_gen;
    simp +decide [ qK ] at *;
  · unfold cl04_inv cl04_gen;
    norm_num [ _root_.stdBasis ] at *

/-! ## §5. Round-trip: forward ∘ inverse = id -/

theorem cl04_forward_inv (M : M2H) :
    cl04_forward (cl04_inv M) = M := by
  refine' Matrix.ext fun i j => _;
  fin_cases i <;> fin_cases j <;> simp +decide [ cl04_inv ];
  · simp +decide [ cl04_forward_e0, cl04_forward_e1, cl04_forward_e2, cl04_forward_e3 ];
    ext <;> norm_num [ qI, qJ, qK ] <;> ring;
  · simp +decide [ cl04_forward_e0, cl04_forward_e1, cl04_forward_e2, cl04_forward_e3 ];
    ext <;> norm_num [ qI, qJ, qK ] <;> ring;
  · simp +decide [ cl04_forward_e0, cl04_forward_e1, cl04_forward_e2, cl04_forward_e3 ];
    ext <;> norm_num [ qI, qJ, qK ] <;> ring;
  · rw [ cl04_forward_e0, cl04_forward_e1, cl04_forward_e2, cl04_forward_e3 ] ; norm_num ; ring;
    ext <;> norm_num [ qI, qJ, qK ] <;> ring

/-! ## §6. Main Result -/

/-- Injectivity of the forward map.

    Cl(0,4) has dimension 2⁴ = 16 as an ℝ-module (proved in CliffordCl04Finite.lean).
    Since M₂(ℍ) also has dimension 16 and cl04_forward is surjective, a surjective
    linear map between equal-dimensional spaces is injective. -/
theorem cl04_forward_surjective : Function.Surjective cl04_forward :=
  fun M => ⟨cl04_inv M, cl04_forward_inv M⟩

theorem cl04_forward_injective : Function.Injective cl04_forward := by
  have h_finrank : Module.finrank ℝ (Cl0 4) = Module.finrank ℝ M2H := by
    have h_dim : Module.finrank ℝ (Cl0 4) ≥ Module.finrank ℝ M2H := by
      have h_surjective : Function.Surjective cl04_forward := by
        -- Apply the theorem that states cl04_forward is surjective.
        apply cl04_forward_surjective;
      have := LinearMap.finrank_range_add_finrank_ker ( cl04_forward.toLinearMap );
      rw [ ← this, LinearMap.range_eq_top.mpr h_surjective ] ; norm_num;
    refine' le_antisymm _ h_dim;
    have h_span : Module.finrank ℝ (Cl0 4) ≤ 16 := by
      have h_span : Submodule.span ℝ (cl04_monoSet) = ⊤ := by
        convert cl04_monoSpan_eq_top;
      have h_card : Set.ncard cl04_monoSet ≤ 16 := by
        refine' le_trans ( Set.ncard_insert_le _ _ ) _;
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        refine' Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) _ );
        exact Nat.succ_le_succ ( le_trans ( Set.ncard_insert_le _ _ ) ( by linarith [ Set.ncard_insert_le ( cl04g 0 * cl04g 2 * cl04g 3 ) { cl04g 1 * cl04g 2 * cl04g 3, cl04g 0 * cl04g 1 * cl04g 2 * cl04g 3 }, Set.ncard_insert_le ( cl04g 1 * cl04g 2 * cl04g 3 ) { cl04g 0 * cl04g 1 * cl04g 2 * cl04g 3 }, Set.ncard_singleton ( cl04g 0 * cl04g 1 * cl04g 2 * cl04g 3 ) ] ) );
      have h_finrank_le : Module.finrank ℝ (Submodule.span ℝ (cl04_monoSet : Set (Cl0 4))) ≤ Set.ncard cl04_monoSet := by
        have h_finite : Set.Finite cl04_monoSet := by
          exact Set.Finite.subset ( Set.toFinite { 1, cl04_gen 0, cl04_gen 1, cl04_gen 2, cl04_gen 3, cl04_gen 0 * cl04_gen 1, cl04_gen 0 * cl04_gen 2, cl04_gen 0 * cl04_gen 3, cl04_gen 1 * cl04_gen 2, cl04_gen 1 * cl04_gen 3, cl04_gen 2 * cl04_gen 3, cl04_gen 0 * cl04_gen 1 * cl04_gen 2, cl04_gen 0 * cl04_gen 1 * cl04_gen 3, cl04_gen 0 * cl04_gen 2 * cl04_gen 3, cl04_gen 1 * cl04_gen 2 * cl04_gen 3, cl04_gen 0 * cl04_gen 1 * cl04_gen 2 * cl04_gen 3 } ) ( by aesop_cat )
        have := h_finite.fintype;
        exact le_trans ( finrank_span_le_card _ ) ( by simp +decide [ Set.ncard_eq_toFinset_card' ] );
      rw [ h_span, finrank_top ] at h_finrank_le ; linarith;
    convert h_span using 1;
    convert Module.finrank_matrix ( R := ℝ ) ( m := Fin 2 ) ( n := Fin 2 ) ( M := Quaternion ℝ );
    norm_num [ Quaternion.finrank_eq_four ]
  exact ((LinearMap.injective_iff_surjective_of_finrank_eq_finrank h_finrank
    (f := cl04_forward.toLinearMap)).mpr
    cl04_forward_surjective)

/-- **Main theorem**: Cl(0,4) ≃ₐ[ℝ] M₂(ℍ) -/
noncomputable def cl0_four_equiv : Cl0 4 ≃ₐ[ℝ] M2H :=
  AlgEquiv.ofBijective cl04_forward ⟨cl04_forward_injective, cl04_forward_surjective⟩