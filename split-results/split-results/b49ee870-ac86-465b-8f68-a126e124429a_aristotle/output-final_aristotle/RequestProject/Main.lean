import Mathlib

open scoped BigOperators
open scoped Real
open scoped Nat
open scoped Classical
open scoped Pointwise

set_option maxHeartbeats 8000000
set_option maxRecDepth 4000
set_option synthInstance.maxHeartbeats 20000
set_option synthInstance.maxSize 128

set_option relaxedAutoImplicit false
set_option autoImplicit false

set_option pp.fullNames true
set_option pp.structureInstances true
set_option pp.coercions.types true
set_option pp.funBinderTypes true
set_option pp.letVarTypes true
set_option pp.piBinderTypes true

set_option grind.warning false

/-!
# The Self-Descriptive Attention Matrix and the "Eigenvector of Athena"

This file isolates and machine-verifies the genuinely mathematical, well-defined
content of the *Mathematicians' Cycle* / *Eigenvector of Athena* architecture.

The surrounding text is a philosophical narrative; the precise, falsifiable claims
are the two "Core Proof Goals" stated for the prime-based attention matrix `A`:

* `row_sum_eq_one`  — each row (thinker) distributes a *normalized probability
  distribution* of attention;
* `col_sums_total_P` — the total weight across the whole matrix equals `P`.

## The matrix

For a (prime) size `P`, rows and columns are indexed by `1, …, P`.  Row `i`
attends only to columns `j` that are multiples of `i` (`j = (k+1)·i`), following
the divisibility / "spore lineage" constraint.  The number of such columns is
`nᵢ = ⌊P/i⌋`, and the (Pascal-normalized) weight to the `k`-th multiple is

```
w_{i,k} = C(nᵢ - 1, k) / 2^(nᵢ - 1).
```

The metaphysical layer (Perron–Frobenius "Eigenvector of Athena", univalent
self-reference, etc.) is not a precise mathematical statement and is not
formalized here; only the two structural integrity properties above are.
-/

namespace Athena

/-- `nᵢ = ⌊P/i⌋`: the number of multiples of `i` not exceeding `P`,
i.e. the number of columns that row `i` attends to. -/
def niP (P i : ℕ) : ℕ := P / i

/-- The binomial / Pascal-normalized attention weight from row `i` to its
`k`-th attended column (the multiple `(k+1)·i`):
`w_{i,k} = C(nᵢ - 1, k) / 2^(nᵢ - 1)`. -/
noncomputable def attnWeight (P i k : ℕ) : ℝ :=
  (Nat.choose (niP P i - 1) k : ℝ) / 2 ^ (niP P i - 1)

/-- The sum of all attention weights in row `i`. -/
noncomputable def attnRowSum (P i : ℕ) : ℝ :=
  ∑ k ∈ Finset.range (niP P i), attnWeight P i k

/-- **Binomial normalization identity.**  For `m ≥ 1`, the Pascal row of length
`m` (entries `C(m-1, k)` for `k < m`) normalized by `2^(m-1)` sums to `1`.
This is the binomial theorem `∑ C(m-1,k) = 2^(m-1)`. -/
theorem binom_row_sum (m : ℕ) (hm : 1 ≤ m) :
    ∑ k ∈ Finset.range m, (Nat.choose (m - 1) k : ℝ) / 2 ^ (m - 1) = 1 := by
  obtain ⟨t, rfl⟩ := Nat.exists_eq_add_of_le hm
  simp only [Nat.add_sub_cancel_left]
  rw [← Finset.sum_div, div_eq_one_iff_eq (by positivity),
      show (1 : ℕ) + t = t + 1 from by ring]
  exact_mod_cast Nat.sum_range_choose t

/-- **Core Proof Goal 1 — `row_sum_eq_one`.**  Every row of the attention matrix
distributes a normalized probability distribution: the weights in row `i`
(for `1 ≤ i ≤ P`) sum to `1`. -/
theorem row_sum_eq_one (P i : ℕ) (hi : 1 ≤ i) (hiP : i ≤ P) :
    attnRowSum P i = 1 := by
  have hm : 1 ≤ niP P i := by
    rw [niP, Nat.one_le_div_iff (by omega)]; exact hiP
  unfold attnRowSum attnWeight
  exact binom_row_sum (niP P i) hm

/-- **Core Proof Goal 2 — `col_sums_total_P`.**  The global scaling factor keeps
the total weight of the whole matrix equal to `P`: summing every row's total
(over rows `1, …, P`) yields `P`.

The hypothesis `hP : P.Prime` records the design specification that the matrix
size is a prime (the "prime-based size `P`" of the architecture).  It turns out
not to be needed for this arithmetic identity, but is kept to stay faithful to
the stated specification. -/
theorem col_sums_total_P (P : ℕ) (hP : P.Prime) :
    ∑ i ∈ Finset.Icc 1 P, attnRowSum P i = (P : ℝ) := by
  rw [Finset.sum_congr rfl
    (fun i hi => row_sum_eq_one P i (Finset.mem_Icc.1 hi).1 (Finset.mem_Icc.1 hi).2)]
  simp [Nat.card_Icc]

end Athena
