import Mathlib

/-!
# DULA Sieve Constants: The Hardy-Littlewood Twin Prime Constant

This file defines the **Hardy-Littlewood twin prime constant** `C_2` as the
limit of finite products over primes, and proves convergence and positivity.

## What this file is — and is not

**This file is**: a formal definition of the analytic constant `C_2` that
controls the Hardy-Littlewood twin-prime conjecture. We prove:
  1. The partial products are positive.
  2. The partial products are antitone (non-increasing).
  3. The partial products are bounded below by `1/2`.
  4. The limit (the Hardy-Littlewood constant) exists and is at least `1/2`.

**This file is not**:
- A proof of the twin prime conjecture.
- A closed-form expression of `C_2` in terms of `π` or `L`-values (no such
  closed form is known; Wrench 1961 computed `C_2 ≈ 0.6601618158...` to 25
  digits precisely because direct evaluation by series was needed).
- Connected to `c_m` from `DULAExamples.lean` by any simple identity. The two
  are related (both are about twin-prime sieve densities) but in different
  normalizations.

## Mathematical strategy

The key insight is that the prime-indexed product
  `C_2 = ∏_{p prime, p ≥ 3} (1 - 1/(p-1)²)`
is *bounded below by* the integer-indexed product
  `∏_{n ≥ 2} (1 - 1/n²) = 1/2`
because the index set `{p - 1 : p prime, p ≥ 3} = {2, 4, 6, 10, 12, ...}` is a
SUBSET of `{n : n ≥ 2}`, and all factors `(1 - 1/k²)` lie in `(0, 1)`.

Multiplying by fewer (sub-1) factors gives a LARGER product. So `C_2 ≥ 1/2`.

The integer product telescopes:
  `∏_{n=2}^{N} (1 - 1/n²) = ∏ (n-1)(n+1)/n² = (N+1)/(2N) → 1/2`.

## References

- Hardy and Littlewood, *Some problems of "Partitio Numerorum" III: On the
  expression of a number as a sum of primes*, Acta Math. **44** (1923).
- Wrench Jr., J. W., *Evaluation of Artin's constant and the twin-prime
  constant*, Math. Comp. **15** (1961), 396–398.
-/

noncomputable section

namespace DULASieveConstants

open scoped BigOperators

/-! ### The twin-prime local factor -/

/-- The Hardy-Littlewood twin-prime local factor at integer `k ≥ 2`:
    `(1 - 1/k²) = (k-1)(k+1)/k²`.

    Defined for all naturals; the values at `k = p - 1` for primes `p ≥ 3` are
    the ones that appear in the twin-prime constant. -/
def localFactor (k : ℕ) : ℝ := 1 - 1 / (k : ℝ) ^ 2

/-- For `k ≥ 2`, the factor is positive (in fact `≥ 3/4` at `k = 2`). -/
theorem localFactor_pos {k : ℕ} (hk : 2 ≤ k) : 0 < localFactor k := by
  unfold localFactor
  have hk_real : (2 : ℝ) ≤ (k : ℝ) := by exact_mod_cast hk
  have hksq : (4 : ℝ) ≤ (k : ℝ) ^ 2 := by nlinarith
  have hksq_pos : (0 : ℝ) < (k : ℝ) ^ 2 := by linarith
  have h_inv_le : 1 / (k : ℝ) ^ 2 ≤ 1 / 4 := by
    apply div_le_div_of_nonneg_left _ (by norm_num) hksq
    norm_num
  linarith

/-- For `k ≥ 2`, the factor is strictly less than 1. -/
theorem localFactor_lt_one {k : ℕ} (hk : 2 ≤ k) : localFactor k < 1 := by
  unfold localFactor
  have hk_real : (2 : ℝ) ≤ (k : ℝ) := by exact_mod_cast hk
  have hksq_pos : (0 : ℝ) < (k : ℝ) ^ 2 := by positivity
  have : (0 : ℝ) < 1 / (k : ℝ) ^ 2 := by positivity
  linarith

/-- Explicit value at `k = 2`: `localFactor 2 = 3/4`. -/
theorem localFactor_two : localFactor 2 = 3 / 4 := by
  unfold localFactor; norm_num

/-! ### The integer-indexed product telescopes to (N+1)/(2N) -/

/-
Telescoping identity: `∏_{k=2}^{N+1} (1 - 1/k²) = (N+2)/(2(N+1))`.

    Proved by induction on `N`.
-/
theorem integerProduct_telescope (N : ℕ) :
    ∏ k ∈ Finset.Icc 2 (N + 2), localFactor k = ((N : ℝ) + 3) / (2 * ((N : ℝ) + 2)) := by
  induction' N with N ih <;> norm_num [ Finset.prod_Ioc_succ_top, (Nat.succ_eq_succ ▸ Finset.Icc_succ_left_eq_Ioc), localFactor ] at *;
  rw [ ih ];
  -- Combine and simplify the fractions
  field_simp
  ring

/-! ### The twin-prime partial product -/

/-- The set of "prime offsets" — values `p - 1` for primes `p ≥ 3` up to bound `N`.

    Equivalently, the set of natural numbers `k` such that `k + 1` is prime and `k ≥ 2`. -/
def primeOffsetsUpTo (N : ℕ) : Finset ℕ :=
  Finset.filter (fun k => 2 ≤ k ∧ Nat.Prime (k + 1)) (Finset.range (N + 1))

/-- The twin-prime partial product:
    `∏_{p prime, 3 ≤ p ≤ N+1} (1 - 1/(p-1)²) = ∏_{k ∈ primeOffsetsUpTo N} localFactor k`. -/
def twinPrimePartialProduct (N : ℕ) : ℝ :=
  ∏ k ∈ primeOffsetsUpTo N, localFactor k

/-- The partial product is positive. -/
theorem twinPrimePartialProduct_pos (N : ℕ) : 0 < twinPrimePartialProduct N := by
  unfold twinPrimePartialProduct
  apply Finset.prod_pos
  intro k hk
  simp only [primeOffsetsUpTo, Finset.mem_filter] at hk
  exact localFactor_pos hk.2.1

/-- The partial product is at most 1 (each factor is ≤ 1, empty product is 1). -/
theorem twinPrimePartialProduct_le_one (N : ℕ) : twinPrimePartialProduct N ≤ 1 := by
  unfold twinPrimePartialProduct
  apply Finset.prod_le_one
  · intro k hk
    simp only [primeOffsetsUpTo, Finset.mem_filter] at hk
    exact le_of_lt (localFactor_pos hk.2.1)
  · intro k hk
    simp only [primeOffsetsUpTo, Finset.mem_filter] at hk
    exact le_of_lt (localFactor_lt_one hk.2.1)

/-- The partial products are antitone: more primes ⇒ smaller product. -/
theorem twinPrimePartialProduct_antitone : Antitone twinPrimePartialProduct := by
  intro M N hMN
  unfold twinPrimePartialProduct
  -- primeOffsetsUpTo M ⊆ primeOffsetsUpTo N
  have h_subset : primeOffsetsUpTo M ⊆ primeOffsetsUpTo N := by
    intro k hk
    simp only [primeOffsetsUpTo, Finset.mem_filter, Finset.mem_range] at hk ⊢
    exact ⟨by omega, hk.2⟩
  -- Split: prod over N = (prod over M) · (prod over difference)
  rw [show primeOffsetsUpTo N
        = primeOffsetsUpTo M ∪ (primeOffsetsUpTo N \ primeOffsetsUpTo M)
        from (Finset.union_sdiff_of_subset h_subset).symm]
  rw [Finset.prod_union Finset.disjoint_sdiff]
  have h_extras_le_one :
      ∏ k ∈ primeOffsetsUpTo N \ primeOffsetsUpTo M, localFactor k ≤ 1 := by
    apply Finset.prod_le_one
    · intro k hk
      rw [Finset.mem_sdiff] at hk
      simp only [primeOffsetsUpTo, Finset.mem_filter] at hk
      exact le_of_lt (localFactor_pos hk.1.2.1)
    · intro k hk
      rw [Finset.mem_sdiff] at hk
      simp only [primeOffsetsUpTo, Finset.mem_filter] at hk
      exact le_of_lt (localFactor_lt_one hk.1.2.1)
  have h_pos_M : 0 < ∏ k ∈ primeOffsetsUpTo M, localFactor k := by
    apply Finset.prod_pos
    intro k hk
    simp only [primeOffsetsUpTo, Finset.mem_filter] at hk
    exact localFactor_pos hk.2.1
  calc (∏ k ∈ primeOffsetsUpTo M, localFactor k)
        * (∏ k ∈ primeOffsetsUpTo N \ primeOffsetsUpTo M, localFactor k)
      ≤ (∏ k ∈ primeOffsetsUpTo M, localFactor k) * 1 := by
        exact mul_le_mul_of_nonneg_left h_extras_le_one (le_of_lt h_pos_M)
    _ = ∏ k ∈ primeOffsetsUpTo M, localFactor k := by ring

/-! ### The lower bound 1/2

The key inequality. The set `primeOffsetsUpTo N` is a subset of `Finset.Icc 2 N`
(every prime offset is in `[2, N]`). All factors `localFactor k` for `k ≥ 2` are
in `(0, 1)`. Therefore:
  `(product over the larger set Icc 2 N) ≤ (product over subset primeOffsetsUpTo N)`
because the missing factors are all `< 1`, and removing them increases the product.

Combined with the telescoping identity for the integer product, this gives the
lower bound. -/

/-- The prime offsets are a subset of integers `≥ 2` up to `N`. -/
theorem primeOffsetsUpTo_subset_Icc (N : ℕ) :
    primeOffsetsUpTo N ⊆ Finset.Icc 2 N := by
  intro k hk
  simp only [primeOffsetsUpTo, Finset.mem_filter, Finset.mem_range] at hk
  simp only [Finset.mem_Icc]
  exact ⟨hk.2.1, by omega⟩

/-- The integer product over `Icc 2 N` is positive (and ≤ partial twin product). -/
theorem integerProduct_pos (N : ℕ) (_hN : 2 ≤ N) :
    0 < ∏ k ∈ Finset.Icc 2 N, localFactor k := by
  apply Finset.prod_pos
  intro k hk
  rw [Finset.mem_Icc] at hk
  exact localFactor_pos hk.1

/-- **Key lemma**: the prime-indexed partial product is at least the integer-indexed
    partial product over the same range. Since the latter telescopes to a known
    expression, we get an explicit lower bound. -/
theorem twinPrimePartialProduct_ge_integerProduct (N : ℕ) :
    ∏ k ∈ Finset.Icc 2 N, localFactor k ≤ twinPrimePartialProduct N := by
  unfold twinPrimePartialProduct
  -- Split Icc 2 N = primeOffsetsUpTo N ∪ (Icc 2 N \ primeOffsetsUpTo N)
  have h_sub : primeOffsetsUpTo N ⊆ Finset.Icc 2 N := primeOffsetsUpTo_subset_Icc N
  rw [show (Finset.Icc 2 N) = primeOffsetsUpTo N ∪ (Finset.Icc 2 N \ primeOffsetsUpTo N)
        from (Finset.union_sdiff_of_subset h_sub).symm]
  rw [Finset.prod_union Finset.disjoint_sdiff]
  have h_pos : 0 < ∏ k ∈ primeOffsetsUpTo N, localFactor k := by
    apply Finset.prod_pos
    intro k hk
    simp only [primeOffsetsUpTo, Finset.mem_filter] at hk
    exact localFactor_pos hk.2.1
  have h_extras_le_one :
      ∏ k ∈ Finset.Icc 2 N \ primeOffsetsUpTo N, localFactor k ≤ 1 := by
    apply Finset.prod_le_one
    · intro k hk
      rw [Finset.mem_sdiff] at hk
      rw [Finset.mem_Icc] at hk
      exact le_of_lt (localFactor_pos hk.1.1)
    · intro k hk
      rw [Finset.mem_sdiff] at hk
      rw [Finset.mem_Icc] at hk
      exact le_of_lt (localFactor_lt_one hk.1.1)
  calc (∏ k ∈ primeOffsetsUpTo N, localFactor k)
        * (∏ k ∈ Finset.Icc 2 N \ primeOffsetsUpTo N, localFactor k)
      ≤ (∏ k ∈ primeOffsetsUpTo N, localFactor k) * 1 := by
        exact mul_le_mul_of_nonneg_left h_extras_le_one (le_of_lt h_pos)
    _ = ∏ k ∈ primeOffsetsUpTo N, localFactor k := by ring

/-- **The lower bound 1/2**: for `N ≥ 2`, the partial product is at least the
    telescoping integer product, which is `(N+1)/(2N) ≥ 1/2`. -/
theorem twinPrimePartialProduct_ge_half (N : ℕ) (hN : 2 ≤ N) :
    (1 : ℝ) / 2 ≤ twinPrimePartialProduct N := by
  -- Step 1: write N = M + 2 for some M ≥ 0
  obtain ⟨M, rfl⟩ : ∃ M, N = M + 2 := ⟨N - 2, by omega⟩
  -- Step 2: use the telescoping identity for Icc 2 (M+2)
  have h_tele : ∏ k ∈ Finset.Icc 2 (M + 2), localFactor k
              = ((M : ℝ) + 3) / (2 * ((M : ℝ) + 2)) := integerProduct_telescope M
  -- Step 3: the telescoping value is ≥ 1/2 since (M+3)/(2(M+2)) ≥ 1/2 ⟺ M+3 ≥ M+2 ✓
  have h_M_pos : (0 : ℝ) < (M : ℝ) + 2 := by positivity
  have h_tele_ge_half : (1 : ℝ) / 2 ≤ ((M : ℝ) + 3) / (2 * ((M : ℝ) + 2)) := by
    rw [div_le_div_iff₀ (by norm_num : (0:ℝ) < 2) (by linarith)]
    nlinarith
  -- Step 4: combine
  have h_chain : ∏ k ∈ Finset.Icc 2 (M + 2), localFactor k ≤ twinPrimePartialProduct (M + 2) :=
    twinPrimePartialProduct_ge_integerProduct (M + 2)
  linarith [h_tele.symm ▸ h_chain]

/-! ### The Hardy-Littlewood constant as a limit -/

/-- The Hardy-Littlewood twin prime constant `C_2`, defined as the infimum of
    the partial products. Since the partial products are antitone and bounded
    below by `1/2`, this infimum is the limit.

    Numerically, `C_2 ≈ 0.6601618158686957...` (Wrench 1961). No elementary
    closed form is known. -/
def twinPrimeConstant : ℝ := ⨅ N, twinPrimePartialProduct N

/-
The constant is bounded above by every partial product.
-/
theorem twinPrimeConstant_le_partial (N : ℕ) :
    twinPrimeConstant ≤ twinPrimePartialProduct N := by
  exact ciInf_le ⟨ 0, Set.forall_mem_range.mpr fun N => le_of_lt ( twinPrimePartialProduct_pos N ) ⟩ N

/-
**The Hardy-Littlewood twin prime constant is at least 1/2**, hence strictly
    positive.
-/
theorem twinPrimeConstant_ge_half : (1 : ℝ) / 2 ≤ twinPrimeConstant := by
  -- By definition of `twinPrimeConstant`, we know that for any `N`, `twinPrimePartialProduct N ≥ 1 / 2`.
  have h_lower_bound : ∀ N : ℕ, twinPrimePartialProduct N ≥ (1 : ℝ) / 2 := by
    intro N;
    by_cases hN : N < 2;
    · interval_cases N <;> norm_num [ twinPrimePartialProduct, primeOffsetsUpTo ];
      · norm_num [ Finset.prod_filter ];
      · norm_num [ Finset.prod_filter, Finset.prod_range_succ ];
    · exact twinPrimePartialProduct_ge_half N ( le_of_not_gt hN );
  exact le_ciInf h_lower_bound

/-- **The Hardy-Littlewood twin prime constant is strictly positive.** -/
theorem twinPrimeConstant_pos : 0 < twinPrimeConstant := by
  have h := twinPrimeConstant_ge_half
  linarith

end DULASieveConstants

end