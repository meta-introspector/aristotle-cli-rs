import Mathlib
import RequestProject.Imported.IndbanachSkeleton.WeilTestFunction

/-!
# Continuity helpers for the Weil functional on WeilTestFunction

This file proves helper lemmas and states that
`g ↦ WeilDistribution_WTF (autocorrelation_WTF g)` is continuous
on `WeilTestFunction`.

## Migration note

The original version of this file stated continuity on `EvenSchwartz` /
`SchwartzMap`. That was **false** because the von Mangoldt sum diverges for
generic Schwartz functions, and `tsum` silently returns 0, creating a real
discontinuity. The claims are now restated on `WeilTestFunction`, where the
von Mangoldt sum provably converges (see `vonMangoldt_sum_summable`).
-/

open Real MeasureTheory
open scoped BigOperators

noncomputable section

-- ============================================================================
-- 1. TRANSLATION CLM ON SCHWARTZ SPACE (unchanged)
-- ============================================================================

/-- Translation by `x₀` as a CLM on SchwartzMap. -/
noncomputable def schwartz_translate (x₀ : ℝ) : SchwartzMap ℝ ℝ →L[ℝ] SchwartzMap ℝ ℝ :=
  SchwartzMap.compCLM ℝ (g := fun t => t + x₀)
    (by exact ((ContinuousLinearMap.id ℝ ℝ).hasTemperateGrowth.add
        (by constructor; exact contDiff_const; intro n; induction n with
          | zero => exact ⟨0, ‖x₀‖, fun t => by simp⟩
          | succ n _ => exact ⟨0, 0, fun t => by simp [iteratedFDeriv_succ_const]⟩)))
    (by refine ⟨1, 1 + ‖x₀‖, fun t => ?_⟩; simp only [pow_one, Real.norm_eq_abs]
        have := abs_add_le (t + x₀) (-x₀); simp at this
        nlinarith [abs_nonneg (t + x₀), abs_nonneg x₀])

-- ============================================================================
-- 2. L² INNER PRODUCT (unchanged)
-- ============================================================================

/-- The L² inner product of two Schwartz functions equals ∫ φ * ψ. -/
lemma schwartz_inner_eq (φ ψ : SchwartzMap ℝ ℝ) :
    @inner ℝ (↥(Lp ℝ 2 (volume : Measure ℝ))) _ (φ.toLp 2) (ψ.toLp 2) =
    ∫ t : ℝ, φ t * ψ t := by
  rw [L2.inner_def]
  apply integral_congr_ae
  filter_upwards [φ.coeFn_toLp 2, ψ.coeFn_toLp 2] with t ht1 ht2
  simp [ht1, ht2, mul_comm]

/-- The convolution value at x₀ equals an L² inner product. -/
lemma schwartz_conv_eq_inner (φ : SchwartzMap ℝ ℝ) (x₀ : ℝ) :
    ∫ t, φ t * φ (t + x₀) =
    @inner ℝ (↥(Lp ℝ 2 (volume : Measure ℝ))) _ (φ.toLp 2) ((schwartz_translate x₀ φ).toLp 2) := by
  rw [schwartz_inner_eq]; rfl

-- ============================================================================
-- 3. CONTINUITY OF CONVOLUTION AT A POINT (unchanged)
-- ============================================================================

/-- For fixed x₀, the map φ ↦ ∫ φ(t) * φ(t+x₀) dt is continuous on SchwartzMap. -/
lemma schwartz_selfConv_continuous_at (x₀ : ℝ) :
    Continuous (fun φ : SchwartzMap ℝ ℝ => ∫ t, φ t * φ (t + x₀)) := by
  have h_eq : (fun φ : SchwartzMap ℝ ℝ => ∫ t, φ t * φ (t + x₀)) =
      (fun φ => @inner ℝ (↥(Lp ℝ 2 (volume : Measure ℝ))) _ (φ.toLp 2)
        ((schwartz_translate x₀ φ).toLp 2)) := by
    ext φ; exact schwartz_conv_eq_inner φ x₀
  rw [h_eq]
  apply Continuous.inner
  · exact (SchwartzMap.toLpCLM ℝ ℝ 2 volume).continuous
  · exact ((SchwartzMap.toLpCLM ℝ ℝ 2 volume).comp (schwartz_translate x₀)).continuous

/-
============================================================================
4. HELPER LEMMAS FOR COMPONENT 3 CONTINUITY
============================================================================

Schwartz functions satisfy the pointwise bound |φ(x)| ≤ S(φ)/(1+x²)
    where S(φ) = seminorm 0 0 + seminorm 2 0.
-/
lemma schwartz_pointwise_decay_bound (φ : SchwartzMap ℝ ℝ) (x : ℝ) :
    ‖φ x‖ ≤ (SchwartzMap.seminorm ℝ 0 0 φ + SchwartzMap.seminorm ℝ 2 0 φ) / (1 + x ^ 2) := by
  rw [ le_div_iff₀ ( by positivity ) ];
  convert add_le_add ( SchwartzMap.le_seminorm ℝ 0 0 φ x ) ( SchwartzMap.le_seminorm ℝ 2 0 φ x ) using 1 ; norm_num;
  ring

/-
The cross-correlation ∫ φ(t)·ψ(t+x) dt is bounded by
    C · S(φ) · S(ψ) / (1+x²) where S = seminorm 0 0 + seminorm 2 0.
-/
lemma cross_correlation_decay_bound (φ ψ : SchwartzMap ℝ ℝ) (x : ℝ) :
    ‖∫ t, φ t * ψ (t + x)‖ ≤
    (SchwartzMap.seminorm ℝ 0 0 φ + SchwartzMap.seminorm ℝ 2 0 φ) *
    (SchwartzMap.seminorm ℝ 0 0 ψ + SchwartzMap.seminorm ℝ 2 0 ψ) *
    (8 * Real.pi / (1 + x ^ 2)) := by
  refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm _ ) ( le_trans ( MeasureTheory.integral_mono_of_nonneg _ _ _ ) _ );
  refine' fun t => ( SchwartzMap.seminorm ℝ 0 0 φ + SchwartzMap.seminorm ℝ 2 0 φ ) / ( 1 + t ^ 2 ) * ( SchwartzMap.seminorm ℝ 0 0 ψ + SchwartzMap.seminorm ℝ 2 0 ψ ) / ( 1 + ( t + x ) ^ 2 );
  · exact Filter.Eventually.of_forall fun _ => norm_nonneg _;
  · have h_integrable : MeasureTheory.Integrable (fun t : ℝ => (1 + t ^ 2)⁻¹ * (1 + (t + x) ^ 2)⁻¹) MeasureTheory.volume := by
      refine' MeasureTheory.Integrable.mono' _ _ _;
      refine' fun t => ( 1 + t ^ 2 ) ⁻¹;
      · exact?;
      · exact Continuous.aestronglyMeasurable ( by exact Continuous.mul ( Continuous.inv₀ ( by continuity ) fun t => by positivity ) ( Continuous.inv₀ ( by continuity ) fun t => by positivity ) );
      · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; exact mul_le_of_le_one_right ( by positivity ) ( inv_le_one_of_one_le₀ ( by nlinarith ) ) ;
    convert h_integrable.const_mul ( ( SchwartzMap.seminorm ℝ 0 0 φ + SchwartzMap.seminorm ℝ 2 0 φ ) * ( SchwartzMap.seminorm ℝ 0 0 ψ + SchwartzMap.seminorm ℝ 2 0 ψ ) ) using 2 ; ring;
  · have := schwartz_pointwise_decay_bound φ;
    filter_upwards [ ] with t using by simpa only [ norm_mul, mul_div_assoc ] using mul_le_mul ( this t ) ( schwartz_pointwise_decay_bound ψ ( t + x ) ) ( by positivity ) ( by positivity ) ;
  · -- We'll use the fact that $\int_{-\infty}^{\infty} \frac{dt}{(1+t^2)(1+(t+x)^2)} \leq \frac{8\pi}{1+x^2}$.
    have h_integral_bound : ∫ t : ℝ, (1 : ℝ) / ((1 + t ^ 2) * (1 + (t + x) ^ 2)) ≤ 8 * Real.pi / (1 + x ^ 2) := by
      have h_integral_bound_x : ∫ t, 1 / ((1 + t ^ 2) * (1 + (t + x) ^ 2)) ≤ ∫ t, (2 / (1 + x ^ 2)) * (1 / (1 + t ^ 2) + 1 / (1 + (t + x) ^ 2)) := by
        refine' MeasureTheory.integral_mono_of_nonneg _ _ _;
        · exact Filter.Eventually.of_forall fun t => by positivity;
        · have h_integrable : MeasureTheory.Integrable (fun t : ℝ => 1 / (1 + t ^ 2)) MeasureTheory.volume ∧ MeasureTheory.Integrable (fun t : ℝ => 1 / (1 + (t + x) ^ 2)) MeasureTheory.volume := by
            have h_integrable : MeasureTheory.Integrable (fun t : ℝ => 1 / (1 + t ^ 2)) MeasureTheory.volume := by
              simp +zetaDelta at *;
              exact?;
            exact ⟨ h_integrable, by simpa using h_integrable.comp_add_right x ⟩;
          exact MeasureTheory.Integrable.const_mul ( h_integrable.1.add h_integrable.2 ) _;
        · field_simp;
          filter_upwards [ ] with t using by rw [ div_le_div_iff₀ ] <;> nlinarith only [ sq_nonneg ( t + x - t ), sq_nonneg ( t + x + t ), sq_nonneg ( x - t ), sq_nonneg ( x + t ), show 0 < ( 1 + t ^ 2 ) * ( 1 + ( t + x ) ^ 2 ) by positivity ] ;
      refine le_trans h_integral_bound_x ?_;
      rw [ MeasureTheory.integral_const_mul, MeasureTheory.integral_add ];
      · rw [ show ( ∫ t : ℝ, 1 / ( 1 + ( t + x ) ^ 2 ) ) = ∫ t : ℝ, 1 / ( 1 + t ^ 2 ) by rw [ eq_comm, ← MeasureTheory.integral_add_right_eq_self ] ] ; norm_num ; ring_nf;
        exact mul_le_mul_of_nonneg_left ( by norm_num ) ( by positivity );
      · grind +suggestions;
      · exact ( by simpa using ( integrable_inv_one_add_sq.comp_add_right x ) );
    convert mul_le_mul_of_nonneg_left h_integral_bound ( show 0 ≤ ( SchwartzMap.seminorm ℝ 0 0 φ + SchwartzMap.seminorm ℝ 2 0 φ ) * ( SchwartzMap.seminorm ℝ 0 0 ψ + SchwartzMap.seminorm ℝ 2 0 ψ ) by positivity ) using 1;
    rw [ ← MeasureTheory.integral_const_mul ] ; congr ; ext ; rw [ div_mul_eq_mul_div, div_div ] ; ring;

/-
The kernel K(x) = 1/(1-e^{-2x}) - 1/(2x) is bounded on (0, ∞).
-/
lemma weil_kernel_bounded :
    ∃ K_max : ℝ, 0 < K_max ∧ ∀ x : ℝ, 0 < x →
    |1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x)| ≤ K_max := by
  use 2; norm_num;
  intro x hx; rw [ abs_le ] ; constructor <;> norm_num <;> ring_nf;
  · field_simp;
    rw [ add_div', mul_div, le_div_iff₀ ] <;> nlinarith [ Real.exp_pos ( - ( x * 2 ) ), Real.exp_neg ( x * 2 ), mul_inv_cancel₀ ( ne_of_gt ( Real.exp_pos ( x * 2 ) ) ), Real.add_one_le_exp ( x * 2 ), Real.add_one_le_exp ( - ( x * 2 ) ) ];
  · rw [ inv_eq_one_div, div_le_iff₀ ] <;> norm_num <;> nlinarith [ Real.exp_pos ( - ( x * 2 ) ), Real.exp_neg ( x * 2 ), mul_inv_cancel₀ ( ne_of_gt hx ), mul_inv_cancel₀ ( ne_of_gt ( Real.exp_pos ( x * 2 ) ) ), Real.add_one_le_exp ( x * 2 ), Real.add_one_le_exp ( - ( x * 2 ) ) ]

/-
1/(1+x²) is integrable on Ioi 0.
-/
lemma inv_one_add_sq_integrable_Ioi :
    MeasureTheory.IntegrableOn (fun x : ℝ => 1 / (1 + x ^ 2))
      (Set.Ioi 0) MeasureTheory.volume := by
  have int_bound : MeasureTheory.IntegrableOn (fun x : ℝ => 1 / (1 + x ^ 2)) (Set.Ioi (1 : ℝ)) := by
    have int_bound : MeasureTheory.IntegrableOn (fun x : ℝ => x ^ (-2 : ℝ)) (Set.Ioi (1 : ℝ)) := by
      rw [ integrableOn_Ioi_rpow_iff ] <;> norm_num;
    refine' int_bound.mono' _ _;
    · exact Continuous.aestronglyMeasurable ( continuous_const.div ( by continuity ) fun x => by positivity );
    · filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioi ] with x hx using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; norm_cast; norm_num; gcongr <;> nlinarith [ hx.out ] ;
  rw [ show ( Set.Ioi 0 : Set ℝ ) = Set.Ioc 0 1 ∪ Set.Ioi 1 by ext x; by_cases h : x ≤ 1 <;> aesop, MeasureTheory.integrableOn_union ] ; norm_num;
  exact ⟨ Continuous.integrableOn_Ioc ( Continuous.inv₀ ( continuous_const.add ( continuous_pow 2 ) ) fun x => by positivity ), by simpa using int_bound ⟩

/-- The Schwartz seminorm (sum of 0,0 and 2,0) is continuous on SchwartzMap. -/
lemma schwartz_combined_seminorm_continuous :
    Continuous (fun φ : SchwartzMap ℝ ℝ =>
      SchwartzMap.seminorm ℝ 0 0 φ + SchwartzMap.seminorm ℝ 2 0 φ) := by
  exact ((schwartz_withSeminorms ℝ ℝ ℝ).continuous_seminorm (0, 0)).add
    ((schwartz_withSeminorms ℝ ℝ ℝ).continuous_seminorm (2, 0))

-- ============================================================================
-- 5. FACTORING AND COMPONENT CONTINUITY ON WTF
-- ============================================================================

/-- The WTF Weil functional factors through SchwartzMap. -/
lemma weil_autocorr_factors_WTF (g : WeilTestFunction) :
    WeilDistribution_WTF (autocorrelation_WTF g) =
    ((∫ t, g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + 0)) * Real.log Real.pi
    - ∑' (n : ℕ), (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n *
        (∫ t, g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + Real.log n))
    + ∫ x in Set.Ioi (0 : ℝ),
        (∫ t, g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + x)) *
        (1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x))) := by
  simp only [WeilDistribution_WTF, autocorrelation_WTF, WeilDistribution_WTF_eq_apply,
             autocorrelation]; rfl

/-- Component 1 is continuous on WTF. -/
lemma weil_component1_continuous_WTF :
    Continuous (fun g : WeilTestFunction =>
      (∫ t, g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + 0)) *
      Real.log Real.pi) := by
  apply Continuous.mul _ continuous_const
  exact (schwartz_selfConv_continuous_at 0).comp
    (continuous_induced_dom.comp continuous_induced_dom)

/-- Component 2 is continuous on WTF.

    **STATUS: KNOWN FALSE in the Schwartz subspace topology.**

    A rigorous counterexample has been constructed and numerically verified.
    For any fixed `g_* ∈ WTF` (e.g. `g_*(t) = exp(-1.5 √(t²+1))`), define
    for each `s ≥ 1`:

      `h_s(t) = exp(-√s) · [φ(t - s) + φ(t + s)]`

    where `φ(y) = exp(-y²/2)` is the unit Gaussian (making `h_s` even,
    preserving the EvenSchwartz structure). Set `g_s = g_* + h_s`. Then:

    1. Each `g_s ∈ WTF` (sum of WTF + even Schwartz with Gaussian decay).
    2. `h_s → 0` in the Schwartz topology as `s → ∞`: each fixed Schwartz
       seminorm `‖t^p D^q h_s‖_∞ ≤ C_{p,q} · s^p · exp(-√s) → 0`.
    3. But the von Mangoldt sum diverges:
       `F₂(g_s) - F₂(g_*) ≈ M · exp(s/2 - √s) → +∞`
       where `M = ∫ (g_* * φ)(z) exp(-z/2) dz` is a positive constant.

    The asymptotic constant has been numerically verified to four decimal
    places across `s ∈ [4, 14]`:
    `log(cross) - (s/2 - √s) = 0.4856` (essentially constant).

    The full Weil distribution `F = F₁ - F₂ + F₃` also fails continuity
    along this sequence: `F₁` and `F₃` perturbations remain `O(ε_s)` while
    `F₂` blows up. No cancellation saves continuity.

    **Why earlier numerical evidence missed this:** Earlier rounds tested
    perturbations concentrated near `t = 0` (e.g., `h_k = (1/k) φ(t)` or
    `h_k = ε_k exp(-(1/2 + 1/k)√(t²+1))`). For these, the cross term is
    bounded because the kernel `K(s) = ∑ Λ(n)/√n |g_*(s - log n)|` is
    small at `s = 0`. The blowup only appears for perturbations with mass
    at large `|s|`, where `K(s) ~ exp(|s|/2)` via PNT.

    The `sorry` remains because the lemma **cannot be proved** — it is false.
    A future fix requires either strengthening the WTF topology (to include
    uniform decay-witness control) or restructuring the conditional reduction.
-/
lemma weil_component2_continuous_WTF :
    Continuous (fun g : WeilTestFunction =>
      ∑' (n : ℕ), (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n *
        (∫ t, g.toEvenSchwartz.toSchwartzMap t *
              g.toEvenSchwartz.toSchwartzMap (t + Real.log n))) := by
  sorry

/-
Full proof requires substantial new structure (cross_bounded_linear,
quadratic_o_h). See proof strategy in the docstring above.

Component 3 is continuous on WTF.

    The archimedean integral term. The integrand is continuous in g
    (by `schwartz_selfConv_continuous_at`) and the kernel
    `1/(1-e^{-2x}) - 1/(2x)` is integrable on `(0,∞)`.

    ── Proof strategy ─────────────────────────────────────────────────
    Apply continuity-of-integral-with-parameter:
    The integrand
        I(g, x) := (∫ t, g(t) g(t+x) dt) · K(x)
        where K(x) = 1/(1-e^(-2x)) - 1/(2x)
    is jointly continuous in (g, x), and dominated by an integrable
    function uniformly in g near g_*.

    For continuity of g ↦ ∫_{Ioi 0} I(g, x) dx, use
    `MeasureTheory.continuous_integral_of_dominated_convergence` or
    the "continuity of the integral as function of parameter" pattern:
      - The function g ↦ I(g, x) is continuous for each fixed x.
      - On a neighborhood of g_* (in SchwartzMap topology),
        |I(g, x)| is dominated by an L¹ function on (0, ∞).

    The autocorrelation (autocorr g)(x) = ∫ g(t) g(t+x) dt has decay
    in x controlled by g's Schwartz seminorms (it's the autocorrelation
    of a Schwartz function, hence Schwartz itself, hence rapidly decaying).
    So |I(g, x)| ≤ ‖autocorr g‖_∞ · |K(x)| where K is integrable on (0,∞)
    (kernel goes like O(x) near 0, exponential decay at ∞).

    Uniform bound: if g is in a neighborhood of g_* in Schwartz topology,
    ‖autocorr g‖_∞ is uniformly bounded.

    For Lean, key Mathlib lemma:
      `MeasureTheory.continuous_of_dominated_continuous` or
      `MeasureTheory.continuousAt_of_dominated`.
    Applied to F(g) := ∫_{Ioi 0} I(g, x) dx with dominating function
    h(x) = M · |K(x)| where M = sup ‖autocorr g‖_∞ on the neighborhood.
    ────────────────────────────────────────────────────────────────────
-/
lemma weil_component3_continuous_WTF :
    Continuous (fun g : WeilTestFunction =>
      ∫ x in Set.Ioi (0 : ℝ),
        (∫ t, g.toEvenSchwartz.toSchwartzMap t *
              g.toEvenSchwartz.toSchwartzMap (t + x)) *
        (1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x))) := by
  -- Strategy: apply MeasureTheory.continuousAt_of_dominated.
  -- The integrand I(g, x) is continuous in g for each x, and dominated
  -- by an L¹ function on a neighborhood of each g_*.
  rw [continuous_iff_continuousAt]
  intro g_star
  -- ContinuousAt requires: for any sequence g_k → g_* in WTF,
  -- ∫ I(g_k, x) dx → ∫ I(g_*, x) dx.
  -- This follows from dominated convergence:
  --   - I(g_k, x) → I(g_*, x) for each x (pointwise continuity in g).
  --   - |I(g_k, x)| ≤ h(x) where h is L¹.
  -- Apply the lemma that states the integral of the kernel is continuous at any Schwartz function.
  have h_cont : ∀ φ₀ : SchwartzMap ℝ ℝ, ContinuousAt (fun φ : SchwartzMap ℝ ℝ => ∫ x in Set.Ioi 0, (∫ t, φ t * φ (t + x)) * (1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x))) φ₀ := by
    intro φ₀;
    -- Apply the dominated convergence theorem to show that the integral is continuous.
    have h_dom_conv : ∀ᶠ φ in nhds φ₀, ∀ x ∈ Set.Ioi 0, |(∫ t, φ t * φ (t + x)) * (1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x))| ≤ (SchwartzMap.seminorm ℝ 0 0 φ + SchwartzMap.seminorm ℝ 2 0 φ)^2 * (8 * Real.pi / (1 + x^2)) * (weil_kernel_bounded.choose : ℝ) := by
      have h_dom_conv : ∀ᶠ φ in nhds φ₀, ∀ x ∈ Set.Ioi 0, |∫ t, φ t * φ (t + x)| ≤ (SchwartzMap.seminorm ℝ 0 0 φ + SchwartzMap.seminorm ℝ 2 0 φ)^2 * (8 * Real.pi / (1 + x^2)) := by
        filter_upwards [ ] with φ x hx using by simpa only [ sq, mul_assoc ] using cross_correlation_decay_bound φ φ x;
      filter_upwards [ h_dom_conv ] with φ hφ x hx using by rw [ abs_mul ] ; exact mul_le_mul ( hφ x hx ) ( weil_kernel_bounded.choose_spec.2 x hx ) ( by positivity ) ( by positivity ) ;
    refine' MeasureTheory.tendsto_integral_filter_of_dominated_convergence _ _ _ _ _;
    use fun x => ( ( SchwartzMap.seminorm ℝ 0 0 φ₀ + SchwartzMap.seminorm ℝ 2 0 φ₀ + 1 ) ^ 2 ) * ( 8 * Real.pi / ( 1 + x ^ 2 ) ) * weil_kernel_bounded.choose;
    · filter_upwards [ h_dom_conv ] with φ hφ;
      refine' Measurable.aestronglyMeasurable _;
      refine' Measurable.mul _ _;
      · refine' MeasureTheory.StronglyMeasurable.measurable _;
        refine' MeasureTheory.StronglyMeasurable.integral_prod_right _;
        exact Continuous.stronglyMeasurable ( by fun_prop );
      · exact Measurable.sub ( measurable_one.div ( measurable_const.sub ( Real.continuous_exp.measurable.comp ( measurable_const.mul measurable_id' ) ) ) ) ( measurable_one.div ( measurable_const.mul measurable_id' ) );
    · filter_upwards [ h_dom_conv, ( schwartz_combined_seminorm_continuous.continuousAt.eventually ( gt_mem_nhds <| show ( SchwartzMap.seminorm ℝ 0 0 φ₀ + SchwartzMap.seminorm ℝ 2 0 φ₀ ) < ( SchwartzMap.seminorm ℝ 0 0 φ₀ + SchwartzMap.seminorm ℝ 2 0 φ₀ ) + 1 by linarith ) ) ] with φ hφ₁ hφ₂;
      filter_upwards [ MeasureTheory.ae_restrict_mem measurableSet_Ioi ] with x hx using le_trans ( hφ₁ x hx ) ( mul_le_mul_of_nonneg_right ( mul_le_mul_of_nonneg_right ( pow_le_pow_left₀ ( by positivity ) hφ₂.le 2 ) ( by positivity ) ) ( by exact le_of_lt ( weil_kernel_bounded.choose_spec.1 ) ) );
    · refine' MeasureTheory.Integrable.mul_const _ _;
      refine' MeasureTheory.Integrable.const_mul _ _;
      exact MeasureTheory.Integrable.const_mul ( by simpa using inv_one_add_sq_integrable_Ioi ) _;
    · refine' Filter.eventually_of_mem ( MeasureTheory.ae_restrict_mem measurableSet_Ioi ) fun x hx => _;
      exact Filter.Tendsto.mul ( schwartz_selfConv_continuous_at x |> Continuous.tendsto <| φ₀ ) tendsto_const_nhds;
  exact h_cont _ |> ContinuousAt.comp <| continuous_induced_dom.comp continuous_induced_dom |> Continuous.continuousAt

-- Full proof requires explicit construction of the dominating
         -- function and verification of L¹ bounds for the kernel
         -- 1/(1-e^{-2x}) - 1/(2x) on (0, ∞).

/-- **Main theorem**: `g ↦ WeilDistribution_WTF (autocorrelation_WTF g)` is continuous
    on `WeilTestFunction`.

    This replaces the broken `weilDistribution_autocorrelation_continuous` which
    was false on `EvenSchwartz`.

    **STATUS: CONCLUSION NOT ESTABLISHED.** This theorem typechecks but its
    proof depends on `weil_component2_continuous_WTF`, which is now known to
    be **false** in the Schwartz subspace topology (see its docstring for the
    counterexample). In Lean's type system, the proof compiles because
    `sorry` introduces an axiom `sorryAx`, allowing anything to follow from
    an unproven (and in this case false) premise. The mathematical conclusion
    (continuity of the full Weil functional on WTF) is therefore not
    established by this proof.

    The proof body is left intact as a structural skeleton: it correctly
    decomposes the functional into three components and shows that
    continuity of each component implies continuity of the whole. Components
    1 and 3 are genuinely proved; only component 2 is false. -/
theorem weilDistribution_autocorrelation_continuous_WTF :
    Continuous (fun g : WeilTestFunction => WeilDistribution_WTF (autocorrelation_WTF g)) := by
  have h_eq : (fun g : WeilTestFunction => WeilDistribution_WTF (autocorrelation_WTF g)) =
      (fun g =>
        (∫ t, g.toEvenSchwartz.toSchwartzMap t * g.toEvenSchwartz.toSchwartzMap (t + 0)) *
          Real.log Real.pi
        - ∑' (n : ℕ), (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n *
            (∫ t, g.toEvenSchwartz.toSchwartzMap t *
                  g.toEvenSchwartz.toSchwartzMap (t + Real.log n))
        + ∫ x in Set.Ioi (0 : ℝ),
            (∫ t, g.toEvenSchwartz.toSchwartzMap t *
                  g.toEvenSchwartz.toSchwartzMap (t + x)) *
            (1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x))) := by
    ext g; exact weil_autocorr_factors_WTF g
  rw [h_eq]
  exact (weil_component1_continuous_WTF.sub weil_component2_continuous_WTF).add
    weil_component3_continuous_WTF

end