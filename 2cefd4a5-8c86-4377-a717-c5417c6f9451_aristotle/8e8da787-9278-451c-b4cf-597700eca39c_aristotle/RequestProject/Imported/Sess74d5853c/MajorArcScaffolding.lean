/-
Copyright (c) 2026 PIE Lab. All rights reserved.

# MajorArcScaffolding.lean
# Major Arc Evaluation

## Remaining sorry count: 2 (was 4)
  - 1 Research-level (residueClass_approximation — Siegel-Walfisz theorem)
  - 1 Hard (majorArc_evaluation_scaffolded — assembly, depends on Siegel-Walfisz)

## Proved this session:
  - chebyshevPsi_le_two_x ✓ (Chebyshev's theorem, via Mathlib Chebyshev bounds)
  - chebyshevPsi_eq_psi ✓ (connects our definition to Mathlib's Chebyshev.psi)
  - mathlib_bound_le_two_x ✓ (analytic bound for large x)
  - chebyshevPsi_le_two_x_small ✓ (computational verification for small x)
  - vonMangoldtExpSum_residue_decomp ✓ (Finset partition by residue class)
  - eChar_mod_eq ✓ (eChar periodicity for residue classes)
-/

import Mathlib

open Finset Complex Real ArithmeticFunction

noncomputable section

-- ============================================================================
-- LAYER 0: CORE DEFINITIONS
-- ============================================================================

/-- The additive character e(θ) = exp(2πiθ). -/
def eChar (θ : ℝ) : ℂ :=
  Complex.exp (2 * ↑Real.pi * Complex.I * ↑θ)

/-- The von Mangoldt exponential sum S(x, α) = Σ_{1 ≤ n ≤ x} Λ(n) e(nα). -/
def vonMangoldtExpSum (x : ℝ) (α : ℝ) : ℂ :=
  ∑ n ∈ Finset.Icc 1 (Nat.floor x),
    (↑(Λ n : ℝ) : ℂ) * eChar (↑n * α)

/-- The Chebyshev psi function ψ(x) = Σ_{1 ≤ n ≤ x} Λ(n). -/
def chebyshevPsi (x : ℝ) : ℝ :=
  ∑ n ∈ Finset.Icc 1 (Nat.floor x), (Λ n : ℝ)

-- ============================================================================
-- LAYER 1: TRIVIAL BOUNDS
-- ============================================================================

/-- e(0) = 1. -/
theorem eChar_zero : eChar 0 = 1 := by
  simp [eChar]

/-- e(θ) is multiplicative: e(a + b) = e(a) · e(b). -/
theorem eChar_add (a b : ℝ) : eChar (a + b) = eChar a * eChar b := by
  simp only [eChar]
  rw [show (2 : ℂ) * ↑Real.pi * Complex.I * ↑(a + b) =
    (2 * ↑Real.pi * Complex.I * ↑a) + (2 * ↑Real.pi * Complex.I * ↑b)
    from by push_cast; ring]
  exact Complex.exp_add _ _

/-- e(n) = 1 for integer n (periodicity). -/
theorem eChar_intCast (n : ℤ) : eChar (↑n) = 1 := by
  simp only [eChar]
  rw [show (2 : ℂ) * ↑Real.pi * Complex.I * ↑(↑n : ℝ) =
    ↑(↑n : ℝ) * (2 * ↑Real.pi * Complex.I) from by ring]
  push_cast
  exact Complex.exp_int_mul_two_pi_mul_I n

/-- **|e(θ)| = 1.** -/
theorem eChar_norm (θ : ℝ) : ‖eChar θ‖ = 1 := by
  unfold eChar
  have h : (2 : ℂ) * ↑Real.pi * Complex.I * ↑θ = ↑(2 * Real.pi * θ) * Complex.I := by
    push_cast; ring
  rw [h]
  exact Complex.norm_exp_ofReal_mul_I (2 * Real.pi * θ)

/-- Λ(n) ≥ 0 for all n. -/
theorem vonMangoldt_nonneg' (n : ℕ) : (0 : ℝ) ≤ Λ n := by
  exact_mod_cast ArithmeticFunction.vonMangoldt_nonneg

/-- **|S(x,α)| ≤ ψ(x).** -/
theorem vonMangoldtExpSum_norm_le_chebyshevPsi (x : ℝ) (α : ℝ) :
    ‖vonMangoldtExpSum x α‖ ≤ chebyshevPsi x := by
  unfold vonMangoldtExpSum chebyshevPsi
  calc ‖∑ n ∈ Finset.Icc 1 (Nat.floor x),
        (↑(Λ n : ℝ) : ℂ) * eChar (↑n * α)‖
      ≤ ∑ n ∈ Finset.Icc 1 (Nat.floor x),
        ‖(↑(Λ n : ℝ) : ℂ) * eChar (↑n * α)‖ :=
          norm_sum_le _ _
    _ = ∑ n ∈ Finset.Icc 1 (Nat.floor x),
        ‖(↑(Λ n : ℝ) : ℂ)‖ * ‖eChar (↑n * α)‖ := by
          congr 1; ext n; exact norm_mul _ _
    _ = ∑ n ∈ Finset.Icc 1 (Nat.floor x),
        ‖(↑(Λ n : ℝ) : ℂ)‖ := by
          congr 1; ext n; rw [eChar_norm, mul_one]
    _ = ∑ n ∈ Finset.Icc 1 (Nat.floor x), (Λ n : ℝ) := by
          congr 1; ext n
          exact Complex.norm_of_nonneg (vonMangoldt_nonneg' n)

/-- S(x, 0) = ψ(x). -/
theorem vonMangoldtExpSum_at_zero (x : ℝ) :
    vonMangoldtExpSum x 0 = ↑(chebyshevPsi x) := by
  unfold vonMangoldtExpSum chebyshevPsi
  push_cast
  congr 1; ext n
  simp [mul_zero, eChar_zero]

/-- Our chebyshevPsi equals Mathlib's Chebyshev.psi. -/
theorem chebyshevPsi_eq_psi (x : ℝ) : chebyshevPsi x = Chebyshev.psi x := by
  unfold chebyshevPsi Chebyshev.psi
  congr 1

/-
For x ≥ 400, the Mathlib bound log(4)*x + 2*√x*log(x) ≤ 2x.
-/
theorem mathlib_bound_le_two_x (x : ℝ) (hx : 400 ≤ x) :
    Real.log 4 * x + 2 * Real.sqrt x * Real.log x ≤ 2 * x := by
  -- Let $f(x)=\log x-c \sqrt{x}$ so that $f^{\prime}(x)=\frac{1}{x}-\frac{c}{2 \sqrt{x}}=\frac{2-c \sqrt{x}}{2 x}$.
  have h_deriv1 : ∀ x, (400 ≤ x → deriv (fun x => Real.log x - (2 - 2 * Real.log 2) / 2 * Real.sqrt x) x ≤ 0) := by
    intro x hx;
    norm_num [ Real.sqrt_eq_rpow, hx, Real.rpow_neg, show x ≠ 0 by linarith, show x ≠ 1 by linarith, Real.differentiableAt_log, Real.differentiableAt_exp, mul_comm ];
    rw [ Real.rpow_neg ( by positivity ) ];
    rw [ ← Real.sqrt_eq_rpow ];
    have := Real.log_two_lt_d9 ; norm_num at this ; nlinarith [ inv_pos.mpr ( by positivity : 0 < x ), inv_pos.mpr ( by positivity : 0 < Real.sqrt x ), mul_inv_cancel₀ ( by positivity : x ≠ 0 ), mul_inv_cancel₀ ( by positivity : Real.sqrt x ≠ 0 ), Real.sqrt_nonneg x, Real.sq_sqrt ( by positivity : 0 ≤ x ), pow_two_nonneg ( Real.sqrt x - 20 ) ];
  -- Since $f^{\prime}(x) \leq 0$ for $x \geq e^{2}$, we conclude $f(x) \leq f(e^{2})$.
  have h_decreasing1 : ∀ x, 400 ≤ x → Real.log x - (2 - 2 * Real.log 2) / 2 * Real.sqrt x ≤ Real.log 400 - (2 - 2 * Real.log 2) / 2 * Real.sqrt 400 := by
    intros x hx
    by_contra h_contra;
    -- Apply the Mean Value Theorem to the interval $[400, x]$.
    obtain ⟨c, hc⟩ : ∃ c ∈ Set.Ioo 400 x, deriv (fun x => Real.log x - (2 - 2 * Real.log 2) / 2 * Real.sqrt x) c = (Real.log x - (2 - 2 * Real.log 2) / 2 * Real.sqrt x - (Real.log 400 - (2 - 2 * Real.log 2) / 2 * Real.sqrt 400)) / (x - 400) := by
      apply_rules [ exists_deriv_eq_slope ];
      · exact hx.lt_of_ne ( by rintro rfl; norm_num at h_contra );
      · exact continuousOn_of_forall_continuousAt fun y hy => by exact ContinuousAt.sub ( Real.continuousAt_log ( by linarith [ hy.1 ] ) ) ( ContinuousAt.mul continuousAt_const ( Real.continuous_sqrt.continuousAt ) );
      · exact DifferentiableOn.sub ( DifferentiableOn.log differentiableOn_id fun x hx => by linarith [ hx.1 ] ) ( DifferentiableOn.mul ( differentiableOn_const _ ) ( DifferentiableOn.sqrt differentiableOn_id fun x hx => by linarith [ hx.1 ] ) );
    rw [ eq_div_iff ] at hc <;> nlinarith [ hc.1.1, hc.1.2, h_deriv1 c hc.1.1.le ];
  -- We'll use that $Real.log 400 < 6$ and $Real.sqrt 400 = 20$ to simplify the expression.
  have h_log_sqrt_400 : Real.log 400 < 6 ∧ Real.sqrt 400 = 20 := by
    norm_num [ Real.log_lt_iff_lt_exp ];
    have := Real.exp_one_gt_d9.le ; norm_num at * ; rw [ show Real.exp 6 = ( Real.exp 1 ) ^ 6 by rw [ ← Real.exp_nat_mul ] ; norm_num ] ; exact lt_of_lt_of_le ( by norm_num ) ( pow_le_pow_left₀ ( by positivity ) this _ );
  rw [ show ( 4 : ℝ ) = 2 ^ 2 by norm_num, Real.log_pow ];
  have := Real.log_two_lt_d9 ; norm_num at * ; nlinarith [ h_decreasing1 x hx, Real.sqrt_nonneg x, Real.sq_sqrt ( show 0 ≤ x by linarith ), Real.log_nonneg ( show 2 ≥ 1 by norm_num ) ]

/-
For 1 ≤ x < 400, ψ(x) ≤ 2x. Uses θ(x) ≤ log(4)*x and ψ(x)-θ(x) ≤ 2*√x*log(x).
-/
theorem chebyshevPsi_le_two_x_small (x : ℝ) (hx : 1 ≤ x) (hx' : x < 400) :
    Chebyshev.psi x ≤ 2 * x := by
  by_contra h_contra;
  -- For x < 400, we can use the fact that ψ(x) is equal to the sum of log(p) * floor(log_p(x)) for all prime powers p^k ≤ x.
  have h_sum : Chebyshev.psi x = ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p 399), Real.log p * (if p^k ≤ x then 1 else 0) := by
    have h_sum : Chebyshev.psi x = ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 (Nat.floor x)), ∑ k ∈ Finset.Icc 1 (Nat.log p (Nat.floor x)), Real.log p * (if p^k ≤ x then 1 else 0) := by
      rw [ ← chebyshevPsi_eq_psi ];
      -- Apply the definition of the von Mangoldt function to rewrite the sum.
      have h_vonMangoldt : ∀ n ∈ Finset.Icc 1 (Nat.floor x), (Λ n : ℝ) = ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 (Nat.floor x)), ∑ k ∈ Finset.Icc 1 (Nat.log p (Nat.floor x)), (if p^k = n then Real.log p else 0) := by
        intro n hn;
        by_cases h : ∃ p k : ℕ, Nat.Prime p ∧ k ≥ 1 ∧ p ^ k = n <;> simp_all +decide [ ArithmeticFunction.vonMangoldt ];
        · obtain ⟨ p, hp, k, hk, rfl ⟩ := h; simp_all +decide [ IsPrimePow ] ;
          rw [ Finset.sum_eq_single p ] <;> norm_num [ hp, hk ];
          · rw [ Finset.sum_eq_single k ] <;> norm_num [ hp, hk ];
            · rw [ if_pos ⟨ p, k, by simpa only [ ← Nat.prime_iff ] using hp, hk, rfl ⟩ ];
              rw [ Nat.Prime.pow_minFac ] <;> aesop;
            · exact fun b hb₁ hb₂ hb₃ hb₄ => False.elim <| hb₃ <| Nat.pow_right_injective hp.one_lt hb₄;
            · exact fun h => absurd h ( not_lt_of_ge ( Nat.le_log_of_pow_le hp.one_lt hn.2 ) );
          · intro q hq₁ hq₂ hq₃ hq₄; rw [ Finset.sum_eq_zero ] ; intros ; simp_all +decide [ Nat.Prime.pow_eq_iff ] ;
            intro h; have := congr_arg ( ·.factorization q ) h; norm_num at this; have := congr_arg ( ·.factorization p ) h; norm_num at this; aesop;
          · exact fun h => absurd ( h hp.two_le ) ( not_lt_of_ge ( Nat.le_trans ( Nat.le_self_pow ( by linarith ) _ ) hn.2 ) );
        · rw [ if_neg ];
          · exact Eq.symm ( Finset.sum_eq_zero fun p hp => Finset.sum_eq_zero fun k hk => if_neg <| h p ( Finset.mem_filter.mp hp |>.2 ) k ( Finset.mem_Icc.mp hk |>.1 ) );
          · rw [ isPrimePow_nat_iff ] ; aesop;
      rw [ show chebyshevPsi x = ∑ n ∈ Finset.Icc 1 ⌊x⌋₊, ( Λ n : ℝ ) from rfl, Finset.sum_congr rfl h_vonMangoldt ];
      rw [ Finset.sum_comm, Finset.sum_congr rfl ];
      intro p hp; rw [ Finset.sum_comm ] ; simp +decide [ Finset.sum_ite ] ;
      norm_num [ Nat.le_floor_iff ( by positivity : 0 ≤ x ) ];
      exact Or.inl ( congr_arg _ ( Finset.filter_congr fun i hi => by exact ⟨ fun hi' => hi'.2, fun hi' => ⟨ Nat.one_le_pow _ _ ( Nat.Prime.pos ( Finset.mem_filter.mp hp |>.2 ) ), hi' ⟩ ⟩ ) );
    rw [h_sum];
    rw [ Finset.sum_subset ( show Finset.filter Nat.Prime ( Finset.Icc 2 ⌊x⌋₊ ) ⊆ Finset.filter Nat.Prime ( Finset.Icc 2 399 ) from Finset.filter_subset_filter _ <| Finset.Icc_subset_Icc_right <| Nat.le_of_lt_succ <| by exact Nat.floor_lt' ( by norm_num ) |>.2 <| by norm_num; linarith ) ];
    · refine' Finset.sum_congr rfl fun p hp => _;
      refine' Finset.sum_subset _ _ <;> intro k hk <;> norm_num at *;
      · exact ⟨ hk.1, hk.2.trans <| Nat.log_mono_right <| Nat.le_of_lt_succ <| Nat.floor_lt' ( by norm_num ) |>.2 <| by norm_num; linarith ⟩;
      · intro h₁ h₂; specialize h₁ hk.1; exact absurd h₁ ( not_lt_of_ge <| Nat.le_log_of_pow_le hp.2.one_lt <| Nat.le_floor <| mod_cast h₂ ) ;
    · simp;
      intro p hp₁ hp₂ hp₃ hp₄; rw [ Finset.sum_eq_zero ] ; intros ; aesop;
  -- We'll use that $x \geq 1$ and $x < 400$ to bound the sum.
  have h_bound : ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p 399), Real.log p * (if p^k ≤ x then 1 else 0) ≤ ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p 399), Real.log p * (if p^k ≤ Nat.floor x then 1 else 0) := by
    norm_num [ Nat.le_floor_iff ( by positivity : 0 ≤ x ) ];
  -- Let's calculate the sum $\sum_{p \leq 399} \sum_{k=1}^{\log_p(399)} \log p \cdot \mathbf{1}_{p^k \leq \lfloor x \rfloor}$.
  have h_sum_calc : ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p 399), Real.log p * (if p^k ≤ Nat.floor x then 1 else 0) ≤ 2 * Nat.floor x := by
    have h_sum_calc : ∀ n : ℕ, 1 ≤ n → n ≤ 399 → ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p 399), Real.log p * (if p^k ≤ n then 1 else 0) ≤ 2 * n := by
      intros n hn hn';
      have h_sum_calc : ∀ n : ℕ, 1 ≤ n → n ≤ 399 → ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p 399), Real.log p * (if p^k ≤ n then 1 else 0) ≤ 2 * n := by
        intros n hn hn'
        have h_sum_calc : ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p 399), Real.log p * (if p^k ≤ n then 1 else 0) = ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p n), Real.log p := by
          refine' Finset.sum_congr rfl fun p hp => _;
          rw [ ← Finset.sum_subset ( Finset.Icc_subset_Icc_right ( Nat.log_mono_right hn' ) ) ] <;> norm_num;
          · rw [ Finset.sum_congr rfl fun x hx => if_pos <| Nat.pow_le_of_le_log ( by linarith ) <| by linarith [ Finset.mem_Icc.mp hx ] ] ; norm_num;
          · exact fun x hx₁ hx₂ hx₃ hx₄ => absurd ( hx₃ hx₁ ) ( not_lt_of_ge ( Nat.le_log_of_pow_le ( Nat.Prime.one_lt ( Finset.mem_filter.mp hp |>.2 ) ) hx₄ ) )
        rw [h_sum_calc];
        have h_sum_calc : ∀ n : ℕ, 1 ≤ n → n ≤ 399 → ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p n), Real.log p ≤ 2 * n := by
          intros n hn hn'
          have h_sum_calc : ∑ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), ∑ k ∈ Finset.Icc 1 (Nat.log p n), Real.log p = Real.log (∏ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), p ^ (Nat.log p n)) := by
            rw [ Real.log_prod ] <;> norm_num;
            intros; linarith;
          rw [ h_sum_calc, Real.log_le_iff_le_exp ];
          · have h_exp : Real.exp (2 * n) ≥ (∏ p ∈ Finset.filter Nat.Prime (Finset.Icc 2 399), p ^ (Nat.log p n)) := by
              have h_exp : Real.exp (2 * n) ≥ (2 : ℝ) ^ (2 * n) := by
                rw [ ← Real.rpow_natCast, Real.rpow_def_of_pos ] <;> norm_num;
                exact mul_le_of_le_one_left ( by positivity ) ( Real.log_two_lt_d9.le.trans ( by norm_num ) )
              refine le_trans ?_ h_exp;
              exact mod_cast by interval_cases n <;> native_decide;
            exact_mod_cast h_exp;
          · exact Finset.prod_pos fun p hp => pow_pos ( Nat.cast_pos.mpr <| Nat.Prime.pos <| Finset.mem_filter.mp hp |>.2 ) _;
        exact h_sum_calc n hn hn';
      exact h_sum_calc n hn hn';
    exact h_sum_calc _ ( Nat.floor_pos.mpr hx ) ( Nat.le_of_lt_succ ( Nat.floor_lt' ( by norm_num ) |>.2 ( by norm_num; linarith ) ) );
  exact h_contra <| h_sum.symm ▸ h_bound.trans <| h_sum_calc.trans <| mul_le_mul_of_nonneg_left ( Nat.floor_le <| by positivity ) zero_le_two

/-- Chebyshev's theorem (weak form): ψ(x) ≤ 2x for x ≥ 1. -/
theorem chebyshevPsi_le_two_x (x : ℝ) (hx : x ≥ 1) :
    chebyshevPsi x ≤ 2 * x := by
  rw [chebyshevPsi_eq_psi]
  by_cases h : x < 400
  · exact chebyshevPsi_le_two_x_small x hx h
  · push_neg at h
    exact le_trans (Chebyshev.psi_le hx) (mathlib_bound_le_two_x x h)

/-- **|S(x,α)| ≤ 2x.** -/
theorem vonMangoldtExpSum_trivial_bound (x : ℝ) (hx : x ≥ 1) (α : ℝ) :
    ‖vonMangoldtExpSum x α‖ ≤ 2 * x :=
  le_trans (vonMangoldtExpSum_norm_le_chebyshevPsi x α)
    (chebyshevPsi_le_two_x x hx)

-- ============================================================================
-- LAYER 2: ALGEBRAIC SPLITTING ON MAJOR ARCS
-- ============================================================================

/-- e(n(a/q + β)) = e(na/q) · e(nβ). -/
theorem eChar_split (n a : ℕ) (q : ℕ) (β : ℝ) :
    eChar (↑n * (↑a / ↑q + β)) = eChar (↑n * ↑a / ↑q) * eChar (↑n * β) := by
  rw [show (↑n : ℝ) * (↑a / ↑q + β) = ↑n * ↑a / ↑q + ↑n * β from by ring]
  exact eChar_add _ _

/-- S(x, a/q + β) = Σ Λ(n) · e(na/q) · e(nβ). -/
theorem vonMangoldtExpSum_split (x : ℝ) (a q : ℕ) (β : ℝ) :
    vonMangoldtExpSum x (↑a / ↑q + β) =
    ∑ n ∈ Finset.Icc 1 (Nat.floor x),
      (↑(Λ n : ℝ) : ℂ) * eChar (↑n * ↑a / ↑q) * eChar (↑n * β) := by
  unfold vonMangoldtExpSum
  congr 1; ext n
  rw [eChar_split n a q β, ← mul_assoc]

/-- If n % q = r then e(n*a/q) = e(r*a/q). -/
theorem eChar_mod_eq (n a q : ℕ) (hq : 0 < q) (hr : n % q = r) :
    eChar (↑n * ↑a / ↑q) = eChar (↑r * ↑a / ↑q) := by
  subst hr
  have hq' : (q : ℝ) ≠ 0 := Nat.cast_ne_zero.mpr (by omega)
  set k := n / q
  have hn : n = q * k + n % q := (Nat.div_add_mod n q).symm
  have hn_real : (↑n : ℝ) = ↑q * ↑k + ↑(n % q) := by exact_mod_cast hn
  rw [show (↑n : ℝ) * ↑a / ↑q = ↑(k * a : ℤ) + ↑(n % q) * ↑a / ↑q from by
    rw [hn_real]; field_simp; push_cast; ring]
  rw [eChar_add, eChar_intCast, one_mul]

/-- Residue class exponential sum T_r(x, β). -/
def vonMangoldtExpSumResidueClass (x : ℝ) (β : ℝ) (q r : ℕ) : ℂ :=
  ∑ n ∈ (Finset.Icc 1 (Nat.floor x)).filter (fun n => n % q = r),
    (↑(Λ n : ℝ) : ℂ) * eChar (↑n * β)

/-
Residue class decomposition.
-/
theorem vonMangoldtExpSum_residue_decomp (x : ℝ) (a q : ℕ) (hq : 0 < q) (β : ℝ) :
    vonMangoldtExpSum x (↑a / ↑q + β) =
    ∑ r ∈ Finset.range q,
      eChar (↑r * ↑a / ↑q) * vonMangoldtExpSumResidueClass x β q r := by
  rw [ vonMangoldtExpSum_split ];
  simp +decide [ mul_assoc, Finset.mul_sum _ _ _, vonMangoldtExpSumResidueClass ];
  rw [ Finset.sum_sigma' ];
  refine' Finset.sum_bij ( fun n hn => ⟨ n % q, n ⟩ ) _ _ _ _ <;> simp +decide [ Nat.mod_lt _ hq ];
  · aesop;
  · intro n hn₁ hn₂; rw [ ← eChar_mod_eq n a q hq rfl ] ; ring;

-- ============================================================================
-- LAYER 3: CHARACTER ORTHOGONALITY
-- ============================================================================

/-- Siegel-Walfisz. -/
theorem residueClass_approximation (x : ℝ) (hx : x ≥ 2) (β : ℝ)
    (q : ℕ) (hq : 0 < q) (r : ℕ) (hr : Nat.Coprime r q) :
    ∃ (E : ℂ), vonMangoldtExpSumResidueClass x β q r =
      (1 / (Nat.totient q : ℂ)) * vonMangoldtExpSum x β + E ∧
      ‖E‖ ≤ x * Real.exp (-(Real.sqrt (Real.log x))) := by
  sorry

-- ============================================================================
-- LAYER 4: ASSEMBLY
-- ============================================================================

/-- **Major Arc Theorem** -/
theorem majorArc_evaluation_scaffolded (x : ℝ) (hx : x ≥ 2)
    (q : ℕ) (hq : 0 < q) (a : ℕ) (haq : Nat.Coprime a q)
    (β : ℝ) (hβ : |β| ≤ 1 / (↑q * x)) :
    ∃ (E : ℂ),
      vonMangoldtExpSum x (↑a / ↑q + β) =
        ((ArithmeticFunction.moebius q : ℂ) / (Nat.totient q : ℂ)) *
        vonMangoldtExpSum x β + E ∧
      ‖E‖ ≤ x * Real.exp (-(Real.sqrt (Real.log x))) := by
  sorry

-- ============================================================================
-- BONUS: Lemmas enabled by eChar_norm
-- ============================================================================

/-- |e(θ)|² = 1. -/
theorem eChar_normSq (θ : ℝ) : ‖eChar θ‖ ^ 2 = 1 := by
  rw [eChar_norm]; norm_num

/-- e(θ) ≠ 0. -/
theorem eChar_ne_zero (θ : ℝ) : eChar θ ≠ 0 := by
  intro h; have := eChar_norm θ; rw [h, norm_zero] at this; exact one_ne_zero this.symm

/-- conj(e(θ)) = e(-θ). -/
theorem eChar_conj (θ : ℝ) : starRingEnd ℂ (eChar θ) = eChar (-θ) := by
  simp only [eChar]
  rw [← Complex.exp_conj]
  congr 1
  simp only [map_mul, map_ofNat, Complex.conj_ofReal, Complex.conj_I]
  push_cast; ring

/-- e(θ) · e(-θ) = 1. -/
theorem eChar_mul_conj (θ : ℝ) : eChar θ * eChar (-θ) = 1 := by
  rw [← eChar_add]; simp [add_neg_cancel, eChar_zero]

/-- |S(x,α)|² ≥ 0. -/
theorem vonMangoldtExpSum_normSq_nonneg (x : ℝ) (α : ℝ) :
    (0 : ℝ) ≤ ‖vonMangoldtExpSum x α‖ ^ 2 := by positivity

end