/-
# q-Pochhammer Symbol

The q-Pochhammer symbol `(a;q)_n` is a fundamental building block in the theory of
q-series, mock theta functions, and modular forms. It appears throughout Zwegers'
thesis "Mock Theta Functions" (2002) as the basic notation for constructing
Ramanujan's mock theta functions and Appell-Lerch sums.

## Definition

For elements `a, q` in a commutative ring `R`, the q-Pochhammer symbol is defined as:
  `(a;q)_n = ∏_{k=0}^{n-1} (1 - a·q^k)`

## References

* S.P. Zwegers, "Mock Theta Functions", PhD thesis, Universiteit Utrecht, 2002.
  arXiv:0807.4834
-/

import Mathlib

open Finset BigOperators

variable {R : Type*} [CommRing R]

/-- The q-Pochhammer symbol `(a;q)_n = ∏_{k=0}^{n-1} (1 - a·q^k)`.
This is the standard notation in q-series theory, appearing throughout
Zwegers' thesis on mock theta functions. -/
noncomputable def qPochhammer (a q : R) (n : ℕ) : R :=
  ∏ k ∈ Finset.range n, (1 - a * q ^ k)

@[simp]
theorem qPochhammer_zero (a q : R) : qPochhammer a q 0 = 1 := by
  simp [qPochhammer]

theorem qPochhammer_succ (a q : R) (n : ℕ) :
    qPochhammer a q (n + 1) = qPochhammer a q n * (1 - a * q ^ n) := by
  exact Finset.prod_range_succ _ _

@[simp]
theorem qPochhammer_one (a q : R) : qPochhammer a q 1 = 1 - a := by
  -- The product over an empty set is 1.
  simp [qPochhammer]

/-
Product splitting: `(a;q)_{m+n} = (a;q)_m · (a·q^m;q)_n`.
This fundamental identity expresses how the q-Pochhammer symbol
decomposes over addition of indices.
-/
theorem qPochhammer_add (a q : R) (m n : ℕ) :
    qPochhammer a q (m + n) = qPochhammer a q m * qPochhammer (a * q ^ m) q n := by
  unfold qPochhammer;
  rw [ Finset.prod_range_add ];
  simp +decide only [pow_add, mul_assoc]

/-
Shift relation: `(a;q)_{n+1} = (1 - a) · (a·q;q)_n`.
This recurrence is used extensively in the theory of mock theta functions.
-/
theorem qPochhammer_succ_eq_mul_shift (a q : R) (n : ℕ) :
    qPochhammer a q (n + 1) = (1 - a) * qPochhammer (a * q) q n := by
  convert qPochhammer_add a q 1 n using 1;
  · rw [ add_comm ];
  · simp +decide [ qPochhammer_one ]

/-
When `a = 0`, the q-Pochhammer symbol equals 1.
-/
@[simp]
theorem qPochhammer_zero_left (q : R) (n : ℕ) : qPochhammer 0 q n = 1 := by
  exact Finset.prod_eq_one fun _ _ => by ring;

/-
When `q = 0` and `n ≥ 1`, the q-Pochhammer symbol equals `1 - a`.
-/
theorem qPochhammer_zero_right (a : R) {n : ℕ} (hn : 1 ≤ n) :
    qPochhammer a 0 n = 1 - a := by
  induction hn <;> simp_all +decide [ qPochhammer, Finset.prod_range_succ' ]

/-
The q-Pochhammer symbol at `a = 1` vanishes for `n ≥ 1`.
-/
theorem qPochhammer_one_left (q : R) {n : ℕ} (hn : 1 ≤ n) :
    qPochhammer 1 q n = 0 := by
  exact Finset.prod_eq_zero ( Finset.mem_range.mpr hn ) ( by simp +decide )

/-
Negation: `(-a;q)_n = ∏_{k=0}^{n-1} (1 + a·q^k)`.
-/
theorem qPochhammer_neg (a q : R) (n : ℕ) :
    qPochhammer (-a) q n = ∏ k ∈ Finset.range n, (1 + a * q ^ k) := by
  exact Finset.prod_congr rfl fun _ _ => by ring;