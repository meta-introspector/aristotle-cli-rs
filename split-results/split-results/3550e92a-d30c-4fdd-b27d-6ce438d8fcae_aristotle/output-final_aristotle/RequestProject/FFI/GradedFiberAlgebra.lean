/-
Copyright (c) 2023 Sina Hazratpour. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Sina Hazratpour, Aristotle (Harmonic)
-/
import Mathlib
import RequestProject.Fiber

/-!
# A computable graded algebra of fibers, with a C FFI surface

This module exposes a small, *computable* model of a **graded algebra of fibers** and wraps it in a
C-callable FFI surface (via `@[export]`) so that it can be driven from other languages.  The
companion Rust trait (`ffi/rust/`) and C++ template (`ffi/cpp/`) are thin wrappers around the
symbols exported here.

## The mathematics

Fix the *grading monoid* `ℕ`.  A homogeneous basis element ("monomial") of degree `n` is a pair
`(n, c) : ℕ × ℤ` recording its degree `n` and its coefficient `c`.  The **degree projection**

```
deg : ℕ × ℤ → ℕ,   deg (n, c) = n
```

has, over each `n : ℕ`, the *fiber* `Fiber deg n` (in the sense of `RequestProject.Fiber`) of all
degree-`n` monomials.  The graded algebra `A = ⊕ₙ Aₙ` is the polynomial algebra `ℤ[x]`, where the
`n`-th graded piece `Aₙ` is exactly the fiber `Fiber deg n`, and multiplication is *graded*:

```
Aᵢ × Aⱼ → Aᵢ₊ⱼ,   (xⁱ·a) · (xʲ·b) = xⁱ⁺ʲ·(a·b).
```

Computationally we represent an element of `A` by its array of coefficients
(`coeff a n = a[n]`, padded with zeros), so that all the operations are executable and can be
compiled to native code behind the FFI.

## Main definitions

* `GradedFiberAlgebra.Mono`, `GradedFiberAlgebra.deg`, `GradedFiberAlgebra.Graded n` — the
  monomials, the degree projection, and the `n`-th graded piece realised as `Fiber deg n`.
* `GradedFiberAlgebra.Elem` — the computable representation of an algebra element.
* `GradedFiberAlgebra.coeff`, `zero`, `one`, `monomial`, `add`, `mul`, `grade` — the operations.
* `GradedFiberAlgebra.homComponent` — the degree-`n` homogeneous component of an element as an
  honest element of the fiber `Graded n`.

## Main results

* `coeff_add`, `coeff_monomial_self`, `coeff_monomial_ne`, `coeff_mul` — correctness of the
  operations at the level of coefficients.
* `graded_mul` — the **graded multiplication law**: the product of a degree-`i` monomial and a
  degree-`j` monomial is the degree-`(i+j)` monomial with the product coefficient.  This is the
  statement that multiplication respects the fiber grading.

## FFI surface

The `@[export]` declarations at the end (`rp_gfa_*`) give a stable C ABI:

* handles are boxed Lean values (`lean_object *`) holding the coefficient array;
* coefficients are passed/returned as `int64_t` and degrees as `size_t`.
-/

namespace GradedFiberAlgebra

open CategoryTheory Finset

/-! ### The grading by fibers of the degree map -/

/-- A homogeneous basis element ("monomial"): its degree together with its coefficient. -/
abbrev Mono := ℕ × ℤ

/-- The degree projection on monomials. -/
def deg : Mono → ℕ := Prod.fst

/-- The `n`-th graded piece, realised as the fiber of the degree projection over `n`.
An element of `Graded n` is a degree-`n` monomial. -/
abbrev Graded (n : ℕ) := Fiber deg n

/-- The degree-`n` monomial with coefficient `c`, as an element of the fiber `Graded n`. -/
def gradedMono (n : ℕ) (c : ℤ) : Graded n := ⟨(n, c), rfl⟩

@[simp] lemma deg_gradedMono (n : ℕ) (c : ℤ) : deg (gradedMono n c).1 = n := rfl

/-! ### The computable representation and its operations -/

/-- The computable representation of an algebra element: the array of its coefficients, indexed by
degree (and implicitly padded with zeros beyond its length). -/
abbrev Elem := Array Int

/-- The coefficient of `a` at degree `n` (zero beyond the stored length). -/
def coeff (a : Elem) (n : Nat) : Int := a[n]?.getD 0

/-- The zero element. -/
def zero : Elem := #[]

/-- The multiplicative unit `1` (the degree-`0` monomial with coefficient `1`). -/
def one : Elem := #[1]

/-- The monomial `c · xⁿ`. -/
def monomial (n : Nat) (c : Int) : Elem := (Array.replicate n (0 : Int)).push c

/-- Addition of two elements. -/
def add (a b : Elem) : Elem :=
  (Array.range (max a.size b.size)).map (fun i => coeff a i + coeff b i)

/-- The convolution coefficient of a product at degree `k`. -/
def mulCoeff (a b : Elem) (k : Nat) : Int :=
  ∑ i ∈ Finset.range (k + 1), coeff a i * coeff b (k - i)

/-- Graded multiplication (convolution of coefficients). -/
def mul (a b : Elem) : Elem :=
  if a.size = 0 ∨ b.size = 0 then #[]
  else (Array.range (a.size + b.size - 1)).map (mulCoeff a b)

/-- The degree-`n` homogeneous component of `a`, as a computable element. -/
def grade (a : Elem) (n : Nat) : Elem := monomial n (coeff a n)

/-- Structural equality test on the stored coefficient arrays. -/
def beq (a b : Elem) : Bool := a == b

/-! ### Correctness of the operations -/

@[simp] lemma coeff_zero (n : Nat) : coeff zero n = 0 := by
  simp [coeff, zero]

@[simp] lemma coeff_add (a b : Elem) (n : Nat) :
    coeff (add a b) n = coeff a n + coeff b n := by
  unfold coeff add
  by_cases hn : n < max a.size b.size <;> simp_all +decide
  rfl

@[simp] lemma coeff_monomial_self (n : Nat) (c : Int) :
    coeff (monomial n c) n = c := by
  unfold coeff monomial;
  simp +decide [ Array.push ]

lemma coeff_monomial_ne {n k : Nat} (c : Int) (h : k ≠ n) :
    coeff (monomial n c) k = 0 := by
  grind +locals

/-- The coefficient of a product is the convolution of the coefficients. -/
lemma coeff_mul (a b : Elem) (k : Nat) :
    coeff (mul a b) k = ∑ i ∈ Finset.range (k + 1), coeff a i * coeff b (k - i) := by
  by_cases h : a.size = 0 ∨ b.size = 0 <;> simp_all +decide [ mul ];
  · cases h <;> simp_all +decide [ coeff ];
  · by_cases hk : k < a.size + b.size - 1 <;> simp_all +decide [ coeff ];
    · rfl;
    · rw [ Finset.sum_eq_zero ];
      grind

/-- The degree-`n` homogeneous component of `a`, as an honest element of the fiber `Graded n`. -/
def homComponent (a : Elem) (n : Nat) : Graded n := gradedMono n (coeff a n)

@[simp] lemma homComponent_coeff (a : Elem) (n : Nat) :
    (homComponent a n).1 = (n, coeff a n) := rfl

/-- The **graded multiplication law**: the product of the degree-`i` monomial with coefficient `a`
and the degree-`j` monomial with coefficient `b` is the degree-`(i+j)` monomial with coefficient
`a * b`.  Equivalently, multiplication carries `Graded i × Graded j` into `Graded (i + j)`. -/
theorem graded_mul (i j : Nat) (a b : Int) :
    coeff (mul (monomial i a) (monomial j b)) (i + j) = a * b := by
  rw [coeff_mul]
  rw [Finset.sum_eq_single i] <;> simp +contextual [coeff_monomial_self, coeff_monomial_ne]

/-- Off the total degree `i + j`, the product of two monomials vanishes: multiplication is
homogeneous of degree `i + j`. -/
theorem graded_mul_ne (i j : Nat) (a b : Int) {k : Nat} (hk : k ≠ i + j) :
    coeff (mul (monomial i a) (monomial j b)) k = 0 := by
  rw [ coeff_mul ];
  refine Finset.sum_eq_zero fun x hx => ?_;
  by_cases hi : x = i <;> by_cases hj : k - x = j <;> simp_all +decide [ coeff_monomial_ne ];
  omega

/-! ### FFI surface

These `@[export]` declarations give a stable C ABI.  Handles (`Elem`) are boxed Lean objects
(`lean_object *`); coefficients are `int64_t`; degrees and lengths are `size_t`. -/

/-- FFI: the zero element. -/
@[export rp_gfa_zero]
def ffiZero (_ : Unit) : Elem := zero

/-- FFI: the unit element. -/
@[export rp_gfa_one]
def ffiOne (_ : Unit) : Elem := one

/-- FFI: the monomial `c · xⁿ`. -/
@[export rp_gfa_monomial]
def ffiMonomial (n : USize) (c : Int64) : Elem := monomial n.toNat c.toInt

/-- FFI: addition. -/
@[export rp_gfa_add]
def ffiAdd (a b : Elem) : Elem := add a b

/-- FFI: graded multiplication. -/
@[export rp_gfa_mul]
def ffiMul (a b : Elem) : Elem := mul a b

/-- FFI: the degree-`n` homogeneous component. -/
@[export rp_gfa_grade]
def ffiGrade (a : Elem) (n : USize) : Elem := grade a n.toNat

/-- FFI: the coefficient at degree `n`. -/
@[export rp_gfa_coeff]
def ffiCoeff (a : Elem) (n : USize) : Int64 := (coeff a n.toNat).toInt64

/-- FFI: the number of stored coefficients (an upper bound on the degree). -/
@[export rp_gfa_size]
def ffiSize (a : Elem) : USize := USize.ofNat a.size

/-- FFI: structural equality of two handles. -/
@[export rp_gfa_eq]
def ffiEq (a b : Elem) : Bool := beq a b

end GradedFiberAlgebra