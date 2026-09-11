/-
# CliffordGenericProof — Fully Generic Injectivity and Dimension Proof

Given a `GramEngine n N`, proves:
- `GramEngine.forward` — algebra homomorphism `Cl0 n →ₐ[ℝ] M_N(ℝ)`
- `GramEngine.forward_injective` — injectivity (faithfulness)
- `GramEngine.finrank_eq` — `finrank ℝ (Cl0 n) = 2^n`

This eliminates ALL per-n boilerplate.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordBitBasis
import RequestProject.Math.Clifford.CliffordDim
import RequestProject.Math.Clifford.SPermGeneric
import RequestProject.Math.Clifford.GramEngine

set_option maxHeartbeats 4000000

open CliffordAlgebra Submodule Matrix

noncomputable section

/-! ## §1. Generic SPerm → Matrix Correspondence -/

theorem SPerm.toMatrix_mul {N : ℕ} (a b : SPerm N) :
    (a * b).toMatrix = a.toMatrix * b.toMatrix := by
  ext i j; simp [Matrix.mul_apply, SPerm.toMatrix]
  rw [Finset.sum_eq_single (a.perm i)]
  · simp; split_ifs <;> simp_all +decide [xor,
      show (a * b).perm = fun i => b.perm (a.perm i) from rfl,
      show (a * b).sign = fun i => !(xor (a.sign i) (b.sign (a.perm i))) from rfl]
  · intro k _ hk; simp [SPerm.toMatrix]; split_ifs <;> simp_all
  · intro h; exact absurd (Finset.mem_univ _) h

/-! ## §2. Real Matrix Lifting -/

abbrev liftZR (N : ℕ) : Matrix (Fin N) (Fin N) ℤ →+* Matrix (Fin N) (Fin N) ℝ :=
  (Int.castRingHom ℝ).mapMatrix

/-! ## §3. Generator Relations over ℝ -/

theorem GramEngine.generator_anticommute_real {n N : ℕ} (ge : GramEngine n N)
    {i j : Fin n} (hij : i ≠ j) :
    ge.generatorMatrix i * ge.generatorMatrix j +
    ge.generatorMatrix j * ge.generatorMatrix i = 0 := by
  unfold GramEngine.generatorMatrix
  rw [← map_mul, ← map_mul, ← map_add]
  suffices h : (ge.rep.generators i).toMatrix * (ge.rep.generators j).toMatrix +
    (ge.rep.generators j).toMatrix * (ge.rep.generators i).toMatrix = 0 by
    rw [h, map_zero]
  rw [← SPerm.toMatrix_mul, ← SPerm.toMatrix_mul]
  ext p q; simp +decide [SPerm.toMatrix]
  have ⟨hp, hs⟩ := ge.anticommute i j hij p
  simp_all +decide [
    show (ge.rep.generators i * ge.rep.generators j).perm =
      fun x => (ge.rep.generators j).perm ((ge.rep.generators i).perm x) from rfl,
    show (ge.rep.generators j * ge.rep.generators i).perm =
      fun x => (ge.rep.generators i).perm ((ge.rep.generators j).perm x) from rfl,
    show (ge.rep.generators i * ge.rep.generators j).sign =
      fun x => !(xor ((ge.rep.generators i).sign x)
        ((ge.rep.generators j).sign ((ge.rep.generators i).perm x))) from rfl,
    show (ge.rep.generators j * ge.rep.generators i).sign =
      fun x => !(xor ((ge.rep.generators j).sign x)
        ((ge.rep.generators i).sign ((ge.rep.generators j).perm x))) from rfl]
  grind

/-! ## §4. The Clifford Relation -/

theorem GramEngine.clifford_sq {n N : ℕ} (ge : GramEngine n N) (v : Fin n → ℝ) :
    ge.forwardLin v * ge.forwardLin v =
    algebraMap ℝ (Matrix (Fin N) (Fin N) ℝ) (negDefForm n v) := by
  unfold negDefForm;
  have h_expand : ∀ i j : Fin n, ge.generatorMatrix i * ge.generatorMatrix j + ge.generatorMatrix j * ge.generatorMatrix i = if i = j then -2 else 0 := by
    intro i j; split_ifs with hij; simp_all +decide [ ← two_mul ] ;
    · rw [ ge.generator_sq_neg ] ; norm_num [ two_mul ];
    · convert GramEngine.generator_anticommute_real ge hij using 1;
  have h_expand : ∑ i : Fin n, ∑ j : Fin n, v i • v j • (ge.generatorMatrix i * ge.generatorMatrix j) = ∑ i : Fin n, v i • v i • (ge.generatorMatrix i * ge.generatorMatrix i) := by
    have h_expand : ∑ i, ∑ j, v i • v j • (ge.generatorMatrix i * ge.generatorMatrix j) = ∑ i, ∑ j, v i • v j • (ge.generatorMatrix j * ge.generatorMatrix i) := by
      rw [ Finset.sum_comm ];
      exact Finset.sum_congr rfl fun i hi => Finset.sum_congr rfl fun j hj => by rw [ smul_smul, smul_smul, mul_comm ] ;
    have h_expand : ∑ i, ∑ j, v i • v j • (ge.generatorMatrix i * ge.generatorMatrix j + ge.generatorMatrix j * ge.generatorMatrix i) = ∑ i, v i • v i • (ge.generatorMatrix i * ge.generatorMatrix i + ge.generatorMatrix i * ge.generatorMatrix i) := by
      simp +decide [ *, Finset.sum_ite, Finset.filter_eq, Finset.filter_ne ];
    convert congr_arg ( fun x => ( 1 / 2 : ℝ ) • x ) h_expand using 1 <;> norm_num [ Finset.sum_add_distrib, smul_add, add_smul ] ; ring;
    · rw [ ‹∑ i, ∑ j, v i • v j • ( ge.generatorMatrix i * ge.generatorMatrix j ) = ∑ i, ∑ j, v i • v j • ( ge.generatorMatrix j * ge.generatorMatrix i ) › ] ; ext ; norm_num ; ring;
    · module;
  simp_all +decide [ ← Finset.mul_sum _ _ _, ← Finset.sum_mul, ← Finset.sum_smul, ← Finset.smul_sum, GramEngine.generator_sq_neg ];
  convert h_expand using 1;
  · simp +decide [ GramEngine.forwardLin, Finset.sum_mul _ _ _, Finset.mul_sum, mul_assoc, mul_left_comm, Finset.sum_add_distrib, add_mul, mul_add, smul_smul ];
    simp +decide only [mul_comm, Finset.smul_sum, smul_smul];
  · simp +decide [ Algebra.smul_def ]

/-! ## §5. The Algebra Homomorphism -/

def GramEngine.forward {n N : ℕ} (ge : GramEngine n N) :
    Cl0 n →ₐ[ℝ] Matrix (Fin N) (Fin N) ℝ :=
  CliffordAlgebra.lift (negDefForm n) ⟨ge.forwardLin, ge.clifford_sq⟩

theorem GramEngine.forward_gen {n N : ℕ} (ge : GramEngine n N) (v : Fin n → ℝ) :
    ge.forward (ι (negDefForm n) v) = ge.forwardLin v :=
  CliffordAlgebra.lift_ι_apply _ _ v

/-! ## §6. Gram Orthogonality over ℝ -/

theorem GramEngine.gram_orthogonality_real {n N : ℕ} (ge : GramEngine n N)
    (i j : Fin (2^n)) :
    Matrix.trace ((ge.monomialMatrix i.val)ᵀ * ge.monomialMatrix j.val) =
    if i = j then (N : ℝ) else 0 := by
  convert congr_arg ( ( ↑ ) : ℤ → ℝ ) ( ge.gram_check i j ) using 1;
  · unfold GramEngine.monomialMatrix SPerm.toMatrix sPermTraceProd; simp +decide [ Matrix.trace, Matrix.mul_apply ] ;
    rw [ Finset.sum_comm ] ; congr ; ext x ; rw [ Finset.sum_eq_single ( ( sPermMonomial ge.rep j.val ).perm x ) ] <;> aesop;
  · split_ifs <;> norm_num

/-! ## §7. Linear Independence -/

theorem GramEngine.monomials_linearIndependent {n N : ℕ} (ge : GramEngine n N)
    (hN : 0 < N) :
    LinearIndependent ℝ (fun i : Fin (2^n) => ge.monomialMatrix i.val) := by
  refine' linearIndependent_iff'.mpr _;
  intro s g hg i hi
  have : ∑ j ∈ s, g j * Matrix.trace ((ge.monomialMatrix i.val)ᵀ * ge.monomialMatrix j.val) = 0 := by
    convert congr_arg ( fun m => Matrix.trace ( ( ge.monomialMatrix i.val )ᵀ * m ) ) hg using 1 <;> simp +decide [ Matrix.mul_sum, Matrix.sum_mul ];
  rw [ Finset.sum_eq_single i ] at this;
  · have := ge.gram_orthogonality_real i i; aesop;
  · intro j hj hij; have := ge.gram_orthogonality_real i j; aesop;
  · aesop

/-! ## §8. Generator and Monomial in Range -/

theorem GramEngine.generator_in_range {n N : ℕ} (ge : GramEngine n N)
    (k : Fin n) :
    ge.generatorMatrix k ∈ Set.range ge.forward := by
  use ι (negDefForm n) (stdBasis n k);
  convert GramEngine.forward_gen ge ( stdBasis n k ) using 1;
  unfold GramEngine.forwardLin _root_.stdBasis; simp +decide [ Finset.sum_ite_eq ] ;

theorem GramEngine.monomial_in_range {n N : ℕ} (ge : GramEngine n N)
    (idx : Fin (2^n)) :
    ge.monomialMatrix idx.val ∈ Set.range ge.forward := by
  unfold GramEngine.monomialMatrix;
  unfold sPermMonomial;
  induction' ( List.range n ) using List.reverseRecOn with k hk <;> simp_all +decide [ List.foldl ];
  · use 1; simp [SPerm.toMatrix];
    ext i j; aesop;
  · split_ifs <;> simp_all +decide [ ← Matrix.ext_iff ];
    obtain ⟨ y, hy ⟩ := ‹∃ y, ∀ i j, ge.forward y i j = _›;
    obtain ⟨ z, hz ⟩ := GramEngine.generator_in_range ge ⟨ hk, by assumption ⟩;
    use y * z;
    simp +decide [ ← hy, ← hz, Matrix.mul_apply, SPerm.toMatrix_mul ];
    exact fun i j => Finset.sum_congr rfl fun _ _ => by rw [ hz ] ; rfl;

/-! ## §9. Finrank of Range -/

theorem GramEngine.finrank_range_ge {n N : ℕ} (ge : GramEngine n N) (hN : 0 < N) :
    2^n ≤ Module.finrank ℝ (LinearMap.range ge.forward.toLinearMap) := by
  have h_span : Submodule.span ℝ (Set.range (fun i : Fin (2^n) =>
      ge.monomialMatrix i.val)) ≤ LinearMap.range ge.forward.toLinearMap :=
    Submodule.span_le.mpr (Set.range_subset_iff.mpr fun i => ge.monomial_in_range i)
  have h_finrank := Submodule.finrank_mono h_span
  rw [finrank_span_eq_card (ge.monomials_linearIndependent hN)] at h_finrank
  simpa using h_finrank

/-! ## §10. Module.Finite -/

instance GramEngine.cl0_module_finite (n : ℕ) : Module.Finite ℝ (Cl0 n) := by
  rw [Module.finite_def]
  exact ⟨(Set.finite_range (cl0Monomial n)).toFinset,
    by rw [Set.Finite.coe_toFinset]; exact cl0Monomial_span⟩

/-! ## §11. Injectivity -/

theorem GramEngine.forward_injective {n N : ℕ} (ge : GramEngine n N) (hN : 0 < N) :
    Function.Injective ge.forward := by
  have h_dim := finrank_Cl0_eq n
  have h_range := ge.finrank_range_ge hN
  have h_rn := LinearMap.finrank_range_add_finrank_ker ge.forward.toLinearMap
  have h_ker_zero : Module.finrank ℝ (LinearMap.ker ge.forward.toLinearMap) = 0 := by omega
  exact LinearMap.ker_eq_bot.mp (Submodule.finrank_eq_zero.mp h_ker_zero)

/-! ## §12. Dimension (re-exported) -/

theorem GramEngine.finrank_eq {n N : ℕ} (_ge : GramEngine n N) :
    Module.finrank ℝ (Cl0 n) = 2^n :=
  finrank_Cl0_eq n

end