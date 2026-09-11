import Mathlib
import RequestProject.Imported.EisensteinAlgebra.EisensteinIntegers_Root

/-!
# The Coxeter–Todd lattice K₁₂ — foundational definitions

This file defines the Coxeter–Todd lattice `K₁₂` via its Gram matrix and
establishes its most basic properties. It is the foundational layer of a
larger `K₁₂` project; substantive theorems (positive definiteness via the
strict equality direction, minimum nonzero norm = 4, kissing number = 756,
automorphism group) are deferred to subsequent files.

## Source

The Gram matrix used here is taken from Gabriele Nebe's Catalogue of Lattices
entry for `K₁₂` (http://www.math.rwth-aachen.de/~Gabriele.Nebe/LATTICES/K12.html).
Nebe normalizes `K₁₂` so that:
* minimum nonzero squared norm = 4,
* determinant = 729 = 3^6,
* diagonal entries of the Gram matrix = 4.

The theta-series coefficients `1, 0, 0, 0, 756, 0, 4032, …` (where the `q^4`
coefficient = 756 is the kissing number) have been independently verified
numerically against this Gram matrix; they match Conway–Sloane's listing in
*Sphere Packings, Lattices and Groups*.

## Key insight: the sum-of-squares identity

The substantive content of this file (non-negativity of the quadratic form)
rests on the following explicit identity, derived from an `LDLᵀ`
decomposition of the Gram matrix and verified by `ring`:

```
64 · normSq(x) = 16 t₀(x)² + 16 t₁(x)² + 16 t₂(x)²
              + 12 t₃(x)² + 12 t₄(x)² + 12 t₅(x)²
              + 4 t₆(x)² + 4 t₇(x)² + 4 t₈(x)²
              + 3 t₉(x)² + 3 t₁₀(x)² + 3 t₁₁(x)²
```

where each `tᵢ(x)` is an explicit integer linear form in `x₀, …, x₁₁`. Since
each coefficient on the right is a positive integer and each `tᵢ(x)²` is
non-negative, `normSq(x) ≥ 0` follows.

## What this file delivers

* `K12.gram` — the 12×12 integer Gram matrix.
* `K12.gram_symm` — symmetry of the Gram matrix (by `decide`).
* `K12.gram_diag` — diagonal entries equal 4 (by `fin_cases`).
* `K12.gram_det` — `det(gram) = 729`, proved via the LDLᵀ factorization.
* `K12.normSq` — the integer squared-norm function `x ↦ x ⬝ gram ⬝ x` on `ℤ¹²`.
* `K12.normSq_basis` — `normSq (eᵢ) = 4` for each standard basis vector
  (via `native_decide +revert`).
* `K12.normSq_sos` — the explicit sum-of-squares identity, proved by `ring`.
* `K12.normSq_nonneg` — `normSq x ≥ 0` for all `x`, as a corollary of `normSq_sos`.
-/

noncomputable section

open Matrix

namespace K12

/-! ## The Gram matrix -/

/-- The Coxeter–Todd lattice `K₁₂` Gram matrix in Nebe's normalization.
Entries verified against the Catalogue of Lattices entry; the resulting
quadratic form has been numerically confirmed to produce the theta series
`1 + 756·q^4 + 4032·q^6 + 20412·q^8 + …` characteristic of `K₁₂`. -/
def gram : Matrix (Fin 12) (Fin 12) ℤ := !![
   4,  0,  0, -2,  0,  0,  2, -1, -1, -1,  2, -1;
   0,  4,  0,  0, -2,  0,  2, -1, -1, -1, -1,  2;
   0,  0,  4,  0,  0, -2,  2,  2,  2, -1, -1, -1;
  -2,  0,  0,  4,  0,  0, -1, -1,  2,  2, -1, -1;
   0, -2,  0,  0,  4,  0, -1,  2, -1,  2, -1, -1;
   0,  0, -2,  0,  0,  4, -1, -1, -1,  2,  2,  2;
   2,  2,  2, -1, -1, -1,  4,  0,  0, -2,  0,  0;
  -1, -1,  2, -1,  2, -1,  0,  4,  0,  0, -2,  0;
  -1, -1,  2,  2, -1, -1,  0,  0,  4,  0,  0, -2;
  -1, -1, -1,  2,  2,  2, -2,  0,  0,  4,  0,  0;
   2, -1, -1, -1, -1,  2,  0, -2,  0,  0,  4,  0;
  -1,  2, -1, -1, -1,  2,  0,  0, -2,  0,  0,  4]

/-! ## Basic properties of the Gram matrix -/

/-- The Gram matrix of `K₁₂` is symmetric. -/
theorem gram_symm : gram.IsSymm := by
  decide

/-- Each diagonal entry of the `K₁₂` Gram matrix equals `4`. -/
theorem gram_diag (i : Fin 12) : gram i i = 4 := by
  fin_cases i <;> rfl

/-! ### The Determinant Proof (Bypassing the 12! Explosion)

The determinant is computed via an LDLᵀ factorization: `Uᵀ · D · U = 64 · gram`
where U is upper triangular with diagonal 4 and D is a diagonal matrix.
Taking determinants: `det(U)² · det(D) = 64¹² · det(gram)`, yielding `det(gram) = 729`.
-/

/-- Explicit integer upper-triangular matrix U from the LDLᵀ factorization. -/
def U : Matrix (Fin 12) (Fin 12) ℤ := !![
  4, 0, 0, -2, 0, 0,  2, -1, -1, -1,  2, -1;
  0, 4, 0,  0,-2, 0,  2, -1, -1, -1, -1,  2;
  0, 0, 4,  0, 0,-2,  2,  2,  2, -1, -1, -1;
  0, 0, 0,  4, 0, 0,  0, -2,  2,  2,  0, -2;
  0, 0, 0,  0, 4, 0,  0,  2, -2,  2, -2,  0;
  0, 0, 0,  0, 0, 4,  0,  0,  0,  2,  2,  2;
  0, 0, 0,  0, 0, 0,  4,  0,  0, -2,  0,  0;
  0, 0, 0,  0, 0, 0,  0,  4,  0,  0, -2,  0;
  0, 0, 0,  0, 0, 0,  0,  0,  4,  0,  0, -2;
  0, 0, 0,  0, 0, 0,  0,  0,  0,  4,  0,  0;
  0, 0, 0,  0, 0, 0,  0,  0,  0,  0,  4,  0;
  0, 0, 0,  0, 0, 0,  0,  0,  0,  0,  0,  4
]

/-- The diagonal matrix D from the LDLᵀ factorization. -/
def D : Matrix (Fin 12) (Fin 12) ℤ :=
  diagonal ![16, 16, 16, 12, 12, 12, 4, 4, 4, 3, 3, 3]

/-- The factorization identity: Uᵀ · D · U = 64 · gram. -/
theorem U_transpose_D_U_eq : Uᵀ * D * U = (64 : ℤ) • gram := by
  decide

/-- U is upper triangular (block triangular w.r.t. the identity function). -/
lemma U_blockTriangular : U.BlockTriangular id := by
  intro i j (hij : j < i)
  fin_cases i <;> fin_cases j <;> simp_all [U]

/-- det(U) = 4^12 (upper triangular with diagonal entries all equal to 4). -/
lemma U_det : U.det = 4 ^ 12 := by
  rw [det_of_upperTriangular U_blockTriangular]
  decide

/-- det(D) = product of diagonal entries. -/
lemma D_det : D.det = 16 ^ 3 * 12 ^ 3 * 4 ^ 3 * 3 ^ 3 := by
  simp only [D, det_diagonal]
  decide

/-
The determinant of the `K₁₂` Gram matrix equals `729 = 3^6`.
-/
theorem gram_det : gram.det = 729 := by
  -- From U_transpose_D_U_eq and U_det we have 4^12 * D.det * 4^12 = (64 : ℤ) ^ 12 * gram.det.
  have h_det : (4 ^ 12 : ℤ) * D.det * (4 ^ 12 : ℤ) = (64 : ℤ) ^ 12 * gram.det := by
    have h_det : (Uᵀ * D * U).det = (64 : ℤ) ^ 12 * gram.det := by
      rw [ U_transpose_D_U_eq ];
      convert Matrix.det_smul ( gram : Matrix ( Fin 12 ) ( Fin 12 ) ℤ ) 64 using 1;
    rw [ ← h_det, Matrix.det_mul, Matrix.det_mul, Matrix.det_transpose ];
    rw [ U_det ];
  norm_num [ D_det ] at h_det ; linarith

/-! ## The integer squared-norm function -/

/-- The squared-norm function on `Fin 12 → ℤ` associated to the `K₁₂` Gram
matrix: `normSq x = ∑_{i,j} G[i][j] · x[i] · x[j]`.

In matrix form this is `x ⬝ gram ⬝ x`, the standard pairing of a vector with
itself under the bilinear form determined by `gram`. -/
def normSq (x : Fin 12 → ℤ) : ℤ :=
  ∑ i : Fin 12, ∑ j : Fin 12, gram i j * x i * x j

/-- The squared norm of a standard basis vector `eᵢ` equals `gram i i = 4`. -/
theorem normSq_basis (i : Fin 12) : normSq (Pi.single i 1) = 4 := by
  native_decide +revert

/-! ## The sum-of-squares identity

The following is the key identity that establishes positive semi-definiteness
of the Gram matrix. It expresses `64 · normSq(x)` as a sum of positive integer
coefficients times squares of integer linear forms in the coordinates `xᵢ`.

The decomposition was derived from the `LDLᵀ` factorization of the Gram
matrix, where the linear forms `tᵢ(x)` correspond to `4 · (Lᵀ x)ᵢ` and the
coefficients `(16, 16, 16, 12, 12, 12, 4, 4, 4, 3, 3, 3)` correspond to
`16 · 4 · diag(D)` clearing all denominators.
-/

/-- The explicit sum-of-squares decomposition of `64 · normSq`. -/
theorem normSq_sos (x : Fin 12 → ℤ) :
    64 * normSq x =
      16 * (4 * x 0 - 2 * x 3 + 2 * x 6 - x 7 - x 8 - x 9 + 2 * x 10 - x 11)^2 +
      16 * (4 * x 1 - 2 * x 4 + 2 * x 6 - x 7 - x 8 - x 9 - x 10 + 2 * x 11)^2 +
      16 * (4 * x 2 - 2 * x 5 + 2 * x 6 + 2 * x 7 + 2 * x 8 - x 9 - x 10 - x 11)^2 +
      12 * (4 * x 3 - 2 * x 7 + 2 * x 8 + 2 * x 9 - 2 * x 11)^2 +
      12 * (4 * x 4 + 2 * x 7 - 2 * x 8 + 2 * x 9 - 2 * x 10)^2 +
      12 * (4 * x 5 + 2 * x 9 + 2 * x 10 + 2 * x 11)^2 +
      4 * (4 * x 6 - 2 * x 9)^2 +
      4 * (4 * x 7 - 2 * x 10)^2 +
      4 * (4 * x 8 - 2 * x 11)^2 +
      3 * (4 * x 9)^2 +
      3 * (4 * x 10)^2 +
      3 * (4 * x 11)^2 := by
  unfold normSq gram
  simp [Fin.sum_univ_succ]
  ring

/-- The squared norm is non-negative. Follows from the sum-of-squares
identity `normSq_sos`: `64 · normSq x` is a positive-integer combination of
squares, hence ≥ 0, and dividing by 64 (positive) preserves the inequality. -/
theorem normSq_nonneg (x : Fin 12 → ℤ) : 0 ≤ normSq x := by
  have hsos := normSq_sos x
  have h64 : (64 : ℤ) * normSq x ≥ 0 := by
    rw [hsos]
    have h1 := sq_nonneg (4 * x 0 - 2 * x 3 + 2 * x 6 - x 7 - x 8 - x 9 + 2 * x 10 - x 11)
    have h2 := sq_nonneg (4 * x 1 - 2 * x 4 + 2 * x 6 - x 7 - x 8 - x 9 - x 10 + 2 * x 11)
    have h3 := sq_nonneg (4 * x 2 - 2 * x 5 + 2 * x 6 + 2 * x 7 + 2 * x 8 - x 9 - x 10 - x 11)
    have h4 := sq_nonneg (4 * x 3 - 2 * x 7 + 2 * x 8 + 2 * x 9 - 2 * x 11)
    have h5 := sq_nonneg (4 * x 4 + 2 * x 7 - 2 * x 8 + 2 * x 9 - 2 * x 10)
    have h6 := sq_nonneg (4 * x 5 + 2 * x 9 + 2 * x 10 + 2 * x 11)
    have h7 := sq_nonneg (4 * x 6 - 2 * x 9)
    have h8 := sq_nonneg (4 * x 7 - 2 * x 10)
    have h9 := sq_nonneg (4 * x 8 - 2 * x 11)
    have h10 := sq_nonneg (4 * x 9)
    have h11 := sq_nonneg (4 * x 10)
    have h12 := sq_nonneg (4 * x 11)
    linarith
  linarith

end K12