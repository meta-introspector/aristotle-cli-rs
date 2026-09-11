import Mathlib

open scoped BigOperators
open Finset Nat Real

set_option maxHeartbeats 800000

/-!
# Adelic Valuation Framework: Lean Formalization

This file formalizes the key mathematical theorems underlying the Adelic Valuation
Field Theory (AVFT) approach to approximating the Gamma function via products over primes.

## Main results

1. **Gamma-Factorial correspondence** (`gamma_factorial_correspondence`):
   The Gamma function at positive integers equals the factorial.

2. **Legendre's formula** (`legendre_formula`):
   The p-adic valuation of n! equals Σ_{i=1}^{b-1} ⌊n/p^i⌋.

3. **p-adic ultrametric inequality** (`padic_ultrametric`):
   The p-adic norm satisfies |x + y|_p ≤ max(|x|_p, |y|_p).

4. **Fundamental theorem of arithmetic** (`factorial_prime_factorization`):
   Every positive natural number equals the product of its prime power factors.

5. **Multiplicativity of p-adic norm** (`padic_norm_multiplicative`):
   The p-adic norm is multiplicative: |xy|_p = |x|_p · |y|_p.

6. **p-adic valuation of products** (`padic_val_factorial_bound`):
   Upper bound on the p-adic valuation of n!.

7. **Gamma positivity** (`gamma_pos_of_pos`):
   Γ(s) > 0 for s > 0.

8. **Geometric series bound** (`geometric_sum_bound`):
   Partial geometric sums are bounded by 1/(1-r).

9. **Stirling-type bounds** (`factorial_ge_self`, `factorial_exponential_lower_bound`):
   Growth estimates for n!.

10. **Log Gamma properties** (`log_gamma_add_one`, `gamma_functional_eq`):
    Functional equation and log properties of Γ.
-/

section GammaFactorial

/-- The Gamma function at positive integers equals the factorial:
    Γ(n + 1) = n! This is the bridge between the analytic Gamma function
    and the combinatorial factorial that the AVFT solver exploits. -/
theorem gamma_factorial_correspondence (n : ℕ) :
    Real.Gamma (↑n + 1) = ↑(n.factorial) :=
  Real.Gamma_nat_eq_factorial n

/-- The Gamma function is positive for positive real arguments.
    This ensures that log Γ(z) is well-defined for z > 0,
    which is essential for the energy functional in the AVFT solver. -/
theorem gamma_pos_of_pos {s : ℝ} (hs : 0 < s) :
    0 < Real.Gamma s :=
  Real.Gamma_pos_of_pos hs

/-- The Gamma function satisfies the functional equation Γ(s+1) = s·Γ(s) for s ≠ 0.
    This recurrence is the continuous analogue of (n+1)! = (n+1)·n!
    and governs how log Γ changes when z shifts by 1. -/
theorem gamma_functional_eq {s : ℝ} (hs : s ≠ 0) :
    Real.Gamma (s + 1) = s * Real.Gamma s :=
  Real.Gamma_add_one hs

/-- The Gamma function at 1 equals 1: Γ(1) = 1.
    This is the base case for the factorial recurrence. -/
theorem gamma_one : Real.Gamma 1 = 1 :=
  Real.Gamma_one

end GammaFactorial

section PAdicValuation

/-- Legendre's formula: the p-adic valuation of n! equals the sum
    Σ_{i=1}^{b-1} ⌊n/p^i⌋, where b is any bound exceeding log_p(n).
    This formula is the discrete analogue of the adelic local factors
    F_p(z) used in the AVFT energy functional. -/
theorem legendre_formula {p n b : ℕ} [hp : Fact (Nat.Prime p)]
    (hnb : Nat.log p n < b) :
    padicValNat p n.factorial = ∑ i ∈ Finset.Ico 1 b, n / p ^ i :=
  padicValNat_factorial hnb

/-- Upper bound on p-adic valuation of factorial: v_p(n!) ≤ n/(p-1).
    This bound ensures that the prime factorization of n! is "controlled"
    and justifies the finite approximation used in the AVFT solver. -/
theorem padic_val_factorial_bound {p n : ℕ} [hp : Fact (Nat.Prime p)] :
    padicValNat p n.factorial ≤ n / (p - 1) := by
  have h_legendre : padicValNat p n.factorial =
      ∑ i ∈ Finset.Ico 1 (Nat.log p n + 1), n / p ^ i := by
    rw [padicValNat_factorial]; grind
  have h_sum_bound : ∑ i ∈ Finset.Ico 1 (Nat.log p n + 1), n / p ^ i ≤
      n * (∑ i ∈ Finset.Ico 1 (Nat.log p n + 1), (1 / p ^ i : ℝ)) := by
    push_cast [Finset.mul_sum _ _ _]
    exact Finset.sum_le_sum fun i _hi => by
      rw [mul_one_div, le_div_iff₀ (pow_pos (Nat.cast_pos.mpr hp.1.pos) _)]
      norm_cast; linarith [Nat.div_mul_le_self n (p ^ i)]
  have h_geo_series : ∑ i ∈ Finset.Ico 1 (Nat.log p n + 1), (1 / p ^ i : ℝ) =
      (1 - (1 / p ^ (Nat.log p n) : ℝ)) / (p - 1) := by
    induction' Nat.log p n with k ih <;>
      simp_all +decide [Finset.sum_Ico_succ_top]
    rw [div_add'] <;> ring_nf
    · have hp1 : (p : ℝ) > 1 := Nat.one_lt_cast.mpr hp.1.one_lt
      have hpne : (p : ℝ) ≠ 0 := by positivity
      field_simp
      ring
    · linarith [show (p : ℝ) > 1 from Nat.one_lt_cast.mpr hp.1.one_lt]
  rw [Nat.le_div_iff_mul_le]
  · rcases p with (_ | _ | p) <;> simp_all +decide
    rw [← @Nat.cast_le ℝ]; push_cast
    rw [mul_div, le_div_iff₀] at * <;>
      nlinarith [inv_pos.mpr
        (by positivity : 0 < (p + 1 + 1 : ℝ) ^ Nat.log (p + 1 + 1) n)]
  · exact Nat.sub_pos_of_lt hp.1.one_lt

/-- The p-adic valuation of a prime power: v_p(p^k) = k.
    This is essential for understanding how the energy functional
    decomposes across prime powers. -/
theorem padic_val_prime_pow {p : ℕ} [hp : Fact (Nat.Prime p)] (k : ℕ) :
    padicValNat p (p ^ k) = k :=
  padicValNat.prime_pow k

end PAdicValuation

section PAdicNorm

/-- The p-adic norm is multiplicative: |xy|_p = |x|_p · |y|_p.
    This is the fundamental property that makes p-adic norms compatible
    with the product structure of adeles. -/
theorem padic_norm_multiplicative {p : ℕ} [hp : Fact (Nat.Prime p)]
    (q r : ℚ) :
    padicNorm p (q * r) = padicNorm p q * padicNorm p r :=
  padicNorm.mul q r

/-- The p-adic ultrametric inequality: |x + y|_p ≤ max(|x|_p, |y|_p).
    This non-Archimedean property distinguishes p-adic norms from the
    real absolute value and is the key structural difference between
    finite and infinite places in the adelic product. -/
theorem padic_ultrametric {p : ℕ} [hp : Fact (Nat.Prime p)]
    {q r : ℚ} :
    padicNorm p (q + r) ≤ max (padicNorm p q) (padicNorm p r) :=
  padicNorm.nonarchimedean

/-- The p-adic norm of p itself equals 1/p.
    This is the normalization convention: |p|_p = p^{-1}. -/
theorem padic_norm_of_prime (p : ℕ) [Fact (Nat.Prime p)] :
    padicNorm p (p : ℚ) = (p : ℚ)⁻¹ := by
  simp +decide [padicNorm]
  exact fun h => absurd h (Fact.out : Nat.Prime p).ne_zero

/-- The p-adic norm is nonneg: |x|_p ≥ 0. -/
theorem padic_norm_nonneg {p : ℕ} [Fact (Nat.Prime p)] (q : ℚ) :
    0 ≤ padicNorm p q :=
  padicNorm.nonneg q

end PAdicNorm

section FundamentalTheorem

/-- The fundamental theorem of arithmetic: every positive natural number
    is the product of its prime power factors. This decomposition is
    the basis for the adelic product representation. -/
theorem factorial_prime_factorization {n : ℕ} (hn : n ≠ 0) :
    n.factorization.prod (· ^ ·) = n :=
  Nat.factorization_prod_pow_eq_self hn

/-- The p-adic valuation equals the factorization at p for any natural number. -/
theorem padic_val_eq_factorization (p n : ℕ) [Fact (Nat.Prime p)]
    (_hn : n ≠ 0) :
    padicValNat p n = n.factorization p := by
  simp [Nat.factorization]
  exact fun h => False.elim <| h (Fact.out)

end FundamentalTheorem

section AdelicProductFormula

/-- For a nonzero integer n, the product of all prime power factors equals n.
    This is a consequence of the product formula and the FTA. -/
theorem adelic_product_nat {n : ℕ} (hn : n ≠ 0) :
    n.factorization.prod (· ^ ·) = n :=
  Nat.factorization_prod_pow_eq_self hn

/-- The p-adic valuation is additive on multiplication:
    v_p(a * b) = v_p(a) + v_p(b) for a, b ≠ 0.
    This additivity is what makes the "energy" functional
    decomposable into independent per-prime contributions. -/
theorem padic_val_mul_add {p : ℕ} [hp : Fact (Nat.Prime p)]
    {a b : ℕ} (ha : a ≠ 0) (hb : b ≠ 0) :
    padicValNat p (a * b) = padicValNat p a + padicValNat p b :=
  padicValNat.mul ha hb

/-- The p-adic valuation of 1 is 0 for any prime p. -/
theorem padic_val_one {p : ℕ} [Fact (Nat.Prime p)] :
    padicValNat p 1 = 0 := by
  simp [padicValNat]

end AdelicProductFormula

section GeometricSeries

/-
For 0 ≤ r < 1, the partial geometric sum is bounded by 1/(1-r).
    The AVFT solver uses this to bound the contribution of
    each prime via Σ (1/p)^i ≤ 1/(1 - 1/p) = p/(p-1).
-/
theorem geometric_sum_bound {r : ℝ} (hr0 : 0 ≤ r) (hr1 : r < 1) (n : ℕ) :
    ∑ i ∈ Finset.range n, r ^ i ≤ 1 / (1 - r) := by
      rw [ le_div_iff₀ ] <;> nlinarith [ pow_nonneg hr0 n, geom_sum_mul r n ]

end GeometricSeries

section StirlingConnection

/-- The factorial is always nonzero. -/
theorem factorial_ne_zero (n : ℕ) : n.factorial ≠ 0 :=
  Nat.factorial_ne_zero n

/-- The factorial is always positive. -/
theorem factorial_pos' (n : ℕ) : 0 < n.factorial :=
  Nat.factorial_pos n

/-- Connecting the Gamma function to the prime factorization:
    Γ(n+1) = n! = (∏_p p^{v_p(n)})!.
    This is the fundamental identity that the AVFT solver exploits:
    the analytic Gamma function equals a product over primes. -/
theorem gamma_eq_prime_product (n : ℕ) (hn : n ≠ 0) :
    Real.Gamma (↑n + 1) = ↑(n.factorization.prod (· ^ ·)).factorial := by
  rw [Nat.factorization_prod_pow_eq_self hn]
  exact Real.Gamma_nat_eq_factorial n

/-- The adelic decomposition of factorial:
    n! = ∏_p p^{v_p(n!)} (prime factorization of the factorial). -/
theorem factorial_from_valuations (n : ℕ) (hn : n.factorial ≠ 0) :
    n.factorial.factorization.prod (· ^ ·) = n.factorial :=
  Nat.factorization_prod_pow_eq_self hn

/-
Factorial grows at least as fast as the base: n! ≥ n for n ≥ 1.
    This is a basic growth bound used in estimating log Γ.
-/
theorem factorial_ge_self {n : ℕ} (_hn : 1 ≤ n) : n ≤ n.factorial :=
  Nat.self_le_factorial _

/-
n! ≥ 2^(n-1) for n ≥ 1. This exponential lower bound on factorial
    implies log(n!) ≥ (n-1)·log 2, providing a lower bound for the
    Stirling approximation used by the AVFT energy functional.
-/
theorem factorial_exponential_lower_bound {n : ℕ} (hn : 1 ≤ n) :
    2 ^ (n - 1) ≤ n.factorial := by
      induction hn <;> simp_all +decide [Nat.factorial_succ]
      cases ‹1 ≤ _› <;> simp_all +decide [pow_succ]; nlinarith

end StirlingConnection

section LogGamma

/-
log Γ functional equation: log Γ(s+1) = log s + log Γ(s) for s > 0.
    This is the logarithmic form of Γ(s+1) = s·Γ(s), and is the
    key recurrence exploited when computing the energy functional.
-/
theorem log_gamma_add_one {s : ℝ} (hs : 0 < s) :
    Real.log (Real.Gamma (s + 1)) = Real.log s + Real.log (Real.Gamma s) := by
      rw [ Real.Gamma_add_one hs.ne', Real.log_mul hs.ne' ( Gamma_pos_of_pos hs |> ne_of_gt ) ]

/-
The factorial of n+1 relates to the factorial of n by multiplication.
    This is the discrete analogue of the log Γ recurrence.
-/
theorem log_factorial_recurrence (n : ℕ) :
    Real.log ↑((n + 1).factorial) = Real.log ↑(n + 1) + Real.log ↑(n.factorial) := by
      rw [ Nat.factorial_succ, Nat.cast_mul, Real.log_mul ( by positivity ) ( by positivity ) ]

/-
For the AVFT solver, the real-valued log of the factorial
    is nonneg for n ≥ 1, ensuring the energy functional is well-defined.
-/
theorem log_factorial_nonneg {n : ℕ} (_hn : 1 ≤ n) :
    0 ≤ Real.log ↑(n.factorial) := by
      positivity

/-
Monotonicity of Gamma on positive integers: if 2 ≤ a ≤ b then Γ(a) ≤ Γ(b).
-/
theorem gamma_mono_nat {a b : ℕ} (_ha : 2 ≤ a) (hab : a ≤ b) :
    Real.Gamma a ≤ Real.Gamma b := by
      induction' hab with b h_b h_b_ih;
      · norm_num;
      · by_cases hb : b = 0 <;> simp_all +decide [Real.Gamma_add_one];
        exact le_trans h_b_ih ( le_mul_of_one_le_left ( by positivity ) ( mod_cast Nat.one_le_iff_ne_zero.mpr hb ) )

end LogGamma

section EnergyFunctional

/-- The factorization recovers the original number: a prerequisite for
    the adelic decomposition Σ_p v_p(n)·log(p) = log(n). -/
theorem factorization_recovers {n : ℕ} (hn : n ≠ 0) :
    n.factorization.prod (· ^ ·) = n :=
  Nat.factorization_prod_pow_eq_self hn

/-
The support of the factorization consists only of prime divisors.
    This means the "energy" sum is finite: only finitely many primes
    contribute to the adelic decomposition of any natural number.
-/
theorem factorization_support_prime {n p : ℕ} (hp : p ∈ n.factorization.support) :
    Nat.Prime p := by
      exact Nat.prime_of_mem_primeFactors hp

end EnergyFunctional