import Mathlib

open MeasureTheory Topology Filter Set
open scoped Convolution

noncomputable section

namespace DULA

/-!
# CONVOLUTION CONTINUITY IN SCHWARTZ SPACE
-/

/-- Peetre's Inequality for positive integer exponents. -/
lemma peetres_inequality_nat (x y : ℝ) (m : ℕ) :
    (1 + |x + y|)^(m : ℝ) ≤ (1 + |x|)^(m : ℝ) * (1 + |y|)^(m : ℝ) := by
  have h_pos1 : 0 ≤ 1 + |x + y| := by positivity
  have h_posx : 0 ≤ 1 + |x| := by positivity
  have h_posy : 0 ≤ 1 + |y| := by positivity
  have h_base_le : 1 + |x + y| ≤ (1 + |x|) * (1 + |y|) := by
    have hx : 0 ≤ |x| := abs_nonneg x
    have hy : 0 ≤ |y| := abs_nonneg y
    have := abs_add_le x y
    nlinarith [mul_nonneg hx hy]
  rw [← Real.mul_rpow h_posx h_posy]
  exact Real.rpow_le_rpow h_pos1 h_base_le (Nat.cast_nonneg m)

/-- The negation map as a continuous linear map on ℝ. -/
def negCLM : ℝ →L[ℝ] ℝ := -ContinuousLinearMap.id ℝ ℝ

/-- Reflection of a Schwartz function: g̃(x) = g(-x). -/
def schwartzReflect (g : SchwartzMap ℝ ℝ) : SchwartzMap ℝ ℝ :=
  SchwartzMap.compCLM ℝ (g := negCLM)
    negCLM.hasTemperateGrowth
    ⟨1, 1, fun x => by simp [negCLM]⟩ g

/-- Convolution of two Schwartz functions. -/
def schwartzConv (g h : SchwartzMap ℝ ℝ) : ℝ → ℝ :=
  (g : ℝ → ℝ) ⋆[ContinuousLinearMap.mul ℝ ℝ] (h : ℝ → ℝ)

/-- The autocorrelation map: g ↦ g ⋆ g̃. -/
def schwartzAutocorr (g : SchwartzMap ℝ ℝ) : ℝ → ℝ :=
  schwartzConv g (schwartzReflect g)

/-! ## Helper Lemmas for the Convolution Bound -/

lemma schwartz_weighted_norm_bddAbove (k : ℕ) (f : SchwartzMap ℝ ℝ) :
    BddAbove (Set.range (fun y : ℝ => (1 + ‖y‖)^k * ‖f y‖)) := by
  have h_bdd : ∃ C, ∀ y : ℝ, (1 + ‖y‖)^k * ‖f y‖ ≤ C := by
    have h_conv : ∃ C, ∀ y : ℝ, ‖y‖^k * ‖f y‖ ≤ C := by
      simpa using f.decay' k 0
    have h_conv2 : ∃ C, ∀ y : ℝ, ‖f y‖ ≤ C := by
      have := f.decay' 0 0; aesop;
    obtain ⟨ C₁, hC₁ ⟩ := h_conv
    obtain ⟨ C₂, hC₂ ⟩ := h_conv2
    use (2^k) * (C₁ + C₂);
    intro y
    have h_ineq : (1 + ‖y‖)^k ≤ 2^k * (‖y‖^k + 1) := by
      have h_ineq : (1 + ‖y‖)^k ≤ (2 * max ‖y‖ 1)^k := by
        exact pow_le_pow_left₀ ( by positivity ) ( by linarith [ le_max_left ‖y‖ 1, le_max_right ‖y‖ 1 ] ) _;
      cases max_cases ‖y‖ 1 <;> simp_all +decide [ mul_pow ];
      · exact h_ineq.trans ( mul_le_mul_of_nonneg_left ( le_add_of_nonneg_right zero_le_one ) ( by positivity ) );
      · exact le_trans h_ineq ( le_mul_of_one_le_right ( by positivity ) ( by linarith [ pow_nonneg ( abs_nonneg y ) k ] ) );
    nlinarith [ hC₁ y, hC₂ y, show 0 ≤ ( 2 : ℝ ) ^ k by positivity, show 0 ≤ ( ‖y‖ ^ k : ℝ ) by positivity, show 0 ≤ ( ‖f y‖ : ℝ ) by positivity, mul_le_mul_of_nonneg_left ( hC₁ y ) ( show 0 ≤ ( 2 : ℝ ) ^ k by positivity ), mul_le_mul_of_nonneg_left ( hC₂ y ) ( show 0 ≤ ( 2 : ℝ ) ^ k by positivity ) ];
  exact ⟨ h_bdd.choose, Set.forall_mem_range.mpr h_bdd.choose_spec ⟩

lemma schwartz_pointwise_le_iSup (k : ℕ) (f : SchwartzMap ℝ ℝ) (y : ℝ) :
    (1 + ‖y‖)^k * ‖f y‖ ≤ ⨆ z : ℝ, (1 + ‖z‖)^k * ‖f z‖ := by
  exact le_csSup (schwartz_weighted_norm_bddAbove k f) (Set.mem_range_self y)

lemma schwartz_iSup_nonneg (k : ℕ) (f : SchwartzMap ℝ ℝ) :
    0 ≤ ⨆ z : ℝ, (1 + ‖z‖)^k * ‖f z‖ := by
  exact Real.iSup_nonneg fun _ => mul_nonneg (pow_nonneg (by positivity) _) (norm_nonneg _)

lemma peetres_inequality_norm (x y : ℝ) (m : ℕ) :
    (1 + ‖x‖)^m ≤ (1 + ‖x - y‖)^m * (1 + ‖y‖)^m := by
  rw [← mul_pow]
  exact pow_le_pow_left₀ (by positivity) (by nlinarith [norm_nonneg (x - y), norm_nonneg y, mul_self_nonneg (‖x - y‖ - ‖y‖), norm_sub_norm_le x y]) _

lemma integrable_one_div_one_plus_norm_sq :
    Integrable (fun t : ℝ => (1 : ℝ) / (1 + ‖t‖)^2) volume := by
  have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => 1 / (1 + |t|)^2) (Set.Ioi 0) := by
    have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => (1 + t) ^ (-2 : ℝ)) (Set.Ioi 0) := by
      have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => t ^ (-2 : ℝ)) (Set.Ioi 1) := by
        rw [ integrableOn_Ioi_rpow_iff ] <;> norm_num;
      rw [ ← MeasureTheory.integrable_indicator_iff ( measurableSet_Ioi ) ] at *;
      convert h_integrable.comp_add_left 1 using 1 ; norm_num [ Set.indicator ] ; ring_nf ; aesop;
    refine' h_integrable.congr_fun ( fun x hx => by norm_cast; norm_num [ abs_of_pos hx.out ] ) measurableSet_Ioi;
  have h_integrable_neg : MeasureTheory.IntegrableOn (fun t : ℝ => 1 / (1 + |t|)^2) (Set.Iio 0) := by
    convert h_integrable.comp_neg using 1 ; norm_num [ abs_neg ];
    norm_num [ Set.ext_iff ];
  simpa using MeasureTheory.IntegrableOn.integrable ( h_integrable_neg.union h_integrable )

lemma schwartz_convolution_bound (m : ℕ) (g h : SchwartzMap ℝ ℝ) :
    ∃ C > 0, ∀ x : ℝ, (1 + ‖x‖)^m * ‖schwartzConv g h x‖ ≤
      C * (⨆ y, (1 + ‖y‖)^(m+2) * ‖g y‖) * (⨆ y, (1 + ‖y‖)^m * ‖h y‖) := by
  -- For any x, t: (1+‖x‖)^m * ‖g t‖ * ‖h(x-t)‖ ≤ Sg * Sh / (1+‖t‖)^2.
  have h_bound : ∀ x t : ℝ, (1 + ‖x‖)^m * ‖g t‖ * ‖h (x - t)‖ ≤ (⨆ y : ℝ, (1 + ‖y‖)^(m+2) * ‖g y‖) * (⨆ y : ℝ, (1 + ‖y‖)^m * ‖h y‖) / (1 + ‖t‖)^2 := by
    -- By Peetre's inequality, we have $(1 + \|x\|)^m \leq (1 + \|x - t\|)^m (1 + \|t\|)^m$.
    have peetre_inequality (x t : ℝ) : (1 + ‖x‖)^m ≤ (1 + ‖x - t‖)^m * (1 + ‖t‖)^m := by
      convert peetres_inequality_norm x t m using 1;
    -- Using the bounds from Peetre's inequality and the definition of Schwartz functions, we get:
    have h_bound_step : ∀ x t : ℝ, (1 + ‖x‖)^m * ‖g t‖ * ‖h (x - t)‖ ≤ ((1 + ‖t‖)^(m+2) * ‖g t‖) * ((1 + ‖x - t‖)^m * ‖h (x - t)‖) / (1 + ‖t‖)^2 := by
      intro x t; specialize peetre_inequality x t; rw [ le_div_iff₀ ( by positivity ) ] ; ring_nf at *;
      nlinarith [ show 0 ≤ ‖g t‖ * ‖h ( x - t )‖ * ‖t‖ by positivity, show 0 ≤ ‖g t‖ * ‖h ( x - t )‖ * ‖t‖ ^ 2 by positivity, show 0 ≤ ‖g t‖ * ‖h ( x - t )‖ by positivity ];
    refine fun x t => le_trans ( h_bound_step x t ) ?_;
    gcongr;
    · exact Real.iSup_nonneg fun _ => by positivity;
    · exact le_ciSup (schwartz_weighted_norm_bddAbove (m+2) g) t;
    · exact schwartz_pointwise_le_iSup m h (x - t);
  -- Integrating over t: (1+‖x‖)^m * ‖conv g h x‖ ≤ ∫ Sg*Sh/(1+‖t‖)^2 dt.
  have h_integral_bound : ∀ x : ℝ, (1 + ‖x‖)^m * ‖schwartzConv g h x‖ ≤ (∫ t : ℝ, (1 : ℝ) / (1 + ‖t‖)^2) * ((⨆ y : ℝ, (1 + ‖y‖)^(m+2) * ‖g y‖) * (⨆ y : ℝ, (1 + ‖y‖)^m * ‖h y‖)) := by
    intro x
    have h_integral_bound : (1 + ‖x‖)^m * ∫ t : ℝ, ‖g t‖ * ‖h (x - t)‖ ≤ (∫ t : ℝ, (1 : ℝ) / (1 + ‖t‖)^2) * ((⨆ y : ℝ, (1 + ‖y‖)^(m+2) * ‖g y‖) * (⨆ y : ℝ, (1 + ‖y‖)^m * ‖h y‖)) := by
      rw [ ← MeasureTheory.integral_const_mul ];
      rw [ ← MeasureTheory.integral_mul_const ];
      refine' MeasureTheory.integral_mono_of_nonneg _ _ _;
      · exact Filter.Eventually.of_forall fun t => by positivity;
      · exact MeasureTheory.Integrable.mul_const ( by simpa using integrable_one_div_one_plus_norm_sq ) _;
      · filter_upwards [ ] using fun t => by simpa only [ mul_assoc, one_div, inv_mul_eq_div ] using h_bound x t;
    refine' le_trans _ h_integral_bound;
    refine' mul_le_mul_of_nonneg_left _ ( by positivity );
    convert MeasureTheory.norm_integral_le_integral_norm ( fun t => g t * h ( x - t ) ) using 1;
    norm_num;
  exact ⟨ Max.max ( ∫ t : ℝ, 1 / ( 1 + ‖t‖ ) ^ 2 ) 1, by positivity, fun x => le_trans ( h_integral_bound x ) ( by rw [ mul_assoc ] ; exact mul_le_mul_of_nonneg_right ( le_max_left _ _ ) ( by exact mul_nonneg ( by exact Real.iSup_nonneg fun _ => by positivity ) ( by exact Real.iSup_nonneg fun _ => by positivity ) ) ) ⟩

/-! ## Helper Lemmas for Continuity -/

/-
Evaluation at a point is continuous in the Schwartz topology.
-/
lemma schwartz_eval_continuous (x₀ : ℝ) :
    Continuous (fun (f : SchwartzMap ℝ ℝ) => f x₀) := by
  refine' continuous_iff_continuousAt.mpr _;
  intro f;
  refine' tendsto_iff_norm_sub_tendsto_zero.mpr _;
  -- The norm of the difference is bounded by the seminorm of the difference.
  have h_norm_le_seminorm : ∀ e : SchwartzMap ℝ ℝ, ‖e x₀ - f x₀‖ ≤ SchwartzMap.seminorm ℝ 0 0 (e - f) := by
    intro e; exact (by
    convert SchwartzMap.le_seminorm ℝ 0 0 ( e - f ) x₀ using 1 ; norm_num);
  refine' squeeze_zero ( fun e => norm_nonneg _ ) h_norm_le_seminorm _;
  convert Continuous.tendsto _ _ <;> norm_num;
  have h_seminorm_cont : Continuous (fun t : SchwartzMap ℝ ℝ => SchwartzMap.seminorm ℝ 0 0 t) := by
    have := schwartz_withSeminorms ℝ ℝ ℝ
    convert this.continuous_seminorm _;
    swap;
    exacts [ ⟨ 0, 0 ⟩, rfl ];
  exact h_seminorm_cont.comp ( continuous_sub_right _ )

lemma schwartzReflect_continuous :
    Continuous (fun (g : SchwartzMap ℝ ℝ) => schwartzReflect g) := by
  convert ContinuousLinearMap.continuous _

/-- Unfolding lemma: schwartzReflect g y = g (-y). -/
lemma schwartzReflect_apply (g : SchwartzMap ℝ ℝ) (y : ℝ) :
    schwartzReflect g y = g (-y) := by
  change (g.toFun ∘ negCLM) y = g (-y)
  simp [negCLM]; rfl

/-- Unfolding lemma: schwartzAutocorr g x₀ = ∫ t, g t * g (t - x₀). -/
lemma schwartzAutocorr_eq (g : SchwartzMap ℝ ℝ) (x₀ : ℝ) :
    schwartzAutocorr g x₀ = ∫ t, g t * g (t - x₀) := by
  unfold schwartzAutocorr schwartzConv
  rw [convolution_def]
  congr 1; ext t
  simp only [ContinuousLinearMap.mul_apply']
  congr 1
  rw [schwartzReflect_apply]
  ring

lemma schwartz_sup_sub_tendsto_zero (g₀ : SchwartzMap ℝ ℝ) :
    Filter.Tendsto (fun g : SchwartzMap ℝ ℝ =>
      ⨆ t : ℝ, ‖(g - g₀) t‖) (nhds g₀) (nhds 0) := by
  have h_sup_norm : ∀ g : SchwartzMap ℝ ℝ, ⨆ t : ℝ, ‖g t‖ ≤ SchwartzMap.seminorm ℝ 0 0 g := by
    intro g;
    have := @SchwartzMap.le_seminorm ℝ;
    exact ciSup_le fun x => by simpa using this 0 0 g x;
  refine' squeeze_zero ( fun g => _ ) ( fun g => h_sup_norm _ ) _;
  · exact Real.iSup_nonneg fun _ => norm_nonneg _;
  · refine' Continuous.tendsto' _ _ _ _ <;> norm_num;
    refine' Continuous.comp _ _;
    · have := schwartz_withSeminorms ℝ ℝ ℝ;
      convert this.continuous_seminorm _;
      swap;
      exacts [ ⟨ 0, 0 ⟩, rfl ];
    · fun_prop

/-
The L¹ norm of a Schwartz function is bounded by a continuous Schwartz seminorm.
-/
lemma schwartz_L1_le (f : SchwartzMap ℝ ℝ) :
    ∫ t, ‖f t‖ ≤ (∫ t : ℝ, 1 / (1 + ‖t‖)^2) *
      (⨆ t : ℝ, (1 + ‖t‖)^2 * ‖f t‖) := by
  have h_bound : ∀ t : ℝ, ‖f t‖ ≤ (1 / (1 + ‖t‖)^2) * (⨆ t : ℝ, (1 + ‖t‖)^2 * ‖f t‖) := by
    intro t;
    have h_le : (1 + ‖t‖)^2 * ‖f t‖ ≤ ⨆ t : ℝ, (1 + ‖t‖)^2 * ‖f t‖ := by
      exact schwartz_pointwise_le_iSup 2 f t;
    rwa [ one_div, inv_mul_eq_div, le_div_iff₀' ( by positivity ) ];
  convert MeasureTheory.integral_mono _ _ h_bound;
  · rw [ MeasureTheory.integral_mul_const ];
  · exact f.integrable.norm;
  · exact MeasureTheory.Integrable.mul_const ( by simpa using integrable_one_div_one_plus_norm_sq ) _

lemma schwartz_mul_shift_integrable (f h : SchwartzMap ℝ ℝ) (c : ℝ) :
    Integrable (fun t => f t * h (t - c)) volume := by
  -- Since $f$ is a Schwartz function, it is bounded. Therefore, there exists $M > 0$ such that $|f(t)| \leq M$ for all $t$.
  obtain ⟨M, hM⟩ : ∃ M > 0, ∀ t : ℝ, |f t| ≤ M := by
    obtain ⟨ M, hM ⟩ := f.decay 0 0;
    aesop;
  refine' MeasureTheory.Integrable.mono' _ _ _;
  refine' fun t => M * ‖h ( t - c )‖;
  · exact MeasureTheory.Integrable.const_mul ( h.integrable.norm.comp_sub_right c ) _;
  · exact MeasureTheory.AEStronglyMeasurable.mul ( f.continuous.aestronglyMeasurable ) ( h.continuous.comp_aestronglyMeasurable ( measurable_id.sub_const c |> Measurable.aestronglyMeasurable ) );
  · filter_upwards [ ] using fun x => by simpa [ abs_mul ] using mul_le_mul_of_nonneg_right ( hM.2 x ) ( abs_nonneg _ ) ;

lemma autocorr_diff_le (g g₀ : SchwartzMap ℝ ℝ) (x₀ : ℝ) :
    ‖∫ t, g t * g (t - x₀) - ∫ t, g₀ t * g₀ (t - x₀)‖ ≤
      (⨆ t : ℝ, ‖(g - g₀) t‖) * (∫ t, ‖g (t - x₀)‖) +
      (∫ t, ‖g₀ t‖) * (⨆ t : ℝ, ‖(g - g₀) t‖) := by
  by_cases h : MeasureTheory.Integrable ( fun t : ℝ => g₀ t * g₀ ( t - x₀ ) ) MeasureTheory.volume <;> simp_all +decide [ MeasureTheory.integral_undef ];
  · -- Apply the triangle inequality for integrals: |∫ f - ∫ g| ≤ ∫ |f - g|.
    have h_triangle : ∀ f g : ℝ → ℝ, MeasureTheory.Integrable f MeasureTheory.volume → MeasureTheory.Integrable g MeasureTheory.volume → |∫ t, f t - ∫ t, g t| ≤ ∫ t, |f t - g t| := by
      intro f g hf hg;
      by_cases h_integrable : MeasureTheory.Integrable (fun t => f t - ∫ t, g t) MeasureTheory.volume;
      · have h_triangle : |∫ t, f t - ∫ t, g t| ≤ ∫ t, |f t - g t| := by
          have h_integral_diff : ∫ t, f t - ∫ t, g t = ∫ t, (f t - g t) - (∫ t, g t - g t) := by
            rw [ MeasureTheory.integral_sub ] <;> norm_num [ hf, hg ];
            · rw [ MeasureTheory.integral_sub hf hg ] ; norm_num [ MeasureTheory.measureReal_def ];
              have := h_integrable.sub hf; simp_all +decide [ MeasureTheory.Integrable ] ;
              simp_all +decide [ hasFiniteIntegral_iff_norm ];
              by_cases h : ∫ t, g t = 0 <;> simp_all +decide [ ENNReal.mul_top ];
            · convert h_integrable.neg.add hf using 1 ; ext ; norm_num
          convert MeasureTheory.norm_integral_le_integral_norm ( fun t => f t - g t ) using 1 ; aesop;
        exact h_triangle;
      · rw [ MeasureTheory.integral_undef h_integrable ] ; norm_num;
        finiteness;
    refine' le_trans ( h_triangle _ _ _ _ ) _;
    · convert schwartz_mul_shift_integrable g g x₀ using 1;
    · exact h;
    · -- Apply the triangle inequality to the integrand.
      have h_triangle : ∀ t : ℝ, |g t * g (t - x₀) - g₀ t * g₀ (t - x₀)| ≤ |g t - g₀ t| * |g (t - x₀)| + |g₀ t| * |g (t - x₀) - g₀ (t - x₀)| := by
        intro t; rw [ ← abs_mul, ← abs_mul ] ; ring_nf;
        cases abs_cases ( g t * g ( t - x₀ ) - g₀ t * g₀ ( t - x₀ ) ) <;> cases abs_cases ( g t * g ( t - x₀ ) - g ( t - x₀ ) * g₀ t ) <;> cases abs_cases ( g ( t - x₀ ) * g₀ t - g₀ t * g₀ ( t - x₀ ) ) <;> linarith;
      refine' le_trans ( MeasureTheory.integral_mono_of_nonneg _ _ _ ) _;
      refine' fun t => ( ⨆ t, |g t - g₀ t| ) * |g ( t - x₀ )| + |g₀ t| * ( ⨆ t, |g t - g₀ t| );
      · exact Filter.Eventually.of_forall fun t => abs_nonneg _;
      · refine' MeasureTheory.Integrable.add _ _;
        · exact MeasureTheory.Integrable.const_mul ( g.integrable.norm.comp_sub_right x₀ ) _;
        · exact MeasureTheory.Integrable.mul_const ( g₀.integrable.norm ) _;
      · filter_upwards [ ] with t using le_trans ( h_triangle t ) ( add_le_add ( mul_le_mul_of_nonneg_right ( le_ciSup ( show BddAbove ( Set.range ( fun t => |g t - g₀ t| ) ) from by
                                                                                                                          have := schwartz_weighted_norm_bddAbove 0 ( g - g₀ );
                                                                                                                          grind ) t ) ( abs_nonneg _ ) ) ( mul_le_mul_of_nonneg_left ( le_ciSup ( show BddAbove ( Set.range ( fun t => |g t - g₀ t| ) ) from by
                                                                                                                                                                                                                                                                have := schwartz_weighted_norm_bddAbove 0 ( g - g₀ );
                                                                                                                                                                                                                                                                grind ) ( t - x₀ ) ) ( abs_nonneg _ ) ) );
      · rw [ MeasureTheory.integral_add, MeasureTheory.integral_const_mul, MeasureTheory.integral_mul_const ];
        · exact MeasureTheory.Integrable.const_mul ( g.integrable.norm.comp_sub_right x₀ ) _;
        · exact MeasureTheory.Integrable.mul_const ( g₀.integrable.norm ) _;
  · exact False.elim <| h <| by simpa using schwartz_mul_shift_integrable g₀ g₀ x₀;

/-
The autocorrelation as L² inner product.
-/
lemma autocorr_eq_L2_inner (g : SchwartzMap ℝ ℝ) (x₀ : ℝ) :
    schwartzAutocorr g x₀ = @inner ℝ (Lp ℝ 2 volume) _
      (g.toLp 2)
      ((Lp.compMeasurePreserving (fun t : ℝ => t - x₀)
        (measurePreserving_sub_right volume x₀)) (g.toLp 2)) := by
  rw [ schwartzAutocorr_eq ];
  convert ( MeasureTheory.integral_congr_ae ?_ ) using 1;
  simp +decide [ Filter.EventuallyEq, Lp.compMeasurePreserving ];
  erw [ MeasureTheory.AEEqFun.compMeasurePreserving_mk ];
  simp +decide [ mul_comm, AEEqFun.mk_eq_mk ];
  filter_upwards [ MeasureTheory.AEEqFun.coeFn_mk ( g ∘ fun t => t - x₀ ) ( by exact g.continuous.comp_aestronglyMeasurable ( by exact measurable_id.sub_const x₀ |> Measurable.aestronglyMeasurable ) ), g.coeFn_toLp 2 ] with x hx₁ hx₂ using by aesop;

/-- For fixed x₀, the autocorrelation evaluation g ↦ ∫ g(t) * g(t - x₀) dt
    is continuous at every g₀ in the Schwartz topology. -/
lemma autocorrelation_continuousAt (x₀ : ℝ) (g₀ : SchwartzMap ℝ ℝ) :
    ContinuousAt (fun g : SchwartzMap ℝ ℝ => schwartzAutocorr g x₀) g₀ := by
  have h_eq : (fun g : SchwartzMap ℝ ℝ => schwartzAutocorr g x₀) =
    (fun g => @inner ℝ (Lp ℝ 2 volume) _ (g.toLp 2)
      ((Lp.compMeasurePreserving (fun t : ℝ => t - x₀)
        (measurePreserving_sub_right volume x₀)) (g.toLp 2))) := by
    ext g; exact autocorr_eq_L2_inner g x₀
  rw [h_eq]
  have h_toLp : Continuous (fun g : SchwartzMap ℝ ℝ => g.toLp 2 (volume : Measure ℝ)) :=
    (SchwartzMap.toLpCLM ℝ ℝ 2 volume).continuous
  have hmp := measurePreserving_sub_right volume x₀
  have h_comp : Continuous (Lp.compMeasurePreserving (E := ℝ) (p := 2)
      (fun t : ℝ => t - x₀) hmp) :=
    LipschitzWith.continuous (K := 1) (fun f g => by
      simp [edist_dist, dist_eq_norm, ← map_sub, Lp.norm_compMeasurePreserving])
  exact ((continuous_inner (𝕜 := ℝ)).comp
    (Continuous.prodMk h_toLp (h_comp.comp h_toLp))).continuousAt

/-- Autocorrelation is continuous in the Schwartz topology. -/
theorem autocorrelation_continuous :
    Continuous (fun (g : SchwartzMap ℝ ℝ) ↦ schwartzAutocorr g) := by
  apply continuous_pi
  intro x₀
  rw [continuous_iff_continuousAt]
  exact fun g₀ => autocorrelation_continuousAt x₀ g₀

end DULA
end