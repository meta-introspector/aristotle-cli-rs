/-
# Cl(0,8) ≃ₐ[ℝ] M₁₆(ℝ)

We construct an explicit ℝ-algebra isomorphism between the Clifford algebra
Cl(0,8) and the matrix algebra M₁₆(ℝ).
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordBitBasis
import RequestProject.Math.Clifford.CliffordCl08SPerm
import RequestProject.Math.Clifford.CliffordCl08Gram

set_option maxHeartbeats 3200000

open CliffordAlgebra Submodule Matrix

noncomputable section

/-! ## §1. Type Abbreviations -/

abbrev M16R := Matrix (Fin 16) (Fin 16) ℝ
abbrev M16Z := Matrix (Fin 16) (Fin 16) ℤ

noncomputable abbrev liftZ16 : M16Z →+* M16R := (Int.castRingHom ℝ).mapMatrix

/-! ## §2. SPerm16 to Matrix Conversion -/

def SPerm16.toMatrix (sp : SPerm16) : M16Z :=
  Matrix.of fun i j => if sp.perm i = j then (if sp.sign i then 1 else -1) else 0

def gammaZ16 (k : Fin 8) : M16Z := (gamSP16 k).toMatrix

noncomputable def cl08_gamma (k : Fin 8) : M16R := liftZ16 (gammaZ16 k)

/-! ## §3. Generator Relations -/

theorem gammaZ16_sq (k : Fin 8) : gammaZ16 k * gammaZ16 k = -1 := by
  fin_cases k <;> native_decide

theorem gammaZ16_anticommute {a b : Fin 8} (hab : a ≠ b) :
    gammaZ16 a * gammaZ16 b + gammaZ16 b * gammaZ16 a = 0 := by
  fin_cases a <;> fin_cases b <;> simp_all +decide <;> native_decide

theorem cl08_gamma_sq (k : Fin 8) : cl08_gamma k * cl08_gamma k = -1 := by
  unfold cl08_gamma; rw [← map_mul, gammaZ16_sq, map_neg, map_one]

theorem cl08_gamma_anticommute {a b : Fin 8} (hab : a ≠ b) :
    cl08_gamma a * cl08_gamma b + cl08_gamma b * cl08_gamma a = 0 := by
  unfold cl08_gamma; rw [← map_mul, ← map_mul, ← map_add,
    gammaZ16_anticommute hab, map_zero]

/-! ## §4. Forward Map Construction -/

noncomputable def cl08_gen (i : Fin 8) : Cl0 8 :=
  ι (negDefForm 8) (stdBasis 8 i)

noncomputable def cl08_forward_lin : (Fin 8 → ℝ) →ₗ[ℝ] M16R where
  toFun v :=
    v 0 • cl08_gamma 0 + v 1 • cl08_gamma 1 + v 2 • cl08_gamma 2 +
    v 3 • cl08_gamma 3 + v 4 • cl08_gamma 4 + v 5 • cl08_gamma 5 +
    v 6 • cl08_gamma 6 + v 7 • cl08_gamma 7
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

theorem cl08_clifford_sq (v : Fin 8 → ℝ) :
    cl08_forward_lin v * cl08_forward_lin v =
    algebraMap ℝ M16R (negDefForm 8 v) := by
  have h_expand : cl08_forward_lin v * cl08_forward_lin v = ∑ i : Fin 8, (v i) ^ 2 • (cl08_gamma i * cl08_gamma i) + ∑ i : Fin 8, ∑ j ∈ Finset.Ioi i, (v i * v j) • (cl08_gamma i * cl08_gamma j + cl08_gamma j * cl08_gamma i) := by
    unfold cl08_forward_lin;
    simp +decide [ Fin.sum_univ_succ, Finset.sum_add_distrib, mul_add, add_mul, smul_add, add_smul, smul_mul_assoc, mul_smul_comm, pow_two ];
    module;
  have h_subst : cl08_forward_lin v * cl08_forward_lin v = ∑ i : Fin 8, (v i) ^ 2 • (-1 : M16R) + ∑ i : Fin 8, ∑ j ∈ Finset.Ioi i, (v i * v j) • (0 : M16R) := by
    convert h_expand using 3;
    · rw [ cl08_gamma_sq ];
    · exact Finset.sum_congr rfl fun j hj => by rw [ show cl08_gamma _ * cl08_gamma j + cl08_gamma j * cl08_gamma _ = 0 from cl08_gamma_anticommute <| by aesop ] ;
  simp +decide [ h_subst, negDefForm ];
  simp +decide [ ← sq, Algebra.smul_def ]

noncomputable def cl08_forward : Cl0 8 →ₐ[ℝ] M16R :=
  CliffordAlgebra.lift (negDefForm 8) ⟨cl08_forward_lin, cl08_clifford_sq⟩

theorem cl08_forward_gen (v : Fin 8 → ℝ) :
    cl08_forward (ι (negDefForm 8) v) = cl08_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §5. Module.Finite and Finrank Bound -/

instance cl08_module_finite : Module.Finite ℝ (Cl0 8) := by
  have h_span := cl0Monomial_span (n := 8)
  rw [Module.finite_def]
  have hfin : Set.Finite (Set.range (cl0Monomial 8)) := Set.finite_range _
  exact ⟨hfin.toFinset, by rw [Set.Finite.coe_toFinset]; exact h_span⟩

theorem finrank_Cl08_le_256 : Module.finrank ℝ (Cl0 8) ≤ 256 := by
  have h_span : Submodule.span ℝ (Set.range (cl0Monomial 8)) = ⊤ := by
    exact cl0Monomial_span;
  have h_card : Set.Finite (Set.range (cl0Monomial 8)) := by
    exact Set.toFinite _;
  have h_finrank_le : Module.finrank ℝ (Cl0 8) ≤ Set.ncard (Set.range (cl0Monomial 8)) := by
    convert finrank_span_le_card ( Set.range ( cl0Monomial 8 ) ) using 1;
    rw [ h_span, finrank_top ];
    convert Set.ncard_eq_toFinset_card' _;
    · exact Set.Finite.fintype h_card;
    · infer_instance;
  have h_card_le : Set.ncard (Set.range (cl0Monomial 8)) ≤ 2 ^ 8 := by
    rw [ ← card_bitvec ];
    refine' le_trans ( Set.ncard_le_ncard ( show Set.range ( cl0Monomial 8 ) ⊆ Set.image ( cl0Monomial 8 ) ( Set.univ : Set ( BitVec 8 ) ) from Set.range_subset_iff.mpr fun x => Set.mem_image_of_mem _ <| Set.mem_univ _ ) ) _;
    exact Set.ncard_image_le ( Set.toFinite _ ) |> le_trans <| by simp +decide [ Set.ncard_univ ] ;
  exact h_finrank_le.trans h_card_le

/-! ## §6. Surjectivity

Strategy: show the forward map's range has finrank ≥ 256 = dim(M₁₆(ℝ)),
which forces it to be all of M₁₆(ℝ).

We use the Gram orthogonality (from the SPerm16 verification) to show
256 linearly independent elements exist in the range.
-/

/-
SPerm16 multiplication corresponds to matrix multiplication.
-/
theorem sperm16_mul_toMatrix (a b : SPerm16) :
    (a * b).toMatrix = a.toMatrix * b.toMatrix := by
  unfold SPerm16.toMatrix;
  ext i j; simp +decide [ Matrix.mul_apply, Finset.sum_ite ] ;
  -- By definition of permutation and sign multiplication, we can split into cases based on the conditions.
  by_cases h_perm : b.perm (a.perm i) = j;
  · cases h : a.sign i <;> cases h' : b.sign ( a.perm i ) <;> simp +decide [ h, h' ];
    · erw [ show ( a * b ).sign i = ! ( xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ] ; simp +decide [ h, h', xor ];
      erw [ show ( a * b ).perm i = b.perm ( a.perm i ) from rfl ] ; aesop;
    · exact if_pos h_perm ▸ by simp +decide [ *, show ( a * b ).sign i = ! ( xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ] ;
    · rw [ show ( a * b ).sign i = ! ( xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ] ; simp +decide [ h, h', h_perm ];
      exact h_perm;
    · erw [ show ( a * b ).sign i = ! ( xor ( a.sign i ) ( b.sign ( a.perm i ) ) ) from rfl ] ; aesop;
  · split_ifs <;> simp_all +decide [ SPerm16 ];
    · exact h_perm ‹_›;
    · exact?

/-
traceProd computes trace(Aᵀ · B) for signed permutation matrices.
-/
theorem traceProd_eq_int_trace (a b : SPerm16) :
    traceProd a b = Matrix.trace (a.toMatrixᵀ * b.toMatrix) := by
  unfold traceProd; simp +decide [ Matrix.mul_apply, Matrix.trace ] ; ring;
  rw [ Finset.sum_comm ];
  rw [ Finset.sum_congr rfl ];
  rotate_right;
  use fun i => if a.perm i = b.perm i then if a.sign i = b.sign i then 1 else -1 else 0;
  · rw [ Fin.sum_univ_castSucc ] ; simp +decide [ Fin.sum_univ_succ ] ; ring!;
  · intro i hi; split_ifs <;> simp_all +decide [ SPerm16.toMatrix ] ;
    lia

/-- The real gamma monomial for subset encoded as Nat. -/
noncomputable def gammaR16_n (n : Nat) : M16R :=
  liftZ16 (monomialN n).toMatrix

/-
Gram orthogonality lifted to ℝ: trace(M_iᵀ · M_j) = 16·δ_{i,j}.
-/
theorem gram_orthogonality_real (i j : Fin 256) :
    Matrix.trace ((gammaR16_n i.val)ᵀ * gammaR16_n j.val) =
    if i = j then 16 else 0 := by
  have h_traceProd : ∀ (i j : Fin 256), traceProd (monomialN i) (monomialN j) = if i = j then 16 else 0 := by
    convert gram_orthogonality using 1;
    simp +decide [ Fin.ext_iff ];
  have h_traceProd_eq : ∀ (a b : SPerm16), traceProd a b = Matrix.trace ((a.toMatrix.map (algebraMap ℤ ℝ))ᵀ * (b.toMatrix.map (algebraMap ℤ ℝ))) := by
    intros a b
    have h_traceProd_eq : traceProd a b = Matrix.trace (a.toMatrixᵀ * b.toMatrix) := by
      convert traceProd_eq_int_trace a b using 1;
    simp +decide [ h_traceProd_eq, Matrix.trace, Matrix.mul_apply ];
  convert h_traceProd_eq ( monomialN i ) ( monomialN j ) |> Eq.symm using 1;
  rw [ h_traceProd i j ] ; aesop

/-
The 256 gammaR16_n matrices are linearly independent.
    Proof: from Gram orthogonality, if Σ c_i M_i = 0, then
    0 = trace(M_jᵀ · Σ c_i M_i) = 16 c_j, so c_j = 0.
-/
theorem gammaR16_linearIndependent :
    LinearIndependent ℝ (fun i : Fin 256 => gammaR16_n i.val) := by
  refine' Fintype.linearIndependent_iff.2 fun g hg => _;
  intro i
  have h_tr : ∑ j, g j * Matrix.trace ((gammaR16_n i.val)ᵀ * gammaR16_n j.val) = 0 := by
    convert congr_arg ( fun x => Matrix.trace ( ( gammaR16_n i.val )ᵀ * x ) ) hg using 1 <;> simp +decide [ Matrix.mul_sum, Matrix.sum_mul ];
  rw [ Finset.sum_eq_single i ] at h_tr;
  · have := gram_orthogonality_real i i; aesop;
  · intro j _ hij; rw [ gram_orthogonality_real ] ; aesop;
  · exact fun hi => False.elim <| hi <| Finset.mem_univ i

/-
Each cl08_gamma k is in the range of cl08_forward.
-/
theorem cl08_gamma_in_range (k : Fin 8) :
    cl08_gamma k ∈ Set.range cl08_forward := by
  use ι ( negDefForm 8 ) ( stdBasis 8 k );
  fin_cases k <;> simp +decide [ cl08_forward_gen ];
  all_goals unfold cl08_forward_lin; simp +decide [ _root_.stdBasis ] ;

/-
Each gammaR16_n i is in the range of cl08_forward.
    Since gammaR16_n i is a product of cl08_gamma's, and the range
    of an algebra homomorphism is closed under multiplication.
-/
theorem gammaR16_n_in_range (i : Fin 256) :
    gammaR16_n i.val ∈ Set.range cl08_forward := by
  revert i;
  have h_prod : ∀ (a b : SPerm16), (a * b).toMatrix = a.toMatrix * b.toMatrix := by
    grind +suggestions;
  intro i
  have h_prod : (monomialN i.val).toMatrix = (if i.val.testBit 0 then gammaZ16 0 else 1) * (if i.val.testBit 1 then gammaZ16 1 else 1) * (if i.val.testBit 2 then gammaZ16 2 else 1) * (if i.val.testBit 3 then gammaZ16 3 else 1) * (if i.val.testBit 4 then gammaZ16 4 else 1) * (if i.val.testBit 5 then gammaZ16 5 else 1) * (if i.val.testBit 6 then gammaZ16 6 else 1) * (if i.val.testBit 7 then gammaZ16 7 else 1) := by
    unfold monomialN gammaZ16;
    simp +decide only [h_prod];
    split_ifs <;> rfl;
  have h_prod : gammaR16_n i.val = (if i.val.testBit 0 then cl08_gamma 0 else 1) * (if i.val.testBit 1 then cl08_gamma 1 else 1) * (if i.val.testBit 2 then cl08_gamma 2 else 1) * (if i.val.testBit 3 then cl08_gamma 3 else 1) * (if i.val.testBit 4 then cl08_gamma 4 else 1) * (if i.val.testBit 5 then cl08_gamma 5 else 1) * (if i.val.testBit 6 then cl08_gamma 6 else 1) * (if i.val.testBit 7 then cl08_gamma 7 else 1) := by
    convert congr_arg ( fun m : M16Z => liftZ16 m ) h_prod using 1;
    grind +locals;
  rw [h_prod];
  have h_prod : ∀ (k : Fin 8), cl08_gamma k ∈ Set.range cl08_forward := by
    grind +suggestions;
  have h_prod : ∀ (x y : M16R), x ∈ Set.range cl08_forward → y ∈ Set.range cl08_forward → x * y ∈ Set.range cl08_forward := by
    rintro x y ⟨ a, rfl ⟩ ⟨ b, rfl ⟩ ; exact ⟨ a * b, by simp +decide ⟩ ;
  apply_rules [ h_prod ];
  all_goals split_ifs <;> [ exact ‹∀ k : Fin 8, cl08_gamma k ∈ Set.range cl08_forward› _; exact ⟨ 1, by simp +decide ⟩ ] ;

theorem cl08_forward_surjective : Function.Surjective cl08_forward := by
  -- Since $M_{16}(\mathbb{R})$ has dimension $256$, and $Cl_0(8)$ has exactly $256$ linearly independent elements, their images must span the entire space.
  have h_span : Submodule.span ℝ (Set.range (fun i : Fin 256 => gammaR16_n i.val)) = ⊤ := by
    refine' Submodule.eq_top_of_finrank_eq _;
    convert finrank_span_eq_card ( gammaR16_linearIndependent ) |> Eq.trans <| ?_;
    norm_num [ Module.finrank ];
  intro x;
  have := h_span.ge ( Submodule.mem_top : x ∈ ⊤ );
  rw [ Finsupp.mem_span_range_iff_exists_finsupp ] at this;
  obtain ⟨ c, rfl ⟩ := this;
  choose f hf using fun i => gammaR16_n_in_range i;
  exact ⟨ c.sum fun i a => a • f i, by simp +decide [ hf, map_finsuppSum ] ⟩

/-! ## §7. Injectivity -/

private theorem finrank_M16R : Module.finrank ℝ M16R = 256 := by
  simp [Module.finrank_matrix]

theorem cl08_forward_injective : Function.Injective cl08_forward := by
  have h_le := finrank_Cl08_le_256
  have h_rn := LinearMap.finrank_range_add_finrank_ker cl08_forward.toLinearMap
  rw [LinearMap.range_eq_top.mpr cl08_forward_surjective, finrank_top, finrank_M16R] at h_rn
  have h_ker : Module.finrank ℝ (LinearMap.ker cl08_forward.toLinearMap) = 0 := by omega
  rwa [Submodule.finrank_eq_zero, LinearMap.ker_eq_bot] at h_ker

/-! ## §8. Main Result -/

/-- **Main theorem**: Cl(0,8) ≃ₐ[ℝ] M₁₆(ℝ) -/
noncomputable def cl0_eight_equiv : Cl0 8 ≃ₐ[ℝ] M16R :=
  AlgEquiv.ofBijective cl08_forward ⟨cl08_forward_injective, cl08_forward_surjective⟩

/-- The dimension of Cl(0,8) is 2⁸ = 256. -/
theorem dim_Cl08 : Module.finrank ℝ (Cl0 8) = 256 := by
  have := cl0_eight_equiv.toLinearEquiv.finrank_eq
  rw [finrank_M16R] at this
  exact this

theorem cl08_bott_class : (8 : ℕ) % 8 = 0 := by norm_num

end