/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Explicit three-dimensional representations of `A₅` over `ℤ[φ] ⊂ ℚ(√5)`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.A5ArtinCosets

/-!
# The two three-dimensional representations of `A₅` over `ℚ(√5)`

The character table of `A₅` used throughout the conductor computation contains
two rows that no permutation representation can produce, `χ₃` and `χ₃′`: they are
the characters of the two three-dimensional irreducible representations, which are
defined over `ℚ(√5)` and are exchanged by the nontrivial automorphism of that
field.  This file constructs them explicitly, so that the last two rows of the
table become theorems.

The model is the icosahedral one.  The rotation group of the icosahedron with
vertices the cyclic permutations of `(0, ±1, ±φ)` preserves the `ℤ[φ]`-lattice
they span, so in a basis of three vertices it is a group of matrices with
entries in the ring of integers `ℤ[φ]` of `ℚ(√5)`.  Concretely:

* `Gold` — the ring `ℤ[φ]`, `⟨a, b⟩ = a + b φ` with `φ² = φ + 1`, with its two
  embeddings `Gold.evalPhi`, `Gold.evalPhi'` in `ℝ` (`φ ↦ (1 ± √5)/2`) and the
  nontrivial automorphism `Gold.conj`; `Gold.lift` evaluates it in any
  commutative ring with a root of `X² = X + 1`;
* `Mat3` — `3 × 3` matrices over `ℤ[φ]` in a form the kernel computes with,
  together with `Mat3.toMatrix` into `Matrix (Fin 3) (Fin 3) Gold`;
* `rho3` — the matrix of each element of `A₅`, tabulated by the images of
  `0, 1, 2` (which determine an even permutation).  That this table really is a
  representation is `rho3_mul`, checked on all `60 × 60` products; it is faithful
  (`rho3_eq_one`) and takes values in `SL₃(ℤ[φ])` (`det_rho3`);
* `rep3` — the resulting monoid homomorphism `A₅ →* Matrix (Fin 3) (Fin 3) Gold`,
  and `rep3b` its Galois conjugate;
* `chi3_eq_trace_rep3`, `chi3b_eq_trace_rep3`, `chi3b_eq_trace_rep3b` — **the two
  asserted characters are the characters of these representations**: `χ₃` is the
  trace of `rep3` read through `evalPhi`, and `χ₃′` is the same trace read
  through the other embedding, equivalently the trace of `rep3b`;
* `rep3_entries_mem_adjoin` — the entries lie in `ℚ(√5) ⊂ ℝ`.
-/

namespace A5Artin

open Cls IRep Equiv

/-! ## 1. The ring `ℤ[φ]` -/

/-- `ℤ[φ]`: the pair `⟨a, b⟩` denotes `a + b φ`, where `φ² = φ + 1`. -/
structure Gold where
  a : ℤ
  b : ℤ
deriving DecidableEq

namespace Gold

instance : Add Gold := ⟨fun x y => ⟨x.a + y.a, x.b + y.b⟩⟩
instance : Mul Gold := ⟨fun x y => ⟨x.a * y.a + x.b * y.b, x.a * y.b + x.b * y.a + x.b * y.b⟩⟩
instance : Neg Gold := ⟨fun x => ⟨-x.a, -x.b⟩⟩
instance : Sub Gold := ⟨fun x y => ⟨x.a - y.a, x.b - y.b⟩⟩
instance : Zero Gold := ⟨⟨0, 0⟩⟩
instance : One Gold := ⟨⟨1, 0⟩⟩

@[ext] theorem ext {x y : Gold} (ha : x.a = y.a) (hb : x.b = y.b) : x = y := by
  cases x; cases y; simp_all

@[simp] theorem add_a (x y : Gold) : (x + y).a = x.a + y.a := rfl
@[simp] theorem add_b (x y : Gold) : (x + y).b = x.b + y.b := rfl
@[simp] theorem mul_a (x y : Gold) : (x * y).a = x.a * y.a + x.b * y.b := rfl
@[simp] theorem mul_b (x y : Gold) : (x * y).b = x.a * y.b + x.b * y.a + x.b * y.b := rfl
@[simp] theorem neg_a (x : Gold) : (-x).a = -x.a := rfl
@[simp] theorem neg_b (x : Gold) : (-x).b = -x.b := rfl
@[simp] theorem sub_a (x y : Gold) : (x - y).a = x.a - y.a := rfl
@[simp] theorem sub_b (x y : Gold) : (x - y).b = x.b - y.b := rfl
@[simp] theorem zero_a : (0 : Gold).a = 0 := rfl
@[simp] theorem zero_b : (0 : Gold).b = 0 := rfl
@[simp] theorem one_a : (1 : Gold).a = 1 := rfl
@[simp] theorem one_b : (1 : Gold).b = 0 := rfl

instance : CommRing Gold where
  add_assoc := by intros; ext <;> simp <;> ring
  zero_add := by intros; ext <;> simp
  add_zero := by intros; ext <;> simp
  add_comm := by intros; ext <;> simp <;> ring
  mul_assoc := by intros; ext <;> simp <;> ring
  one_mul := by intros; ext <;> simp
  mul_one := by intros; ext <;> simp
  left_distrib := by intros; ext <;> simp <;> ring
  right_distrib := by intros; ext <;> simp <;> ring
  mul_comm := by intros; ext <;> simp <;> ring
  zero_mul := by intros; ext <;> simp
  mul_zero := by intros; ext <;> simp
  neg_add_cancel := by intros; ext <;> simp
  sub_eq_add_neg := by intros; ext <;> simp <;> ring
  nsmul := nsmulRec
  zsmul := zsmulRec

/-- Evaluation of `ℤ[φ]` in any commutative ring with a chosen root `t` of
`X² = X + 1`. -/
def lift {R : Type*} [CommRing R] (t : R) (ht : t ^ 2 = t + 1) : Gold →+* R where
  toFun z := (z.a : R) + (z.b : R) * t
  map_one' := by simp
  map_zero' := by simp
  map_add' x y := by simp only [add_a, add_b]; push_cast; ring
  map_mul' x y := by
    simp only [mul_a, mul_b]
    push_cast
    linear_combination (-((x.b : R) * (y.b : R))) * ht

/-- The nontrivial automorphism `φ ↦ 1 − φ` of `ℤ[φ]`. -/
def conj : Gold →+* Gold where
  toFun z := ⟨z.a + z.b, -z.b⟩
  map_one' := rfl
  map_zero' := rfl
  map_add' x y := by ext <;> simp <;> ring
  map_mul' x y := by ext <;> simp <;> ring

@[simp] theorem conj_a (z : Gold) : (conj z).a = z.a + z.b := rfl
@[simp] theorem conj_b (z : Gold) : (conj z).b = -z.b := rfl

/-- The embedding of `ℤ[φ]` in `ℝ` sending `φ` to the golden ratio. -/
noncomputable def evalPhi : Gold →+* ℝ := lift phi Real.goldenRatio_sq

/-- The other embedding of `ℤ[φ]` in `ℝ`, sending `φ` to its conjugate. -/
noncomputable def evalPhi' : Gold →+* ℝ := lift phi' Real.goldenConj_sq

theorem evalPhi_apply (z : Gold) : evalPhi z = (z.a : ℝ) + (z.b : ℝ) * phi := rfl

theorem evalPhi'_apply (z : Gold) : evalPhi' z = (z.a : ℝ) + (z.b : ℝ) * phi' := rfl

/-- The two embeddings differ by the automorphism `conj`. -/
theorem evalPhi_conj (z : Gold) : evalPhi (conj z) = evalPhi' z := by
  rw [evalPhi_apply, evalPhi'_apply, conj_a, conj_b]
  push_cast
  linear_combination (z.b : ℝ) * phi_add

end Gold

/-! ## 2. `3 × 3` matrices over `ℤ[φ]`, and the icosahedral table -/

/-- A `3 × 3` matrix over `ℤ[φ]`, in a form the kernel can compute with. -/
structure Mat3 where
  a00 : Gold
  a01 : Gold
  a02 : Gold
  a10 : Gold
  a11 : Gold
  a12 : Gold
  a20 : Gold
  a21 : Gold
  a22 : Gold
deriving DecidableEq

namespace Mat3

instance : One Mat3 := ⟨⟨1, 0, 0, 0, 1, 0, 0, 0, 1⟩⟩

instance : Mul Mat3 := ⟨fun x y =>
  ⟨x.a00 * y.a00 + x.a01 * y.a10 + x.a02 * y.a20,
   x.a00 * y.a01 + x.a01 * y.a11 + x.a02 * y.a21,
   x.a00 * y.a02 + x.a01 * y.a12 + x.a02 * y.a22,
   x.a10 * y.a00 + x.a11 * y.a10 + x.a12 * y.a20,
   x.a10 * y.a01 + x.a11 * y.a11 + x.a12 * y.a21,
   x.a10 * y.a02 + x.a11 * y.a12 + x.a12 * y.a22,
   x.a20 * y.a00 + x.a21 * y.a10 + x.a22 * y.a20,
   x.a20 * y.a01 + x.a21 * y.a11 + x.a22 * y.a21,
   x.a20 * y.a02 + x.a21 * y.a12 + x.a22 * y.a22⟩⟩

/-- The trace. -/
def trace (x : Mat3) : Gold := x.a00 + x.a11 + x.a22

@[simp] theorem mul_a00 (x y : Mat3) :
    (x * y).a00 = x.a00 * y.a00 + x.a01 * y.a10 + x.a02 * y.a20 := rfl
@[simp] theorem mul_a01 (x y : Mat3) :
    (x * y).a01 = x.a00 * y.a01 + x.a01 * y.a11 + x.a02 * y.a21 := rfl
@[simp] theorem mul_a02 (x y : Mat3) :
    (x * y).a02 = x.a00 * y.a02 + x.a01 * y.a12 + x.a02 * y.a22 := rfl
@[simp] theorem mul_a10 (x y : Mat3) :
    (x * y).a10 = x.a10 * y.a00 + x.a11 * y.a10 + x.a12 * y.a20 := rfl
@[simp] theorem mul_a11 (x y : Mat3) :
    (x * y).a11 = x.a10 * y.a01 + x.a11 * y.a11 + x.a12 * y.a21 := rfl
@[simp] theorem mul_a12 (x y : Mat3) :
    (x * y).a12 = x.a10 * y.a02 + x.a11 * y.a12 + x.a12 * y.a22 := rfl
@[simp] theorem mul_a20 (x y : Mat3) :
    (x * y).a20 = x.a20 * y.a00 + x.a21 * y.a10 + x.a22 * y.a20 := rfl
@[simp] theorem mul_a21 (x y : Mat3) :
    (x * y).a21 = x.a20 * y.a01 + x.a21 * y.a11 + x.a22 * y.a21 := rfl
@[simp] theorem mul_a22 (x y : Mat3) :
    (x * y).a22 = x.a20 * y.a02 + x.a21 * y.a12 + x.a22 * y.a22 := rfl

/-- The determinant. -/
def det (x : Mat3) : Gold :=
  x.a00 * (x.a11 * x.a22 - x.a12 * x.a21) - x.a01 * (x.a10 * x.a22 - x.a12 * x.a20)
    + x.a02 * (x.a10 * x.a21 - x.a11 * x.a20)

/-- The corresponding honest `Matrix (Fin 3) (Fin 3) Gold`. -/
def toMatrix (x : Mat3) : Matrix (Fin 3) (Fin 3) Gold :=
  !![x.a00, x.a01, x.a02; x.a10, x.a11, x.a12; x.a20, x.a21, x.a22]

/-- The nine entries, read back off a matrix. -/
def ofMatrix (M : Matrix (Fin 3) (Fin 3) Gold) : Mat3 :=
  ⟨M 0 0, M 0 1, M 0 2, M 1 0, M 1 1, M 1 2, M 2 0, M 2 1, M 2 2⟩

theorem ofMatrix_toMatrix (x : Mat3) : ofMatrix x.toMatrix = x := by
  cases x; simp [ofMatrix, toMatrix]

theorem toMatrix_injective : Function.Injective toMatrix :=
  Function.LeftInverse.injective ofMatrix_toMatrix

theorem toMatrix_one : (1 : Mat3).toMatrix = 1 := by
  refine Matrix.ext fun i j => ?_
  fin_cases i <;> fin_cases j <;> simp [toMatrix] <;> rfl

theorem toMatrix_mul (x y : Mat3) : (x * y).toMatrix = x.toMatrix * y.toMatrix := by
  refine Matrix.ext fun i j => ?_
  fin_cases i <;> fin_cases j <;>
    simp [toMatrix, Matrix.mul_apply, Fin.sum_univ_three]

theorem trace_toMatrix (x : Mat3) : Matrix.trace x.toMatrix = x.trace := by
  simp [Matrix.trace, Matrix.diag, Fin.sum_univ_three, toMatrix, trace]

theorem det_toMatrix (x : Mat3) : x.toMatrix.det = x.det := by
  rw [Matrix.det_fin_three]
  simp [toMatrix, det]
  ring

end Mat3

/-- The key of a permutation: an even permutation of `Fin 5` is determined by the
images of `0, 1, 2`. -/
def keyPerm (g : Perm (Fin 5)) : ℕ := 25 * (g 0).val + 5 * (g 1).val + (g 2).val

/-- The table of the icosahedral representation, indexed by `keyPerm`. -/
def rho3Tbl : ℕ → Mat3
  | 7 => ⟨⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩⟩
  | 8 => ⟨⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩⟩
  | 9 => ⟨⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩⟩
  | 11 => ⟨⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩⟩
  | 13 => ⟨⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩⟩
  | 14 => ⟨⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩⟩
  | 16 => ⟨⟨0, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩⟩
  | 17 => ⟨⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩⟩
  | 19 => ⟨⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩⟩
  | 21 => ⟨⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩⟩
  | 22 => ⟨⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩⟩
  | 23 => ⟨⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩⟩
  | 27 => ⟨⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩⟩
  | 28 => ⟨⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩⟩
  | 29 => ⟨⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩⟩
  | 35 => ⟨⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩⟩
  | 38 => ⟨⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩⟩
  | 39 => ⟨⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩⟩
  | 40 => ⟨⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩⟩
  | 42 => ⟨⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩⟩
  | 44 => ⟨⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩⟩
  | 45 => ⟨⟨0, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩⟩
  | 47 => ⟨⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩⟩
  | 48 => ⟨⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩⟩
  | 51 => ⟨⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩⟩
  | 53 => ⟨⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩⟩
  | 54 => ⟨⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩⟩
  | 55 => ⟨⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩⟩
  | 58 => ⟨⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩⟩
  | 59 => ⟨⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩⟩
  | 65 => ⟨⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩⟩
  | 66 => ⟨⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, 0⟩⟩
  | 69 => ⟨⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩⟩
  | 70 => ⟨⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩⟩
  | 71 => ⟨⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩⟩
  | 73 => ⟨⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩⟩
  | 76 => ⟨⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩⟩
  | 77 => ⟨⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩⟩
  | 79 => ⟨⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩⟩
  | 80 => ⟨⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩⟩
  | 82 => ⟨⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩⟩
  | 84 => ⟨⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩⟩
  | 85 => ⟨⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩⟩
  | 86 => ⟨⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩⟩
  | 89 => ⟨⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩⟩
  | 95 => ⟨⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨0, 0⟩⟩
  | 96 => ⟨⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨1, -1⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨1, -1⟩⟩
  | 97 => ⟨⟨-1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨0, 0⟩⟩
  | 101 => ⟨⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, 0⟩⟩
  | 102 => ⟨⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩⟩
  | 103 => ⟨⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩⟩
  | 105 => ⟨⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩⟩
  | 107 => ⟨⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩⟩
  | 108 => ⟨⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩⟩
  | 110 => ⟨⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩⟩
  | 111 => ⟨⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩⟩
  | 113 => ⟨⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩⟩
  | 115 => ⟨⟨1, 0⟩, ⟨-1, 1⟩, ⟨1, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨0, 0⟩⟩
  | 116 => ⟨⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 0⟩, ⟨1, 0⟩, ⟨1, 0⟩, ⟨-1, 1⟩, ⟨0, 0⟩, ⟨1, -1⟩, ⟨-1, 1⟩⟩
  | 117 => ⟨⟨-1, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩, ⟨-1, 0⟩, ⟨0, 0⟩⟩
  | _ => 1

/-- The icosahedral representation of `A₅` in matrix form: `rho3 g` is the matrix
of `g` in the basis of `ℤ[φ]³` given by three vertices of the icosahedron. -/
def rho3 (g : Perm (Fin 5)) : Mat3 := rho3Tbl (keyPerm g)

set_option maxRecDepth 100000
set_option maxHeartbeats 4000000

theorem rho3_one : rho3 1 = 1 := by decide

/-- **The table is multiplicative on `A₅`**: checked on all `60 × 60` pairs. -/
theorem rho3_mul : ∀ g ∈ A5finset, ∀ h ∈ A5finset, rho3 (g * h) = rho3 g * rho3 h := by
  decide +kernel

/-- The representation is faithful. -/
theorem rho3_eq_one : ∀ g ∈ A5finset, rho3 g = 1 → g = 1 := by decide +kernel

/-- Every matrix of the representation has determinant `1`: the image lies in
`SL₃(ℤ[φ])`. -/
theorem det_rho3 : ∀ g ∈ A5finset, (rho3 g).det = 1 := by decide +kernel

/-! ## 3. The representation as a monoid homomorphism -/

/-- The icosahedral representation `A₅ → GL₃(ℤ[φ])`, as a monoid homomorphism into
the matrix ring over `ℤ[φ] ⊆ ℚ(√5)`. -/
def rep3 : alternatingGroup (Fin 5) →* Matrix (Fin 3) (Fin 3) Gold where
  toFun g := (rho3 (g : Perm (Fin 5))).toMatrix
  map_one' := by
    show (rho3 (1 : Perm (Fin 5))).toMatrix = 1
    rw [rho3_one, Mat3.toMatrix_one]
  map_mul' g h := by
    show (rho3 ((g : Perm (Fin 5)) * (h : Perm (Fin 5)))).toMatrix = _
    rw [rho3_mul _ (mem_A5finset.2 g.2) _ (mem_A5finset.2 h.2), Mat3.toMatrix_mul]

/-- The Galois-conjugate representation: apply the nontrivial automorphism
`φ ↦ 1 − φ` of `ℤ[φ]` to every matrix entry. -/
def rep3b : alternatingGroup (Fin 5) →* Matrix (Fin 3) (Fin 3) Gold :=
  (Gold.conj.mapMatrix : Matrix (Fin 3) (Fin 3) Gold →+* Matrix (Fin 3) (Fin 3) Gold).toMonoidHom.comp
    rep3

theorem det_rep3 (g : alternatingGroup (Fin 5)) : (rep3 g).det = 1 := by
  show ((rho3 (g : Perm (Fin 5))).toMatrix).det = 1
  rw [Mat3.det_toMatrix, det_rho3 _ (mem_A5finset.2 g.2)]

/-- The representation is faithful. -/
theorem rep3_injective : Function.Injective rep3 := by
  rw [injective_iff_map_eq_one]
  intro g hg
  have h1 : (rho3 (g : Perm (Fin 5))).toMatrix = (1 : Mat3).toMatrix := by
    rw [Mat3.toMatrix_one]; exact hg
  have h2 : rho3 (g : Perm (Fin 5)) = 1 := Mat3.toMatrix_injective h1
  exact Subtype.ext (rho3_eq_one _ (mem_A5finset.2 g.2) h2)

/-- The same representation, viewed as a homomorphism into `SL₃(ℤ[φ])`. -/
def rep3SL : alternatingGroup (Fin 5) →* Matrix.SpecialLinearGroup (Fin 3) Gold where
  toFun g := ⟨rep3 g, det_rep3 g⟩
  map_one' := Subtype.ext (map_one rep3)
  map_mul' g h := Subtype.ext (map_mul rep3 g h)

/-! ## 4. The characters -/

theorem trace_rep3 (c : Cls) : Matrix.trace (rep3 (repA c)) = (rho3 (rep c)).trace :=
  Mat3.trace_toMatrix _

theorem trace_rep3b (c : Cls) :
    Matrix.trace (rep3b (repA c)) = Gold.conj ((rho3 (rep c)).trace) := by
  show Matrix.trace (Gold.conj.mapMatrix (rep3 (repA c))) = _
  rw [← trace_rep3 c]
  simp [Matrix.trace, RingHom.mapMatrix_apply, Matrix.diag, map_sum]

/-- The trace of the representation at the five class representatives, in `ℤ[φ]`. -/
theorem trace_rho3_rep (c : Cls) :
    (rho3 (rep c)).trace =
      match c with
      | c1 => ⟨3, 0⟩ | c2 => ⟨-1, 0⟩ | c3 => ⟨0, 0⟩ | c5A => ⟨0, 1⟩ | c5B => ⟨1, -1⟩ := by
  cases c <;> decide

/-- **`χ₃` is the character of the explicit representation `rep3`.** -/
theorem chi3_eq_trace_rep3 (c : Cls) :
    chi3 c = Gold.evalPhi (Matrix.trace (rep3 (repA c))) := by
  rw [trace_rep3, trace_rho3_rep]
  cases c
  · norm_num [chi3, Gold.evalPhi_apply]
  · norm_num [chi3, Gold.evalPhi_apply]
  · norm_num [chi3, Gold.evalPhi_apply]
  · norm_num [chi3, Gold.evalPhi_apply]
  · have h := phi_add
    norm_num [chi3, Gold.evalPhi_apply]
    linarith

/-- **`χ₃′` is the character of the same representation, read through the other
embedding of `ℤ[φ]` into `ℝ`** (equivalently, of the Galois-conjugate
representation `rep3b`). -/
theorem chi3b_eq_trace_rep3 (c : Cls) :
    chi3b c = Gold.evalPhi' (Matrix.trace (rep3 (repA c))) := by
  rw [trace_rep3, trace_rho3_rep]
  cases c
  · norm_num [chi3b, Gold.evalPhi'_apply]
  · norm_num [chi3b, Gold.evalPhi'_apply]
  · norm_num [chi3b, Gold.evalPhi'_apply]
  · norm_num [chi3b, Gold.evalPhi'_apply]
  · have h := phi_add
    norm_num [chi3b, Gold.evalPhi'_apply]
    linarith

/-- **`χ₃′` is the character of the Galois-conjugate representation `rep3b`.** -/
theorem chi3b_eq_trace_rep3b (c : Cls) :
    chi3b c = Gold.evalPhi (Matrix.trace (rep3b (repA c))) := by
  rw [trace_rep3b, Gold.evalPhi_conj, ← trace_rep3, chi3b_eq_trace_rep3]

/-! ## 5. The entries really lie in `ℚ(√5)` -/

theorem Gold.evalPhi_mem_adjoin (z : Gold) :
    Gold.evalPhi z ∈ Algebra.adjoin ℚ ({Real.sqrt 5} : Set ℝ) := by
  have h5 : Real.sqrt 5 ∈ Algebra.adjoin ℚ ({Real.sqrt 5} : Set ℝ) :=
    Algebra.subset_adjoin rfl
  have hhalf : ((2 : ℝ))⁻¹ ∈ Algebra.adjoin ℚ ({Real.sqrt 5} : Set ℝ) := by
    have h : ((2 : ℝ))⁻¹ = algebraMap ℚ ℝ ((2 : ℚ)⁻¹) := by rw [map_inv₀]; norm_num
    rw [h]; exact Subalgebra.algebraMap_mem _ _
  have hphi : phi ∈ Algebra.adjoin ℚ ({Real.sqrt 5} : Set ℝ) := by
    have hval : phi = (1 + Real.sqrt 5) * ((2 : ℝ))⁻¹ := by
      show (1 + Real.sqrt 5) / 2 = _
      ring
    rw [hval]
    exact mul_mem (add_mem (one_mem _) h5) hhalf
  have ha : ((z.a : ℝ)) ∈ Algebra.adjoin ℚ ({Real.sqrt 5} : Set ℝ) := by
    have h : ((z.a : ℝ)) = algebraMap ℚ ℝ (z.a : ℚ) := (map_intCast (algebraMap ℚ ℝ) z.a).symm
    rw [h]; exact Subalgebra.algebraMap_mem _ _
  have hb : ((z.b : ℝ)) ∈ Algebra.adjoin ℚ ({Real.sqrt 5} : Set ℝ) := by
    have h : ((z.b : ℝ)) = algebraMap ℚ ℝ (z.b : ℚ) := (map_intCast (algebraMap ℚ ℝ) z.b).symm
    rw [h]; exact Subalgebra.algebraMap_mem _ _
  rw [Gold.evalPhi_apply]
  exact add_mem ha (mul_mem hb hphi)

/-- All the matrix entries of the representation lie in `ℚ(√5) ⊂ ℝ`. -/
theorem rep3_entries_mem_adjoin (g : alternatingGroup (Fin 5)) (i j : Fin 3) :
    Gold.evalPhi (rep3 g i j) ∈ Algebra.adjoin ℚ ({Real.sqrt 5} : Set ℝ) :=
  Gold.evalPhi_mem_adjoin _

end A5Artin
