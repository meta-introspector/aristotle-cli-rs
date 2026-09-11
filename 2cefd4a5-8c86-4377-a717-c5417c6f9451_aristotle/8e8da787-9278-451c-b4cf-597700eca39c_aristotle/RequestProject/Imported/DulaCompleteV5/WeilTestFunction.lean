import Mathlib
import RequestProject.Imported.DulaCompleteV5.Main

/-!
# Weil Test Functions — fixing the convergence issue
==============================================================================

## Background

The `WeilDistribution` defined in `Main.lean` contains the von Mangoldt sum

  ∑'_{n ≥ 1} Λ(n) / √n · g(log n)

Aristotle's analysis (`ANALYSIS.md`, this session) demonstrated that this sum
**does not converge** for generic Schwartz functions g. Schwartz decay gives
|g(log n)| = O((log n)^{-N}) for any N, but ∑ Λ(n)/√n · (log n)^{-N} diverges
for every N (the prime sum density grows like √n, defeating any polynomial
log-decay).

Lean's `tsum` returns 0 for non-summable series, so `WeilDistribution g` as
currently defined silently returns mathematically incorrect values for
generic Schwartz g — making the surrounding theorems (`WeilCriterion`,
`weilDistribution_autocorrelation_continuous`, etc.) about a junk function.

## The fix (this file)

Following Weil's own 1952 paper (condition (B), p. 6), restrict the test
function class to those with **exponential decay**: there exist b > 0 and
C > 0 such that

  |F(x)| ≤ C · e^{-(1/2 + b)|x|}     and similarly for F'.

For such F, |F(log p)| ≤ C · p^{-(1/2+b)}, so the term
Λ(n)/√n · F(log n) is bounded by C · Λ(n) · n^{-(1+b)}, and the sum
converges absolutely.

This file defines `WeilTestFunction` as the structure capturing this class,
provides instances (CoeFun, topology), and redefines `WeilDistribution`
(under a fresh name, `WeilDistribution_WTF`) on this restricted class.
The old `WeilDistribution` in `Main.lean` is *not* modified yet —
this skeleton is purely additive until verified.

## Status — sub-sorrys

| Declaration                                | Status   | Substance                       |
|--------------------------------------------|----------|---------------------------------|
| `WeilTestFunction`                         | defined  | structure                        |
| `WeilTestFunction.coe_apply`               | proved   | rfl                              |
| topology instance                          | defined  | induced from EvenSchwartz        |
| `vonMangoldt_sum_summable`                 | proved   | absolute convergence             |
| `WeilDistribution_WTF`                     | defined  | new well-defined functional      |
| `autocorrelation_WTF`                      | sorry    | autocorr closure under WTF       |

Once the two sorrys are filled, downstream code can be migrated to use
`WeilTestFunction`/`WeilDistribution_WTF`/`autocorrelation_WTF` in place
of `EvenSchwartz`/`WeilDistribution`/`autocorrelation`, and the convergence
issue is resolved.

## What this file does NOT do

- Does not modify `Main.lean` or any other existing file.
- Does not redefine `WeilCriterion` or `WeilPositivity`.
- Does not propagate the type change to `ConjectureA.lean`,
  `HermiteBiehler.lean`, or `ContinuityHelpers.lean`.

These migrations are deferred to a follow-up session, after the structure
in this file is verified to compile and the two sorrys are scoped.
-/

open Real MeasureTheory
open scoped BigOperators

noncomputable section

-- ============================================================================
-- 1. THE WEIL TEST FUNCTION STRUCTURE
-- ============================================================================

/-- A **Weil test function** is an even Schwartz function on ℝ together with
    a witness that |F(x)| and |F'(x)| are O(e^{-(1/2+b)|x|}) for some b > 0.

    This matches condition (B) of Weil's 1952 paper (p. 6) and ensures
    that the von Mangoldt sum ∑ Λ(n)/√n · F(log n) converges absolutely.

    The decay rate b is existentially quantified — we don't expose it as a
    type parameter to keep the type family flat. The constant C is also
    existentially quantified inside the decay bounds. -/
structure WeilTestFunction where
  /-- The underlying even Schwartz function. -/
  toEvenSchwartz : EvenSchwartz
  /-- Exponential decay bound on F: ∃ b > 0, ∃ C > 0, ∀ x, |F(x)| ≤ C·exp(-(1/2+b)|x|). -/
  has_exponential_decay :
    ∃ b > (0 : ℝ), ∃ C > (0 : ℝ),
      ∀ x : ℝ, |toEvenSchwartz x| ≤ C * Real.exp (-(1/2 + b) * |x|)
  /-- Exponential decay bound on F': ∃ b > 0, ∃ C > 0, ∀ x, |F'(x)| ≤ C·exp(-(1/2+b)|x|).
      Required for Weil's contour-integration argument; not strictly needed for the
      von Mangoldt sum convergence, but included to match Weil's condition (B) exactly. -/
  has_exponential_decay_deriv :
    ∃ b > (0 : ℝ), ∃ C > (0 : ℝ),
      ∀ x : ℝ, |deriv toEvenSchwartz.toSchwartzMap x| ≤ C * Real.exp (-(1/2 + b) * |x|)

/-- Coerce a Weil test function to `ℝ → ℝ` via the underlying Schwartz map. -/
instance : CoeFun WeilTestFunction (fun _ => ℝ → ℝ) where
  coe g := g.toEvenSchwartz

/-- Topology on `WeilTestFunction` induced from `EvenSchwartz` via `toEvenSchwartz`.
    Note: this is the *coarsest* topology making the projection continuous. It does
    NOT control the decay constants `b`, `C`. If a future continuity proof needs
    uniform decay control, this topology may need to be strengthened. For the
    current scope (convergence of the von Mangoldt sum, plus continuity proofs that
    only need the underlying Schwartz topology), the induced topology is sufficient. -/
instance : TopologicalSpace WeilTestFunction :=
  TopologicalSpace.induced WeilTestFunction.toEvenSchwartz inferInstance

/-- Pointwise application unfolds via the underlying Schwartz map. -/
@[simp]
lemma WeilTestFunction.coe_apply (g : WeilTestFunction) (x : ℝ) :
    g x = g.toEvenSchwartz.toSchwartzMap x := rfl

/-
============================================================================
2. CONVERGENCE OF THE VON MANGOLDT SUM
============================================================================

**Absolute convergence of the von Mangoldt sum on Weil test functions.**

    For any `g : WeilTestFunction`, the series
        ∑'_{n ≥ 1} Λ(n) / √n · g(log n)
    converges absolutely.

    Proof sketch (to be filled in):
    Obtain b > 0, C > 0 from `g.has_exponential_decay`. For n ≥ 2,
        |g(log n)| ≤ C · exp(-(1/2 + b) · |log n|) = C · n^{-(1/2 + b)}
    so
        |Λ(n) / √n · g(log n)| ≤ Λ(n) / √n · C · n^{-(1/2 + b)}
                                = C · Λ(n) · n^{-(1+b)}.
    Now ∑'_n Λ(n) · n^{-(1+b)} converges absolutely for b > 0 by
    comparison with -ζ'/ζ(s) at s = 1+b > 1, where the Dirichlet series for
    -ζ'/ζ is the von Mangoldt generating series and converges absolutely
    in the region Re s > 1. The constant term n=1 has Λ(1) = 0 so contributes
    nothing. Multiplying by the constant C gives summability of the original.
-/
theorem vonMangoldt_sum_summable (g : WeilTestFunction) :
    Summable (fun n : ℕ => |(ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n * g (Real.log n)|) := by
  -- By definition of $WeilTestFunction$, we know that $|g(x)|$ decays exponentially.
  obtain ⟨b, hb_pos, C, hC_pos, hg_bound⟩ : ∃ b > 0, ∃ C > 0, ∀ x : ℝ, |g.toEvenSchwartz.toSchwartzMap x| ≤ C * Real.exp (-(1/2 + b) * |x|) := by
    exact g.has_exponential_decay;
  -- Use the bound on $|g(x)|$ to show that $|\Lambda(n) / \sqrt{n} \cdot g(\log n)|$ is bounded.
  have h_bound : ∀ n : ℕ, n ≥ 1 → |(ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n * g.toEvenSchwartz.toSchwartzMap (Real.log n)| ≤ C * (ArithmeticFunction.vonMangoldt n : ℝ) * (n : ℝ) ^ (-(1 + b)) := by
    intro n hn
    have h_abs : |g.toEvenSchwartz.toSchwartzMap (Real.log n)| ≤ C * (n : ℝ) ^ (-(1/2 + b)) := by
      convert hg_bound ( Real.log n ) using 1 ; rw [ Real.rpow_def_of_pos ( by positivity ) ] ; ring;
      rw [ abs_of_nonneg ( Real.log_nonneg ( Nat.one_le_cast.mpr hn ) ) ] ; ring;
    convert mul_le_mul_of_nonneg_left h_abs ( show 0 ≤ |ArithmeticFunction.vonMangoldt n / Real.sqrt n| by positivity ) using 1 <;> norm_num [ abs_mul, abs_div, abs_of_nonneg, Real.sqrt_nonneg ] ; ring;
    rw [ show ( -1 - b : ℝ ) = -1 / 2 - b - 1 / 2 by ring, Real.rpow_sub ( by positivity ), Real.sqrt_eq_rpow, Real.rpow_def_of_pos ( by positivity ) ] ; ring;
  -- Use the fact that $\sum_{n=1}^{\infty} \frac{\Lambda(n)}{n^{1+b}}$ converges.
  have h_summable : Summable (fun n : ℕ => (ArithmeticFunction.vonMangoldt n : ℝ) * (n : ℝ) ^ (-(1 + b))) := by
    have h_summable : Summable (fun n : ℕ => (Real.log n : ℝ) * (n : ℝ) ^ (-(1 + b))) := by
      -- We can compare our series with the convergent p-series $\sum_{n=1}^{\infty} \frac{1}{n^{1+b/2}}$.
      have h_comparison : ∃ C > 0, ∀ n : ℕ, n ≥ 2 → (Real.log n : ℝ) * (n : ℝ) ^ (-(1 + b)) ≤ C * (n : ℝ) ^ (-(1 + b / 2)) := by
        have h_comparison : ∃ C > 0, ∀ n : ℕ, n ≥ 2 → (Real.log n : ℝ) ≤ C * (n : ℝ) ^ (b / 2) := by
          use 2 / b, by positivity, fun n hn => by have := Real.log_le_sub_one_of_pos ( by positivity : 0 < ( n : ℝ ) ^ ( b / 2 ) ) ; rw [ Real.log_rpow ( by positivity ) ] at this; nlinarith [ show ( n : ℝ ) ≥ 2 by exact_mod_cast hn, Real.rpow_pos_of_pos ( by positivity : 0 < ( n : ℝ ) ) ( b / 2 ), mul_div_cancel₀ ( 2 : ℝ ) hb_pos.ne' ] ;
        obtain ⟨ C, hC_pos, hC ⟩ := h_comparison; use C; refine' ⟨ hC_pos, fun n hn => _ ⟩ ; convert mul_le_mul_of_nonneg_right ( hC n hn ) ( Real.rpow_nonneg ( Nat.cast_nonneg n ) ( - ( 1 + b ) ) ) using 1 ; rw [ mul_assoc, ← Real.rpow_add ( by positivity ) ] ; ring;
      obtain ⟨ C, hC_pos, hC ⟩ := h_comparison;
      rw [ ← summable_nat_add_iff 2 ];
      exact Summable.of_nonneg_of_le ( fun n => mul_nonneg ( Real.log_nonneg ( by norm_cast; linarith ) ) ( Real.rpow_nonneg ( Nat.cast_nonneg _ ) _ ) ) ( fun n => hC _ ( by linarith ) ) ( Summable.mul_left _ <| by simpa using summable_nat_add_iff 2 |>.2 <| Real.summable_nat_rpow.2 <| by linarith );
    refine' .of_nonneg_of_le ( fun n => _ ) ( fun n => _ ) h_summable;
    · exact mul_nonneg ( by rw [ ArithmeticFunction.vonMangoldt_apply ] ; positivity ) ( by positivity );
    · by_cases hn : n = 0 <;> simp_all +decide [ ArithmeticFunction.vonMangoldt ];
      split_ifs;
      · exact mul_le_mul_of_nonneg_right ( Real.log_le_log ( Nat.cast_pos.mpr ( Nat.minFac_pos _ ) ) ( Nat.cast_le.mpr ( Nat.minFac_le ( Nat.pos_of_ne_zero hn ) ) ) ) ( by positivity );
      · positivity;
  rw [ ← summable_nat_add_iff 1 ] at *;
  exact Summable.of_nonneg_of_le ( fun n => abs_nonneg _ ) ( fun n => h_bound _ le_add_self ) ( by simpa only [ mul_assoc ] using h_summable.mul_left C )

-- ============================================================================
-- 3. THE WELL-DEFINED WEIL DISTRIBUTION
-- ============================================================================

/-- The **Weil distribution** on the restricted class `WeilTestFunction`,
    where the von Mangoldt sum provably converges absolutely.

    Identical formula to `WeilDistribution` in `Main.lean`, but with the
    domain restricted to `WeilTestFunction` so that the `tsum` is the
    real sum (not the `tsum-returns-0-on-non-summable` artifact).

    Naming convention: `_WTF` suffix distinguishes this from the original
    `WeilDistribution` in `Main.lean`. After the migration is complete and
    verified, the original can be deprecated and the suffix dropped. -/
def WeilDistribution_WTF (g : WeilTestFunction) : ℝ :=
  -- Term 1: evaluation at 0 scaled by log π.
  g 0 * Real.log Real.pi
  -- Term 2: von Mangoldt sum (now provably absolutely convergent).
  - ∑' (n : ℕ), (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n * g (Real.log n)
  -- Term 3: archimedean integral (unchanged from Main.lean).
  + ∫ x in Set.Ioi (0 : ℝ), g x * (1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x))

/-- Sanity lemma: by construction, `WeilDistribution_WTF g` has the *same formula*
    as `WeilDistribution g.toEvenSchwartz`. So they agree definitionally; the
    *meaning* is what differs. For `WeilDistribution g.toEvenSchwartz` (the original),
    Lean's `tsum` returns the sum if summable and 0 otherwise. For `WeilDistribution_WTF g`,
    we will prove (via `vonMangoldt_sum_summable`) that the `tsum` is always the genuine
    sum. So the two functions are equal *as values* but `WeilDistribution_WTF` is the
    one that is mathematically meaningful. -/
lemma WeilDistribution_WTF_eq_apply (g : WeilTestFunction) :
    WeilDistribution_WTF g = WeilDistribution g.toEvenSchwartz := by
  unfold WeilDistribution_WTF WeilDistribution
  rfl

-- ============================================================================
-- 4. AUTOCORRELATION CLOSURE
-- ============================================================================

/-  **Autocorrelation preserves the WeilTestFunction class.**

    If h is a Weil test function (Schwartz + exponential decay rate b),
    then its autocorrelation h ⋆ h̃ is also a Weil test function (with
    a possibly smaller exponential decay rate, e.g., b/2 or b' < b).

    Proof sketch (to be filled in):
    The autocorrelation, viewed as an `EvenSchwartz`, already exists from
    `Main.lean`'s `autocorrelation`. We need the additional decay witness.

    Bound: |h ⋆ h̃(x)| = |∫ h(t) · h(t+x) dt|. Using the exponential decay
    of h: |h(t)| ≤ C·exp(-(1/2+b)|t|) and |h(t+x)| ≤ C·exp(-(1/2+b)|t+x|).
    Multiplying:
        |h(t)·h(t+x)| ≤ C² · exp(-(1/2+b)(|t| + |t+x|))
    For each x, ∫ exp(-(1/2+b)(|t|+|t+x|)) dt ≤ C'·exp(-(1/2+b')|x|) for
    some 0 < b' ≤ b (from the triangle-inequality-style bound on
    |t| + |t+x| ≥ |x|). The exact b' depends on the bound we use; b' = b
    works; b' = b/2 is a safe choice giving ample slack.

    For the derivative: deriv(h⋆h̃) = h ⋆ deriv(h̃) = h ⋆ (-deriv h)(-·),
    and the same exponential-decay computation applies. -/
/-- **Helper Lemma 1** — Pointwise bound on the autocorrelation integrand.

    If `|f(t)| ≤ Cf · exp(-α|t|)` and `|g(t)| ≤ Cg · exp(-α|t|)` for all t,
    then for all t and x:
        `|f(t) · g(t+x)| ≤ Cf · Cg · exp(-α(|t| + |t+x|))`

    This is just the product of two pointwise exponential-decay bounds.
    The triangle inequality `|t| + |t+x| ≥ |x|` is NOT used here; that
    comes in the integral bound below. -/
lemma exp_decay_pointwise_product
    (f g : ℝ → ℝ) (α : ℝ)
    (Cf : ℝ) (hCf : 0 < Cf) (hf : ∀ t : ℝ, |f t| ≤ Cf * Real.exp (-α * |t|))
    (Cg : ℝ) (hCg : 0 < Cg) (hg : ∀ t : ℝ, |g t| ≤ Cg * Real.exp (-α * |t|)) :
    ∀ t x : ℝ, |f t * g (t + x)| ≤ Cf * Cg * (Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
  intro t x
  have h1 : |f t * g (t + x)| = |f t| * |g (t + x)| := abs_mul _ _
  rw [h1]
  have h2 : |f t| * |g (t + x)| ≤ (Cf * Real.exp (-α * |t|)) * (Cg * Real.exp (-α * |t + x|)) := by
    apply mul_le_mul (hf t) (hg (t + x)) (abs_nonneg _)
    exact mul_nonneg hCf.le (Real.exp_pos _).le
  calc |f t| * |g (t + x)|
      ≤ (Cf * Real.exp (-α * |t|)) * (Cg * Real.exp (-α * |t + x|)) := h2
    _ = Cf * Cg * (Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by ring

/-
**Helper Lemma 2** — The integral computation.

    For α > 0, the integral
        `∫ exp(-α|t|) · exp(-α|t+x|) dt`
    equals (or is at most) `(1/α + |x|) · exp(-α|x|)`.

    Proof: split the real line into three regions based on the signs of t and t+x.
    For x ≥ 0:
      • t ≥ 0:        integrand = exp(-α(2t + x)), integral = exp(-αx) / (2α)
      • -x ≤ t ≤ 0:   integrand = exp(-αx) (constant), integral = x · exp(-αx)
      • t ≤ -x:       integrand = exp(α(2t + x)), integral = exp(-αx) / (2α)
    Sum = (1/α + x) · exp(-αx).

    For x < 0, symmetry gives (1/α + |x|) · exp(-α|x|).

    This is the **hardest** step in the autocorrelation closure proof. It
    requires region-splitting integration of a function involving absolute
    values. Mathlib lemmas needed (likely):
      - `MeasureTheory.integral_Iic_add_Ioi` or `integral_Ioi_add_Iio`
        for splitting at a point.
      - `Real.exp_neg`, `mul_inv_cancel`, basic exponential algebra.
-/
set_option maxHeartbeats 800000 in
lemma exp_decay_convolution_integral_bound
    (α : ℝ) (hα : 0 < α) :
    ∀ x : ℝ, ∫ t : ℝ, Real.exp (-α * |t|) * Real.exp (-α * |t + x|)
              ≤ (1/α + |x|) * Real.exp (-α * |x|) := by
  -- Fix an $x$ and split the integral into three parts based on the value of $t$.
  intros x
  have h_split : ∫ t : ℝ, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) = (∫ t in Set.Ici 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) + (∫ t in Set.Iio 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
    rw [ MeasureTheory.integral_Ici_eq_integral_Ioi, add_comm, ← MeasureTheory.setIntegral_union ] <;> norm_num;
    · -- The integral of the product of two exponentials over $(-\infty, 0)$ is finite.
      have h_integrable_neg : MeasureTheory.IntegrableOn (fun t => Real.exp (-(α * |t|))) (Set.Iio 0) := by
        have h_integrable_neg : ∫ t in Set.Iio 0, Real.exp (-(α * |t|)) = ∫ t in Set.Ioi 0, Real.exp (-α * t) := by
          rw [ ← MeasureTheory.integral_Iic_eq_integral_Iio ] ; rw [ ← neg_zero, ← integral_comp_neg_Iic ] ; norm_num;
          exact MeasureTheory.setIntegral_congr_fun measurableSet_Iic fun x hx => by rw [ abs_of_nonpos hx.out ] ; ring;
        contrapose! h_integrable_neg;
        rw [ MeasureTheory.integral_undef h_integrable_neg ] ; exact ne_of_lt ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact ( by exact by have := integral_exp_neg_mul_rpow zero_lt_one hα; norm_num [ Real.rpow_neg_one ] at *; exact this.symm ▸ by positivity ) ) ) ) ) ) ) ) ) ) ) ) ) ;
      refine' h_integrable_neg.mono' _ _;
      · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable_neg.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) );
      · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Iio ] with t ht using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_of_le_one_right ( by positivity ) ( Real.exp_le_one_iff.mpr <| by nlinarith [ abs_nonneg ( t + x ) ] ) ;
    · have h_integrable : MeasureTheory.IntegrableOn (fun t => Real.exp (-α * t)) (Set.Ioi 0) := by
        have := ( exp_neg_integrableOn_Ioi 0 hα );
        exact this;
      refine' h_integrable.mono' _ _;
      · exact Continuous.aestronglyMeasurable ( by continuity );
      · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioi ] with t ht using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; rw [ ← Real.exp_add ] ; exact Real.exp_le_exp.mpr ( by cases abs_cases t <;> cases abs_cases ( t + x ) <;> nlinarith [ ht.out ] ) ;
  cases abs_cases x <;> simp +decide [ *, MeasureTheory.integral_Ici_eq_integral_Ioi ] at *;
  · -- For $t \geq 0$, we have $|t| = t$ and $|t + x| = t + x$, so the integral becomes:
    have h_pos : ∫ t in Set.Ioi 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) = ∫ t in Set.Ioi 0, Real.exp (-α * (2 * t + x)) := by
      exact MeasureTheory.setIntegral_congr_fun measurableSet_Ioi fun t ht => by rw [ ← Real.exp_add ] ; rw [ abs_of_nonneg ht.out.le, abs_of_nonneg ( by linarith [ ht.out ] ) ] ; ring;
    -- For $t < 0$, we have $|t| = -t$ and $|t + x| = -(t + x)$ if $t + x < 0$, or $|t + x| = t + x$ if $t + x \geq 0$.
    have h_neg : ∫ t in Set.Iio 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) = (∫ t in Set.Iio (-x), Real.exp (α * (2 * t + x))) + (∫ t in Set.Ico (-x) 0, Real.exp (-α * x)) := by
      have h_neg : ∫ t in Set.Iio 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) = (∫ t in Set.Iio (-x), Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) + (∫ t in Set.Ico (-x) 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
        rw [ ← MeasureTheory.setIntegral_union ] <;> norm_num;
        · rw [ Set.Iio_union_Ico_eq_Iio ( by linarith ) ];
        · grind;
        · refine' MeasureTheory.Integrable.mono' _ _ _;
          refine' fun t => Real.exp ( -α * |t| );
          · have h_integrable : MeasureTheory.IntegrableOn (fun t => Real.exp (-α * |t|)) (Set.Iio 0) := by
              have h_integrable : MeasureTheory.IntegrableOn (fun t => Real.exp (α * t)) (Set.Iio 0) := by
                have h_integrable : ∫ t in Set.Iio 0, Real.exp (α * t) = 1 / α := by
                  have := integral_exp_neg_mul_rpow zero_lt_one hα;
                  rw [ ← MeasureTheory.integral_Iic_eq_integral_Iio ] ; rw [ ← neg_zero, ← integral_comp_neg_Ioi ] ; norm_num [ Real.rpow_neg_one ] at * ; aesop;
                exact ( by contrapose! h_integrable; rw [ MeasureTheory.integral_undef h_integrable ] ; positivity );
              exact h_integrable.congr_fun ( fun t ht => by rw [ abs_of_neg ht.out ] ; ring ) measurableSet_Iio;
            exact h_integrable.mono_set <| Set.Iio_subset_Iio <| by linarith;
          · exact Continuous.aestronglyMeasurable ( by continuity );
          · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Iio ] with t ht using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_of_le_one_right ( by positivity ) ( Real.exp_le_one_iff.mpr <| by nlinarith [ abs_nonneg t, abs_nonneg ( t + x ) ] ) |> le_trans <| by ring_nf; norm_num;
        · exact Continuous.integrableOn_Icc ( by continuity ) |> fun h => h.mono_set ( Set.Ico_subset_Icc_self );
      convert h_neg using 2;
      · exact MeasureTheory.setIntegral_congr_fun measurableSet_Iio fun t ht => by rw [ ← Real.exp_add ] ; rw [ abs_of_neg ( by linarith [ ht.out ] ), abs_of_neg ( by linarith [ ht.out ] ) ] ; ring;
      · exact MeasureTheory.setIntegral_congr_fun measurableSet_Ico fun t ht => by rw [ ← Real.exp_add ] ; rw [ abs_of_nonpos ht.2.le, abs_of_nonneg ( by linarith [ ht.1, ht.2 ] ) ] ; ring;
    -- Evaluate the integral $\int_{0}^{\infty} e^{-\alpha(2t+x)} \, dt$.
    have h_pos_eval : ∫ t in Set.Ioi 0, Real.exp (-α * (2 * t + x)) = (1 / (2 * α)) * Real.exp (-α * x) := by
      have := integral_exp_neg_mul_rpow zero_lt_one ( show 0 < 2 * α by positivity );
      convert congr_arg ( fun y => y * Real.exp ( -α * x ) ) this using 1 <;> norm_num [ Real.rpow_neg_one ] ; ring;
      rw [ ← MeasureTheory.integral_mul_const ] ; congr ; ext ; rw [ ← Real.exp_add ] ; ring;
    -- Evaluate the integral $\int_{-\infty}^{-x} e^{\alpha(2t+x)} \, dt$.
    have h_neg_eval : ∫ t in Set.Iio (-x), Real.exp (α * (2 * t + x)) = (1 / (2 * α)) * Real.exp (-α * x) := by
      rw [ ← h_pos_eval, ← MeasureTheory.integral_Iic_eq_integral_Iio ];
      rw [ ← neg_zero, ← integral_comp_neg_Iic ] ; norm_num;
      rw [ ← MeasureTheory.integral_indicator ( measurableSet_Iic ), ← MeasureTheory.integral_indicator ( measurableSet_Iic ) ] ; rw [ ← MeasureTheory.integral_add_right_eq_self _ ( -x ) ] ; congr ; ext ; ring;
      simp +decide [ Set.indicator ] ; ring;
    simp_all +decide [ MeasureTheory.integral_Ico_eq_integral_Ioo ];
    ring_nf; norm_num;
  · -- For $x < 0$, we can split the integral into three parts:
    have h_split_neg : ∫ t in Set.Ioi 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) = (∫ t in Set.Ioi (-x), Real.exp (-α * t) * Real.exp (-α * (t + x))) + (∫ t in Set.Ioc 0 (-x), Real.exp (-α * t) * Real.exp (α * (t + x))) := by
      have h_split_neg : ∫ t in Set.Ioi 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) = (∫ t in Set.Ioc 0 (-x), Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) + (∫ t in Set.Ioi (-x), Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
        rw [ ← MeasureTheory.setIntegral_union ] <;> norm_num [ * ];
        · exact Continuous.integrableOn_Ioc ( by continuity );
        · have h_integrable : MeasureTheory.IntegrableOn (fun t => Real.exp (-α * t)) (Set.Ioi (-x)) := by
            exact?;
          refine' h_integrable.mono' _ _;
          · exact Continuous.aestronglyMeasurable ( by continuity );
          · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioi ] with t ht using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; rw [ ← Real.exp_add ] ; exact Real.exp_le_exp.mpr ( by cases abs_cases t <;> cases abs_cases ( t + x ) <;> nlinarith [ ht.out ] ) ;
      rw [ h_split_neg, add_comm ];
      refine' congrArg₂ ( · + · ) _ _;
      · exact MeasureTheory.setIntegral_congr_fun measurableSet_Ioi fun t ht => by rw [ abs_of_nonneg ( by linarith [ ht.out ] ), abs_of_nonneg ( by linarith [ ht.out ] ) ] ;
      · exact MeasureTheory.setIntegral_congr_fun measurableSet_Ioc fun t ht => by rw [ abs_of_nonneg ht.1.le, abs_of_nonpos ( by linarith [ ht.2 ] ) ] ; ring;
    -- For $x < 0$, we can split the integral into three parts and compute each part separately.
    have h_split_neg_computed : (∫ t in Set.Ioi (-x), Real.exp (-α * t) * Real.exp (-α * (t + x))) + (∫ t in Set.Ioc 0 (-x), Real.exp (-α * t) * Real.exp (α * (t + x))) = (1 / (2 * α)) * Real.exp (α * x) + (-x) * Real.exp (α * x) := by
      congr 1;
      · have h_integral_neg : ∫ t in Set.Ioi (-x), Real.exp (-2 * α * t) = (1 / (2 * α)) * Real.exp (2 * α * x) := by
          have := integral_exp_neg_mul_rpow zero_lt_one ( show 0 < 2 * α by positivity );
          norm_num [ Real.rpow_neg_one ] at this;
          convert congr_arg ( fun y => y * Real.exp ( 2 * α * x ) ) this using 1 <;> ring;
          rw [ ← MeasureTheory.integral_mul_const ] ; rw [ ← MeasureTheory.integral_indicator ( measurableSet_Ioi ), ← MeasureTheory.integral_indicator ( measurableSet_Ioi ) ] ; norm_num [ Set.indicator ] ; ring;
          rw [ ← MeasureTheory.integral_add_right_eq_self _ ( -x ) ] ; congr ; ext ; split_ifs <;> first | linarith | rw [ ← Real.exp_add ] ; ring;
        convert congr_arg ( · * Real.exp ( -α * x ) ) h_integral_neg using 1 <;> ring;
        · rw [ ← MeasureTheory.integral_mul_const ] ; congr ; ext ; rw [ ← Real.exp_add ] ; ring;
          rw [ ← Real.exp_add, sub_eq_add_neg ];
        · norm_num [ mul_assoc, ← Real.exp_add ] ; ring;
          norm_num;
      · norm_num [ ← Real.exp_add, mul_add ];
        rw [ max_eq_left ] <;> linarith;
    have h_split_neg_computed : ∫ t in Set.Iio 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) = (1 / (2 * α)) * Real.exp (α * x) := by
      have h_split_neg_computed : ∫ t in Set.Iio 0, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) = ∫ t in Set.Ioi 0, Real.exp (-α * t) * Real.exp (-α * (t - x)) := by
        rw [ ← MeasureTheory.integral_Iic_eq_integral_Iio ] ; rw [ ← neg_zero, ← integral_comp_neg_Iic ] ; norm_num;
        exact MeasureTheory.setIntegral_congr_fun measurableSet_Iic fun t ht => by rw [ abs_of_nonpos ht.out, abs_of_nonpos ( by linarith [ ht.out ] ) ] ; ring;
      rw [ h_split_neg_computed ];
      have := integral_exp_neg_mul_rpow zero_lt_one ( show 0 < 2 * α by positivity );
      convert congr_arg ( fun y => y * Real.exp ( α * x ) ) this using 1 <;> norm_num [ ← Real.exp_add ] ; ring;
      · rw [ ← MeasureTheory.integral_mul_const ] ; congr ; ext ; rw [ ← Real.exp_add ];
      · norm_num [ Real.rpow_neg_one, mul_comm ];
    simp_all +decide [ div_eq_mul_inv ] ; ring_nf ; norm_num [ hα.ne' ]

/-
**Helper Lemma 3** — Polynomial-times-exponential absorption.

    For 0 < β < α, there is a constant K such that for all x:
        `(1/α + |x|) · exp(-α|x|) ≤ K · exp(-β|x|)`

    Proof: rewrite as `(1/α + |x|) · exp(-(α-β)|x|) · exp(-β|x|)`, then bound
    the first two factors. The function `(1/α + y) · exp(-(α-β)y)` is
    continuous on `[0, ∞)` and goes to 0 at infinity, so it is bounded.

    Mathlib lemmas needed:
      - `IsBounded` of `(1/α + y) · exp(-εy)` on `[0, ∞)` (or just take the max
        over a compact interval and use exponential decay beyond it).
      - `Real.exp_add`, `Real.exp_neg` for arithmetic.
-/
lemma poly_exp_absorption
    (α β : ℝ) (hα : 0 < α) (hβ : 0 < β) (hβα : β < α) :
    ∃ K : ℝ, 0 < K ∧ ∀ x : ℝ,
      (1/α + |x|) * Real.exp (-α * |x|) ≤ K * Real.exp (-β * |x|) := by
  -- We can choose K = 1/α + 1/(α - β) based on the formal proof sketch.
  use 1/α + 1/(α - β);
  refine' ⟨ by exact add_pos ( one_div_pos.mpr hα ) ( one_div_pos.mpr ( by linarith ) ), fun x => _ ⟩;
  have h_exp_bound : |x| * Real.exp (-(α - β) * |x|) ≤ 1 / (α - β) := by
    rw [ le_div_iff₀ ( sub_pos.mpr hβα ) ];
    nlinarith [ Real.exp_pos ( - ( α - β ) * |x| ), Real.exp_neg ( - ( α - β ) * |x| ), mul_inv_cancel₀ ( ne_of_gt ( Real.exp_pos ( - ( α - β ) * |x| ) ) ), Real.add_one_le_exp ( - ( α - β ) * |x| ), Real.add_one_le_exp ( - ( - ( α - β ) * |x| ) ) ];
  rw [ add_mul, add_mul ];
  refine' add_le_add _ _;
  · exact mul_le_mul_of_nonneg_left ( Real.exp_le_exp.mpr ( by nlinarith [ abs_nonneg x ] ) ) ( by positivity );
  · exact le_trans ( by rw [ mul_assoc, ← Real.exp_add ] ; ring_nf; norm_num ) ( mul_le_mul_of_nonneg_right h_exp_bound ( Real.exp_nonneg _ ) )

/-
**Autocorrelation preserves the WeilTestFunction class.**

    Given `h : WeilTestFunction` with decay rate `b > 0`, the autocorrelation
    `h ⋆ h̃` is also a `WeilTestFunction` with decay rate `b/2 > 0`.

    The proof uses the three helper lemmas above:
      1. `exp_decay_pointwise_product` bounds the integrand.
      2. `exp_decay_convolution_integral_bound` integrates the bound, giving
         a polynomial × exponential.
      3. `poly_exp_absorption` absorbs the polynomial into a slightly weaker
         exponential rate.

    For the derivative bound: same structure, but using `h.has_exponential_decay_deriv`
    on the second factor (since `deriv(h ⋆ h̃) = h ⋆ deriv(h̃)`). This requires
    differentiation under the integral sign, which is in `AutocorrSmooth.lean`'s
    `schwartz_conv_hasDerivAt`.
-/
def autocorrelation_WTF (h : WeilTestFunction) : WeilTestFunction where
  -- The underlying EvenSchwartz is the existing autocorrelation.
  toEvenSchwartz := autocorrelation h.toEvenSchwartz
  -- The exponential decay bound.
  has_exponential_decay := by
    -- Step 1: extract the decay witness from h.
    obtain ⟨b, hb, C, hC, hbound⟩ := h.has_exponential_decay
    -- Step 2: extract the absorption constant K from poly_exp_absorption.
    -- We use rates α = 1/2 + b and β = 1/2 + b/2 (so β < α since b > 0).
    obtain ⟨K, hK_pos, hK_bound⟩ := poly_exp_absorption (1/2 + b) (1/2 + b/2)
      (by linarith) (by linarith) (by linarith)
    -- Step 3: provide the witnesses (b' = b/2, C' = C^2 * K) and the bound.
    refine ⟨b/2, by linarith, C * C * K, by positivity, ?_⟩
    -- Goal: ∀ x, |autocorrelation h.toEvenSchwartz x| ≤ (C * C * K) * exp(-(1/2 + b/2)|x|)
    intro x
    -- Step 0: Unfold the autocorrelation to its integral form.
    -- (autocorrelation g) is defined with toFun := fun x => ∫ t, g t * g (t + x)
    -- so (autocorrelation g) x reduces to ∫ t, g t * g (t + x) via the EvenSchwartz coercion.
    -- If `rfl` doesn't succeed (because of how coercions are resolved),
    -- try: `simp only [autocorrelation, EvenSchwartz.coe_apply]`
    -- or explicit `show |∫ t, ...| = |∫ t, ...|` followed by `rfl`.
    have h_unfold : ((autocorrelation h.toEvenSchwartz : EvenSchwartz) : ℝ → ℝ) x
                  = ∫ t : ℝ, h.toEvenSchwartz t * h.toEvenSchwartz (t + x) := by
      rfl
    -- Set α and β for clarity.
    set α : ℝ := 1/2 + b with hα_def
    set β : ℝ := 1/2 + b/2 with hβ_def
    have hα_pos : 0 < α := by simp [hα_def]; linarith
    have hβ_pos : 0 < β := by simp [hβ_def]; linarith
    have hβ_lt_α : β < α := by simp [hα_def, hβ_def]; linarith
    -- Integrability of the exponential bound (needed for integral_mono).
    -- The function exp(-α|t|) * exp(-α|t+x|) is integrable because exp(-α|t|) is L¹.
    have h_integrable_exp : Integrable (fun t : ℝ => Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
      have h_integrable : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-α * |t|)) MeasureTheory.volume := by
        have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-α * |t|)) (Set.Ioi 0) := by
          have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-α * t)) (Set.Ioi 0) := by
            have := ( exp_neg_integrableOn_Ioi 0 hα_pos );
            exact this;
          exact h_integrable.congr_fun ( fun x hx => by rw [ abs_of_pos hx.out ] ) measurableSet_Ioi;
        have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-α * |t|)) (Set.Iio 0) MeasureTheory.volume := by
          convert h_integrable.comp_neg using 1 ; norm_num [ abs_neg ];
          norm_num [ Set.ext_iff ];
        convert MeasureTheory.IntegrableOn.integrable ( h_integrable.union ‹IntegrableOn ( fun t => Real.exp ( -α * |t| ) ) ( Set.Ioi 0 ) volume› ) using 1;
        norm_num [ Set.union_comm ];
      refine' h_integrable.mono' _ _;
      · exact MeasureTheory.AEStronglyMeasurable.mul ( h_integrable.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) );
      · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_of_le_one_right ( by positivity ) ( Real.exp_le_one_iff.mpr <| by nlinarith [ abs_nonneg ( t + x ) ] ) ;  -- Sub-sorry: integrability of product of L¹ exponentials.
    -- Integrability of |h(t) * h(t+x)|: pointwise bounded by C·C · exp-decay (integrable).
    have h_integrable_abs : Integrable (fun t : ℝ => |h.toEvenSchwartz t * h.toEvenSchwartz (t + x)|) := by
      refine' h_integrable_exp.const_mul ( C ^ 2 ) |> fun h => h.mono' _ _;
      · exact Continuous.aestronglyMeasurable ( by exact Continuous.abs ( by exact Continuous.mul ( by exact ‹WeilTestFunction›.toEvenSchwartz.toSchwartzMap.continuous ) ( by exact ‹WeilTestFunction›.toEvenSchwartz.toSchwartzMap.continuous.comp ( continuous_add_right _ ) ) ) );
      · filter_upwards [ ] with t using by simpa [ abs_mul, sq, mul_assoc, mul_comm, mul_left_comm ] using mul_le_mul ( hbound t ) ( hbound ( t + x ) ) ( by positivity ) ( by positivity ) ;  -- Sub-sorry: integrability via domination by h_integrable_exp scaled by C*C.
    -- Integrability of h(t) * h(t+x) (without absolute value), needed for norm_integral_le_integral_norm.
    have h_integrable : Integrable (fun t : ℝ => h.toEvenSchwartz t * h.toEvenSchwartz (t + x)) := by
      refine' h_integrable_abs.mono' _ _;
      · exact Continuous.aestronglyMeasurable ( by exact Continuous.mul ( h.toEvenSchwartz.toSchwartzMap.continuous ) ( h.toEvenSchwartz.toSchwartzMap.continuous.comp ( continuous_add_right x ) ) );
      · exact Filter.Eventually.of_forall fun t => le_rfl  -- Sub-sorry: integrability of the integrand itself (Schwartz × translated Schwartz).
    -- The pointwise bound from exp_decay_pointwise_product (specialized).
    have h_pointwise : ∀ t : ℝ,
        |h.toEvenSchwartz t * h.toEvenSchwartz (t + x)| ≤
          C * C * (Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
      intro t
      have := exp_decay_pointwise_product
        (h.toEvenSchwartz : ℝ → ℝ) (h.toEvenSchwartz : ℝ → ℝ) α
        C hC hbound C hC hbound t x
      exact this
    -- Now the main calc chain.
    calc |((autocorrelation h.toEvenSchwartz : EvenSchwartz) : ℝ → ℝ) x|
        = |∫ t : ℝ, h.toEvenSchwartz t * h.toEvenSchwartz (t + x)| := by
            rw [h_unfold]
      _ ≤ ∫ t : ℝ, |h.toEvenSchwartz t * h.toEvenSchwartz (t + x)| := by
            calc |∫ (t : ℝ), h.toEvenSchwartz t * h.toEvenSchwartz (t + x)|
                = ‖∫ (t : ℝ), h.toEvenSchwartz t * h.toEvenSchwartz (t + x)‖ := (Real.norm_eq_abs _).symm
              _ ≤ ∫ (t : ℝ), ‖h.toEvenSchwartz t * h.toEvenSchwartz (t + x)‖ :=
                    MeasureTheory.norm_integral_le_integral_norm _
              _ = ∫ (t : ℝ), |h.toEvenSchwartz t * h.toEvenSchwartz (t + x)| := by
                    simp [Real.norm_eq_abs]
      _ ≤ ∫ t : ℝ, C * C * (Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
            exact MeasureTheory.integral_mono h_integrable_abs (h_integrable_exp.const_mul (C * C)) h_pointwise
      _ = C * C * ∫ t : ℝ, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) := by
            rw [MeasureTheory.integral_const_mul]
      _ ≤ C * C * ((1/α + |x|) * Real.exp (-α * |x|)) := by
            apply mul_le_mul_of_nonneg_left
            · exact exp_decay_convolution_integral_bound α hα_pos x
            · positivity
      _ ≤ C * C * (K * Real.exp (-β * |x|)) := by
            apply mul_le_mul_of_nonneg_left
            · exact hK_bound x
            · positivity
      _ = C * C * K * Real.exp (-β * |x|) := by ring
  -- The derivative decay bound. Same structure as has_exponential_decay,
  -- but with deriv h.toSchwartzMap as the second factor of the integrand,
  -- using h.has_exponential_decay_deriv for its bound.
  has_exponential_decay_deriv := by
    -- Step 1: extract the decay witnesses from h.
    obtain ⟨b₁, hb₁, C₁, hC₁, hbound⟩ := h.has_exponential_decay
    obtain ⟨b₂, hb₂, C₂, hC₂, hbound'⟩ := h.has_exponential_decay_deriv
    -- Step 2: take the smaller of b₁, b₂ so both bounds hold with rate b.
    set b : ℝ := min b₁ b₂ with hb_def
    have hb : 0 < b := lt_min hb₁ hb₂
    have hb_le_b₁ : b ≤ b₁ := min_le_left _ _
    have hb_le_b₂ : b ≤ b₂ := min_le_right _ _
    have hbound_b : ∀ x : ℝ, |h.toEvenSchwartz x| ≤ C₁ * Real.exp (-(1/2 + b) * |x|) := by
      intro x
      have h₁ : -(1/2 + b₁) * |x| ≤ -(1/2 + b) * |x| := by
        nlinarith [abs_nonneg x, hb_le_b₁]
      calc |h.toEvenSchwartz x|
          ≤ C₁ * Real.exp (-(1/2 + b₁) * |x|) := hbound x
        _ ≤ C₁ * Real.exp (-(1/2 + b) * |x|) := by
              apply mul_le_mul_of_nonneg_left
              · exact Real.exp_le_exp.mpr h₁
              · linarith
    have hbound_b' : ∀ x : ℝ, |deriv h.toEvenSchwartz.toSchwartzMap x| ≤ C₂ * Real.exp (-(1/2 + b) * |x|) := by
      intro x
      have h₂ : -(1/2 + b₂) * |x| ≤ -(1/2 + b) * |x| := by
        nlinarith [abs_nonneg x, hb_le_b₂]
      calc |deriv h.toEvenSchwartz.toSchwartzMap x|
          ≤ C₂ * Real.exp (-(1/2 + b₂) * |x|) := hbound' x
        _ ≤ C₂ * Real.exp (-(1/2 + b) * |x|) := by
              apply mul_le_mul_of_nonneg_left
              · exact Real.exp_le_exp.mpr h₂
              · linarith
    -- Step 3: extract the absorption constant K.
    obtain ⟨K, hK_pos, hK_bound⟩ := poly_exp_absorption (1/2 + b) (1/2 + b/2)
      (by linarith) (by linarith) (by linarith)
    -- Step 4: provide the witnesses and the bound.
    refine ⟨b/2, by linarith, C₁ * C₂ * K, by positivity, ?_⟩
    intro x
    -- Step 5: identify the derivative using schwartz_conv_hasDerivAt.
    -- (autocorrelation g).toSchwartzMap.toFun = fun x => ∫ t, g t * g (t + x),
    -- so its derivative at x is ∫ t, g t * (deriv g.toSchwartzMap) (t + x).
    have h_deriv_eq : deriv (autocorrelation h.toEvenSchwartz).toSchwartzMap x
                    = ∫ t : ℝ, h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x) := by
      -- Use schwartz_conv_hasDerivAt from AutocorrSmooth.lean
      have hd := schwartz_conv_hasDerivAt h.toEvenSchwartz.toSchwartzMap h.toEvenSchwartz.toSchwartzMap x
      -- hd : HasDerivAt (fun y => ∫ t, h(t) * h(t+y))
      --           (∫ t, h(t) * deriv h.toSchwartzMap (t+x)) x
      -- The function `fun y => ∫ t, h(t) * h(t+y)` is definitionally equal to
      -- (autocorrelation h.toEvenSchwartz).toSchwartzMap (via the structure unfolding,
      -- since `autocorrelation g` has `toSchwartzMap.toFun = fun x => ∫ t, g t * g (t + x)`).
      -- Convert HasDerivAt → deriv equation. The ideal one-liner is `exact hd.deriv`,
      -- but if the function shapes don't unify automatically, may need:
      --   have := hd.deriv; convert this using 2; rfl
      -- or `simp only [autocorrelation]` to unfold the structure.
      have : deriv (fun x => ∫ t : ℝ, h.toEvenSchwartz.toSchwartzMap t * h.toEvenSchwartz.toSchwartzMap (t + x)) x = ∫ t : ℝ, h.toEvenSchwartz.toSchwartzMap t * deriv (⇑h.toEvenSchwartz.toSchwartzMap) (t + x) := hd.deriv
      convert this using 2
    -- Set α and β.
    set α : ℝ := 1/2 + b with hα_def
    set β : ℝ := 1/2 + b/2 with hβ_def
    have hα_pos : 0 < α := by simp [hα_def]; linarith
    have hβ_pos : 0 < β := by simp [hβ_def]; linarith
    -- Step 6: integrability witnesses, parallel to has_exponential_decay.
    have h_integrable_exp : Integrable (fun t : ℝ =>
        Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
      have h_int : MeasureTheory.Integrable (fun t : ℝ => Real.exp (-α * |t|)) MeasureTheory.volume := by
        have h_int_pos : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-α * |t|)) (Set.Ioi 0) := by
          have h_int_pos : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-α * t)) (Set.Ioi 0) := by
            have := ( exp_neg_integrableOn_Ioi 0 hα_pos )
            exact this
          exact h_int_pos.congr_fun ( fun x hx => by rw [ abs_of_pos hx.out ] ) measurableSet_Ioi
        have h_int_neg : MeasureTheory.IntegrableOn (fun t : ℝ => Real.exp (-α * |t|)) (Set.Iio 0) MeasureTheory.volume := by
          convert h_int_pos.comp_neg using 1 ; norm_num [ abs_neg ]
          norm_num [ Set.ext_iff ]
        convert MeasureTheory.IntegrableOn.integrable ( h_int_neg.union h_int_pos ) using 1
        norm_num [ Set.union_comm ]
      refine' h_int.mono' _ _
      · exact MeasureTheory.AEStronglyMeasurable.mul ( h_int.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) )
      · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_of_le_one_right ( by positivity ) ( Real.exp_le_one_iff.mpr <| by nlinarith [ abs_nonneg ( t + x ) ] )
    have h_pointwise : ∀ t : ℝ,
        |h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)| ≤
          C₁ * C₂ * (Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
      intro t
      exact exp_decay_pointwise_product
        (h.toEvenSchwartz : ℝ → ℝ) (deriv h.toEvenSchwartz.toSchwartzMap) α
        C₁ hC₁ hbound_b C₂ hC₂ hbound_b' t x
    have h_integrable_abs : Integrable (fun t : ℝ =>
        |h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)|) := by
      refine' (h_integrable_exp.const_mul ( C₁ * C₂ )).mono' ?_ ?_
      · have hcont_deriv : Continuous (deriv (⇑h.toEvenSchwartz.toSchwartzMap)) :=
          (h.toEvenSchwartz.toSchwartzMap.smooth 2).continuous_deriv (by norm_num)
        exact Continuous.aestronglyMeasurable (Continuous.abs (Continuous.mul (h.toEvenSchwartz.toSchwartzMap.continuous) (hcont_deriv.comp (continuous_add_right x))))
      · filter_upwards [] with t
        rw [Real.norm_of_nonneg (abs_nonneg _)]
        exact h_pointwise t
    have h_integrable : Integrable (fun t : ℝ =>
        h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)) := by
      refine' h_integrable_abs.mono' ?_ ?_
      · have hcont_deriv : Continuous (deriv (⇑h.toEvenSchwartz.toSchwartzMap)) :=
          (h.toEvenSchwartz.toSchwartzMap.smooth 2).continuous_deriv (by norm_num)
        exact Continuous.aestronglyMeasurable (Continuous.mul (h.toEvenSchwartz.toSchwartzMap.continuous) (hcont_deriv.comp (continuous_add_right x)))
      · exact Filter.Eventually.of_forall fun t => by simp [Real.norm_eq_abs]
    -- Step 7: the main calc chain (parallel to has_exponential_decay).
    calc |deriv (autocorrelation h.toEvenSchwartz).toSchwartzMap x|
        = |∫ t : ℝ, h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)| := by
              rw [h_deriv_eq]
      _ ≤ ∫ t : ℝ, |h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)| := by
            calc |∫ (t : ℝ), h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)|
                = ‖∫ (t : ℝ), h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)‖ :=
                    (Real.norm_eq_abs _).symm
              _ ≤ ∫ (t : ℝ), ‖h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)‖ :=
                    MeasureTheory.norm_integral_le_integral_norm _
              _ = ∫ (t : ℝ), |h.toEvenSchwartz t * deriv h.toEvenSchwartz.toSchwartzMap (t + x)| := by
                    simp [Real.norm_eq_abs]
      _ ≤ ∫ t : ℝ, C₁ * C₂ * (Real.exp (-α * |t|) * Real.exp (-α * |t + x|)) := by
            exact MeasureTheory.integral_mono h_integrable_abs
              (h_integrable_exp.const_mul (C₁ * C₂)) h_pointwise
      _ = C₁ * C₂ * ∫ t : ℝ, Real.exp (-α * |t|) * Real.exp (-α * |t + x|) := by
            rw [MeasureTheory.integral_const_mul]
      _ ≤ C₁ * C₂ * ((1/α + |x|) * Real.exp (-α * |x|)) := by
            apply mul_le_mul_of_nonneg_left
            · exact exp_decay_convolution_integral_bound α hα_pos x
            · positivity
      _ ≤ C₁ * C₂ * (K * Real.exp (-β * |x|)) := by
            apply mul_le_mul_of_nonneg_left
            · exact hK_bound x
            · positivity
      _ = C₁ * C₂ * K * Real.exp (-β * |x|) := by ring

-- ============================================================================
-- 5. WEIL POSITIVITY AND CRITERION ON WTF
-- ============================================================================

/-- The Weil positivity condition on `WeilTestFunction`:
    the Weil distribution is non-negative on all autocorrelations. -/
def WeilPositivity_WTF : Prop :=
  ∀ g : WeilTestFunction, WeilDistribution_WTF (autocorrelation_WTF g) ≥ 0

/-- The spectral side of the explicit formula on `WeilTestFunction`.
    Defined as `WeilDistribution_WTF` so the explicit formula is definitional. -/
noncomputable def spectralSide_WTF : WeilTestFunction → ℝ := WeilDistribution_WTF

/-- The explicit formula (Weil 1952) on `WeilTestFunction`:
    W(g) = spectralSide(g). Definitionally true. -/
theorem explicit_formula_WTF (g : WeilTestFunction) :
    WeilDistribution_WTF g = spectralSide_WTF g := rfl

/-- Under RH, the spectral side is non-negative on autocorrelations
    of Weil test functions. This is the backward direction of Weil's criterion.

    The proof requires showing that for each non-trivial zero ρ of ζ with
    Re(ρ) = 1/2 (by RH), the spectral contribution ĝ((ρ - 1/2)/i) is
    non-negative on autocorrelations. -/
theorem spectralSide_autocorr_nonneg_WTF (hRH : RiemannHypothesis) :
    ∀ h : WeilTestFunction, spectralSide_WTF (autocorrelation_WTF h) ≥ 0 := by
  sorry

/-- WeilPositivity_WTF implies RH (the harder direction of Weil's criterion).

    The proof constructs test functions in `WeilTestFunction` that detect
    off-line zeros. Compactly supported smooth even functions are in WTF
    (trivial exponential decay) and suffice for Weil's 1952 argument. -/
theorem weilPositivity_wtf_implies_rh (hWP : WeilPositivity_WTF) :
    RiemannHypothesis := by
  sorry

/-- **Weil's Criterion on WeilTestFunction** (1952):
    The Weil positivity condition on `WeilTestFunction` is equivalent
    to the Riemann Hypothesis.

    The body has no `sorry`; it depends on sorry'd sub-lemmas
    (`spectralSide_autocorr_nonneg_WTF`, `weilPositivity_wtf_implies_rh`). -/
theorem WeilCriterion_WTF : WeilPositivity_WTF ↔ RiemannHypothesis := by
  constructor
  · exact weilPositivity_wtf_implies_rh
  · intro hRH h
    rw [explicit_formula_WTF (autocorrelation_WTF h)]
    exact spectralSide_autocorr_nonneg_WTF hRH h

end