/-
Copyright (c) 2026 PIE Lab / DULA Collaboration. All rights reserved.

# PartialSummation.lean — Abel Summation Tools and Bounds
-/

import Mathlib

open Finset Real ArithmeticFunction Nat Complex MeasureTheory
open scoped BigOperators

noncomputable section

-- ============================================================================
-- DEFINITIONS (self-contained, matching SiegelWalfisz.lean)
-- ============================================================================

/-- Additive character e(θ) = exp(2πiθ). -/
def eChar' (θ : ℝ) : ℂ :=
  Complex.exp (2 * ↑Real.pi * Complex.I * ↑θ)

/-- |e(θ)| = 1 for all θ. -/
theorem eChar'_norm (θ : ℝ) : ‖eChar' θ‖ = 1 := by
  unfold eChar'
  have h : (2 : ℂ) * ↑Real.pi * Complex.I * ↑θ = ↑(2 * Real.pi * θ) * Complex.I := by
    push_cast; ring
  rw [h]
  exact Complex.norm_exp_ofReal_mul_I (2 * Real.pi * θ)

/-- The function t ↦ eChar'(t·β) is differentiable. -/
theorem eChar'_mul_differentiable (β : ℝ) :
    Differentiable ℝ (fun t : ℝ => eChar' (t * β)) := by
  unfold eChar'
  exact Complex.differentiable_exp.comp
    (Differentiable.const_mul
      (differentiable_id.comp
        (Complex.ofRealCLM.differentiable.comp
          (differentiable_id.mul_const _))) _)

/-- Exponential sum over all integers ≤ x weighted by von Mangoldt. -/
def vonMangoldtExpSum' (x : ℝ) (α : ℝ) : ℂ :=
  ∑ n ∈ Finset.Icc 1 (Nat.floor x),
    (↑(Λ n : ℝ) : ℂ) * eChar' (↑n * α)

/-- Exponential sum restricted to residue class r mod q. -/
def vonMangoldtExpSumResidueClass' (x : ℝ) (β : ℝ) (q r : ℕ) : ℂ :=
  ∑ n ∈ (Finset.Icc 1 (Nat.floor x)).filter (fun n => n % q = r),
    (↑(Λ n : ℝ) : ℂ) * eChar' (↑n * β)

/-- Cumulative von Mangoldt in residue class. -/
def vonMangoldtPsiResidueClass (x : ℝ) (q r : ℕ) : ℝ :=
  ∑ n ∈ (Finset.Icc 1 (Nat.floor x)).filter (fun n => n % q = r),
    (Λ n : ℝ)

-- ============================================================================
-- HELPER LEMMAS (all proved)
-- ============================================================================

/-- The difference |eChar'(nβ) - eChar'((n+1)β)| ≤ 2π|β|.
    This follows from |e^{iα} - e^{iβ}| ≤ |α - β|. -/
lemma eChar'_diff_bound (n : ℕ) (β : ℝ) :
    ‖eChar' ((n + 1 : ℝ) * β) - eChar' ((n : ℝ) * β)‖ ≤ 2 * Real.pi * |β| := by
  have h_diff : ‖(eChar' β) - 1‖ = 2 * |Real.sin (Real.pi * β)| := by
    unfold eChar';
    norm_num [ Complex.norm_def, Complex.normSq, Complex.exp_re, Complex.exp_im ];
    rw [ Real.sqrt_eq_iff_mul_self_eq ] <;> norm_num <;> ring <;> norm_num [ Real.sin_sq, Real.cos_sq ] <;> ring;
    nlinarith [ Real.cos_sq' ( Real.pi * β * 2 ) ];
  have h_sin_bound : 2 * |Real.sin (Real.pi * β)| ≤ 2 * Real.pi * |β| := by
    have h_sin_bound : ∀ θ : ℝ, |Real.sin θ| ≤ |θ| := by
      exact?;
    exact le_trans ( mul_le_mul_of_nonneg_left ( h_sin_bound _ ) zero_le_two ) ( by rw [ abs_mul, abs_of_nonneg Real.pi_pos.le ] ; ring_nf; norm_num );
  have h_diff : ‖(eChar' ((n + 1) * β)) - (eChar' (n * β))‖ = ‖(eChar' (n * β)) * (eChar' β - 1)‖ := by
    unfold eChar'; ring;
    rw [ ← Complex.exp_add ] ; push_cast ; ring;
  simp_all +decide [ Complex.norm_exp ];
  exact le_trans ( mul_le_of_le_one_left ( by positivity ) ( by simpa [ eChar'_norm ] ) ) h_sin_bound

/-- Summation by parts (discrete Abel summation). -/
lemma discrete_abel {N : ℕ} (c : ℕ → ℂ) (b : ℕ → ℂ) :
    ∑ n ∈ Finset.Icc 1 N, c n * b n =
    (∑ n ∈ Finset.Icc 1 N, c n) * b N -
    ∑ n ∈ Finset.Ico 1 N, (∑ k ∈ Finset.Icc 1 n, c k) * (b (n + 1) - b n) := by
  induction N <;> simp_all +decide [ Finset.sum_Ioc_succ_top, (Nat.succ_eq_succ ▸ Finset.Icc_succ_left_eq_Ioc) ] ; ring;
  cases ‹ℕ› <;> simp_all +decide [ add_comm 1 _, Finset.sum_Ico_succ_top ] ; ring!;

/-- Triangle inequality for the Abel summation bound. -/
lemma abel_bound {N : ℕ} (c : ℕ → ℂ) (b : ℕ → ℂ)
    (hA : ∀ n, 1 ≤ n → n ≤ N → ‖∑ k ∈ Finset.Icc 1 n, c k‖ ≤ (M : ℝ))
    (hb : ∀ n, 1 ≤ n → n < N → ‖b (n + 1) - b n‖ ≤ (D : ℝ))
    (hbN : ‖b N‖ ≤ 1)
    (hM : M ≥ 0) (hD : D ≥ 0) :
    ‖∑ n ∈ Finset.Icc 1 N, c n * b n‖ ≤ M + M * N * D := by
  have h_norm : ‖∑ n ∈ Finset.Icc 1 N, c n * b n‖ ≤ ‖∑ k ∈ Finset.Icc 1 N, c k‖ * ‖b N‖ + ∑ n ∈ Finset.Ico 1 N, ‖∑ k ∈ Finset.Icc 1 n, c k‖ * ‖b (n + 1) - b n‖ := by
    rw [ discrete_abel ];
    exact le_trans ( norm_sub_le _ _ ) ( add_le_add ( norm_mul_le _ _ ) ( by simpa only [ ← norm_mul ] using norm_sum_le _ _ ) );
  have h_bound : ‖∑ k ∈ Finset.Icc 1 N, c k‖ * ‖b N‖ + ∑ n ∈ Finset.Ico 1 N, ‖∑ k ∈ Finset.Icc 1 n, c k‖ * ‖b (n + 1) - b n‖ ≤ M * 1 + ∑ n ∈ Finset.Ico 1 N, M * D := by
    exact add_le_add ( mul_le_mul ( if h : N = 0 then by aesop else hA N ( Nat.pos_of_ne_zero h ) le_rfl ) hbN ( by positivity ) ( by positivity ) ) ( Finset.sum_le_sum fun n hn => mul_le_mul ( hA n ( Finset.mem_Ico.mp hn |>.1 ) ( Finset.mem_Ico.mp hn |>.2.le ) ) ( hb n ( Finset.mem_Ico.mp hn |>.1 ) ( Finset.mem_Ico.mp hn |>.2 ) ) ( by positivity ) ( by positivity ) );
  cases N <;> norm_num at * ; nlinarith;
  nlinarith [ mul_nonneg hM hD ]

-- ============================================================================
-- EXPONENTIAL SUM BOUND (general Abel bound for weighted exponential sums)
-- ============================================================================

/-- **General Abel bound for exponential sums with eChar'.**

    If the partial sums of c are bounded by M, then the exponential sum
    ∑ c(n)·eChar'(nβ) is bounded by M·(1 + 2πN|β|). -/
theorem abel_exponential_sum_bound
    {N : ℕ} (c : ℕ → ℂ) (β : ℝ) (M : ℝ) (hM : M ≥ 0)
    (hA : ∀ n, 1 ≤ n → n ≤ N →
      ‖∑ k ∈ Finset.Icc 1 n, c k‖ ≤ M) :
    ‖∑ n ∈ Finset.Icc 1 N, c n * eChar' (↑n * β)‖ ≤
    M + M * N * (2 * Real.pi * |β|) := by
  apply abel_bound c (fun n => eChar' (↑n * β)) hA
  · intro n hn1 hn2
    have := eChar'_diff_bound n β
    push_cast at this ⊢
    exact this
  · simp [eChar'_norm]
  · exact hM
  · positivity

-- ============================================================================
-- MAIN THEOREM (original statement)
-- ============================================================================

/-!
## Issue with the original `partial_summation_residue_bound`

The original statement hypothesizes a bound on `|ψ(y;q,r) - y/φ(q)|` (the
Siegel–Walfisz error) and concludes a bound on the exponential sum difference
`‖S_r(x,β) - (1/φ(q))·S(x,β)‖ ≤ (2π|β| + 1)·K·x/(log x)^B`.

However, rewriting the LHS as `∑ c(n)·eChar'(nβ)` where
`c(n) = Λ(n)·(𝟙_{n≡r} - 1/φ(q))` gives partial sums
`A(n) = ψ(n;q,r) - ψ(n)/φ(q)`, which differs from the hypothesized quantity
`ψ(n;q,r) - n/φ(q)` by the PNT error `(ψ(n) - n)/φ(q)`.

Without a separate PNT hypothesis, the bound on `A(n)` cannot be obtained from
`hpsi` alone, making the original statement unprovable as stated.

Additionally, even with the correct partial-sum bound, Abel summation produces
a factor of `N ≈ ⌊x⌋` multiplying `|β|` (from summing over `N-1` difference
terms), giving a bound of order `(2π|β|·x + 1)·M` rather than `(2π|β| + 1)·M`.

The corrected versions below address these issues.
-/

/-- **Original statement (INCORRECT — left as sorry).**

    This statement has two issues:
    1. The hypothesis bounds `ψ(y;q,r) - y/φ(q)` but the Abel summation
       partial sums are `ψ(n;q,r) - ψ(n)/φ(q)`, requiring a PNT bound.
    2. The factor `(2π|β| + 1)` should be `(2π|β|·⌊x⌋ + 1)` from the
       `N-1` terms in the Abel summation difference sum.

    See `partial_summation_residue_bound_corrected` below for the fixable version. -/
theorem partial_summation_residue_bound
    (x : ℝ) (hx : x ≥ 2) (β : ℝ)
    (q : ℕ) (hq : 0 < q) (r : ℕ) (hr_cop : Nat.Coprime r q) (hr_lt : r < q)
    (K B : ℝ) (hK : K > 0) (hB : B > 0)
    (hpsi : ∀ y : ℝ, 2 ≤ y → y ≤ x →
      |vonMangoldtPsiResidueClass y q r - y / (Nat.totient q)| ≤
      K * y / (Real.log y) ^ B) :
    ‖vonMangoldtExpSumResidueClass' x β q r -
      (1 / (Nat.totient q : ℂ)) * vonMangoldtExpSum' x β‖ ≤
    (2 * Real.pi * |β| + 1) * K * x / (Real.log x) ^ B := by
  sorry

/-
============================================================================
CORRECTED VERSION
============================================================================

**Corrected partial summation bound.**

    This version uses a hypothesis that directly bounds the partial sums
    `ψ(n;q,r) - ψ(n)/φ(q)` (the mean-value adjusted error), and produces the
    correct Abel summation bound with the factor `⌊x⌋` multiplying `|β|`.

    In the Siegel–Walfisz context, this hypothesis follows from the standard
    Siegel–Walfisz bound applied to ALL coprime residue classes (not just `r`),
    together with PNT.
-/
theorem partial_summation_residue_bound_corrected
    (x : ℝ) (hx : x ≥ 2) (β : ℝ)
    (q : ℕ) (hq : 0 < q) (r : ℕ)
    (M : ℝ) (hM : M ≥ 0)
    (hpartial : ∀ n : ℕ, 1 ≤ n → n ≤ Nat.floor x →
      ‖(∑ k ∈ (Finset.Icc 1 n).filter (fun k => k % q = r),
          (↑(Λ k : ℝ) : ℂ)) -
       (1 / (Nat.totient q : ℂ)) *
       (∑ k ∈ Finset.Icc 1 n, (↑(Λ k : ℝ) : ℂ))‖ ≤ M) :
    ‖vonMangoldtExpSumResidueClass' x β q r -
      (1 / (Nat.totient q : ℂ)) * vonMangoldtExpSum' x β‖ ≤
    M + M * ↑(Nat.floor x) * (2 * Real.pi * |β|) := by
  simp_all +decide [ vonMangoldtExpSumResidueClass', vonMangoldtExpSum' ];
  convert abel_exponential_sum_bound ( fun n => if n % q = r then ( Λ n : ℂ ) - ( φ q : ℂ ) ⁻¹ * ( Λ n : ℂ ) else - ( φ q : ℂ ) ⁻¹ * ( Λ n : ℂ ) ) β M hM _ using 1;
  · simp +decide [ Finset.sum_filter, Finset.mul_sum _ _ _, sub_mul, Finset.sum_mul ];
    rw [ ← Finset.sum_sub_distrib ] ; congr ; ext ; split_ifs <;> ring;
  · intro n hn hn'; convert hpartial n hn hn' using 2; simp +decide [ Finset.sum_ite ] ; ring;
    simp +decide [ Finset.sum_ite, Finset.filter_not, Finset.sum_add_distrib, Finset.mul_sum _ _ _ ] ; ring

-- ============================================================================
-- ASSEMBLY
-- ============================================================================

/-- Parameter optimization (already proved). -/
lemma param_optimization (x : ℝ) (hx : x ≥ Real.exp (Real.exp 2))
    (B : ℝ) (hB : B ≥ Real.sqrt (Real.log x)) :
    x / (Real.log x) ^ B ≤ x * Real.exp (-(Real.sqrt (Real.log x))) := by
  rw [Real.rpow_def_of_pos (Real.log_pos <| lt_of_lt_of_le (by norm_num [Real.exp_pos]) hx)]
  rw [div_eq_mul_inv, ← Real.exp_neg]
  gcongr
  · linarith [Real.exp_pos (Real.exp 2)]
  · have h_log_log : Real.log (Real.log x) ≥ 2 := by
      exact (Real.le_log_iff_exp_le (Real.log_pos <|
        lt_of_lt_of_le (by norm_num [Real.exp_pos]) hx)).2 <| by
          simpa using Real.log_le_log (by positivity) hx
    nlinarith [Real.sqrt_nonneg (Real.log x)]

#check sum_mul_eq_sub_sub_integral_mul
#check Complex.norm_exp_ofReal_mul_I

end