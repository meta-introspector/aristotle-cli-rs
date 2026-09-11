import Mathlib

open MeasureTheory Topology Filter Set
open scoped Convolution

noncomputable section

namespace DULA

/-!
# CONVOLUTION CONTINUITY IN SCHWARTZ SPACE
==============================================================================
We formally prove the continuity of the autocorrelation map g ↦ g ⋆ g̃.
This clears the final hypothesis (`hac`) in the DULA Framework.
-/

/-- Peetre's Inequality for positive integer exponents.
    This is the core bound required to split polynomial weights across
    the convolution integral.
    STATUS: PROVED (Zero Sorries) -/
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

/-- Reflection of a Schwartz function: g̃(x) = g(-x).
    For real-valued Schwartz maps, this serves as the star (adjoint) involution. -/
def schwartzReflect (g : SchwartzMap ℝ ℝ) : SchwartzMap ℝ ℝ :=
  SchwartzMap.compCLM ℝ (g := negCLM)
    negCLM.hasTemperateGrowth
    ⟨1, 1, fun x => by simp [negCLM]⟩ g

/-- Convolution of two Schwartz functions, using the standard Mathlib
    bilinear multiplication map. -/
def schwartzConv (g h : SchwartzMap ℝ ℝ) : ℝ → ℝ :=
  (g : ℝ → ℝ) ⋆[ContinuousLinearMap.mul ℝ ℝ] (h : ℝ → ℝ)

/-- The autocorrelation map: g ↦ g ⋆ g̃ where g̃(x) = g(-x). -/
def schwartzAutocorr (g : SchwartzMap ℝ ℝ) : ℝ → ℝ :=
  schwartzConv g (schwartzReflect g)

/-! ## Helper Lemmas for the Convolution Bound -/

/-
The weighted norms of a Schwartz function are bounded above.
-/
lemma schwartz_weighted_norm_bddAbove (k : ℕ) (f : SchwartzMap ℝ ℝ) :
    BddAbove (Set.range (fun y : ℝ => (1 + ‖y‖)^k * ‖f y‖)) := by
  obtain ⟨ C, hC ⟩ := f.decay' k 0;
  -- Use the decay' condition to find a bound for the function.
  have h_bound : ∀ y : ℝ, (1 + ‖y‖)^k * ‖f y‖ ≤ 2^k * (‖y‖^k * ‖f y‖ + ‖f y‖) := by
    intro y;
    have h_bound : (1 + ‖y‖)^k ≤ 2^k * (‖y‖^k + 1) := by
      rw [ show ( 1 + ‖y‖ ) ^ k = ( ( 1 + ‖y‖ ) / 2 ) ^ k * 2 ^ k by rw [ ← mul_pow, div_mul_cancel₀ _ ( by norm_num ) ] ];
      rw [ mul_comm ] ; gcongr;
      exact le_trans ( pow_le_pow_left₀ ( by positivity ) ( show ( 1 + ‖y‖ ) / 2 ≤ Max.max ‖y‖ 1 by cases max_cases ‖y‖ 1 <;> linarith ) _ ) ( by rw [ max_def ] ; split_ifs <;> ring_nf <;> norm_num );
    nlinarith [ norm_nonneg ( f y ) ];
  obtain ⟨ D, hD ⟩ := f.decay 0 0;
  exact ⟨ 2 ^ k * ( C + D ), Set.forall_mem_range.mpr fun y => le_trans ( h_bound y ) ( mul_le_mul_of_nonneg_left ( add_le_add ( by simpa using hC y ) ( by simpa using hD.2 y ) ) ( by positivity ) ) ⟩

/-
Pointwise bound: a Schwartz function value is bounded by its weighted sup.
-/
lemma schwartz_pointwise_le_iSup (k : ℕ) (f : SchwartzMap ℝ ℝ) (y : ℝ) :
    (1 + ‖y‖)^k * ‖f y‖ ≤ ⨆ z : ℝ, (1 + ‖z‖)^k * ‖f z‖ := by
  apply le_csSup;
  · exact?;
  · exact Set.mem_range_self y

/-
The weighted sup is nonneg.
-/
lemma schwartz_iSup_nonneg (k : ℕ) (f : SchwartzMap ℝ ℝ) :
    0 ≤ ⨆ z : ℝ, (1 + ‖z‖)^k * ‖f z‖ := by
  exact Real.iSup_nonneg fun _ => mul_nonneg ( pow_nonneg ( by positivity ) _ ) ( norm_nonneg _ )

/-
Peetre's inequality with natural powers and norms.
-/
lemma peetres_inequality_norm (x y : ℝ) (m : ℕ) :
    (1 + ‖x‖)^m ≤ (1 + ‖x - y‖)^m * (1 + ‖y‖)^m := by
  rw [ ← mul_pow ];
  exact pow_le_pow_left₀ ( by positivity ) ( by nlinarith [ norm_nonneg ( x - y ), norm_nonneg y, mul_self_nonneg ( ‖x - y‖ - ‖y‖ ), norm_sub_norm_le x y ] ) _

/-
The function 1/(1+|t|)^2 is integrable on ℝ.
-/
lemma integrable_one_div_one_plus_norm_sq :
    Integrable (fun t : ℝ => (1 : ℝ) / (1 + ‖t‖)^2) volume := by
  -- We'll use the fact that the integral of $1/(1+|t|)^2$ over $\mathbb{R}$ converges.
  have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => (1 + |t|) ^ (-2 : ℝ)) (Set.Ioi 0) := by
    have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => (1 + t) ^ (-2 : ℝ)) (Set.Ioi (0 : ℝ)) := by
      have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => t ^ (-2 : ℝ)) (Set.Ioi 1) := by
        rw [ integrableOn_Ioi_rpow_iff ] <;> norm_num;
      rw [ ← MeasureTheory.integrable_indicator_iff ( measurableSet_Ioi ) ] at *;
      convert h_integrable.comp_add_left 1 using 1;
      ext; rw [ Set.indicator_apply, Set.indicator_apply ] ; aesop;
    exact h_integrable.congr_fun ( fun x hx => by rw [ abs_of_pos hx.out ] ) measurableSet_Ioi;
  have h_integrable_neg : MeasureTheory.IntegrableOn (fun t : ℝ => (1 + |t|) ^ (-2 : ℝ)) (Set.Iio 0) := by
    convert h_integrable.comp_neg using 1 ; norm_num [ abs_neg ];
    norm_num [ Set.ext_iff ];
  simpa using MeasureTheory.IntegrableOn.integrable ( h_integrable_neg.union h_integrable )

/-
The Fundamental Convolution Seminorm Bound.
-/
lemma schwartz_convolution_bound (m : ℕ) (g h : SchwartzMap ℝ ℝ) :
    ∃ C > 0, ∀ x : ℝ, (1 + ‖x‖)^m * ‖schwartzConv g h x‖ ≤
      C * (⨆ y, (1 + ‖y‖)^(m+2) * ‖g y‖) * (⨆ y, (1 + ‖y‖)^m * ‖h y‖) := by
  -- Set Sg = ⨆ y, (1 + ‖y‖)^(m+2) * ‖g y‖ and Sh = ⨆ y, (1 + ‖y‖)^m * ‖h y‖.
  set Sg := ⨆ y : ℝ, (1 + ‖y‖)^(m + 2) * ‖g y‖
  set Sh := ⨆ y : ℝ, (1 + ‖y‖)^m * ‖h y‖;
  -- By definition of $Sg$ and $Sh$, we know that for all $t \in \mathbb{R}$, $(1 + ‖t‖)^{m+2} * ‖g t‖ ≤ Sg$ and $(1 + ‖x - t‖)^m * ‖h (x - t)‖ ≤ Sh$.
  have h_bound : ∀ x t : ℝ, (1 + ‖x‖)^m * ‖g t‖ * ‖h (x - t)‖ ≤ Sg * Sh / (1 + ‖t‖)^2 := by
    intro x t;
    -- Applying the pointwise bounds and Peetre's inequality, we get:
    have h_pointwise : (1 + ‖t‖)^(m + 2) * ‖g t‖ ≤ Sg ∧ (1 + ‖x - t‖)^m * ‖h (x - t)‖ ≤ Sh := by
      exact ⟨ le_ciSup ( show BddAbove ( Set.range ( fun y : ℝ => ( 1 + ‖y‖ ) ^ ( m + 2 ) * ‖g y‖ ) ) from by exact? ) t, le_ciSup ( show BddAbove ( Set.range ( fun y : ℝ => ( 1 + ‖y‖ ) ^ m * ‖h y‖ ) ) from by exact? ) ( x - t ) ⟩;
    -- By Peetre's inequality, we have $(1 + ‖x‖)^m \leq (1 + ‖x - t‖)^m * (1 + ‖t‖)^m$.
    have h_peetre : (1 + ‖x‖)^m ≤ (1 + ‖x - t‖)^m * (1 + ‖t‖)^m := by
      convert peetres_inequality_norm x t m using 1;
    rw [ le_div_iff₀ ( by positivity ) ];
    convert mul_le_mul h_pointwise.1 h_pointwise.2 ( by positivity ) ( by exact ( show 0 ≤ Sg by exact Real.iSup_nonneg fun _ => by positivity ) ) |> le_trans _ using 1 ; ring;
    nlinarith [ show 0 ≤ ‖g t‖ * ‖h ( x - t )‖ * ‖t‖ by positivity, show 0 ≤ ‖g t‖ * ‖h ( x - t )‖ * ‖t‖ ^ 2 by positivity, show 0 ≤ ‖g t‖ * ‖h ( x - t )‖ by positivity ];
  -- Integrating over $t$, we get $(1 + ‖x‖)^m * ‖schwartzConv g h x‖ ≤ ∫ t, Sg * Sh / (1 + ‖t‖)^2 dt$.
  have h_integral_bound : ∀ x : ℝ, (1 + ‖x‖)^m * ‖schwartzConv g h x‖ ≤ ∫ t : ℝ, Sg * Sh / (1 + ‖t‖)^2 := by
    intro x
    have h_integral_bound : (1 + ‖x‖)^m * ‖schwartzConv g h x‖ ≤ ∫ t : ℝ, (1 + ‖x‖)^m * ‖g t‖ * ‖h (x - t)‖ := by
      refine' le_trans ( mul_le_mul_of_nonneg_left ( MeasureTheory.norm_integral_le_integral_norm _ ) ( by positivity ) ) _;
      norm_num [ mul_assoc, MeasureTheory.integral_const_mul ];
    refine' le_trans h_integral_bound ( MeasureTheory.integral_mono_of_nonneg _ _ _ );
    · exact Filter.Eventually.of_forall fun t => by positivity;
    · have := integrable_one_div_one_plus_norm_sq;
      simpa using this.const_mul _;
    · filter_upwards [ ] using h_bound x;
  refine' ⟨ Max.max ( ∫ t : ℝ, 1 / ( 1 + ‖t‖ ) ^ 2 ) 1, _, _ ⟩ <;> norm_num [ div_eq_mul_inv, mul_assoc, MeasureTheory.integral_const_mul ] at *;
  exact fun x => le_trans ( h_integral_bound x ) ( by nlinarith [ le_max_left ( ∫ t : ℝ, ( ( 1 + |t| ) ^ 2 ) ⁻¹ ) 1, le_max_right ( ∫ t : ℝ, ( ( 1 + |t| ) ^ 2 ) ⁻¹ ) 1, show 0 ≤ Sg * Sh by exact mul_nonneg ( by exact Real.iSup_nonneg fun _ => by positivity ) ( by exact Real.iSup_nonneg fun _ => by positivity ) ] )

/-! ## Helper Lemmas for Continuity -/

/-- Evaluation at a point is continuous in the Schwartz topology. -/
lemma schwartz_eval_continuous (x₀ : ℝ) :
    Continuous (fun (f : SchwartzMap ℝ ℝ) => f x₀) := by
  have hw := schwartz_withSeminorms ℝ ℝ ℝ
  have h_sc : Continuous (fun f : SchwartzMap ℝ ℝ => (schwartzSeminormFamily ℝ ℝ ℝ (0, 0)) f) :=
    hw.continuous_seminorm (0, 0)
  rw [continuous_iff_continuousAt]
  intro g₀
  rw [ContinuousAt, tendsto_iff_norm_sub_tendsto_zero]
  apply squeeze_zero (fun _ => norm_nonneg _)
  · intro f
    show ‖f x₀ - g₀ x₀‖ ≤ (schwartzSeminormFamily ℝ ℝ ℝ (0, 0)) (f - g₀)
    simp only [schwartzSeminormFamily]
    have := SchwartzMap.le_seminorm ℝ 0 0 (f - g₀) x₀
    simp at this
    exact this
  · have : Continuous (fun f : SchwartzMap ℝ ℝ => (schwartzSeminormFamily ℝ ℝ ℝ (0, 0)) (f - g₀)) :=
      h_sc.comp (continuous_sub_right g₀)
    simpa using this.tendsto g₀

/-
The reflection map is continuous on SchwartzMap.
-/
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

/-
The sup norm of a Schwartz function difference tends to 0.
-/
lemma schwartz_sup_sub_tendsto_zero (g₀ : SchwartzMap ℝ ℝ) :
    Filter.Tendsto (fun g : SchwartzMap ℝ ℝ =>
      ⨆ t : ℝ, ‖(g - g₀) t‖) (nhds g₀) (nhds 0) := by
  -- The seminorm of a Schwartz function is continuous with respect to the Schwartz topology.
  have h_seminorm_cont : Continuous (fun (g : SchwartzMap ℝ ℝ) => SchwartzMap.seminorm ℝ 0 0 g) := by
    have := @schwartz_withSeminorms ℝ ℝ ℝ;
    convert this.continuous_seminorm ( 0, 0 ) using 1;
  -- The supremum norm is bounded above by the seminorm (0,0).
  have h_sup_le_seminorm : ∀ g : SchwartzMap ℝ ℝ, ⨆ t, ‖g t‖ ≤ SchwartzMap.seminorm ℝ 0 0 g := by
    intro g;
    refine' ciSup_le _;
    exact?;
  exact squeeze_zero ( fun _ => by exact Real.iSup_nonneg fun _ => norm_nonneg _ ) ( fun _ => h_sup_le_seminorm _ ) ( by simpa using h_seminorm_cont.continuousAt.tendsto.comp ( tendsto_sub_nhds_zero_iff.mpr Filter.tendsto_id ) )

/-- The L¹ norm of a Schwartz function is bounded by a continuous Schwartz seminorm.
    More precisely, ∫ ‖f t‖ dt ≤ C * (Schwartz seminorm bound). -/
lemma schwartz_L1_le (f : SchwartzMap ℝ ℝ) :
    ∫ t, ‖f t‖ ≤ (∫ t : ℝ, 1 / (1 + ‖t‖)^2) *
      (⨆ t : ℝ, (1 + ‖t‖)^2 * ‖f t‖) := by
  rw [ ← MeasureTheory.integral_mul_const ];
  refine' MeasureTheory.integral_mono_of_nonneg _ _ _;
  · exact Filter.Eventually.of_forall fun x => norm_nonneg _;
  · exact MeasureTheory.Integrable.mul_const ( by simpa using integrable_one_div_one_plus_norm_sq ) _;
  · filter_upwards [ ] with t;
    rw [ div_mul_eq_mul_div, le_div_iff₀ ] <;> try positivity;
    simpa [ mul_comm ] using le_ciSup ( show BddAbove ( Set.range ( fun t : ℝ => ( 1 + ‖t‖ ) ^ 2 * ‖f t‖ ) ) from by simpa [ mul_comm ] using schwartz_weighted_norm_bddAbove 2 f ) t

/-
Schwartz functions times shifted Schwartz functions are integrable.
-/
lemma schwartz_mul_shift_integrable (f h : SchwartzMap ℝ ℝ) (c : ℝ) :
    Integrable (fun t => f t * h (t - c)) volume := by
  -- Since $f$ is a Schwartz function, it is bounded. We can obtain such a $C$ from the definition of Schwartz functions.
  obtain ⟨C, hC⟩ : ∃ C, ∀ t, ‖f t‖ ≤ C := by
    have := f.decay' 0 0;
    aesop;
  refine' MeasureTheory.Integrable.mono' ( h.integrable.comp_sub_right c |> fun h_int => h_int.norm.const_mul C ) _ _;
  · exact Continuous.aestronglyMeasurable ( by exact Continuous.mul ( f.continuous ) ( h.continuous.comp ( continuous_sub_right _ ) ) );
  · filter_upwards [ ] using fun x => by simpa only [ norm_mul ] using mul_le_mul_of_nonneg_right ( hC x ) ( norm_nonneg _ ) ;

/-
The autocorrelation difference is bounded by the sup norm times L¹ norms.
-/
lemma autocorr_diff_le (g g₀ : SchwartzMap ℝ ℝ) (x₀ : ℝ) :
    ‖∫ t, g t * g (t - x₀) - ∫ t, g₀ t * g₀ (t - x₀)‖ ≤
      (⨆ t : ℝ, ‖(g - g₀) t‖) * (∫ t, ‖g (t - x₀)‖) +
      (∫ t, ‖g₀ t‖) * (⨆ t : ℝ, ‖(g - g₀) t‖) := by
  by_contra h;
  rw [ MeasureTheory.integral_undef ] at h;
  · exact h <| by rw [ norm_zero ] ; exact add_nonneg ( mul_nonneg ( Real.iSup_nonneg fun _ => norm_nonneg _ ) <| MeasureTheory.integral_nonneg fun _ => norm_nonneg _ ) <| mul_nonneg ( MeasureTheory.integral_nonneg fun _ => norm_nonneg _ ) <| Real.iSup_nonneg fun _ => norm_nonneg _;
  · intro h_integrable
    have h_const : ∫ t : ℝ, g₀ t * g₀ (t - x₀) = 0 := by
      by_cases h : ∫ t : ℝ, g₀ t * g₀ ( t - x₀ ) = 0 <;> simp_all +decide [ MeasureTheory.integral_const_mul ];
      have h_const : ¬MeasureTheory.Integrable (fun t : ℝ => g t * g (t - x₀) - ∫ t : ℝ, g₀ t * g₀ (t - x₀)) volume := by
        intro h_integrable
        have h_const : MeasureTheory.Integrable (fun t : ℝ => g t * g (t - x₀)) volume := by
          convert schwartz_mul_shift_integrable g g x₀ using 1
        have := h_integrable.sub h_const; simp_all +decide [ MeasureTheory.integrable_const_iff ] ;
        convert this.norm.lintegral_lt_top using 1 ; norm_num [ h ];
      contradiction;
    have h_const : ∫ t : ℝ, g t * g (t - x₀) = ∫ t : ℝ, (g - g₀) t * g (t - x₀) + g₀ t * (g - g₀) (t - x₀) + g₀ t * g₀ (t - x₀) := by
      congr; ext t; norm_num; ring;
    have h_const : ∫ t : ℝ, (g - g₀) t * g (t - x₀) + g₀ t * (g - g₀) (t - x₀) + g₀ t * g₀ (t - x₀) = (∫ t : ℝ, (g - g₀) t * g (t - x₀)) + (∫ t : ℝ, g₀ t * (g - g₀) (t - x₀)) + (∫ t : ℝ, g₀ t * g₀ (t - x₀)) := by
      rw [ MeasureTheory.integral_add, MeasureTheory.integral_add ];
      · have := schwartz_mul_shift_integrable ( g - g₀ ) g x₀;
        exact this;
      · convert schwartz_mul_shift_integrable g₀ ( g - g₀ ) x₀ using 1;
      · refine' MeasureTheory.Integrable.add _ _;
        · convert schwartz_mul_shift_integrable ( g - g₀ ) g x₀ using 1;
        · convert schwartz_mul_shift_integrable g₀ ( g - g₀ ) x₀ using 1;
      · exact?;
    have h_const : ‖∫ t : ℝ, (g - g₀) t * g (t - x₀)‖ ≤ (∫ t : ℝ, ‖g (t - x₀)‖) * (⨆ t, ‖(g - g₀) t‖) := by
      refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm _ ) _;
      rw [ ← MeasureTheory.integral_mul_const ];
      refine' MeasureTheory.integral_mono_of_nonneg _ _ _;
      · exact Filter.Eventually.of_forall fun x => norm_nonneg _;
      · exact MeasureTheory.Integrable.mul_const ( MeasureTheory.Integrable.norm ( g.integrable.comp_sub_right x₀ ) ) _;
      · filter_upwards [ ] with t using by rw [ norm_mul, mul_comm ] ; exact mul_le_mul_of_nonneg_left ( le_ciSup ( show BddAbove ( Set.range ( fun t => ‖( g - g₀ ) t‖ ) ) from by
                                                                                                                      have := schwartz_weighted_norm_bddAbove 0 ( g - g₀ );
                                                                                                                      simpa using this ) t ) ( norm_nonneg _ ) ;
    have h_const : ‖∫ t : ℝ, g₀ t * (g - g₀) (t - x₀)‖ ≤ (∫ t : ℝ, ‖g₀ t‖) * (⨆ t, ‖(g - g₀) t‖) := by
      refine' le_trans ( MeasureTheory.norm_integral_le_integral_norm _ ) _;
      rw [ ← MeasureTheory.integral_mul_const ];
      refine' MeasureTheory.integral_mono_of_nonneg _ _ _;
      · exact Filter.Eventually.of_forall fun x => norm_nonneg _;
      · exact MeasureTheory.Integrable.mul_const ( g₀.integrable.norm ) _;
      · filter_upwards [ ] with t using by simpa only [ norm_mul ] using mul_le_mul_of_nonneg_left ( le_ciSup ( show BddAbove ( Set.range ( fun t => ‖( g - g₀ ) t‖ ) ) from by
                                                                                                                  have := schwartz_weighted_norm_bddAbove 0 ( g - g₀ );
                                                                                                                  simpa using this ) ( t - x₀ ) ) ( norm_nonneg _ ) ;
    have h_const : ‖∫ t : ℝ, g t * g (t - x₀)‖ ≤ (∫ t : ℝ, ‖g (t - x₀)‖) * (⨆ t, ‖(g - g₀) t‖) + (∫ t : ℝ, ‖g₀ t‖) * (⨆ t, ‖(g - g₀) t‖) := by
      nontriviality;
      rw [ ‹∫ t : ℝ, g t * g ( t - x₀ ) = _›, ‹∫ t : ℝ, ( g - g₀ ) t * g ( t - x₀ ) + g₀ t * ( g - g₀ ) ( t - x₀ ) + g₀ t * g₀ ( t - x₀ ) = _› ];
      exact le_trans ( by simpa [ * ] using norm_add_le ( ∫ t : ℝ, ( g - g₀ ) t * g ( t - x₀ ) ) ( ∫ t : ℝ, g₀ t * ( g - g₀ ) ( t - x₀ ) ) ) ( add_le_add ‹_› ‹_› );
    simp_all +decide [ mul_comm ];
    linarith

/-- The L² inner product of g with its translate equals the autocorrelation integral.
    This is the key identity: ∫ g(t) g(t - x₀) dt = ⟪toLp g, τ_{x₀}(toLp g)⟫_{L²}. -/
lemma autocorr_eq_L2_inner (g : SchwartzMap ℝ ℝ) (x₀ : ℝ) :
    schwartzAutocorr g x₀ = @inner ℝ (Lp ℝ 2 volume) _
      (g.toLp 2)
      ((Lp.compMeasurePreserving (fun t : ℝ => t - x₀)
        (measurePreserving_sub_right volume x₀)) (g.toLp 2)) := by
  rw [schwartzAutocorr_eq, L2.inner_def]
  have h1 : (↑↑(g.toLp 2 volume) : ℝ → ℝ) =ᵐ[volume] g := SchwartzMap.coeFn_toLp g 2 volume
  have hmp := measurePreserving_sub_right volume x₀
  have h2 := Lp.coeFn_compMeasurePreserving (g.toLp 2 volume) hmp
  have h3 : (fun t => (↑↑(g.toLp 2 volume) : ℝ → ℝ) (t - x₀)) =ᵐ[volume] (fun t => g (t - x₀)) :=
    (h1.comp_tendsto hmp.quasiMeasurePreserving.tendsto_ae).mono (fun t ht => ht)
  symm
  refine integral_congr_ae ?_
  filter_upwards [h1, h2, h3] with t ht1 ht2 ht3
  rw [RCLike.inner_apply]
  simp only [Function.comp] at ht2
  rw [ht1, ht2, ht3]
  simp [mul_comm]

/-- For fixed x₀, the autocorrelation evaluation g ↦ ∫ g(t) * g(t - x₀) dt
    is continuous at every g₀ in the Schwartz topology.
    Proof via the L² isometry bypass:
    • `SchwartzMap.toLpCLM` embeds 𝓢(ℝ, ℝ) into L²(ℝ) continuously.
    • `Lp.compMeasurePreserving` for translation by x₀ is an isometry on L².
    • `continuous_inner` gives continuity of the real inner product.
    Their composition is unconditionally continuous. -/
lemma autocorrelation_continuousAt (x₀ : ℝ) (g₀ : SchwartzMap ℝ ℝ) :
    ContinuousAt (fun g : SchwartzMap ℝ ℝ => schwartzAutocorr g x₀) g₀ := by
  -- Rewrite the autocorrelation as an L² inner product
  have h_eq : (fun g : SchwartzMap ℝ ℝ => schwartzAutocorr g x₀) =
    (fun g => @inner ℝ (Lp ℝ 2 volume) _ (g.toLp 2)
      ((Lp.compMeasurePreserving (fun t : ℝ => t - x₀)
        (measurePreserving_sub_right volume x₀)) (g.toLp 2))) := by
    ext g; exact autocorr_eq_L2_inner g x₀
  rw [h_eq]
  -- Compose the three continuous maps: toLp, translation, inner product
  have h_toLp : Continuous (fun g : SchwartzMap ℝ ℝ => g.toLp 2 (volume : Measure ℝ)) :=
    (SchwartzMap.toLpCLM ℝ ℝ 2 volume).continuous
  have hmp := measurePreserving_sub_right volume x₀
  have h_comp : Continuous (Lp.compMeasurePreserving (E := ℝ) (p := 2)
      (fun t : ℝ => t - x₀) hmp) :=
    LipschitzWith.continuous (K := 1) (fun f g => by
      simp [edist_dist, dist_eq_norm, ← map_sub, Lp.norm_compMeasurePreserving])
  exact ((continuous_inner (𝕜 := ℝ)).comp
    (Continuous.prodMk h_toLp (h_comp.comp h_toLp))).continuousAt

/-- Autocorrelation is continuous in the Schwartz topology.
    This natively satisfies the `hac` hypothesis in WeilDistribution.lean. -/
theorem autocorrelation_continuous :
    Continuous (fun (g : SchwartzMap ℝ ℝ) ↦ schwartzAutocorr g) := by
  apply continuous_pi
  intro x₀
  rw [continuous_iff_continuousAt]
  exact fun g₀ => autocorrelation_continuousAt x₀ g₀

end DULA