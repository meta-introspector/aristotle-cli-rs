import RequestProject.Compute.Weaver

/-!
# The Hyper-Reflective Attention Layer

This module builds a **three-level, self-reflective attention hierarchy** on top of the
row-stochastic attention theory of `RequestProject.Compute.Weaver`:

* **Level 1 — the Observed.** The existing 14-node row-stochastic object matrix
  `attentionMatrix`, which converges to the absorbing node `13` in exactly `12` steps
  (`attentionMatrix_converges`).
* **Level 2 — the Observer (meta-matrix).** A row-stochastic `metaAttentionMatrix` over the
  macro-states `Fin 13` (the convergence counter `0, 1, …, 12` of Level 1). Each macro-step
  advances the counter; macro-state `12` is absorbing. This matrix "pays attention" to the
  *progress of Level 1*, not to raw tokens, and converges in `12` macro-steps.
* **Level 3 — the Hyper-Matrix.** The Kronecker (tensor) product
  `hyperAttentionMatrix = attentionMatrix ⊗ₖ metaAttentionMatrix`, a genuine "matrix of
  matrices" giving the *joint* dynamics of object × meta. We show this hyper-matrix is again
  row-stochastic (global conservation is preserved), its powers split as the Kronecker product
  of the factor powers, and the joint system **hyper-converges** to the absorbing joint state
  `(13, 12)` in `12` steps.

Finally we anchor Level 3 to the project's fibred-category bridge
(`scaleBridgeFunctor_isSection`): the global graph section preserves both the fibration
structure and the joint row-stochastic conservation law.
-/

namespace RequestProject.Compute.HyperWeaver

open Matrix Kronecker
open RequestProject.Compute.Weaver

/-! ## A row-stochasticity predicate over arbitrary finite index types

`Weaver.IsRowStochastic` is stated for `Matrix (Fin n) (Fin n) ℝ`. The Level-3 hyper-matrix is
indexed by the *product* `Fin 14 × Fin 13`, so we use the following index-agnostic version
(which agrees definitionally with `Weaver.IsRowStochastic` on `Fin n`). -/

/-- A real square matrix over any finite index type is **row-stochastic** when all entries are
nonnegative and every row sums to `1`. -/
def IsRowStochasticOn {ι : Type*} [Fintype ι] (M : Matrix ι ι ℝ) : Prop :=
  (∀ i j, 0 ≤ M i j) ∧ ∀ i, ∑ j, M i j = 1

/-- On `Fin n`, the index-agnostic predicate coincides with `Weaver.IsRowStochastic`. -/
lemma isRowStochasticOn_of_isRowStochastic {n : ℕ} {M : Matrix (Fin n) (Fin n) ℝ}
    (h : IsRowStochastic M) : IsRowStochasticOn M := h

/-- The Kronecker product of two row-stochastic matrices is row-stochastic: this is the
conservation law for the *joint* (tensor-product) system. -/
lemma IsRowStochasticOn.kronecker {ι κ : Type*} [Fintype ι] [Fintype κ]
    {A : Matrix ι ι ℝ} {B : Matrix κ κ ℝ}
    (hA : IsRowStochasticOn A) (hB : IsRowStochasticOn B) :
    IsRowStochasticOn (A ⊗ₖ B) := by
  refine' ⟨ fun i j => mul_nonneg ( hA.1 i.1 j.1 ) ( hB.1 i.2 j.2 ), fun i => _ ⟩;
  convert congr_arg₂ ( · * · ) ( hA.2 i.1 ) ( hB.2 i.2 ) using 1;
  · simp +decide only [kroneckerMap_apply, Fintype.sum_prod_type, Finset.sum_mul _ _ _, Finset.mul_sum];
  · norm_num

/-! ## Level 2: the meta-attention matrix (the observer) -/

/-- The **meta-attention matrix** over the macro-states `Fin 13` (the convergence counter of
Level 1). Each macro-step advances the counter by one; macro-state `12` is absorbing. -/
noncomputable def metaAttentionMatrix : Matrix (Fin 13) (Fin 13) ℝ := fun i j =>
  if i = 12 then (if j = 12 then 1 else 0)
  else (if j = i + 1 then 1 else 0)

/-- Every meta-attention weight is nonnegative. -/
lemma metaAttentionMatrix_nonneg : ∀ i j, 0 ≤ metaAttentionMatrix i j := by
  intro i j; unfold metaAttentionMatrix; split_ifs <;> norm_num;

/-- **Meta conservation law.** Every row of the meta-attention matrix sums to `1`. -/
lemma metaAttentionMatrix_rowSum : ∀ i, ∑ j, metaAttentionMatrix i j = 1 := by
  unfold metaAttentionMatrix;
  simp +decide

/-- The meta-attention matrix is row-stochastic. -/
theorem metaAttentionMatrix_isRowStochastic : IsRowStochastic metaAttentionMatrix :=
  ⟨metaAttentionMatrix_nonneg, metaAttentionMatrix_rowSum⟩

/-- Every multi-step meta transition matrix is row-stochastic. -/
theorem metaAttentionMatrix_pow_isRowStochastic (k : ℕ) :
    IsRowStochastic (metaAttentionMatrix ^ k) :=
  metaAttentionMatrix_isRowStochastic.pow k

/-- The macro-state `12` is absorbing for one meta-step (a stationary / fixed-point state of
the observer, analogous to a stable evaluation fixed point). -/
theorem metaAttentionMatrix_absorbing :
    (Pi.single (12 : Fin 13) (1 : ℝ)) ᵥ* metaAttentionMatrix = Pi.single 12 1 := by
  ext j; simp +decide [ Pi.single_apply ] ;
  fin_cases j <;> rfl

/-- The macro-state `12` is fixed by every multi-step meta transition. -/
theorem metaAttentionMatrix_pow_absorbing (k : ℕ) :
    (Pi.single (12 : Fin 13) (1 : ℝ)) ᵥ* metaAttentionMatrix ^ k = Pi.single 12 1 := by
  induction' ‹ℕ› with k ih <;> simp_all +decide [ pow_succ ];
  simp_all +decide [ funext_iff, Matrix.mul_apply, Pi.single_apply ];
  simp +decide [ metaAttentionMatrix ]

/-- **Meta convergence.** After `12` macro-steps the observer concentrates all of its mass at
the absorbing macro-state `12`, mirroring Level 1's `12`-step convergence. -/
theorem metaAttentionMatrix_converges (i : Fin 13) :
    (metaAttentionMatrix ^ 12) i 12 = 1 := by
  unfold metaAttentionMatrix; simp +decide [ Fin.sum_univ_succ, Matrix.mul_apply, pow_succ ] ; fin_cases i <;> simp +decide

/-! ## Level 3: the hyper-matrix (the joint object × meta system) -/

/-- The **hyper-attention matrix**: the Kronecker (tensor) product of the object attention
matrix (Level 1) and the meta-attention matrix (Level 2). It is a genuine "matrix of matrices"
encoding the joint dynamics of the observer watching the observed. -/
noncomputable def hyperAttentionMatrix :
    Matrix (Fin 14 × Fin 13) (Fin 14 × Fin 13) ℝ :=
  attentionMatrix ⊗ₖ metaAttentionMatrix

/-- **Joint conservation law.** The hyper-matrix is row-stochastic: lifting two conserved
systems to their joint product preserves total probability mass. -/
theorem hyperAttentionMatrix_isRowStochastic : IsRowStochasticOn hyperAttentionMatrix :=
  (isRowStochasticOn_of_isRowStochastic attentionMatrix_isRowStochastic).kronecker
    (isRowStochasticOn_of_isRowStochastic metaAttentionMatrix_isRowStochastic)

/-- Powers of the hyper-matrix split as the Kronecker product of the factor powers:
`(A ⊗ₖ B) ^ k = A ^ k ⊗ₖ B ^ k`. -/
theorem hyperAttentionMatrix_pow (k : ℕ) :
    hyperAttentionMatrix ^ k = (attentionMatrix ^ k) ⊗ₖ (metaAttentionMatrix ^ k) := by
  induction k with
  | zero => simp
  | succ k ih =>
      rw [pow_succ, pow_succ, pow_succ, ih, hyperAttentionMatrix, ← Matrix.mul_kronecker_mul]

/-- **Hyper-convergence (fixed-point boundary).** If Level 1 converges in `12` steps and the
meta-observer converges in `12` macro-steps, then the *joint* hyper-system converges in `12`
steps to the absorbing joint state `(13, 12)`: every starting joint state ends with all its
mass at `(13, 12)`. -/
theorem hyperAttentionMatrix_converges (p : Fin 14 × Fin 13) :
    (hyperAttentionMatrix ^ 12) p (13, 12) = 1 := by
  simp +decide [ hyperAttentionMatrix_pow, Matrix.kroneckerMap_apply, attentionMatrix_converges, metaAttentionMatrix_converges ]

/-! ## Anchoring Level 3 to the fibred-category bridge

The global graph of attention modules is the scale fibration of `Weaver`; a global shift is a
section of that fibration (`scaleBridgeFunctor_isSection`). The following records the woven
statement: the section preserves both the fibration structure *and* the joint row-stochastic
conservation law of the hyper-matrix. -/

open CategoryTheory in
/-- The global-graph section preserves the fibration (it is a genuine section of the scale
projection) **and** the joint hyper-system obeys the row-stochastic conservation law. -/
theorem hyperConservation_under_section (c₀ : ConfluenceFiber) :
    ((scaleBridgeFunctor ConfluenceFiber ℕ c₀).toFunctor ⋙
        CategoryTheory.Prod.snd ConfluenceFiber ℕ = 𝟭 ℕ)
      ∧ IsRowStochasticOn hyperAttentionMatrix :=
  ⟨scaleBridgeFunctor_isSection c₀, hyperAttentionMatrix_isRowStochastic⟩

end RequestProject.Compute.HyperWeaver