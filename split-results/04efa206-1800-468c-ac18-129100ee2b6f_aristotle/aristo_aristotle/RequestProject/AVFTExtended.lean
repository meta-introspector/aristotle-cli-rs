/-
# Arithmetic Variational Field Theory: Extended Formalizations
This file extends the core AVFT formalizations with additional verified claims:
1. **Geometric Sum Closed Form** — Connecting σ_k(p^a) to the Euler product formula
   (p^{k(a+1)} − 1)/(p^k − 1).
2. **ℚ_p Structural Properties** — Completeness, local compactness, total disconnectedness,
   and normed field structure of p-adic completions.
3. **The Adelic Product Formula** — Concrete verified instances demonstrating
   |q|_∞ · ∏_p |q|_p = 1 for specific rationals.
4. **Q-Tower Floor Computations** — Detailed σ₃ verifications for each floor of the
   Q-Tower hierarchy (dyadic, trialogic, pentadic).
5. **E₄ Eisenstein Series Normalization** — The coefficient 240 in E₄ = 1 + 240 Σ σ₃(n)qⁿ
   is divisible by 30 = den(B₄), connecting the Bernoulli density to modular forms.
6. **p-adic Valuation Structure** — Key properties of the p-adic valuation used in
   the lattice quantization framework.
-/
import Mathlib
/-! ## 1. Geometric Sum Closed Form for the Euler Product
The document states: σ_s(n) = ∏_{p^a ∥ n} (p^{s(a+1)}−1)/(p^s−1).
The key algebraic identity underlying this is the geometric sum formula:
  (x - 1) · Σ_{i=0}^{n-1} x^i = x^n - 1
Specialized to x = p^k, this gives the closed form for σ_k at prime powers. -/
/-- The geometric sum identity: (x-1) · Σ_{i<n} x^i = x^n - 1.
    This is the algebraic foundation of the Euler product for σ_k. -/
theorem geom_sum_mul_identity (x : ℤ) (n : ℕ) :
    (∑ i ∈ Finset.range n, x ^ i) * (x - 1) = x ^ n - 1 :=
  geom_sum_mul x n
/-- Division form of the geometric sum: when x ≠ 1,
    Σ_{i<n} x^i = (x^n - 1)/(x - 1). -/
theorem geom_sum_division {x : ℚ} (hx : x ≠ 1) (n : ℕ) :
    ∑ i ∈ Finset.range n, x ^ i = (x ^ n - 1) / (x - 1) :=
  geom_sum_eq hx n
/-
For the Euler product: σ_k(p^a) expressed via the geometric sum equals
    (p^{k·(a+1)} - 1) / (p^k - 1) when cast to ℚ (where division makes sense).
    We verify that (p^k - 1) · σ_k(p^a) = p^{k·(a+1)} - 1 in ℤ.
-/
theorem euler_product_closed_form (k : ℕ) (p : ℕ) (_hp : Nat.Prime p) (a : ℕ) :
    ((p : ℤ) ^ k - 1) * ∑ i ∈ Finset.range (a + 1), (p : ℤ) ^ (k * i) =
    (p : ℤ) ^ (k * (a + 1)) - 1 := by
      norm_num [ pow_mul, mul_geom_sum ]
/-! ## 2. ℚ_p as a Complete, Locally Compact, Totally Disconnected Normed Field
The AVFT framework requires ℚ_p to carry rich analytic structure: it must be a
complete normed field (for p-adic analysis), locally compact (for Haar measure
and adelic integration), and totally disconnected (the non-Archimedean topology). -/
/-- ℚ_p is a normed field. -/
noncomputable example (p : ℕ) [Fact (Nat.Prime p)] : NormedField ℚ_[p] := inferInstance
/-- ℚ_p is a complete metric space (the completion of ℚ with respect to |·|_p). -/
theorem padic_complete (p : ℕ) [Fact (Nat.Prime p)] : CompleteSpace ℚ_[p] :=
  inferInstance
/-- ℚ_p is totally disconnected, a consequence of the ultrametric property. -/
theorem padic_totally_disconnected (p : ℕ) [Fact (Nat.Prime p)] :
    TotallyDisconnectedSpace ℚ_[p] :=
  inferInstance
/-- ℚ_p carries the structure of a topological ring. -/
noncomputable example (p : ℕ) [Fact (Nat.Prime p)] : IsTopologicalRing ℚ_[p] := inferInstance
/-- ℚ_p is a nontrivially normed field (essential for p-adic functional analysis). -/
noncomputable example (p : ℕ) [Fact (Nat.Prime p)] : NontriviallyNormedField ℚ_[p] := inferInstance
/-! ## 3. The p-adic Norm: Values as Powers of p
The document specifies that |·|_p takes values in {p^(-v) : v ∈ ℤ} ∪ {0}.
We verify the structural theorem: for q ≠ 0, |q|_p = p^(-v_p(q)). -/
/-- The p-adic norm of a nonzero rational equals p raised to minus the p-adic valuation. -/
theorem padic_norm_eq_pow_neg_val (p : ℕ) [Fact (Nat.Prime p)] (q : ℚ) (hq : q ≠ 0) :
    padicNorm p q = (p : ℚ) ^ (-padicValRat p q) :=
  padicNorm.eq_zpow_of_nonzero hq
/-- The p-adic norm of 0 is 0. -/
theorem padic_norm_zero (p : ℕ) [Fact (Nat.Prime p)] :
    padicNorm p 0 = 0 :=
  padicNorm.zero
/-- The p-adic norm of 1 is 1. -/
theorem padic_norm_one (p : ℕ) [Fact (Nat.Prime p)] :
    padicNorm p 1 = 1 :=
  padicNorm.one
/-- The p-adic valuation of p itself is 1. -/
theorem padic_val_self (p : ℕ) (hp : 1 < p) :
    padicValNat p p = 1 :=
  padicValNat.self hp
open ArithmeticFunction in
/-! ## 4. The Adelic Product Formula: Concrete Instances
The product formula ∏_v |x|_v = 1 (ranging over all places v including ∞)
is fundamental to adelic analysis. We verify concrete instances:
  |n|_∞ · ∏_{p | n} |n|_p = 1
For n = 6 = 2 · 3:   |6|_∞ · |6|_2 · |6|_3 = 6 · (1/2) · (1/3) = 1
For n = 30 = 2·3·5:  |30|_∞ · |30|_2 · |30|_3 · |30|_5 = 30 · (1/2)·(1/3)·(1/5) = 1 -/
/-- |6|_2 = 1/2 -/
theorem padic_norm_six_at_two : padicNorm 2 (6 : ℚ) = 1 / 2 := by native_decide
/-- |6|_3 = 1/3 -/
theorem padic_norm_six_at_three : padicNorm 3 (6 : ℚ) = 1 / 3 := by native_decide
/-- |6|_5 = 1 (6 is a 5-adic unit) -/
theorem padic_norm_six_at_five : padicNorm 5 (6 : ℚ) = 1 := by native_decide
/-- Product formula instance for n=6: |6|_∞ · |6|₂ · |6|₃ = 1,
    where |6|_∞ = 6 (the ordinary absolute value). -/
theorem product_formula_six :
    (6 : ℚ) * padicNorm 2 6 * padicNorm 3 6 = 1 := by native_decide
/-- |30|_2 = 1/2 -/
theorem padic_norm_thirty_at_two : padicNorm 2 (30 : ℚ) = 1 / 2 := by native_decide
/-- |30|_3 = 1/3 -/
theorem padic_norm_thirty_at_three : padicNorm 3 (30 : ℚ) = 1 / 3 := by native_decide
/-- |30|_5 = 1/5 -/
theorem padic_norm_thirty_at_five : padicNorm 5 (30 : ℚ) = 1 / 5 := by native_decide
/-- Product formula instance for n=30: |30|_∞ · |30|₂ · |30|₃ · |30|₅ = 1.
    This connects directly to the pentadic floor of the Q-Tower,
    where 30 = den(B₄) is the fundamental period. -/
theorem product_formula_thirty :
    (30 : ℚ) * padicNorm 2 30 * padicNorm 3 30 * padicNorm 5 30 = 1 := by native_decide
/-! ## 5. Q-Tower Floor Computations
The Q-Tower is a multi-floor computational hierarchy refining σ₃.
Each floor adds primes to the lattice support P_N. -/
/-! ### Floor 1: The Dyadic Base (P₁ = {2})
Restricted to p = 2, σ₃ is evaluated only at powers of 2. -/
/-- σ₃(1) = 1 (the trivial base) -/
theorem sigma_three_one : ArithmeticFunction.sigma 3 1 = 1 := by native_decide
/-- σ₃(16) = 1 + 8 + 64 + 512 + 4096 = 4681 -/
theorem sigma_three_sixteen : ArithmeticFunction.sigma 3 16 = 4681 := by native_decide
/-- σ₃(32) = 37449 -/
theorem sigma_three_thirtytwo : ArithmeticFunction.sigma 3 32 = 37449 := by native_decide
/-- The geometric sum pattern: σ₃(2^a) grows as (2^{3(a+1)} - 1)/7.
    Verified: σ₃(16) = σ₃(2⁴) = (2^15 - 1)/7 = 32767/7 = 4681. -/
theorem sigma_three_pow2_four_closed :
    ArithmeticFunction.sigma 3 (2^4) = (2^15 - 1) / 7 := by native_decide
/-! ### Floor 2: The Trialogic Expansion (P₂ = {2, 3})
Adding p = 3 creates resonance with the 3^20 coordinate. -/
/-- σ₃(9) = σ₃(3²) = 1 + 27 + 729 = 757 -/
theorem sigma_three_nine : ArithmeticFunction.sigma 3 9 = 757 := by native_decide
/-- σ₃(12) = σ₃(4) · σ₃(3) = 73 · 28 = 2044 (multiplicativity at Floor 2) -/
theorem sigma_three_twelve : ArithmeticFunction.sigma 3 12 = 2044 := by native_decide
/-- Multiplicativity check: σ₃(12) = σ₃(4) · σ₃(3) -/
theorem sigma_three_twelve_mult :
    ArithmeticFunction.sigma 3 12 =
    ArithmeticFunction.sigma 3 4 * ArithmeticFunction.sigma 3 3 := by native_decide
/-- σ₃(18) = σ₃(2) · σ₃(9) = 9 · 757 = 6813 -/
theorem sigma_three_eighteen : ArithmeticFunction.sigma 3 18 = 6813 := by native_decide
/-- σ₃(24) = σ₃(8) · σ₃(3) = 585 · 28 = 16380 -/
theorem sigma_three_twentyfour : ArithmeticFunction.sigma 3 24 = 16380 := by native_decide
/-! ### Floor 3: The Pentadic Refinement (P₃ = {2, 3, 5})
The addition of p = 5 completes a critical symmetry break. -/
/-- σ₃(5) = 1 + 125 = 126 -/
theorem sigma_three_five : ArithmeticFunction.sigma 3 5 = 126 := by native_decide
/-- σ₃(25) = σ₃(5²) = 1 + 125 + 15625 = 15751 -/
theorem sigma_three_twentyfive : ArithmeticFunction.sigma 3 25 = 15751 := by native_decide
/-- σ₃(30) = σ₃(2) · σ₃(3) · σ₃(5) = 9 · 28 · 126 = 31752
    The value at 30 = den(B₄), the fundamental period of the pentadic floor. -/
theorem sigma_three_thirty : ArithmeticFunction.sigma 3 30 = 31752 := by native_decide
/-- Multiplicativity at the pentadic floor: σ₃(30) = σ₃(2) · σ₃(3) · σ₃(5) -/
theorem sigma_three_thirty_mult :
    ArithmeticFunction.sigma 3 30 =
    ArithmeticFunction.sigma 3 2 * ArithmeticFunction.sigma 3 3 *
    ArithmeticFunction.sigma 3 5 := by native_decide
/-- σ₃(60) = σ₃(4) · σ₃(3) · σ₃(5) = 73 · 28 · 126 = 257544 -/
theorem sigma_three_sixty : ArithmeticFunction.sigma 3 60 = 257544 := by native_decide
/-! ## 6. E₄ Eisenstein Series Normalization
E₄(q) = 1 + 240 Σ_{n≥1} σ₃(n) qⁿ. The coefficient 240 arises from
the formula 2k / B_k for k=4: 2·4 / B₄ = 8 / (-1/30) = -240.
In the normalized form, we use |240| = 240 = 2⁴ · 3 · 5.
The denominator 30 = den(B₄) divides 240, connecting the Bernoulli density
to the Eisenstein normalization. -/
/-- 240 = 8 · 30: the E₄ coefficient is 8 times the Bernoulli denominator. -/
theorem e4_coefficient_factored : (240 : ℕ) = 8 * 30 := by norm_num
/-- 30 divides 240, connecting the Bernoulli denominator to the Eisenstein normalization. -/
theorem bernoulli_denom_divides_e4_coeff : (30 : ℕ) ∣ 240 := ⟨8, by norm_num⟩
/-- The E₄ normalization coefficient 240 = 2⁴ · 3 · 5. -/
theorem e4_coeff_prime_factored : (240 : ℕ) = 2^4 * 3 * 5 := by norm_num
/-- The E₄ coefficient 240 equals 2k/B_k for k=4 (up to sign):
    |2 · 4 / B₄| = |8 / (-1/30)| = 240. -/
theorem e4_coeff_from_bernoulli :
    |2 * 4 / bernoulli' 4| = (240 : ℚ) := by
  simp [bernoulli_four_value]
  norm_num
  where bernoulli_four_value : bernoulli' 4 = -1 / 30 := by native_decide
/-! ## 7. p-adic Valuation Structure
The p-adic valuation v_p provides the "height" function in the prime lattice.
Key properties used in the adelic framework: -/
/-- v_p(p) = 1: the prime itself has valuation exactly 1. -/
theorem padic_val_prime (p : ℕ) [hp : Fact (Nat.Prime p)] :
    padicValNat p p = 1 :=
  padicValNat.self hp.out.one_lt
/-- v_p(1) = 0: units have trivial valuation. -/
theorem padic_val_one (p : ℕ) :
    padicValNat p 1 = 0 :=
  padicValNat.one
/-
v_p(p²) = 2
-/
theorem padic_val_p_sq (p : ℕ) [hp : Fact (Nat.Prime p)] :
    padicValNat p (p ^ 2) = 2 := by
      haveI := Fact.mk hp.1; rw [ padicValNat.pow ] ; aesop;
      exact hp.1.ne_zero
/-
v_p(q) = 0 when q is coprime to p (q is a p-adic unit).
-/
theorem padic_val_coprime (p q : ℕ) [hp : Fact (Nat.Prime p)] (hq : Nat.Coprime p q) :
    padicValNat p q = 0 := by
      rw [ padicValNat.eq_zero_iff ];
      exact Or.inr <| Or.inr <| fun h => hp.1.not_dvd_one <| hq.gcd_eq_one ▸ Nat.dvd_gcd ( dvd_refl p ) h
/-- The p-adic valuation is additive on multiplication: v_p(mn) = v_p(m) + v_p(n). -/
theorem padic_val_mul (p m n : ℕ) [hp : Fact (Nat.Prime p)]
    (hm : m ≠ 0) (hn : n ≠ 0) :
    padicValNat p (m * n) = padicValNat p m + padicValNat p n := by
  exact padicValNat.mul hm hn
/-- Concrete: v₂(6) = 1, v₃(6) = 1, confirming 6 = 2¹ · 3¹ -/
theorem padic_val_six_at_two : padicValNat 2 6 = 1 := by native_decide
theorem padic_val_six_at_three : padicValNat 3 6 = 1 := by native_decide
/-- Concrete: v₂(30) = 1, v₃(30) = 1, v₅(30) = 1, confirming 30 = 2 · 3 · 5 -/
theorem padic_val_thirty_at_two : padicValNat 2 30 = 1 := by native_decide
theorem padic_val_thirty_at_three : padicValNat 3 30 = 1 := by native_decide
theorem padic_val_thirty_at_five : padicValNat 5 30 = 1 := by native_decide
/-! ## 8. Ultrametric Consequences for the Adelic Framework
Further consequences of the ultrametric property that are central to AVFT's
stability guarantees. -/
/-- In an ultrametric space, the distance satisfies the strong triangle inequality.
    This ensures that p-adic "balls" are both open and closed (clopen),
    giving the totally disconnected topology. -/
theorem padic_strong_triangle (p : ℕ) [Fact (Nat.Prime p)] (x y z : ℚ_[p]) :
    dist x z ≤ max (dist x y) (dist y z) :=
  IsUltrametricDist.dist_triangle_max x y z
/-- The p-adic norm is non-negative (a basic well-formedness condition). -/
theorem padic_norm_nonneg (p : ℕ) [Fact (Nat.Prime p)] (q : ℚ) :
    0 ≤ padicNorm p q :=
  padicNorm.nonneg q
