/-
  DULA_ThetaPositivity.lean

  WEIL POSITIVITY OF THE TWISTED COEFFICIENTS FOR θ_A₂
  ===================================================

  This file formalizes the positivity of the twisted Fourier coefficients
  f(n) = χ₃(n) · σ_χ₃(n) for the weight-1 Eisenstein series θ_A₂.

  It does NOT prove GRH or directly apply Viazovska's sphere-packing method.
  The connection to GRH remains an open heuristic in the DULA framework.
-/

import Mathlib

open Nat Finset BigOperators Pointwise

namespace DULA.ThetaPositivity

/-! ## Part 1: Definitions -/

/-- The Legendre symbol mod 3, as an integer-valued function on ℕ.
  chi3(n) = 0 if 3 ∣ n, 1 if n ≡ 1 mod 3, -1 if n ≡ 2 mod 3. -/
def chi3 (n : ℕ) : ℤ :=
  if n % 3 = 0 then 0
  else if n % 3 = 1 then 1
  else -1

/-- σ_χ₃(n) = ∑_{d ∣ n} χ₃(d). -/
def sigma_chi3 (n : ℕ) : ℤ :=
  ∑ d ∈ n.divisors, chi3 d

/-- Twisted coefficient f(n) = χ₃(n) · σ_χ₃(n). -/
def f (n : ℕ) : ℤ :=
  chi3 n * sigma_chi3 n

/-! ## Part 2: Basic properties of χ₃ -/

@[simp] theorem chi3_zero : chi3 0 = 0 := by simp [chi3]

@[simp] theorem chi3_one : chi3 1 = 1 := by simp [chi3]

theorem chi3_values (n : ℕ) : chi3 n = 0 ∨ chi3 n = 1 ∨ chi3 n = -1 := by
  simp [chi3]; omega

theorem chi3_mod (n : ℕ) : chi3 n = chi3 (n % 3) := by
  simp [chi3, Nat.mod_mod_of_dvd]

/-
PROVIDED SOLUTION
chi3 is defined by n % 3. We need chi3((a*b) % 3) = chi3(a%3) * chi3(b%3). Use Nat.mul_mod to get (a*b)%3 = (a%3 * b%3) % 3. Then case split on a%3 and b%3 (each is 0, 1, or 2) - there are 9 cases, all trivial by computation. Use omega or decide for each case.
-/
theorem chi3_mul (a b : ℕ) : chi3 (a * b) = chi3 a * chi3 b := by
  unfold chi3; split_ifs <;> simp_all +decide [ Nat.mul_mod ] ;
  · have := Nat.mod_lt a zero_lt_three; have := Nat.mod_lt b zero_lt_three; interval_cases a % 3 <;> interval_cases b % 3 <;> trivial;
  · have := Nat.mod_lt a zero_lt_three; have := Nat.mod_lt b zero_lt_three; interval_cases a % 3 <;> interval_cases b % 3 <;> contradiction;

/-! ## Part 3: Multiplicativity of σ_χ₃ and f -/

/-
PROVIDED SOLUTION
Use Nat.divisors_mul to rewrite (a*b).divisors = a.divisors * b.divisors (pointwise product under open Pointwise). The sum over the pointwise product equals the sum over pairs by Finset.sum_mul_of_injOn or similar, using that the multiplication map is injective on divisors of coprime numbers. Then use chi3_mul and Finset.sum_mul_sum. Alternatively, try using Nat.sum_divisors_eq_sum_divisors_mul_of_coprime or similar Mathlib multiplicativity infrastructure.
-/
theorem sigma_chi3_mul_coprime {a b : ℕ} (hab : Nat.Coprime a b) :
    sigma_chi3 (a * b) = sigma_chi3 a * sigma_chi3 b := by
  -- By definition of divisors, we can rewrite the sum over the divisors of $ab$ as a double sum over the divisors of $a$ and $b$.
  have h_divisors : (a * b).divisors = Finset.image (fun (p : ℕ × ℕ) => p.1 * p.2) (a.divisors ×ˢ b.divisors) := by
    exact Nat.divisors_mul _ _;
  unfold sigma_chi3;
  rw [ h_divisors, Finset.sum_image, Finset.sum_product ];
  · simp +decide only [chi3_mul, sum_mul_sum];
  · intros p hp q hq h_eq;
    -- Since $a$ and $b$ are coprime, if $p.1 \cdot p.2 = q.1 \cdot q.2$, then $p.1 = q.1$ and $p.2 = q.2$.
    have h_coprime : p.1 ∣ q.1 ∧ q.1 ∣ p.1 := by
      simp +zetaDelta at *;
      exact ⟨ Nat.Coprime.dvd_of_dvd_mul_right ( Nat.Coprime.coprime_dvd_left hp.1.1 <| Nat.Coprime.coprime_dvd_right hq.2.1 hab ) <| h_eq ▸ dvd_mul_right _ _, Nat.Coprime.dvd_of_dvd_mul_right ( Nat.Coprime.coprime_dvd_left hq.1.1 <| Nat.Coprime.coprime_dvd_right hp.2.1 hab ) <| h_eq.symm ▸ dvd_mul_right _ _ ⟩;
    have := Nat.dvd_antisymm h_coprime.1 h_coprime.2; aesop;

theorem f_mul_coprime {a b : ℕ} (hab : Nat.Coprime a b) :
    f (a * b) = f a * f b := by
  unfold f
  rw [chi3_mul, sigma_chi3_mul_coprime hab]
  ring

/-! ## Part 4: Prime power evaluations -/

/-
PROVIDED SOLUTION
Induction on k. Base case k=0: chi3(p^0) = chi3(1) = 1 = (chi3 p)^0. Inductive step: chi3(p^(k+1)) = chi3(p * p^k) = chi3(p) * chi3(p^k) by chi3_mul = chi3(p) * (chi3(p))^k by IH = (chi3 p)^(k+1).
-/
theorem chi3_pow (p k : ℕ) : chi3 (p ^ k) = (chi3 p) ^ k := by
  unfold chi3; induction k <;> simp_all +decide [ pow_succ' ] ;
  norm_num [ Nat.mul_mod, pow_succ' ] at *; have := Nat.mod_lt p zero_lt_three; interval_cases p % 3 <;> simp_all +decide ;
  grind

/-
PROVIDED SOLUTION
Use Nat.divisors_prime_pow to rewrite (p^k).divisors = (Finset.range (k+1)).map ⟨(p^·), Nat.pow_left_injective hp.one_le⟩. Then use Finset.sum_map to convert to a sum over range (k+1), and chi3_pow to get chi3(p^i) = (chi3 p)^i.
-/
theorem sigma_chi3_prime_pow {p : ℕ} (hp : p.Prime) (k : ℕ) :
    sigma_chi3 (p ^ k) = ∑ i ∈ Finset.range (k + 1), (chi3 p) ^ i := by
  unfold sigma_chi3;
  simp +decide [ Nat.divisors_prime_pow hp, chi3_pow ]

/-
PROVIDED SOLUTION
Use sigma_chi3_prime_pow and chi3_pow to rewrite f(p^k) = (chi3 p)^k * ∑ i in range(k+1), (chi3 p)^i. Case split on p % 3:
- If p%3 = 0 (i.e. p=3): chi3 p = 0, so (chi3 p)^k = 0 for k≥1, giving f = 0. For k=0, f(1) = 1.
- If p%3 = 1: chi3 p = 1, so f = 1^k * (k+1) = k+1 ≥ 0.
- If p%3 = 2: chi3 p = -1, so f = (-1)^k * ∑ i, (-1)^i.
  The geometric sum ∑_{i=0}^{k} (-1)^i = 1 if k even, 0 if k odd.
  If k even: (-1)^k = 1, sum = 1, f = 1.
  If k odd: sum = 0, f = 0.
  In both cases f ≥ 0.
Use Finset.geom_sum_neg_one or compute the geometric sum directly. Key: the sum ∑_{i=0}^{k} (-1)^i as integers equals if k is even then 1 else 0.
-/
theorem f_prime_power_nonneg (p k : ℕ) (hp : p.Prime) : f (p ^ k) ≥ 0 := by
  -- By definition of $f$, we know that $f(p^k) = \chi_3(p^k) \cdot \sigma_{\chi_3}(p^k)$.
  have hf_prime_pow : f (p ^ k) = (chi3 p) ^ k * (∑ i ∈ Finset.range (k + 1), (chi3 p) ^ i) := by
    convert congr_arg₂ ( · * · ) ( chi3_pow p k ) ( sigma_chi3_prime_pow hp k ) using 1;
  rcases Nat.mod_two_eq_zero_or_one p with h | h <;> rcases k with ( _ | _ | k ) <;> simp_all +decide [ pow_succ' ];
  · cases Nat.Prime.eq_two_or_odd hp <;> simp_all +decide;
  · cases hp.eq_two_or_odd <;> simp_all +decide [ chi3 ];
    split_ifs <;> simp_all +decide [ parity_simps ];
  · unfold chi3; split_ifs <;> norm_num;
  · unfold chi3; split_ifs <;> norm_num;
    · positivity;
    · split_ifs <;> simp_all +decide [ Nat.even_add_one ]

/-! ## Part 5: The Main Positivity Theorem -/

theorem f_one : f 1 = 1 := by simp [f, sigma_chi3, chi3]

theorem f_zero : f 0 = 0 := by simp [f, chi3]

theorem twisted_coefficients_nonneg (n : ℕ) : f n ≥ 0 := by
  induction n using Nat.recOnPrimeCoprime with
  | zero => simp [f_zero]
  | prime_pow p k hp => exact f_prime_power_nonneg p k hp
  | coprime a b ha hb hab iha ihb =>
    rw [f_mul_coprime hab]
    exact mul_nonneg iha ihb

/-! ## Verification Checks -/

#check twisted_coefficients_nonneg
#print axioms twisted_coefficients_nonneg

end DULA.ThetaPositivity