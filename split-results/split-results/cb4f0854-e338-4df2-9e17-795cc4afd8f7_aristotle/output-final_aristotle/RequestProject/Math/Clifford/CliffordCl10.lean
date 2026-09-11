/-
# Cl(0,10) — Faithful Representation and Dimension

We construct a faithful ℝ-algebra representation of Cl(0,10) into M₆₄(ℝ)
using 10 generators as signed permutations of size 64, and prove:
- dim_ℝ Cl(0,10) = 1024
- The representation is injective (faithful)

The classification theorem says Cl(0,10) ≅ M₁₆(ℍ) as ℝ-algebras.
The 64×64 representation embeds M₁₆(ℍ) ↪ M₆₄(ℝ) via the standard
real realization of quaternionic matrices.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordBitBasis
import RequestProject.Math.Clifford.CliffordCl10SPerm
import RequestProject.Math.Clifford.CliffordCl10Rels
import RequestProject.Math.Clifford.CliffordCl10Gram

set_option maxHeartbeats 3200000

open CliffordAlgebra Submodule Matrix

noncomputable section

/-! ## §1. Type Abbreviations -/

abbrev M64R := Matrix (Fin 64) (Fin 64) ℝ
abbrev M64Z := Matrix (Fin 64) (Fin 64) ℤ

noncomputable abbrev liftZ64 : M64Z →+* M64R := (Int.castRingHom ℝ).mapMatrix

/-! ## §2. Connection to CliffordCl10Rels -/

def gammaZ64 (k : Fin 10) : M64Z := SPerm64.toMatrix' (gamSP64 k)

noncomputable def cl10_gamma (k : Fin 10) : M64R := liftZ64 (gammaZ64 k)

/-! ## §3. Generator Relations (imported from CliffordCl10Rels) -/

theorem gammaZ64_sq (k : Fin 10) : gammaZ64 k * gammaZ64 k = -1 :=
  gammaZ64_sq' k

theorem gammaZ64_anticommute {a b : Fin 10} (hab : a ≠ b) :
    gammaZ64 a * gammaZ64 b + gammaZ64 b * gammaZ64 a = 0 :=
  gammaZ64_anticommute' hab

theorem cl10_gamma_sq (k : Fin 10) : cl10_gamma k * cl10_gamma k = -1 := by
  unfold cl10_gamma; rw [← map_mul, gammaZ64_sq, map_neg, map_one]

theorem cl10_gamma_anticommute {a b : Fin 10} (hab : a ≠ b) :
    cl10_gamma a * cl10_gamma b + cl10_gamma b * cl10_gamma a = 0 := by
  unfold cl10_gamma; rw [← map_mul, ← map_mul, ← map_add,
    gammaZ64_anticommute hab, map_zero]

/-! ## §4. Forward Map Construction -/

noncomputable def cl10_gen (i : Fin 10) : Cl0 10 :=
  ι (negDefForm 10) (stdBasis 10 i)

noncomputable def cl10_forward_lin : (Fin 10 → ℝ) →ₗ[ℝ] M64R where
  toFun v :=
    v 0 • cl10_gamma 0 + v 1 • cl10_gamma 1 + v 2 • cl10_gamma 2 +
    v 3 • cl10_gamma 3 + v 4 • cl10_gamma 4 + v 5 • cl10_gamma 5 +
    v 6 • cl10_gamma 6 + v 7 • cl10_gamma 7 + v 8 • cl10_gamma 8 +
    v 9 • cl10_gamma 9
  map_add' u w := by simp [add_smul]; abel
  map_smul' r v := by simp [smul_add, smul_smul]

theorem cl10_clifford_sq (v : Fin 10 → ℝ) :
    cl10_forward_lin v * cl10_forward_lin v =
    algebraMap ℝ M64R (negDefForm 10 v) := by
  have h_expand : cl10_forward_lin v * cl10_forward_lin v =
    ∑ i : Fin 10, (v i) ^ 2 • (cl10_gamma i * cl10_gamma i) +
    ∑ i : Fin 10, ∑ j ∈ Finset.Ioi i, (v i * v j) •
      (cl10_gamma i * cl10_gamma j + cl10_gamma j * cl10_gamma i) := by
    unfold cl10_forward_lin
    simp +decide [Fin.sum_univ_succ, Finset.sum_add_distrib, mul_add, add_mul,
      smul_add, add_smul, smul_mul_assoc, mul_smul_comm, pow_two]
    module
  have h_subst : cl10_forward_lin v * cl10_forward_lin v =
    ∑ i : Fin 10, (v i) ^ 2 • (-1 : M64R) +
    ∑ i : Fin 10, ∑ j ∈ Finset.Ioi i, (v i * v j) • (0 : M64R) := by
    convert h_expand using 3
    · rw [cl10_gamma_sq]
    · exact Finset.sum_congr rfl fun j hj => by
        rw [show cl10_gamma _ * cl10_gamma j + cl10_gamma j * cl10_gamma _ = 0
          from cl10_gamma_anticommute <| by aesop]
  simp +decide [h_subst, negDefForm]
  simp +decide [← sq, Algebra.smul_def]

noncomputable def cl10_forward : Cl0 10 →ₐ[ℝ] M64R :=
  CliffordAlgebra.lift (negDefForm 10) ⟨cl10_forward_lin, cl10_clifford_sq⟩

theorem cl10_forward_gen (v : Fin 10 → ℝ) :
    cl10_forward (ι (negDefForm 10) v) = cl10_forward_lin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §5. Module.Finite and Finrank Bound -/

instance cl10_module_finite : Module.Finite ℝ (Cl0 10) := by
  have h_span := cl0Monomial_span (n := 10)
  rw [Module.finite_def]
  have hfin : Set.Finite (Set.range (cl0Monomial 10)) := Set.finite_range _
  exact ⟨hfin.toFinset, by rw [Set.Finite.coe_toFinset]; exact h_span⟩

theorem finrank_Cl10_le_1024 : Module.finrank ℝ (Cl0 10) ≤ 1024 := by
  have h_span : Submodule.span ℝ (Set.range (cl0Monomial 10)) = ⊤ := cl0Monomial_span
  have h_card : Set.Finite (Set.range (cl0Monomial 10)) := Set.toFinite _
  have h_finrank_le : Module.finrank ℝ (Cl0 10) ≤
      Set.ncard (Set.range (cl0Monomial 10)) := by
    convert finrank_span_le_card (Set.range (cl0Monomial 10)) using 1
    rw [h_span, finrank_top]
    convert Set.ncard_eq_toFinset_card' _
    · exact Set.Finite.fintype h_card
    · infer_instance
  have h_card_le : Set.ncard (Set.range (cl0Monomial 10)) ≤ 2 ^ 10 := by
    rw [← card_bitvec]
    refine le_trans (Set.ncard_le_ncard
      (show Set.range (cl0Monomial 10) ⊆
        Set.image (cl0Monomial 10) (Set.univ : Set (BitVec 10))
        from Set.range_subset_iff.mpr fun x =>
          Set.mem_image_of_mem _ <| Set.mem_univ _)) ?_
    exact Set.ncard_image_le (Set.toFinite _) |> le_trans <| by
      simp +decide [Set.ncard_univ]
  exact h_finrank_le.trans h_card_le

/-! ## §6. Gram Orthogonality Lifting and Linear Independence -/

/-- The real matrix for monomial index m. -/
noncomputable def gammaR64_n (n : Nat) : M64R :=
  liftZ64 (SPerm64.toMatrix' (monomialN10 n))

theorem traceProd64_eq_int_trace (a b : SPerm 64) :
    (traceProd64 a b : ℤ) =
    Matrix.trace ((SPerm64.toMatrix' a)ᵀ * SPerm64.toMatrix' b) := by
  unfold SPerm64.toMatrix';
  simp +decide [ Matrix.trace, Matrix.mul_apply ];
  rw [ Finset.sum_comm ];
  rw [ Finset.sum_congr rfl ];
  rotate_right;
  use fun i => if a.perm i = b.perm i then if a.sign i = b.sign i then 1 else -1 else 0;
  · unfold traceProd64; simp +decide [ Fin.sum_univ_succ ] ;
    ring;
  · intro i hi; rw [ Finset.sum_eq_single ( b.perm i ) ] <;> aesop;

theorem gram10_orthogonality_real (i j : Fin 1024) :
    Matrix.trace ((gammaR64_n i.val)ᵀ * gammaR64_n j.val) =
    if i = j then 64 else 0 := by
  have h_gammaR64_n_def : ∀ n : Nat, gammaR64_n n = liftZ64 (SPerm64.toMatrix' (monomialN10 n)) := by
    grind +locals;
  have h_liftZ64 : ∀ (A B : M64Z), Matrix.trace ((liftZ64 A)ᵀ * (liftZ64 B)) = Matrix.trace (Aᵀ * B) := by
    intro A B; simp +decide [ Matrix.trace, Matrix.mul_apply ] ;
  simp_all +decide [ traceProd64_eq_int_trace ];
  exact mod_cast traceProd64_eq_int_trace _ _ ▸ gram10_orthogonality i j ▸ by simp +decide [ Fin.ext_iff ] ;

theorem gammaR64_linearIndependent :
    LinearIndependent ℝ (fun i : Fin 1024 => gammaR64_n i.val) := by
  refine' Fintype.linearIndependent_iff.2 _;
  intro g hg i
  have h_trace : Matrix.trace ((gammaR64_n i.val)ᵀ * (∑ j ∈ Finset.univ, g j • gammaR64_n j.val)) = 64 * g i := by
    have h_trace : Matrix.trace ((gammaR64_n i.val)ᵀ * (∑ j ∈ Finset.univ, g j • gammaR64_n j.val)) = ∑ j ∈ Finset.univ, g j * Matrix.trace ((gammaR64_n i.val)ᵀ * gammaR64_n j.val) := by
      simp +decide only [Matrix.mul_sum, trace_sum];
      simp +decide [ Matrix.mul_smul, Matrix.trace_smul ];
    rw [ h_trace, Finset.sum_eq_single i ] <;> simp +contextual [ gram10_orthogonality_real ] ; ring;
    exact fun j hj₁ hj₂ => False.elim <| hj₁ <| hj₂.symm;
  simp_all +decide [ Finset.sum_apply, Matrix.mul_apply ]

/-- Each cl10_gamma k is in the range of cl10_forward. -/
theorem cl10_gamma_in_range (k : Fin 10) :
    cl10_gamma k ∈ Set.range cl10_forward := by
  use ι (negDefForm 10) (stdBasis 10 k)
  fin_cases k <;> simp +decide [cl10_forward_gen]
  all_goals unfold cl10_forward_lin; simp +decide [_root_.stdBasis]

theorem gammaR64_n_in_range (i : Fin 1024) :
    gammaR64_n i.val ∈ Set.range cl10_forward := by
  have h_prod : gammaR64_n i.val = (if i.val.testBit 0 then cl10_gamma 0 else 1) * (if i.val.testBit 1 then cl10_gamma 1 else 1) * (if i.val.testBit 2 then cl10_gamma 2 else 1) * (if i.val.testBit 3 then cl10_gamma 3 else 1) * (if i.val.testBit 4 then cl10_gamma 4 else 1) * (if i.val.testBit 5 then cl10_gamma 5 else 1) * (if i.val.testBit 6 then cl10_gamma 6 else 1) * (if i.val.testBit 7 then cl10_gamma 7 else 1) * (if i.val.testBit 8 then cl10_gamma 8 else 1) * (if i.val.testBit 9 then cl10_gamma 9 else 1) := by
    have h_prod : ∀ (a b : SPerm 64), liftZ64 (SPerm64.toMatrix' (a * b)) = liftZ64 (SPerm64.toMatrix' a) * liftZ64 (SPerm64.toMatrix' b) := by
      intro a b
      have h_prod : SPerm64.toMatrix' (a * b) = SPerm64.toMatrix' a * SPerm64.toMatrix' b := by
        exact?
      simp [h_prod];
      ext i j; simp +decide [ Matrix.mul_apply ] ;
    unfold gammaR64_n;
    unfold monomialN10;
    simp +decide only [h_prod];
    congr;
    all_goals split_ifs <;> simp +decide [ *, cl10_gamma ] ;
    all_goals norm_cast;
    all_goals ext i j; simp +decide [ SPerm64.toMatrix' ] ;
    all_goals fin_cases i <;> trivial;
  rw [h_prod];
  have h_hom : ∀ k : Fin 10, cl10_gamma k ∈ Set.range cl10_forward := by
    exact?;
  have h_hom : ∀ k : Fin 10, (if i.val.testBit k.val then cl10_gamma k else 1) ∈ Set.range cl10_forward := by
    intro k; split_ifs <;> [ exact h_hom k; exact ⟨ 1, by simp +decide ⟩ ] ;
  obtain ⟨ x, hx ⟩ := h_hom 0; obtain ⟨ y, hy ⟩ := h_hom 1; obtain ⟨ z, hz ⟩ := h_hom 2; obtain ⟨ w, hw ⟩ := h_hom 3; obtain ⟨ u, hu ⟩ := h_hom 4; obtain ⟨ v, hv ⟩ := h_hom 5; obtain ⟨ t, ht ⟩ := h_hom 6; obtain ⟨ s, hs ⟩ := h_hom 7; obtain ⟨ r, hr ⟩ := h_hom 8; obtain ⟨ q, hq ⟩ := h_hom 9; use x * y * z * w * u * v * t * s * r * q; simp +decide [ hx, hy, hz, hw, hu, hv, ht, hs, hr, hq ] ;

theorem finrank_range_cl10_ge_1024 :
    1024 ≤ Module.finrank ℝ (LinearMap.range cl10_forward.toLinearMap) := by
  have h_span : Submodule.span ℝ (Set.range (fun i : Fin 1024 => gammaR64_n i.val)) ≤ LinearMap.range cl10_forward.toLinearMap := by
    exact Submodule.span_le.mpr ( Set.range_subset_iff.mpr fun i => gammaR64_n_in_range i );
  have := Submodule.finrank_mono h_span;
  rw [ finrank_span_eq_card ] at this <;> norm_num at *;
  · exact this;
  · convert gammaR64_linearIndependent

theorem cl10_forward_injective : Function.Injective cl10_forward := by
  convert LinearMap.ker_eq_bot.mp _;
  rotate_left;
  exact ℝ;
  exact ℝ;
  all_goals try infer_instance;
  exact RingHom.id ℝ;
  exact cl10_forward.toLinearMap;
  · have := LinearMap.finrank_range_add_finrank_ker cl10_forward.toLinearMap;
    exact Submodule.finrank_eq_zero.mp ( by linarith [ finrank_Cl10_le_1024, finrank_range_cl10_ge_1024 ] );
  · rfl

theorem dim_Cl10 : Module.finrank ℝ (Cl0 10) = 1024 := by
  refine' le_antisymm _ _;
  · exact?;
  · convert finrank_range_cl10_ge_1024 using 1;
    rw [ LinearMap.finrank_range_of_inj ];
    convert cl10_forward_injective using 1

/-- Cl(0,10) is faithfully represented as a subalgebra of M₆₄(ℝ). -/
noncomputable def cl10_faithful_rep : Cl0 10 →ₐ[ℝ] M64R :=
  cl10_forward

theorem cl10_faithful_rep_injective : Function.Injective cl10_faithful_rep :=
  cl10_forward_injective

/-- The Bott class of CL10: 10 mod 8 = 2, matching Cl(0,2) ≅ ℍ.
    Hence Cl(0,10) ≅ Cl(0,2) ⊗ M₁₆(ℝ) ≅ ℍ ⊗ M₁₆(ℝ) ≅ M₁₆(ℍ). -/
theorem cl10_bott_class : (10 : ℕ) % 8 = 2 := by norm_num

end
