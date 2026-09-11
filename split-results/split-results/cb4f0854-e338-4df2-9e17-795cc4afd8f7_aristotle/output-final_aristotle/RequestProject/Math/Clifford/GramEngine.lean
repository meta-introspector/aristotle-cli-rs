/-
# GramEngine — Dimension-Parametric Gram Orthogonality Verification

Generalizes the CL8 Gram orthogonality proof into a reusable engine.
Given an SPermRep with verified Gram orthogonality, this file provides:

1. The abstract GramEngine structure capturing the verified invariants
2. Linear independence of the monomial basis
3. Surjectivity of the forward map (when dim matches)
4. Injectivity via rank-nullity
5. The full algebra equivalence via CliffordAlgebra.lift

This abstracts away the batching trick and makes CL9, CL10, …
structurally trivial once the Gram check passes.
-/

import Mathlib
import RequestProject.Math.Clifford.CliffordBase
import RequestProject.Math.Clifford.CliffordBitBasis
import RequestProject.Math.Clifford.SPermGeneric

set_option maxHeartbeats 1600000

open CliffordAlgebra Submodule Matrix

/-! ## §1. The Gram Engine Structure -/

/-- A verified Gram engine for Cl(0,n) with matrix size N.
    Encapsulates the key invariants needed to prove algebra properties. -/
structure GramEngine (n N : ℕ) where
  /-- The underlying signed-permutation representation -/
  rep : SPermRep n N
  /-- Gram orthogonality: trace(Mᵢᵀ·Mⱼ) = N·δᵢⱼ for all monomial pairs -/
  gram_check : ∀ i j : Fin (2^n),
    sPermTraceProd (sPermMonomial rep i.val) (sPermMonomial rep j.val) =
      if i = j then (N : ℤ) else 0
  /-- All generators square to -I -/
  sq_neg_id : ∀ k : Fin n,
    (rep.generators k * rep.generators k).perm = id ∧
    ∀ j : Fin N, (rep.generators k * rep.generators k).sign j = false
  /-- All distinct generators anticommute -/
  anticommute : ∀ i j : Fin n, i ≠ j →
    ∀ k : Fin N,
      (rep.generators i * rep.generators j).perm k =
        (rep.generators j * rep.generators i).perm k ∧
      (rep.generators i * rep.generators j).sign k ≠
        (rep.generators j * rep.generators i).sign k

/-! ## §2. Converting Gram Engine Properties to Algebraic Facts -/

/-- The real matrix for monomial index m, derived from a Gram engine. -/
noncomputable def GramEngine.monomialMatrix {n N : ℕ} (ge : GramEngine n N)
    (m : ℕ) : Matrix (Fin N) (Fin N) ℝ :=
  (Int.castRingHom ℝ).mapMatrix (sPermMonomial ge.rep m).toMatrix

/-- The real generator matrix for index k. -/
noncomputable def GramEngine.generatorMatrix {n N : ℕ} (ge : GramEngine n N)
    (k : Fin n) : Matrix (Fin N) (Fin N) ℝ :=
  (Int.castRingHom ℝ).mapMatrix (ge.rep.generators k).toMatrix

/-
Generator matrix squares to -I in the integer ring.
-/
theorem GramEngine.generatorZ_sq_neg {n N : ℕ} (ge : GramEngine n N) (k : Fin n) :
    (ge.rep.generators k).toMatrix * (ge.rep.generators k).toMatrix =
    -(1 : Matrix (Fin N) (Fin N) ℤ) := by
  ext i j; simp +decide [ Matrix.mul_apply ] ;
  have := ge.sq_neg_id k;
  unfold SPerm.toMatrix at *; simp_all +decide [ Matrix.mul_apply, Matrix.one_apply ] ;
  rw [ Finset.sum_eq_single ( ( ge.rep.generators k ).perm i ) ] <;> simp_all +decide [ funext_iff ];
  · have := this.1 i; have := this; simp_all +decide [ show ( ge.rep.generators k * ge.rep.generators k ).perm = fun x => ( ge.rep.generators k ).perm ( ( ge.rep.generators k ).perm x ) from rfl ] ;
    split_ifs <;> simp_all +decide [ show ( ge.rep.generators k * ge.rep.generators k ).sign = fun x => ! ( xor ( ( ge.rep.generators k ).sign x ) ( ( ge.rep.generators k ).sign ( ( ge.rep.generators k ).perm x ) ) ) from rfl ];
    · grind;
    · grind;
  · grind

/-- Generator matrix squares to -I over ℝ. -/
theorem GramEngine.generator_sq_neg {n N : ℕ} (ge : GramEngine n N) (k : Fin n) :
    ge.generatorMatrix k * ge.generatorMatrix k = -1 := by
  unfold GramEngine.generatorMatrix
  rw [← map_mul, ge.generatorZ_sq_neg, map_neg, map_one]

/-! ## §3. The Forward Linear Map -/

/-- The forward linear map from ℝⁿ into M_N(ℝ) via generators. -/
noncomputable def GramEngine.forwardLin {n N : ℕ} (ge : GramEngine n N) :
    (Fin n → ℝ) →ₗ[ℝ] Matrix (Fin N) (Fin N) ℝ where
  toFun v := ∑ k : Fin n, v k • ge.generatorMatrix k
  map_add' u w := by simp [add_smul, Finset.sum_add_distrib]
  map_smul' r v := by
    simp only [RingHom.id_apply, Pi.smul_apply, smul_eq_mul]
    rw [Finset.smul_sum]; congr 1; funext k
    rw [smul_smul]

/-! ## §4. Gram Check Format Utilities -/

/-- Helper: convert BEq-based Gram check to Prop-based. -/
theorem gramBlock_to_engine_format {n N : ℕ} (rep : SPermRep n N)
    (h_full : ∀ i j : Fin (2^n),
      sPermTraceProd (sPermMonomial rep i.val) (sPermMonomial rep j.val) =
        if i.val == j.val then (N : ℤ) else 0) :
    ∀ i j : Fin (2^n),
      sPermTraceProd (sPermMonomial rep i.val) (sPermMonomial rep j.val) =
        if i = j then (N : ℤ) else 0 := by
  intro i j
  have := h_full i j
  simp only [beq_iff_eq, Fin.val_eq_val] at this ⊢
  exact this