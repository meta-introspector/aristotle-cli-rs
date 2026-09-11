import Mathlib

open MeasureTheory Real
open scoped BigOperators

noncomputable section

/-
Helper: the derivative of x ↦ ∫ f(t) * g(t+x) dt is x ↦ ∫ f(t) * g'(t+x) dt,
    for Schwartz f and g.
-/
lemma schwartz_conv_hasDerivAt (f g : SchwartzMap ℝ ℝ) (x₀ : ℝ) :
    HasDerivAt (fun x => ∫ t, f t * g (t + x))
      (∫ t, f t * (deriv g) (t + x₀)) x₀ := by
  -- proved by subagent
  -- By the dominated convergence theorem, we can interchange the limit and the integral.
  have h_dominated_convergence : Filter.Tendsto (fun h => ∫ t, (f t * (g (t + x₀ + h) - g (t + x₀))) / h ∂MeasureTheory.volume) (nhdsWithin 0 {0}ᶜ) (nhds (∫ t, (f t) * (deriv g (t + x₀)) ∂MeasureTheory.volume)) := by
    refine' MeasureTheory.tendsto_integral_filter_of_dominated_convergence _ _ _ _ _;
    refine' fun t => ‖f t‖ * ( SupSet.sSup ( Set.range ( fun x => ‖deriv g x‖ ) ) );
    · exact Filter.Eventually.of_forall fun n => Continuous.aestronglyMeasurable ( by exact Continuous.div_const ( by exact Continuous.mul ( f.continuous ) ( by exact Continuous.sub ( g.continuous.comp ( by continuity ) ) ( g.continuous.comp ( by continuity ) ) ) ) _ );
    · -- By the properties of the derivative and the mean value theorem, we can bound the difference quotient.
      have h_bound : ∀ t n, n ≠ 0 → ‖(g (t + x₀ + n) - g (t + x₀)) / n‖ ≤ sSup (Set.range (fun x => ‖deriv g x‖)) := by
        intros t n hn_ne_zero
        have h_mean_value : ∃ c ∈ Set.Icc (min (t + x₀) (t + x₀ + n)) (max (t + x₀) (t + x₀ + n)), deriv g c = (g (t + x₀ + n) - g (t + x₀)) / n := by
          cases le_total ( t + x₀ ) ( t + x₀ + n ) <;> simp_all +decide [ div_eq_inv_mul ];
          · have := exists_deriv_eq_slope g ( show t + x₀ < t + x₀ + n by linarith [ show n > 0 from lt_of_le_of_ne ‹_› ( Ne.symm hn_ne_zero ) ] );
            exact this ( g.continuous.continuousOn ) ( g.differentiable.differentiableOn ) |> fun ⟨ c, hc₁, hc₂ ⟩ => ⟨ c, ⟨ by linarith [ hc₁.1 ], by linarith [ hc₁.2 ] ⟩, by simpa [ div_eq_inv_mul ] using hc₂ ⟩;
          · have := exists_deriv_eq_slope ( f := g ) ( show t + x₀ + n < t + x₀ by contrapose! hn_ne_zero; linarith );
            exact this ( g.continuous.continuousOn ) ( g.differentiable.differentiableOn ) |> fun ⟨ c, hc₁, hc₂ ⟩ => ⟨ c, ⟨ by linarith [ hc₁.1 ], by linarith [ hc₁.2 ] ⟩, by rw [ hc₂ ] ; ring ⟩;
        obtain ⟨ c, hc₁, hc₂ ⟩ := h_mean_value; rw [ ← hc₂ ] ; exact le_csSup ( show BddAbove ( Set.range fun x => ‖deriv g x‖ ) from by
                                                                                  have := g.decay 0 1;
                                                                                  obtain ⟨ C, hC₀, hC ⟩ := this; exact ⟨ C, Set.forall_mem_range.mpr fun x => by simpa [ iteratedFDeriv_eq_equiv_comp ] using hC x ⟩ ; ) ( Set.mem_range_self c ) ;
      filter_upwards [ self_mem_nhdsWithin ] with n hn using Filter.Eventually.of_forall fun t => by simpa only [ mul_div_assoc, norm_mul ] using mul_le_mul_of_nonneg_left ( h_bound t n hn ) ( norm_nonneg _ ) ;
    · exact MeasureTheory.Integrable.mul_const ( f.integrable.norm ) _;
    · refine' Filter.Eventually.of_forall fun t => _;
      have h_deriv : HasDerivAt (fun n => g (t + x₀ + n)) (deriv g (t + x₀)) 0 := by
        convert HasDerivAt.comp 0 ( g.differentiableAt.hasDerivAt ) ( hasDerivAt_id 0 |> HasDerivAt.const_add _ ) using 1 ; norm_num;
      simpa [ div_eq_mul_inv, mul_assoc, mul_comm, mul_left_comm ] using h_deriv.tendsto_slope_zero.const_mul ( f t );
  rw [ hasDerivAt_iff_tendsto_slope_zero ];
  convert h_dominated_convergence using 2;
  rw [ ← MeasureTheory.integral_sub ];
  · simp +decide [ div_eq_inv_mul, mul_sub, add_assoc, mul_assoc, mul_comm, mul_left_comm, ← MeasureTheory.integral_const_mul ];
  · refine' MeasureTheory.Integrable.mono' _ _ _;
    refine' fun t => ‖f t‖ * ( SupSet.sSup ( Set.range ( fun t => ‖g t‖ ) ) );
    · exact MeasureTheory.Integrable.mul_const ( f.integrable.norm ) _;
    · exact MeasureTheory.AEStronglyMeasurable.mul ( f.continuous.aestronglyMeasurable ) ( g.continuous.comp_aestronglyMeasurable ( measurable_id.add_const _ |> Measurable.aestronglyMeasurable ) );
    · filter_upwards [ ] with t using by rw [ norm_mul ] ; exact mul_le_mul_of_nonneg_left ( le_csSup ( show BddAbove ( Set.range fun t => ‖g t‖ ) from by
                                                                                                          have := g.decay 0 0;
                                                                                                          exact ⟨ this.choose, Set.forall_mem_range.mpr fun x => by simpa using this.choose_spec.2 x ⟩ ) ( Set.mem_range_self _ ) ) ( norm_nonneg _ ) ;
  · refine' MeasureTheory.Integrable.mono' _ _ _;
    refine' fun t => ‖f t‖ * ( SupSet.sSup ( Set.range ( fun t => ‖g t‖ ) ) );
    · exact MeasureTheory.Integrable.mul_const ( f.integrable.norm ) _;
    · exact MeasureTheory.AEStronglyMeasurable.mul ( f.continuous.aestronglyMeasurable ) ( g.continuous.comp_aestronglyMeasurable ( measurable_id.add_const x₀ |> Measurable.aestronglyMeasurable ) );
    · filter_upwards [ ] with t using by rw [ norm_mul ] ; exact mul_le_mul_of_nonneg_left ( le_csSup ( show BddAbove ( Set.range fun t => ‖g t‖ ) from by
                                                                                                          have := g.decay 0 0;
                                                                                                          exact ⟨ this.choose, Set.forall_mem_range.mpr fun x => by simpa using this.choose_spec.2 x ⟩ ) ( Set.mem_range_self _ ) ) ( norm_nonneg _ ) ;

/-
The n-th iterated derivative of x ↦ ∫ f(t) * g(t+x) is x ↦ ∫ f(t) * g^(n)(t+x).
-/
lemma schwartz_conv_iteratedDeriv (f g : SchwartzMap ℝ ℝ) (n : ℕ) (x : ℝ) :
    iteratedDeriv n (fun x => ∫ t, f t * g (t + x)) x =
    ∫ t, f t * (iteratedDeriv n g) (t + x) := by
  -- proved by subagent
  induction' n with n ih generalizing x <;> simp_all +decide [ iteratedDeriv_succ ];
  rw [ show iteratedDeriv n _ = _ from funext ih ];
  convert HasDerivAt.deriv ( ?_ ) using 1;
  convert schwartz_conv_hasDerivAt f ( show SchwartzMap ℝ ℝ from ( show SchwartzMap ℝ ℝ from { toFun := iteratedDeriv n g.toFun, smooth' := ?_, decay' := ?_ } ) ) x using 1;
  · induction' n with n ih;
    · exact g.2;
    · induction' n + 1 with n ih <;> simp_all +decide [ iteratedDeriv_succ ];
      · exact g.smooth';
      · exact ContDiff.deriv' ih;
  · intro k l; have := g.decay' k ( l + n ) ; simp_all +decide [ iteratedFDeriv_eq_equiv_comp, iteratedDeriv_eq_iterate ] ;
    simpa only [ ← Function.iterate_add_apply ] using this

/-- The n-th Schwartz derivative of g, as a SchwartzMap. -/
def SchwartzMap.iteratedDerivSchwartz (g : SchwartzMap ℝ ℝ) : ℕ → SchwartzMap ℝ ℝ
  | 0 => g
  | n + 1 => SchwartzMap.derivCLM ℝ ℝ (g.iteratedDerivSchwartz n)

lemma SchwartzMap.iteratedDerivSchwartz_apply (g : SchwartzMap ℝ ℝ) (n : ℕ) (x : ℝ) :
    g.iteratedDerivSchwartz n x = iteratedDeriv n g x := by
  induction' n with n ih generalizing x <;> simp_all +decide [ SchwartzMap.iteratedDerivSchwartz, iteratedDeriv_succ ];
  exact congr_arg ( deriv · x ) ( funext ih )

/-
Continuity of x ↦ ∫ f(t) * h(t+x) dt for Schwartz f, h.
-/
lemma schwartz_conv_continuous (f h : SchwartzMap ℝ ℝ) :
    Continuous (fun x => ∫ t, f t * h (t + x)) := by
  refine' continuous_iff_continuousAt.mpr _;
  refine' fun x => MeasureTheory.tendsto_integral_filter_of_dominated_convergence _ _ _ _ _;
  refine' fun t => ‖f t‖ * ( SupSet.sSup ( Set.range fun y => ‖h y‖ ) );
  · exact Filter.Eventually.of_forall fun n => Continuous.aestronglyMeasurable ( by exact Continuous.mul ( f.continuous ) ( h.continuous.comp ( continuous_add_right _ ) ) );
  · refine' Filter.Eventually.of_forall fun n => Filter.Eventually.of_forall fun a => _;
    rw [ norm_mul ];
    gcongr;
    apply le_csSup;
    · have := h.decay;
      obtain ⟨ C, hC₀, hC ⟩ := this 0 0 ; exact ⟨ C, Set.forall_mem_range.mpr fun x => by simpa using hC x ⟩;
    · exact Set.mem_range_self _;
  · exact MeasureTheory.Integrable.mul_const ( f.integrable.norm ) _;
  · exact Filter.Eventually.of_forall fun t => Continuous.tendsto ( by exact Continuous.mul continuous_const <| h.continuous.comp <| continuous_const.add continuous_id' ) _

/-
Each iterated derivative of the convolution is differentiable.
-/
lemma schwartz_conv_differentiable_iteratedDeriv (f g : SchwartzMap ℝ ℝ) (m : ℕ) :
    Differentiable ℝ (iteratedDeriv m (fun x => ∫ t, f t * g (t + x))) := by
  rw [ show iteratedDeriv m ( fun x => ∫ t, f t * g ( t + x ) ) = fun x => ∫ t, f t * ( g.iteratedDerivSchwartz m ) ( t + x ) from funext fun x => ?_ ];
  · exact fun x => ( schwartz_conv_hasDerivAt f ( g.iteratedDerivSchwartz m ) x |> HasDerivAt.differentiableAt );
  · convert schwartz_conv_iteratedDeriv f g m x using 1;
    exact congr_arg _ ( funext fun t => by rw [ SchwartzMap.iteratedDerivSchwartz_apply ] )

/-
The function x ↦ ∫ f(t) * g(t+x) dt is C∞ for Schwartz f, g.
-/
lemma schwartz_conv_contDiff (f g : SchwartzMap ℝ ℝ) :
    ContDiff ℝ (↑(⊤ : ℕ∞)) (fun x => ∫ t, f t * g (t + x)) := by
  exact contDiff_of_differentiable_iteratedDeriv (fun m _ => schwartz_conv_differentiable_iteratedDeriv f g m)

/-
The Schwartz decay of x ↦ ∫ f(t) * g(t+x) dt.
-/
lemma schwartz_conv_decay (f g : SchwartzMap ℝ ℝ) (k n : ℕ) :
    ∃ C, ∀ x, ‖x‖ ^ k * ‖iteratedFDeriv ℝ n (fun x => ∫ t, f t * g (t + x)) x‖ ≤ C := by
  -- Now |(iteratedDeriv n g)(t+x)| ≤ C_{k,n} / (1+|t+x|)^(k+2) by Schwartz decay of g.
  have h_decay : ∃ C, ∀ x t, ‖x‖^k * ‖(iteratedDeriv n g) (t + x)‖ ≤ C * (1 + ‖t‖)^(k + 2) / (1 + ‖x‖)^(2) := by
    -- By Schwartz decay of g, we have |(iteratedDeriv n g)(t+x)| ≤ C_{k,n} / (1+|t+x|)^(k+2).
    obtain ⟨C, hC⟩ : ∃ C, ∀ x, ‖iteratedDeriv n g x‖ ≤ C / (1 + ‖x‖)^(k + 2) := by
      obtain ⟨ C, hC ⟩ := g.decay' ( k + 2 ) n;
      have h_bound : ∃ C, ∀ x, ‖iteratedDeriv n g x‖ ≤ C / (1 + ‖x‖)^(k + 2) := by
        have h_bound_aux : ∃ C, ∀ x, ‖x‖^(k + 2) * ‖iteratedDeriv n g x‖ ≤ C := by
          use C;
          convert hC using 1;
          norm_num [ iteratedFDeriv_eq_equiv_comp ];
          rfl
        have h_bound_aux : ∃ C, ∀ x, ‖iteratedDeriv n g x‖ ≤ C / (1 + ‖x‖)^(k + 2) := by
          have h_bound_aux : ∃ C, ∀ x, ‖x‖^(k + 2) * ‖iteratedDeriv n g x‖ ≤ C := h_bound_aux
          obtain ⟨C, hC⟩ := h_bound_aux
          have h_bound_aux : ∃ C, ∀ x, ‖iteratedDeriv n g x‖ ≤ C := by
            have := g.decay' 0 n;
            simp_all +decide [ iteratedFDeriv_eq_equiv_comp ];
            exact this
          obtain ⟨D, hD⟩ := h_bound_aux
          use max C D * 2^(k + 2)
          intro x
          by_cases hx : ‖x‖ ≥ 1;
          · rw [ le_div_iff₀ ( by positivity ) ];
            refine' le_trans _ ( mul_le_mul_of_nonneg_right ( le_max_left _ _ ) ( by positivity ) );
            refine' le_trans _ ( mul_le_mul_of_nonneg_right ( hC x ) ( by positivity ) );
            rw [ mul_right_comm ];
            rw [ mul_comm ] ; gcongr;
            rw [ ← mul_pow ] ; gcongr ; linarith;
          · rw [ le_div_iff₀ ( by positivity ) ];
            exact le_trans ( mul_le_mul_of_nonneg_right ( hD x ) ( by positivity ) ) ( mul_le_mul ( le_max_right _ _ ) ( pow_le_pow_left₀ ( by positivity ) ( by linarith [ norm_nonneg x ] ) _ ) ( by positivity ) ( by exact le_max_of_le_right ( by exact le_trans ( by norm_num ) ( hD 0 ) ) ) );
        exact h_bound_aux;
      exact h_bound;
    -- Using 1+|t+x| ≥ (1+|x|)/(1+|t|) (Peetre), so (1+|t+x|)^(k+2) ≥ (1+|x|)^(k+2) / (1+|t|)^(k+2).
    have h_peetre : ∀ x t : ℝ, (1 + ‖t + x‖)^(k + 2) ≥ (1 + ‖x‖)^(k + 2) / (1 + ‖t‖)^(k + 2) := by
      intros x t
      have h_peetre : 1 + ‖t + x‖ ≥ (1 + ‖x‖) / (1 + ‖t‖) := by
        rw [ ge_iff_le, div_le_iff₀ ] <;> norm_num;
        · cases abs_cases ( t + x ) <;> cases abs_cases t <;> cases abs_cases x <;> nlinarith;
        · positivity;
      simpa only [ div_pow ] using pow_le_pow_left₀ ( by positivity ) h_peetre _;
    -- Substitute the decay bound into the inequality.
    have h_subst : ∀ x t : ℝ, ‖x‖^k * ‖iteratedDeriv n g (t + x)‖ ≤ C * ‖x‖^k * (1 + ‖t‖)^(k + 2) / (1 + ‖x‖)^(k + 2) := by
      intro x t; specialize hC ( t + x ) ; specialize h_peetre x t; rw [ ge_iff_le ] at h_peetre; rw [ div_le_iff₀ ] at h_peetre <;> try positivity;
      rw [ le_div_iff₀ ( by positivity ) ] at *;
      nlinarith [ show 0 ≤ ‖x‖ ^ k * ‖iteratedDeriv n ( g ) ( t + x )‖ by positivity, show 0 ≤ ‖x‖ ^ k * C by exact mul_nonneg ( pow_nonneg ( norm_nonneg x ) _ ) ( le_trans ( by positivity ) hC ), show 0 ≤ ‖x‖ ^ k * ( 1 + ‖t‖ ) ^ ( k + 2 ) by positivity ];
    use C;
    intro x t; specialize h_subst x t; refine le_trans h_subst ?_; rw [ div_le_div_iff₀ ] <;> try positivity;
    rw [ show ( 1 + ‖x‖ ) ^ ( k + 2 ) = ( 1 + ‖x‖ ) ^ k * ( 1 + ‖x‖ ) ^ 2 by ring ];
    norm_num [ mul_assoc, mul_comm, mul_left_comm ];
    exact mul_le_mul_of_nonneg_left ( mul_le_mul_of_nonneg_right ( pow_le_pow_left₀ ( by positivity ) ( by linarith [ abs_nonneg x ] ) _ ) ( by positivity ) ) ( show 0 ≤ C by exact le_trans ( norm_nonneg _ ) ( hC 0 ) |> le_trans <| by norm_num );
  -- So ‖x‖^k * |∫...| ≤ S_n * ∫ |f(t)| * (1+|t|)^(k+2) dt.
  obtain ⟨C, hC⟩ := h_decay;
  have h_integral : ∃ D, ∀ x, ‖x‖^k * ‖∫ t, f t * (iteratedDeriv n g) (t + x)‖ ≤ D / (1 + ‖x‖)^(2) := by
    -- Using the bound from h_decay, we can bound the integral.
    have h_integral_bound : ∀ x, ‖x‖^k * ‖∫ t, f t * (iteratedDeriv n g) (t + x)‖ ≤ ∫ t, ‖f t‖ * (C * (1 + ‖t‖)^(k + 2) / (1 + ‖x‖)^(2)) := by
      intro x;
      refine' le_trans ( mul_le_mul_of_nonneg_left ( MeasureTheory.norm_integral_le_integral_norm _ ) ( by positivity ) ) _;
      rw [ ← MeasureTheory.integral_const_mul ];
      refine' MeasureTheory.integral_mono_of_nonneg _ _ _;
      · exact Filter.Eventually.of_forall fun t => by positivity;
      · have h_integrable : Integrable (fun t => ‖f t‖ * (1 + ‖t‖)^(k + 2)) := by
          have h_integrable : ∀ m : ℕ, ∃ C, ∀ t : ℝ, ‖f t‖ * (1 + ‖t‖)^m ≤ C := by
            intro m
            obtain ⟨C, hC⟩ : ∃ C, ∀ t : ℝ, ‖f t‖ * ‖t‖^m ≤ C := by
              have := f.decay' m 0;
              simp_all +decide [ mul_comm, iteratedFDeriv_eq_equiv_comp ];
              exact this;
            have h_integrable : ∃ C, ∀ t : ℝ, ‖f t‖ * (1 + ‖t‖)^m ≤ C := by
              have h_bound : ∀ t : ℝ, ‖f t‖ * (1 + ‖t‖)^m ≤ ‖f t‖ * (2 * max 1 ‖t‖)^m := by
                exact fun t => mul_le_mul_of_nonneg_left ( pow_le_pow_left₀ ( by positivity ) ( by cases max_cases 1 ‖t‖ <;> linarith [ norm_nonneg t ] ) _ ) ( by positivity )
              have h_bound : ∀ t : ℝ, ‖f t‖ * (2 * max 1 ‖t‖)^m ≤ 2^m * (‖f t‖ * ‖t‖^m + ‖f t‖) := by
                intro t; rw [ mul_pow ] ; ring_nf;
                cases max_cases 1 ‖t‖ <;> simp +decide [ * ];
                · simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
                  positivity;
                · simp_all +decide [ mul_assoc, mul_comm, mul_left_comm ];
              have h_bound : ∃ C, ∀ t : ℝ, ‖f t‖ ≤ C := by
                have := f.decay' 0 0; aesop;
              exact ⟨ 2 ^ m * ( C + h_bound.choose ), fun t => le_trans ( by solve_by_elim ) ( le_trans ( by solve_by_elim ) ( mul_le_mul_of_nonneg_left ( add_le_add ( hC t ) ( h_bound.choose_spec t ) ) ( by positivity ) ) ) ⟩;
            exact h_integrable;
          obtain ⟨ C, hC ⟩ := h_integrable ( k + 2 + 2 );
          refine' MeasureTheory.Integrable.mono' _ _ _;
          refine' fun t => C / ( 1 + ‖t‖ ) ^ 2;
          · have h_integrable : MeasureTheory.Integrable (fun t : ℝ => (1 + ‖t‖)^(-2 : ℝ)) MeasureTheory.volume := by
              have h_integrable : MeasureTheory.Integrable (fun t : ℝ => (1 + |t|)^(-2 : ℝ)) MeasureTheory.volume := by
                have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => (1 + |t|)^(-2 : ℝ)) (Set.Ioi 0) := by
                  have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => (1 + t)^(-2 : ℝ)) (Set.Ioi 0) := by
                    have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => t^(-2 : ℝ)) (Set.Ioi 1) := by
                      rw [ integrableOn_Ioi_rpow_iff ] <;> norm_num;
                    rw [ ← MeasureTheory.integrable_indicator_iff ( measurableSet_Ioi ) ] at *;
                    convert h_integrable.comp_add_right 1 using 1;
                    ext; simp [Set.indicator];
                    split_ifs <;> ring;
                  exact h_integrable.congr_fun ( fun x hx => by rw [ abs_of_pos hx.out ] ) measurableSet_Ioi
                have h_integrable : MeasureTheory.IntegrableOn (fun t : ℝ => (1 + |t|)^(-2 : ℝ)) (Set.Iio 0) MeasureTheory.volume := by
                  rw [ ← MeasureTheory.integrable_indicator_iff ] at *;
                  · convert h_integrable.comp_neg using 1;
                    ext; simp [Set.indicator];
                  · norm_num;
                  · norm_num;
                convert MeasureTheory.IntegrableOn.integrable ( h_integrable.union ‹IntegrableOn ( fun t : ℝ => ( 1 + |t| ) ^ ( -2 : ℝ ) ) ( Set.Ioi 0 ) volume› ) using 1;
                norm_num [ Set.union_comm ];
              exact h_integrable;
            norm_cast at * ; simpa using h_integrable.const_mul C;
          · exact MeasureTheory.AEStronglyMeasurable.mul ( f.continuous.norm.aestronglyMeasurable ) ( Continuous.aestronglyMeasurable ( by continuity ) );
          · filter_upwards [ ] with t using by rw [ Real.norm_of_nonneg ( by positivity ) ] ; rw [ le_div_iff₀ ( by positivity ) ] ; convert hC t using 1 ; ring;
        convert h_integrable.const_mul ( C / ( 1 + ‖x‖ ) ^ 2 ) using 2 ; ring;
      · filter_upwards [ ] with t using by simpa [ mul_assoc, mul_comm, mul_left_comm ] using mul_le_mul_of_nonneg_left ( hC x t ) ( norm_nonneg ( f t ) ) ;
    use ∫ t, ‖f t‖ * (C * (1 + ‖t‖)^(k + 2));
    simpa only [ mul_div, ← MeasureTheory.integral_div ] using h_integral_bound;
  obtain ⟨ D, hD ⟩ := h_integral; use Max.max D 1; intro x; specialize hD x; simp_all +decide [ iteratedFDeriv_eq_equiv_comp ] ;
  rw [ schwartz_conv_iteratedDeriv ];
  exact Classical.or_iff_not_imp_left.2 fun h => by rw [ le_div_iff₀ ] at hD <;> nlinarith [ abs_nonneg x, pow_two_nonneg ( |x| : ℝ ) ] ;

end