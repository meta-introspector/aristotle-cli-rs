/-
# Cl(0,3) ≃ₐ[ℝ] ℍ × ℍ

We construct an explicit ℝ-algebra isomorphism between the Clifford algebra
Cl(0,3) (of the negative-definite quadratic form on ℝ³) and the product
algebra ℍ × ℍ (two copies of the real quaternions).
-/

import Mathlib
import RequestProject.CliffordBase

set_option maxHeartbeats 1600000

open CliffordAlgebra

/-! ## §1. Basic Elements and Relations -/

noncomputable def cl03_gen (i : Fin 3) : Cl0 3 :=
  ι (negDefForm 3) (stdBasis 3 i)

noncomputable def cl03_vol : Cl0 3 := cl03_gen 0 * cl03_gen 1 * cl03_gen 2

theorem cl03_gen_sq (i : Fin 3) :
    cl03_gen i * cl03_gen i = algebraMap ℝ (Cl0 3) (-1) := by
  unfold cl03_gen; rw [ι_sq_scalar]; congr 1; exact negDefForm_basis 3 i

theorem cl03_gen_sq' (i : Fin 3) :
    cl03_gen i * cl03_gen i = -(1 : Cl0 3) := by
  rw [cl03_gen_sq, map_neg, map_one]

theorem cl03_anticommute {i j : Fin 3} (hij : i ≠ j) :
    cl03_gen i * cl03_gen j + cl03_gen j * cl03_gen i = 0 := by
      fin_cases i <;> fin_cases j <;> simp_all +decide;
      all_goals unfold cl03_gen; simp +decide [ ι_mul_ι_add_swap, negDefForm, stdBasis ] ;
      all_goals simp +decide [ Fin.sum_univ_three, QuadraticMap.polar ] ;

theorem cl03_gen_swap {i j : Fin 3} (hij : i ≠ j) :
    cl03_gen i * cl03_gen j = -(cl03_gen j * cl03_gen i) :=
  eq_neg_of_add_eq_zero_left (cl03_anticommute hij)

theorem cl03_vol_sq : cl03_vol * cl03_vol = 1 := by
  unfold cl03_vol;
  simp +decide [ ← mul_assoc, cl03_gen_sq' ];
  simp +decide [ mul_assoc, cl03_gen_swap ( show 0 ≠ 1 by decide ), cl03_gen_swap ( show 0 ≠ 2 by decide ), cl03_gen_swap ( show 1 ≠ 2 by decide ), cl03_gen_sq' ]

theorem cl03_vol_comm (i : Fin 3) :
    cl03_vol * cl03_gen i = cl03_gen i * cl03_vol := by
      fin_cases i <;> simp +decide [ cl03_vol, mul_assoc ];
      · simp +decide only [cl03_gen_swap (by decide : (2 : Fin 3) ≠ 0), ← mul_assoc];
        simp +decide [ mul_assoc, cl03_gen_swap ( by decide : ( 1 : Fin 3 ) ≠ 0 ) ];
        simp +decide [ ← mul_assoc, cl03_gen_swap ( by decide : ( 1 : Fin 3 ) ≠ 0 ) ];
      · simp +decide only [cl03_gen_swap (by decide : (1 : Fin 3) ≠ 2)];
        simp +decide [ ← mul_assoc, cl03_gen_swap ( by decide : ( 0 : Fin 3 ) ≠ 1 ) ];
      · simp +decide only [cl03_gen_sq'];
        simp +decide [ ← mul_assoc, cl03_gen_swap ( show 0 ≠ 2 by decide ), cl03_gen_swap ( show 1 ≠ 2 by decide ) ];
        simp +decide [ mul_assoc, cl03_gen_sq' ]

/-! ## §2. Forward Map -/

noncomputable def cl03_forward_lin : (Fin 3 → ℝ) →ₗ[ℝ] Quaternion ℝ × Quaternion ℝ where
  toFun v := (⟨0, v 0, v 1, v 2⟩, ⟨0, -(v 0), -(v 1), -(v 2)⟩)
  map_add' u v := by ext <;> simp [add_comm]
  map_smul' r v := by ext <;> simp [mul_neg]

theorem cl03_clifford_sq (v : Fin 3 → ℝ) :
    cl03_forward_lin v * cl03_forward_lin v =
    algebraMap ℝ (Quaternion ℝ × Quaternion ℝ) (negDefForm 3 v) := by
      ext <;> simp +decide [ negDefForm ];
      all_goals simp +decide [ Fin.sum_univ_three, cl03_forward_lin ] ; ring

noncomputable def cl03_forward : Cl0 3 →ₐ[ℝ] Quaternion ℝ × Quaternion ℝ :=
  CliffordAlgebra.lift (negDefForm 3) ⟨cl03_forward_lin, cl03_clifford_sq⟩

theorem cl03_forward_gen (v : Fin 3 → ℝ) :
    cl03_forward (ι (negDefForm 3) v) = cl03_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §3. Central Idempotents -/

noncomputable def p_plus : Cl0 3 := (1/2 : ℝ) • ((1 : Cl0 3) - cl03_vol)
noncomputable def p_minus : Cl0 3 := (1/2 : ℝ) • ((1 : Cl0 3) + cl03_vol)

theorem p_plus_add_minus : p_plus + p_minus = 1 := by
  unfold p_plus p_minus; module

theorem p_plus_sq : p_plus * p_plus = p_plus := by
  unfold p_plus;
  simp +decide [ mul_sub, sub_mul, smul_smul, cl03_vol_sq ];
  module

theorem p_minus_sq : p_minus * p_minus = p_minus := by
  unfold p_minus; ring_nf; norm_num;
  simp +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, cl03_vol_sq ];
  module

theorem p_plus_mul_minus : p_plus * p_minus = 0 := by
  unfold p_plus p_minus;
  simp +decide [ mul_add, add_mul, sub_mul, mul_sub, ← mul_assoc, cl03_vol_sq ];
  module

theorem p_minus_mul_plus : p_minus * p_plus = 0 := by
  unfold p_minus p_plus;
  simp +decide [ mul_sub, sub_mul, mul_add, add_mul, mul_assoc, mul_left_comm, cl03_vol_sq ];
  abel1

theorem p_plus_comm_gen (i : Fin 3) :
    p_plus * cl03_gen i = cl03_gen i * p_plus := by
      simp +decide only [p_plus];
      simp +decide [ mul_sub, sub_mul, mul_assoc, cl03_vol_comm ]

theorem p_minus_comm_gen (i : Fin 3) :
    p_minus * cl03_gen i = cl03_gen i * p_minus := by
      unfold p_minus;
      simp +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, cl03_vol_comm ]

/-! ## §4. Quaternion Embedding -/

/-- φ : ℍ → Cl(0,3) mapping i ↦ e₂e₃, j ↦ -e₁e₃, k ↦ e₁e₂ -/
noncomputable def phi_quat (q : Quaternion ℝ) : Cl0 3 :=
  q.re • (1 : Cl0 3) + q.imI • (cl03_gen 1 * cl03_gen 2)
  - q.imJ • (cl03_gen 0 * cl03_gen 2) + q.imK • (cl03_gen 0 * cl03_gen 1)

theorem phi_quat_one : phi_quat 1 = 1 := by unfold phi_quat; simp

theorem phi_quat_mul (a b : Quaternion ℝ) :
    phi_quat (a * b) = phi_quat a * phi_quat b := by
      -- The goal is to show that two expressions are equal, but they appear to be different. This suggests a mistake in the setup or definitions. Let's re-examine the definitions of `phi_quat` and the multiplication in the Clifford algebra.
      by_contra h_contra
      generalize_proofs at *; (
      exact h_contra <| by
        have h_eq : ∀ (a b : Quaternion ℝ), phi_quat (a * b) = phi_quat a * phi_quat b := by
          intros a b
          simp [phi_quat, QuaternionAlgebra.mk_mul_mk] at *; (
          simp +decide [ mul_add, add_mul, mul_assoc, mul_left_comm, sub_eq_add_neg, add_assoc, smul_add, smul_sub, smul_smul ] at *; (
          simp +decide [ ← mul_assoc, cl03_gen_swap ( show 0 ≠ 1 by decide ), cl03_gen_swap ( show 0 ≠ 2 by decide ), cl03_gen_swap ( show 1 ≠ 2 by decide ), cl03_gen_sq' ] at *; (
                                                                                                                                        simp +decide [ mul_assoc, cl03_gen_swap ( show 0 ≠ 1 by decide ), cl03_gen_swap ( show 0 ≠ 2 by decide ), cl03_gen_swap ( show 1 ≠ 2 by decide ), cl03_gen_sq' ] at *; (
                                                                                                                                                                                                                                                                    simp +decide [ ← mul_assoc, cl03_gen_swap ( show 0 ≠ 1 by decide ), cl03_gen_swap ( show 0 ≠ 2 by decide ), cl03_gen_swap ( show 1 ≠ 2 by decide ), cl03_gen_sq' ] at *; (
                                                                                                                                                                                                                                                                                                                                                                                                  module)))))
        exact h_eq a b;)

/-! ## §5. Inverse Map -/

private theorem quat_add_re (a b : Quaternion ℝ) : (a + b).re = a.re + b.re := rfl
private theorem quat_add_imI (a b : Quaternion ℝ) : (a + b).imI = a.imI + b.imI := rfl
private theorem quat_add_imJ (a b : Quaternion ℝ) : (a + b).imJ = a.imJ + b.imJ := rfl
private theorem quat_add_imK (a b : Quaternion ℝ) : (a + b).imK = a.imK + b.imK := rfl
private theorem quat_smul_re (c : ℝ) (a : Quaternion ℝ) : (c • a).re = c * a.re := rfl
private theorem quat_smul_imI (c : ℝ) (a : Quaternion ℝ) : (c • a).imI = c * a.imI := rfl
private theorem quat_smul_imJ (c : ℝ) (a : Quaternion ℝ) : (c • a).imJ = c * a.imJ := rfl
private theorem quat_smul_imK (c : ℝ) (a : Quaternion ℝ) : (c • a).imK = c * a.imK := rfl

noncomputable def cl03_inv_fun (p : Quaternion ℝ × Quaternion ℝ) : Cl0 3 :=
  ((p.1.re + p.2.re) / 2) • (1 : Cl0 3)
  + ((p.1.imI - p.2.imI) / 2) • cl03_gen 0
  + ((p.1.imJ - p.2.imJ) / 2) • cl03_gen 1
  + ((p.1.imK - p.2.imK) / 2) • cl03_gen 2
  + ((p.1.imK + p.2.imK) / 2) • (cl03_gen 0 * cl03_gen 1)
  + ((-(p.1.imJ + p.2.imJ)) / 2) • (cl03_gen 0 * cl03_gen 2)
  + ((p.1.imI + p.2.imI) / 2) • (cl03_gen 1 * cl03_gen 2)
  + ((p.2.re - p.1.re) / 2) • cl03_vol

noncomputable def cl03_inv : Quaternion ℝ × Quaternion ℝ →ₗ[ℝ] Cl0 3 where
  toFun := cl03_inv_fun
  map_add' a b := by
    unfold cl03_inv_fun
    simp only [Prod.fst_add, Prod.snd_add, quat_add_re, quat_add_imI, quat_add_imJ, quat_add_imK]
    module
  map_smul' r a := by
    unfold cl03_inv_fun
    simp only [Prod.smul_fst, Prod.smul_snd, RingHom.id_apply,
      quat_smul_re, quat_smul_imI, quat_smul_imJ, quat_smul_imK]
    module

theorem cl03_inv_decomp (q₁ q₂ : Quaternion ℝ) :
    cl03_inv (q₁, q₂) = phi_quat q₁ * p_plus + phi_quat q₂ * p_minus := by
      unfold cl03_inv phi_quat p_plus p_minus;
      simp +decide [ cl03_inv_fun, mul_sub, sub_mul, mul_add, add_mul, mul_assoc, mul_left_comm, mul_comm ];
      simp +decide [ ← mul_assoc, cl03_vol ];
      simp +decide [ mul_assoc, cl03_gen_swap ( show 0 ≠ 1 from by decide ), cl03_gen_swap ( show 0 ≠ 2 from by decide ), cl03_gen_swap ( show 1 ≠ 2 from by decide ), cl03_gen_sq' ] ; ring;
      simp +decide [ ← mul_assoc, cl03_gen_swap ( show 0 ≠ 1 from by decide ), cl03_gen_swap ( show 0 ≠ 2 from by decide ), cl03_gen_swap ( show 1 ≠ 2 from by decide ), cl03_gen_sq' ] ; ring;
      module

/-! ## §6. Inverse is an AlgHom -/

theorem cl03_inv_map_one : cl03_inv (1 : Quaternion ℝ × Quaternion ℝ) = 1 := by
  convert cl03_inv_decomp 1 1 using 1 ; norm_num [ cl03_vol_sq, p_plus_add_minus, phi_quat_one ]

theorem cl03_inv_map_mul (x y : Quaternion ℝ × Quaternion ℝ) :
    cl03_inv (x * y) = cl03_inv x * cl03_inv y := by
  obtain ⟨x₁, x₂⟩ := x; obtain ⟨y₁, y₂⟩ := y
  rw [show (x₁, x₂) * (y₁, y₂) = (x₁ * y₁, x₂ * y₂) from rfl]
  rw [cl03_inv_decomp, cl03_inv_decomp, cl03_inv_decomp]
  rw [phi_quat_mul, phi_quat_mul]
  -- Now use idempotent properties:
  -- (φ(x₁)·p₊ + φ(x₂)·p₋)(φ(y₁)·p₊ + φ(y₂)·p₋)
  -- = φ(x₁)·p₊·φ(y₁)·p₊ + φ(x₁)·p₊·φ(y₂)·p₋ + φ(x₂)·p₋·φ(y₁)·p₊ + φ(x₂)·p₋·φ(y₂)·p₋
  -- Cross terms vanish (p₊·p₋ = 0), same terms use p² = p and centrality
  -- = φ(x₁)·φ(y₁)·p₊ + φ(x₂)·φ(y₂)·p₋
  simp +decide only [mul_add, add_mul, mul_assoc];
  -- By commutativity of multiplication, we can rearrange the terms on the right-hand side.
  have h_comm : phi_quat y₁ * p_plus = p_plus * phi_quat y₁ ∧ phi_quat y₂ * p_minus = p_minus * phi_quat y₂ := by
    unfold phi_quat;
    simp +decide [ mul_add, add_mul, mul_sub, sub_mul, mul_assoc, mul_left_comm, p_plus_comm_gen, p_minus_comm_gen ];
    simp +decide [ ← mul_assoc, p_plus_comm_gen, p_minus_comm_gen ];
    simp +decide [ mul_assoc, p_plus_comm_gen, p_minus_comm_gen ];
  simp +decide only [h_comm, ← mul_assoc, p_plus_sq, p_minus_sq, mul_one];
  simp +decide [ mul_assoc, p_plus_mul_minus, p_minus_mul_plus ]

noncomputable def cl03_inv_alg : (Quaternion ℝ × Quaternion ℝ) →ₐ[ℝ] Cl0 3 :=
  AlgHom.ofLinearMap cl03_inv cl03_inv_map_one cl03_inv_map_mul

/-! ## §7. Compositions are identity -/

theorem cl03_forward_inv (p : Quaternion ℝ × Quaternion ℝ) :
    cl03_forward (cl03_inv p) = p := by
      convert cl03_inv_decomp p.1 p.2 using 1;
      constructor <;> intro h <;> simp_all +decide [ Prod.ext_iff ];
      · exact cl03_inv_decomp p.1 p.2;
      · unfold cl03_forward p_plus p_minus phi_quat; norm_num; ring;
        unfold cl03_vol cl03_gen; norm_num [ cl03_forward_gen, cl03_forward_lin ] ; ring;
        simp +decide [ stdBasis ] ; ring;
        constructor <;> ext <;> norm_num [ QuaternionAlgebra.ext_iff ] <;> ring

theorem cl03_inv_forward_gen (v : Fin 3 → ℝ) :
    cl03_inv (cl03_forward (ι (negDefForm 3) v)) = ι (negDefForm 3) v := by
      rw [ cl03_forward_gen ] ; unfold cl03_inv ; simp +decide [ cl03_inv_fun ] ; ring;
      unfold cl03_forward_lin; ring;
      rw [ show v = v 0 • stdBasis 3 0 + v 1 • stdBasis 3 1 + v 2 • stdBasis 3 2 from _ ];
      · simp +decide [ cl03_gen, stdBasis ] ; ring!;
      · ext i; fin_cases i <;> simp +decide [ stdBasis ] ;

theorem cl03_inv_comp_forward :
    cl03_inv_alg.comp cl03_forward = AlgHom.id ℝ (Cl0 3) := by
  apply CliffordAlgebra.hom_ext
  ext v
  simp only [AlgHom.comp_toLinearMap, LinearMap.comp_apply, AlgHom.toLinearMap_apply,
    AlgHom.toLinearMap_id, LinearMap.id_apply]
  -- Need: cl03_inv_alg(cl03_forward(ι(stdBasis v))) = ι(stdBasis v)
  -- cl03_inv_alg = AlgHom.ofLinearMap cl03_inv ...
  -- So cl03_inv_alg x = cl03_inv x
  show cl03_inv (cl03_forward (ι (negDefForm 3) ((LinearMap.single ℝ (fun _ => ℝ) v) 1))) =
    ι (negDefForm 3) ((LinearMap.single ℝ (fun _ => ℝ) v) 1)
  exact cl03_inv_forward_gen _

/-! ## §8. Main Result -/

theorem cl03_forward_injective : Function.Injective cl03_forward := by
  intro a b hab
  have h1 : cl03_inv_alg (cl03_forward a) = cl03_inv_alg (cl03_forward b) := congr_arg _ hab
  rwa [show cl03_inv_alg (cl03_forward a) = a from
    AlgHom.congr_fun cl03_inv_comp_forward a,
    show cl03_inv_alg (cl03_forward b) = b from
    AlgHom.congr_fun cl03_inv_comp_forward b] at h1

theorem cl03_forward_surjective : Function.Surjective cl03_forward :=
  fun p => ⟨cl03_inv p, cl03_forward_inv p⟩

/-- **Main theorem**: Cl(0,3) ≃ₐ[ℝ] ℍ × ℍ -/
noncomputable def cl0_three_equiv : Cl0 3 ≃ₐ[ℝ] Quaternion ℝ × Quaternion ℝ :=
  AlgEquiv.ofBijective cl03_forward ⟨cl03_forward_injective, cl03_forward_surjective⟩