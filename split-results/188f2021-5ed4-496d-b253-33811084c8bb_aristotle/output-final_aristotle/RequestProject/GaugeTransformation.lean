import RequestProject.SuperBundle

/-!
# Gauge transformations and the clash of trivializations

The framework in `RequestProject.SuperBundle` handles **diagonal** transition data: a split
super vector bundle on `ℙ¹` recorded by two integer twist-lists.  This file extends the
picture to **non-diagonal** transition matrices, by formalizing the *gauge transformation*
(a.k.a. *clash-of-trivializations*) relation between cocycles.

## Geometric picture

A rank-`n` vector bundle on `ℙ¹`, trivialized over the two standard charts
`U = Spec K[z]` and `V = Spec K[z⁻¹]`, is glued on the overlap `𝔾ₘ = Spec K[z, z⁻¹]` by an
invertible transition matrix `g ∈ GLₙ(K[z, z⁻¹])`.  Two transition matrices `g`, `g'`
describe **isomorphic** bundles exactly when they differ by a change of trivialization on
each chart:
```
g' = h_U · g · h_V ,     h_U ∈ GLₙ(K[z]),   h_V ∈ GLₙ(K[z⁻¹]).
```
The left factor `h_U` is a gauge transformation regular on `U`, the right factor `h_V` one
regular on `V`.  This is the relation `GaugeEquiv` below.  Its equivalence-class structure
(`gaugeEquiv_refl/symm/trans`, `gaugeSetoid`) is the bookkeeping for the *clash of
trivializations*: the obstruction to simultaneously trivializing two patches.

For a **super** vector bundle the transition supermatrix is block-structured,
`fromBlocks A B C 0`-style, with the even summands on the block diagonal and the odd
"clash" blocks off the diagonal.  The diagonal case `B = C = 0` is exactly a
`SplitSuperBundle`; a nonzero off-diagonal block is the genuine clash.

## Main definitions and results

* `ringHomU`, `ringHomV` : the two chart inclusions `K[X] ↪ K[z, z⁻¹]`
  (`X ↦ z` for `U`, `X ↦ z⁻¹` for `V`).
* `gaugeGroupHomU`, `gaugeGroupHomV` : the induced maps on invertible matrices
  `GLₙ(K[X]) → GLₙ(K[z, z⁻¹])`.
* `GaugeEquiv` : the gauge-equivalence relation on transition matrices, and
  `gaugeEquiv_refl/symm/trans`, `gaugeEquivalence`, `gaugeSetoid`.
* `diagTwist`, `transitionMatrix` : the diagonal twist matrix of a list, and the
  block-diagonal transition supermatrix of a `SplitSuperBundle`.
* `clashMatrix` : the upper-block-triangular transition supermatrix with an off-diagonal
  odd clash block.
* `clash_gaugeEquiv_diagonal` : a `U`-regular clash block can be gauged away — the clashed
  bundle is gauge-equivalent to its diagonal (split) part.
-/

open Polynomial LaurentPolynomial Matrix

namespace SuperBundleP1

variable (K : Type*) [Field K]

/-- The chart-`U` inclusion of polynomials `K[X]` into Laurent polynomials `K[z, z⁻¹]`,
sending `X ↦ z`.  Its image is the ring of sections regular on `U = Spec K[z]`. -/
noncomputable def ringHomU : Polynomial K →+* LaurentPolynomial K := Polynomial.toLaurent

/-- The chart-`V` inclusion of polynomials `K[X]` into Laurent polynomials `K[z, z⁻¹]`,
sending `X ↦ z⁻¹`.  Its image is the ring of sections regular on `V = Spec K[z⁻¹]`. -/
noncomputable def ringHomV : Polynomial K →+* LaurentPolynomial K :=
  (Polynomial.aeval (LaurentPolynomial.T (-1) : LaurentPolynomial K)).toRingHom

variable {m : Type*} [Fintype m] [DecidableEq m]

/-- The gauge group homomorphism on chart `U`: an invertible polynomial matrix
(an element of `GLₙ(K[z])`) regarded as an invertible Laurent matrix. -/
noncomputable def gaugeGroupHomU :
    (Matrix m m (Polynomial K))ˣ →* (Matrix m m (LaurentPolynomial K))ˣ :=
  Units.map (ringHomU K).mapMatrix.toMonoidHom

/-- The gauge group homomorphism on chart `V`: an invertible polynomial matrix in the
`z⁻¹`-coordinate (an element of `GLₙ(K[z⁻¹])`) regarded as an invertible Laurent matrix. -/
noncomputable def gaugeGroupHomV :
    (Matrix m m (Polynomial K))ˣ →* (Matrix m m (LaurentPolynomial K))ˣ :=
  Units.map (ringHomV K).mapMatrix.toMonoidHom

/-- **Gauge equivalence of transition matrices.**  Two transition matrices `g`, `g'` over
`K[z, z⁻¹]` are gauge equivalent when they differ by a gauge transformation regular on `U`
on the left and one regular on `V` on the right: `g' = h_U · g · h_V`.  This is precisely
the condition that the two cocycles describe isomorphic bundles. -/
def GaugeEquiv (g g' : Matrix m m (LaurentPolynomial K)) : Prop :=
  ∃ (hU hV : (Matrix m m (Polynomial K))ˣ),
    g' = (gaugeGroupHomU K hU : Matrix m m (LaurentPolynomial K)) * g
          * (gaugeGroupHomV K hV : Matrix m m (LaurentPolynomial K))

/-- Gauge equivalence is reflexive (use the identity gauge on both charts). -/
theorem gaugeEquiv_refl (g : Matrix m m (LaurentPolynomial K)) : GaugeEquiv K g g := by
  refine' ⟨ 1, 1, _ ⟩ ; simp +decide

/-- Gauge equivalence is symmetric (invert both gauge transformations). -/
theorem gaugeEquiv_symm {g g' : Matrix m m (LaurentPolynomial K)} :
    GaugeEquiv K g g' → GaugeEquiv K g' g := by
  -- Assume that `g' = h_U · g · h_V`; we must show `g = h_U⁻¹ · g' · h_V⁻¹`.
  rintro ⟨hU, hV, h⟩
  exact ⟨hU⁻¹, hV⁻¹, by simp [h, ← mul_assoc]⟩

/-- Gauge equivalence is transitive (compose the gauge transformations on each chart). -/
theorem gaugeEquiv_trans {g g' g'' : Matrix m m (LaurentPolynomial K)} :
    GaugeEquiv K g g' → GaugeEquiv K g' g'' → GaugeEquiv K g g'' := by
  rintro ⟨ hU₁, hV₁, rfl ⟩ ⟨ hU₂, hV₂, rfl ⟩;
  exact ⟨ hU₂ * hU₁, hV₁ * hV₂, by simp +decide [ mul_assoc, map_mul ] ⟩

/-- Gauge equivalence is an equivalence relation. -/
theorem gaugeEquivalence : Equivalence (GaugeEquiv K (m := m)) :=
  ⟨gaugeEquiv_refl K, gaugeEquiv_symm K, gaugeEquiv_trans K⟩

/-- The setoid of transition matrices up to gauge equivalence; its quotient is the set of
isomorphism classes of rank-`|m|` bundles presented on the two-chart cover. -/
def gaugeSetoid : Setoid (Matrix m m (LaurentPolynomial K)) where
  r := GaugeEquiv K
  iseqv := gaugeEquivalence K

/-! ### Diagonal transition data and the split case -/

/-- The diagonal transition matrix `diag(z^{d₀}, …, z^{d_{k-1}})` of a list of twists. -/
noncomputable def diagTwist (l : List ℤ) :
    Matrix (Fin l.length) (Fin l.length) (LaurentPolynomial K) :=
  Matrix.diagonal (fun i => LaurentPolynomial.T l[i])

/-- The block-diagonal transition supermatrix of a `SplitSuperBundle`: even twists on the
even block, odd twists on the odd block, and no clash. -/
noncomputable def transitionMatrix (E : SplitSuperBundle) :
    Matrix (Fin E.even.length ⊕ Fin E.odd.length)
      (Fin E.even.length ⊕ Fin E.odd.length) (LaurentPolynomial K) :=
  Matrix.fromBlocks (diagTwist K E.even) 0 0 (diagTwist K E.odd)

/-- An upper-block-triangular transition supermatrix with an off-diagonal odd **clash**
block `N` between the even and odd parts.  Taking `N = 0` recovers `transitionMatrix`. -/
noncomputable def clashMatrix (E : SplitSuperBundle)
    (N : Matrix (Fin E.even.length) (Fin E.odd.length) (LaurentPolynomial K)) :
    Matrix (Fin E.even.length ⊕ Fin E.odd.length)
      (Fin E.even.length ⊕ Fin E.odd.length) (LaurentPolynomial K) :=
  Matrix.fromBlocks (diagTwist K E.even) N 0 (diagTwist K E.odd)

/-- Taking the clash block to be `0` gives exactly the split transition matrix. -/
theorem clashMatrix_zero (E : SplitSuperBundle) :
    clashMatrix K E 0 = transitionMatrix K E := rfl

/-- The elementary upper-triangular gauge transformation `[[1, M], [0, 1]]`, as an
invertible polynomial matrix (its inverse is `[[1, -M], [0, 1]]`). -/
noncomputable def upperGaugeUnit {a b : ℕ} (M : Matrix (Fin a) (Fin b) (Polynomial K)) :
    (Matrix (Fin a ⊕ Fin b) (Fin a ⊕ Fin b) (Polynomial K))ˣ where
  val := Matrix.fromBlocks 1 M 0 1
  inv := Matrix.fromBlocks 1 (-M) 0 1
  val_inv := by
    rw [Matrix.fromBlocks_multiply]
    simp [Matrix.fromBlocks_one]
  inv_val := by
    rw [Matrix.fromBlocks_multiply]
    simp [Matrix.fromBlocks_one]

/-- **A `U`-regular clash can be gauged away.**  If the clash block has the form
`N = (M.map z) · (odd diagonal)` for a polynomial matrix `M` (i.e. it is a `U`-regular
coboundary), then the clashed transition supermatrix is gauge equivalent to the diagonal
(split) one: the off-diagonal obstruction is trivial and the super bundle splits.  This is
the matrix incarnation of the statement that a clash class vanishing in `H¹` is removable. -/
theorem clash_gaugeEquiv_diagonal (E : SplitSuperBundle)
    (M : Matrix (Fin E.even.length) (Fin E.odd.length) (Polynomial K)) :
    GaugeEquiv K
      (clashMatrix K E ((M.map (ringHomU K)) * diagTwist K E.odd))
      (transitionMatrix K E) := by
  refine' ⟨ upperGaugeUnit K ( -M ), 1, _ ⟩;
  unfold gaugeGroupHomU gaugeGroupHomV upperGaugeUnit transitionMatrix clashMatrix;
  simp +decide [ Matrix.fromBlocks_multiply, Matrix.fromBlocks_map ];
  ext i j; simp +decide [ Matrix.mul_apply, Matrix.map_apply ] ;

end SuperBundleP1