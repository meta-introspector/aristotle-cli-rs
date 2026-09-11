import Mathlib
/-!
# The q-Pochhammer Symbol
This file defines the q-Pochhammer symbol `(a; q)_n` and proves its basic algebraic
properties. The q-Pochhammer symbol is a fundamental building block in the theory of
q-series, basic hypergeometric functions, and mock theta functions.
## Main definitions
* `qPochhammer n a q` - The q-Pochhammer symbol `(a; q)_n = ∏_{k=0}^{n-1} (1 - a · q^k)`
## Main results
* `qPochhammer_succ` - Recurrence: `(a;q)_{n+1} = (a;q)_n · (1 - a·q^n)`
* `qPochhammer_split` - Splitting: `(a;q)_{m+n} = (a;q)_m · (a·q^m; q)_n`
* `qPochhammer_neg` - `(-a;q)_n = ∏_{k=0}^{n-1} (1 + a · q^k)`
## References
* S. P. Zwegers, "Mock Theta Functions", PhD thesis, Utrecht University, 2002.
  arXiv:0807.4834
* G. E. Andrews, "The Theory of Partitions", Cambridge University Press, 1998.
-/
open Finset
variable {R : Type*} [CommRing R]
/-- The q-Pochhammer symbol `(a; q)_n = ∏_{k=0}^{n-1} (1 - a · q^k)`.
This is one of the most fundamental objects in the theory of q-series.
It appears throughout Zwegers' thesis as a building block for mock theta functions
and Appell-Lerch sums. -/
def qPochhammer (n : ℕ) (a q : R) : R :=
  ∏ k ∈ range n, (1 - a * q ^ k)
@[simp]
theorem qPochhammer_zero (a q : R) : qPochhammer 0 a q = 1 := by
  simp [qPochhammer]
@[simp]
theorem qPochhammer_succ (n : ℕ) (a q : R) :
    qPochhammer (n + 1) a q = qPochhammer n a q * (1 - a * q ^ n) := by
  simp [qPochhammer, Finset.prod_range_succ]
theorem qPochhammer_one (a q : R) : qPochhammer 1 a q = 1 - a := by
  simp [qPochhammer]
theorem qPochhammer_two (a q : R) : qPochhammer 2 a q = (1 - a) * (1 - a * q) := by
  simp [qPochhammer, Finset.prod_range_succ]
/-
The splitting formula for the q-Pochhammer symbol:
`(a; q)_{m+n} = (a; q)_m · (a · q^m; q)_n`
This fundamental identity expresses how the q-Pochhammer symbol behaves
under addition of the index parameter.
-/
theorem qPochhammer_split (m n : ℕ) (a q : R) :
    qPochhammer (m + n) a q = qPochhammer m a q * qPochhammer n (a * q ^ m) q := by
  unfold qPochhammer;
  rw [ Finset.prod_range_add, Finset.prod_congr rfl ] ; ring;
  tauto
/-
The q-Pochhammer symbol with negated first argument gives products of (1 + aq^k):
`(-a; q)_n = ∏_{k=0}^{n-1} (1 + a · q^k)`
-/
theorem qPochhammer_neg (n : ℕ) (a q : R) :
    qPochhammer n (-a) q = ∏ k ∈ range n, (1 + a * q ^ k) := by
  exact Finset.prod_congr rfl fun _ _ => by ring;
/-
Specialization: `(q; q)_n = ∏_{k=1}^{n} (1 - q^{k+1})` expressed using range.
-/
theorem qPochhammer_self (n : ℕ) (q : R) :
    qPochhammer n q q = ∏ k ∈ range n, (1 - q ^ (k + 1)) := by
  exact Finset.prod_congr rfl fun _ _ => by ring;
/-
The q-Pochhammer symbol at a = 0 is 1.
-/
@[simp]
theorem qPochhammer_zero_left (n : ℕ) (q : R) : qPochhammer n 0 q = 1 := by
  exact Finset.prod_eq_one fun _ _ => by simp +decide ;
/-
The q-Pochhammer symbol at q = 0: `(a; 0)_n = (1-a)` for n ≥ 1.
-/
theorem qPochhammer_zero_right (n : ℕ) (a : R) (hn : 0 < n) :
    qPochhammer n a 0 = 1 - a := by
  unfold qPochhammer;
  cases n <;> simp_all +decide [ Finset.prod_range_succ' ]
/-
`(1; q)_n = 0` for n ≥ 1.
-/
theorem qPochhammer_one_left (n : ℕ) (q : R) (hn : 0 < n) :
    qPochhammer n 1 q = 0 := by
  exact Finset.prod_eq_zero ( Finset.mem_range.mpr hn ) ( by simp +decide )
