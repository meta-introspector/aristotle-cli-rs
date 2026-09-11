/-
# Cl(0,9) — Faithful Representation and Dimension

We construct a faithful ℝ-algebra representation of Cl(0,9) into M₃₂(ℝ)
using 9 generators as signed permutations of size 32, and prove:
- dim_ℝ Cl(0,9) = 512
- The representation is injective (faithful)

The classification theorem says Cl(0,9) ≅ M₁₆(ℂ) as ℝ-algebras.
The 32×32 representation embeds M₁₆(ℂ) ↪ M₃₂(ℝ) via the standard
real realization of complex matrices.

## Construction

Using the Kronecker doubling from CL8:
- Γᵢ = diag(Γᵢ⁽⁸⁾, -Γᵢ⁽⁸⁾) for i = 0,...,7
- Γ₈ = [[0, I₁₆], [-I₁₆, 0]]
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordBitBasis
import RequestProject.Math.Clifford.CliffordCl09SPerm
import RequestProject.Math.Clifford.CliffordCl09Rels
import RequestProject.Math.Clifford.CliffordCl09Gram

set_option maxHeartbeats 3200000

open CliffordAlgebra Submodule Matrix

noncomputable section

/-! ## §1. Type Abbreviations -/

abbrev M32R := Matrix (Fin 32) (Fin 32) ℝ
abbrev M32Z := Matrix (Fin 32) (Fin 32) ℤ

noncomputable abbrev liftZ32 : M32Z →+* M32R := (Int.castRingHom ℝ).mapMatrix

/-! ## §2. Connection to CliffordCl09Rels -/

/-- gammaZ32 is the same definition as gammaZ32' from CliffordCl09Rels. -/
def gammaZ32 (k : Fin 9) : M32Z := SPerm32.toMatrix' (gamSP32 k)

noncomputable def cl09_gamma (k : Fin 9) : M32R := liftZ32 (gammaZ32 k)

/-! ## §3. Generator Relations (imported from CliffordCl09Rels) -/

theorem gammaZ32_sq (k : Fin 9) : gammaZ32 k * gammaZ32 k = -1 :=
  gammaZ32_sq' k

theorem gammaZ32_anticommute {a b : Fin 9} (hab : a ≠ b) :
    gammaZ32 a * gammaZ32 b + gammaZ32 b * gammaZ32 a = 0 :=
  gammaZ32_anticommute' hab

theorem cl09_gamma_sq (k : Fin 9) : cl09_gamma k * cl09_gamma k = -1 := by
  unfold cl09_gamma; rw [← map_mul, gammaZ32_sq, map_neg, map_one]

theorem cl09_gamma_anticommute {a b : Fin 9} (hab : a ≠ b) :
    cl09_gamma a * cl09_gamma b + cl09_gamma b * cl09_gamma a = 0 := by
  unfold cl09_gamma; rw [← map_mul, ← map_mul, ← map_add,
    gammaZ32_anticommute hab, map_zero]

/-! ## §4. Forward Map Construction -/

noncomputable def cl09_gen (i : Fin 9) : Cl0 9 :=
  ι (negDefForm 9) (stdBasis 9 i)

noncomputable def cl09_forward_lin : (Fin 9 → ℝ) →ₗ[ℝ] M32R where
  toFun v :=
    v 0 • cl09_gamma 0 + v 1 • cl09_gamma 1 + v 2 • cl09_gamma 2 +
    v 3 • cl09_gamma 3 + v 4 • cl09_gamma 4 + v 5 • cl09_gamma 5 +
    v 6 • cl09_gamma 6 + v 7 • cl09_gamma 7 + v 8 • cl09_gamma 8
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

theorem cl09_clifford_sq (v : Fin 9 → ℝ) :
    cl09_forward_lin v * cl09_forward_lin v =
    algebraMap ℝ M32R (negDefForm 9 v) := by
  have h_expand : cl09_forward_lin v * cl09_forward_lin v =
    ∑ i : Fin 9, (v i) ^ 2 • (cl09_gamma i * cl09_gamma i) +
    ∑ i : Fin 9, ∑ j ∈ Finset.Ioi i, (v i * v j) •
      (cl09_gamma i * cl09_gamma j + cl09_gamma j * cl09_gamma i) := by
    unfold cl09_forward_lin
    simp +decide [Fin.sum_univ_succ, Finset.sum_add_distrib, mul_add, add_mul,
      smul_add, add_smul, smul_mul_assoc, mul_smul_comm, pow_two]
    module
  have h_subst : cl09_forward_lin v * cl09_forward_lin v =
    ∑ i : Fin 9, (v i) ^ 2 • (-1 : M32R) +
    ∑ i : Fin 9, ∑ j ∈ Finset.Ioi i, (v i * v j) • (0 : M32R) := by
    convert h_expand using 3
    · rw [cl09_gamma_sq]
    · exact Finset.sum_congr rfl fun j hj => by
        rw [show cl09_gamma _ * cl09_gamma j + cl09_gamma j * cl09_gamma _ = 0
          from cl09_gamma_anticommute <| by aesop]
  simp +decide [h_subst, negDefForm]
  simp +decide [← sq, Algebra.smul_def]

noncomputable def cl09_forward : Cl0 9 →ₐ[ℝ] M32R :=
  CliffordAlgebra.lift (negDefForm 9) ⟨cl09_forward_lin, cl09_clifford_sq⟩

theorem cl09_forward_gen (v : Fin 9 → ℝ) :
    cl09_forward (ι (negDefForm 9) v) = cl09_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §5. Module.Finite and Finrank Bound -/

instance cl09_module_finite : Module.Finite ℝ (Cl0 9) := by
  have h_span := cl0Monomial_span (n := 9)
  rw [Module.finite_def]
  have hfin : Set.Finite (Set.range (cl0Monomial 9)) := Set.finite_range _
  exact ⟨hfin.toFinset, by rw [Set.Finite.coe_toFinset]; exact h_span⟩

theorem finrank_Cl09_le_512 : Module.finrank ℝ (Cl0 9) ≤ 512 := by
  have h_span : Submodule.span ℝ (Set.range (cl0Monomial 9)) = ⊤ := cl0Monomial_span
  have h_card : Set.Finite (Set.range (cl0Monomial 9)) := Set.toFinite _
  have h_finrank_le : Module.finrank ℝ (Cl0 9) ≤
      Set.ncard (Set.range (cl0Monomial 9)) := by
    convert finrank_span_le_card (Set.range (cl0Monomial 9)) using 1
    rw [h_span, finrank_top]
    convert Set.ncard_eq_toFinset_card' _
    · exact Set.Finite.fintype h_card
    · infer_instance
  have h_card_le : Set.ncard (Set.range (cl0Monomial 9)) ≤ 2 ^ 9 := by
    rw [← card_bitvec]
    refine le_trans (Set.ncard_le_ncard
      (show Set.range (cl0Monomial 9) ⊆
        Set.image (cl0Monomial 9) (Set.univ : Set (BitVec 9))
        from Set.range_subset_iff.mpr fun x =>
          Set.mem_image_of_mem _ <| Set.mem_univ _)) ?_
    exact Set.ncard_image_le (Set.toFinite _) |> le_trans <| by
      simp +decide [Set.ncard_univ]
  exact h_finrank_le.trans h_card_le

/-! ## §6. Gram Orthogonality Lifting and Linear Independence

Strategy: The 512 monomials {Γ_S : S ⊆ {0,...,8}} mapped through cl09_forward
give 512 linearly independent elements in M₃₂(ℝ). Since Cl(0,9) has dim ≤ 512,
this forces the kernel of cl09_forward to be trivial.

Note: Cl(0,9) ≅ M₁₆(ℂ) has dim 512, NOT 1024 = dim(M₃₂(ℝ)),
so cl09_forward is injective but NOT surjective.
-/

/-- The real matrix for monomial index m. -/
noncomputable def gammaR32_n (n : Nat) : M32R :=
  liftZ32 (SPerm32.toMatrix' (monomialN9 n))

/-
traceProd32 computes trace(Aᵀ · B) for SPerm 32 matrices over ℤ.
-/
theorem traceProd32_eq_int_trace (a b : SPerm 32) :
    (traceProd32 a b : ℤ) =
    Matrix.trace ((SPerm32.toMatrix' a)ᵀ * SPerm32.toMatrix' b) := by
  unfold SPerm32.toMatrix';
  simp +decide [ Matrix.trace, Matrix.mul_apply ];
  rw [ Finset.sum_comm ];
  rw [ Finset.sum_congr rfl ];
  rotate_right;
  use fun i => if a.perm i = b.perm i then if a.sign i = b.sign i then 1 else -1 else 0;
  · unfold traceProd32; simp +decide [ Fin.sum_univ_succ ] ;
    ring;
  · intro i hi; rw [ Finset.sum_eq_single ( b.perm i ) ] <;> aesop;

/-
Gram orthogonality lifted to ℝ: trace(M_iᵀ · M_j) = 32·δ_{i,j}.
-/
theorem gram9_orthogonality_real (i j : Fin 512) :
    Matrix.trace ((gammaR32_n i.val)ᵀ * gammaR32_n j.val) =
    if i = j then 32 else 0 := by
  -- By definition of gammaR32_n, we know that
  have h_gammaR32_n_def : ∀ n : Nat, gammaR32_n n = liftZ32 (SPerm32.toMatrix' (monomialN9 n)) := by
    grind +locals;
  -- By definition of liftZ32, we know that
  have h_liftZ32 : ∀ (A B : M32Z), Matrix.trace ((liftZ32 A)ᵀ * (liftZ32 B)) = Matrix.trace (Aᵀ * B) := by
    intro A B; simp +decide [ Matrix.trace, Matrix.mul_apply ] ;
  simp_all +decide [ traceProd32_eq_int_trace ];
  exact mod_cast traceProd32_eq_int_trace _ _ ▸ gram9_orthogonality i j ▸ by simp +decide [ Fin.ext_iff ] ;

/-
The 512 gammaR32_n matrices are linearly independent.
    Proof: from Gram orthogonality, if Σ c_i M_i = 0, then
    0 = trace(M_jᵀ · Σ c_i M_i) = 32 c_j, so c_j = 0.
-/
theorem gammaR32_linearIndependent :
    LinearIndependent ℝ (fun i : Fin 512 => gammaR32_n i.val) := by
  refine' Fintype.linearIndependent_iff.2 _;
  intro g hg i
  have h_trace : Matrix.trace ((gammaR32_n i.val)ᵀ * (∑ j ∈ Finset.univ, g j • gammaR32_n j.val)) = 32 * g i := by
    have h_trace : Matrix.trace ((gammaR32_n i.val)ᵀ * (∑ j ∈ Finset.univ, g j • gammaR32_n j.val)) = ∑ j ∈ Finset.univ, g j * Matrix.trace ((gammaR32_n i.val)ᵀ * gammaR32_n j.val) := by
      simp +decide only [Matrix.mul_sum, trace_sum];
      simp +decide [ Matrix.mul_smul, Matrix.trace_smul ];
    rw [ h_trace, Finset.sum_eq_single i ] <;> simp +contextual [ gram9_orthogonality_real ] ; ring;
    exact fun j hj₁ hj₂ => False.elim <| hj₁ <| hj₂.symm;
  simp_all +decide [ Finset.sum_apply, Matrix.mul_apply ]

/-- Each cl09_gamma k is in the range of cl09_forward. -/
theorem cl09_gamma_in_range (k : Fin 9) :
    cl09_gamma k ∈ Set.range cl09_forward := by
  use ι (negDefForm 9) (stdBasis 9 k)
  fin_cases k <;> simp +decide [cl09_forward_gen]
  all_goals unfold cl09_forward_lin; simp +decide [_root_.stdBasis]

/-
Each gammaR32_n i is in the range of cl09_forward.
    Since gammaR32_n i is a product of cl09_gamma's, and the range
    of an algebra homomorphism is closed under multiplication.
-/
theorem gammaR32_n_in_range (i : Fin 512) :
    gammaR32_n i.val ∈ Set.range cl09_forward := by
  -- By definition of $gammaR32_n$, we know that it is a product of $cl09_gamma$ matrices.
  have h_prod : gammaR32_n i.val = (if i.val.testBit 0 then cl09_gamma 0 else 1) * (if i.val.testBit 1 then cl09_gamma 1 else 1) * (if i.val.testBit 2 then cl09_gamma 2 else 1) * (if i.val.testBit 3 then cl09_gamma 3 else 1) * (if i.val.testBit 4 then cl09_gamma 4 else 1) * (if i.val.testBit 5 then cl09_gamma 5 else 1) * (if i.val.testBit 6 then cl09_gamma 6 else 1) * (if i.val.testBit 7 then cl09_gamma 7 else 1) * (if i.val.testBit 8 then cl09_gamma 8 else 1) := by
    have h_prod : ∀ (a b : SPerm 32), liftZ32 (SPerm32.toMatrix' (a * b)) = liftZ32 (SPerm32.toMatrix' a) * liftZ32 (SPerm32.toMatrix' b) := by
      intro a b
      have h_prod : SPerm32.toMatrix' (a * b) = SPerm32.toMatrix' a * SPerm32.toMatrix' b := by
        exact?
      simp [h_prod];
      ext i j; simp +decide [ Matrix.mul_apply ] ;
    unfold gammaR32_n;
    unfold monomialN9;
    simp +decide only [h_prod];
    congr;
    all_goals split_ifs <;> simp +decide [ *, cl09_gamma ] ;
    all_goals norm_cast;
    all_goals ext i j; simp +decide [ SPerm32.toMatrix' ] ;
    all_goals fin_cases i <;> trivial;
  rw [h_prod];
  -- By definition of $cl09_forward$, we know that it is a ring homomorphism.
  have h_hom : ∀ k : Fin 9, cl09_gamma k ∈ Set.range cl09_forward := by
    exact?;
  have h_hom : ∀ k : Fin 9, (if i.val.testBit k.val then cl09_gamma k else 1) ∈ Set.range cl09_forward := by
    intro k; split_ifs <;> [ exact h_hom k; exact ⟨ 1, by simp +decide ⟩ ] ;
  obtain ⟨ x, hx ⟩ := h_hom 0; obtain ⟨ y, hy ⟩ := h_hom 1; obtain ⟨ z, hz ⟩ := h_hom 2; obtain ⟨ w, hw ⟩ := h_hom 3; obtain ⟨ u, hu ⟩ := h_hom 4; obtain ⟨ v, hv ⟩ := h_hom 5; obtain ⟨ t, ht ⟩ := h_hom 6; obtain ⟨ s, hs ⟩ := h_hom 7; obtain ⟨ r, hr ⟩ := h_hom 8; use x * y * z * w * u * v * t * s * r; simp +decide [ hx, hy, hz, hw, hu, hv, ht, hs, hr ] ;

/-
The range of cl09_forward has finrank ≥ 512, because it contains
    512 linearly independent elements.
-/
theorem finrank_range_cl09_ge_512 :
    512 ≤ Module.finrank ℝ (LinearMap.range cl09_forward.toLinearMap) := by
  have h_span : Submodule.span ℝ (Set.range (fun i : Fin 512 => gammaR32_n i.val)) ≤ LinearMap.range cl09_forward.toLinearMap := by
    exact Submodule.span_le.mpr ( Set.range_subset_iff.mpr fun i => gammaR32_n_in_range i );
  have := Submodule.finrank_mono h_span;
  rw [ finrank_span_eq_card ] at this <;> norm_num at *;
  · exact this;
  · convert gammaR32_linearIndependent

/-
The forward map is injective: Cl(0,9) embeds faithfully into M₃₂(ℝ).
    Proof: dim(range) ≥ 512 and dim(Cl0 9) ≤ 512, so by rank-nullity
    dim(ker) = dim(Cl0 9) - dim(range) ≤ 0.
-/
theorem cl09_forward_injective : Function.Injective cl09_forward := by
  convert LinearMap.ker_eq_bot.mp _;
  rotate_left;
  exact ℝ;
  exact ℝ;
  all_goals try infer_instance;
  exact RingHom.id ℝ;
  exact cl09_forward.toLinearMap;
  · have := LinearMap.finrank_range_add_finrank_ker cl09_forward.toLinearMap;
    exact Submodule.finrank_eq_zero.mp ( by linarith [ finrank_Cl09_le_512, finrank_range_cl09_ge_512 ] );
  · rfl

/-
The dimension of Cl(0,9) is 2⁹ = 512.
-/
theorem dim_Cl09 : Module.finrank ℝ (Cl0 9) = 512 := by
  refine' le_antisymm _ _;
  · exact?;
  · convert finrank_range_cl09_ge_512 using 1;
    rw [ LinearMap.finrank_range_of_inj ];
    convert cl09_forward_injective using 1

/-- Cl(0,9) is faithfully represented as a subalgebra of M₃₂(ℝ). -/
noncomputable def cl09_faithful_rep : Cl0 9 →ₐ[ℝ] M32R :=
  cl09_forward

theorem cl09_faithful_rep_injective : Function.Injective cl09_faithful_rep :=
  cl09_forward_injective

/-- The Bott class of CL9: 9 mod 8 = 1, matching Cl(0,1) ≅ ℂ.
    Hence Cl(0,9) ≅ Cl(0,1) ⊗ M₁₆(ℝ) ≅ ℂ ⊗ M₁₆(ℝ) ≅ M₁₆(ℂ). -/
theorem cl09_bott_class : (9 : ℕ) % 8 = 1 := by norm_num

end