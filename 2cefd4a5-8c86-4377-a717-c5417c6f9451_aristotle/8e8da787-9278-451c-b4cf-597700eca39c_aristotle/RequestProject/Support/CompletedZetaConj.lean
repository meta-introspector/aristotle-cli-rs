import Mathlib

/-!
# Schwarz reflection for the Riemann zeta function and its completion

This file supplies the reflection ("conjugation") identities

* `Gammaℝ_conj`                  : `Gammaℝ (conj s) = conj (Gammaℝ s)`
* `completedRiemannZeta₀_conj`   : `Λ₀ (conj s) = conj (Λ₀ s)`
* `completedRiemannZeta_conj`    : `Λ (conj s) = conj (Λ s)`
* `riemannZeta_conj`             : `ζ (conj s) = conj (ζ s)`

which are not available in Mathlib but are needed by several of the imported
developments (for instance the identity `Ξ(conj z) = conj (Ξ z)` for
`Ξ z = Λ (1/2 + I z)`).

The proof is the classical one: both sides are entire (for `Λ₀`), and they agree
on the real ray `(1, ∞)`, where `Λ₀` is real because `ζ` is given there by a
Dirichlet series with real terms.  The identity theorem for analytic functions
then propagates the identity to all of `ℂ`.

The general reflection lemmas `hasDerivAt_conj_reflect` and
`differentiable_conj_reflect` (the reflected function `z ↦ conj (f (conj z))` of
an entire function is entire) are proved along the way.
-/

open Complex Filter Topology

namespace RequestProject.Support

private lemma conj_two : (starRingEnd ℂ) 2 = 2 := conj_eq_iff_re.mpr rfl

/-- If `f` is complex-differentiable at `conj z`, then its Schwarz reflection
`w ↦ conj (f (conj w))` is complex-differentiable at `z`, with the conjugate derivative. -/
theorem hasDerivAt_conj_reflect {f : ℂ → ℂ} {z f' : ℂ}
    (hf : HasDerivAt f f' (starRingEnd ℂ z)) :
    HasDerivAt (fun w => (starRingEnd ℂ) (f ((starRingEnd ℂ) w))) ((starRingEnd ℂ) f') z := by
  rw [hasDerivAt_iff_tendsto_slope] at hf ⊢
  have hmap : Tendsto (starRingEnd ℂ) (𝓝[≠] z) (𝓝[≠] (starRingEnd ℂ z)) := by
    apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within
    · exact (Complex.continuous_conj.tendsto z).mono_left nhdsWithin_le_nhds
    · filter_upwards [self_mem_nhdsWithin] with w hw
      simpa using fun h => hw (by have := congrArg (starRingEnd ℂ) h; simpa using this)
  have hcomp := (Complex.continuous_conj.tendsto _).comp (hf.comp hmap)
  refine hcomp.congr fun w => ?_
  simp only [Function.comp_apply, slope_def_field, div_eq_mul_inv]
  rw [map_mul, map_sub, map_inv₀, map_sub]
  simp

/-- The Schwarz reflection of an entire function is entire. -/
theorem differentiable_conj_reflect {f : ℂ → ℂ} (hf : Differentiable ℂ f) :
    Differentiable ℂ (fun w => (starRingEnd ℂ) (f ((starRingEnd ℂ) w))) := fun z =>
  (hasDerivAt_conj_reflect (hf (starRingEnd ℂ z)).hasDerivAt).differentiableAt

/-- The real Gamma factor `Gammaℝ s = π ^ (-s/2) * Γ (s/2)` commutes with conjugation. -/
theorem Gammaℝ_conj (s : ℂ) : Gammaℝ (starRingEnd ℂ s) = starRingEnd ℂ (Gammaℝ s) := by
  rw [Gammaℝ_def, Gammaℝ_def, map_mul]
  congr 1
  · rw [show (-(starRingEnd ℂ s) / 2) = starRingEnd ℂ (-s / 2) by
      rw [map_div₀, map_neg, conj_two]]
    rw [Complex.cpow_conj]
    · simp
    · rw [Complex.arg_ofReal_of_nonneg Real.pi_pos.le]
      exact fun h => Real.pi_ne_zero h.symm
  · rw [show ((starRingEnd ℂ s) / 2) = starRingEnd ℂ (s / 2) by rw [map_div₀, conj_two]]
    exact Complex.Gamma_conj _

/-- `ζ` is real on the real ray `(1, ∞)`. -/
theorem zeta_conj_of_real {x : ℝ} (hx : 1 < x) :
    starRingEnd ℂ (riemannZeta (x : ℂ)) = riemannZeta (x : ℂ) := by
  have hre : 1 < ((x : ℂ)).re := by simpa using hx
  rw [zeta_eq_tsum_one_div_nat_cpow hre, conj_tsum]
  refine tsum_congr fun n => ?_
  simp only [map_div₀, map_one]
  congr 1
  conv_rhs => rw [show ((x : ℂ)) = starRingEnd ℂ (x : ℂ) by simp]
  rw [Complex.cpow_conj]
  · simp
  · rcases Nat.eq_zero_or_pos n with rfl | h
    · simp only [Nat.cast_zero, Complex.arg_zero]
      exact fun h => Real.pi_ne_zero h.symm
    · rw [show ((n : ℂ)) = ((n : ℝ) : ℂ) by push_cast; ring]
      rw [Complex.arg_ofReal_of_nonneg (by positivity)]
      exact fun h => Real.pi_ne_zero h.symm

/-- `Λ` is real on the real ray `(1, ∞)`. -/
theorem completedZeta_conj_of_real {x : ℝ} (hx : 1 < x) :
    starRingEnd ℂ (completedRiemannZeta (x : ℂ)) = completedRiemannZeta (x : ℂ) := by
  have hx0 : ((x : ℂ)) ≠ 0 := by simp only [ne_eq, Complex.ofReal_eq_zero]; linarith
  have hG : Gammaℝ (x : ℂ) ≠ 0 :=
    Gammaℝ_ne_zero_of_re_pos (by simpa using by linarith : 0 < ((x : ℂ)).re)
  have hΛ : completedRiemannZeta (x : ℂ) = riemannZeta (x : ℂ) * Gammaℝ (x : ℂ) := by
    rw [riemannZeta_def_of_ne_zero hx0, div_mul_cancel₀ _ hG]
  rw [hΛ, map_mul, zeta_conj_of_real hx, ← Gammaℝ_conj]
  simp

/-- `Λ₀` is real on the real ray `(1, ∞)`. -/
theorem completedZeta₀_conj_of_real {x : ℝ} (hx : 1 < x) :
    starRingEnd ℂ (completedRiemannZeta₀ (x : ℂ)) = completedRiemannZeta₀ (x : ℂ) := by
  have hsplit : completedRiemannZeta₀ (x : ℂ)
      = completedRiemannZeta (x : ℂ) + 1 / (x : ℂ) + 1 / (1 - (x : ℂ)) := by
    rw [completedRiemannZeta_eq]; ring
  rw [hsplit]
  simp [completedZeta_conj_of_real hx]

/-- Any property that holds on the real ray `(1, ∞)` holds frequently near `2`. -/
private lemma frequently_of_real_ray {P : ℂ → Prop} (h : ∀ x : ℝ, 1 < x → P (x : ℂ)) :
    ∃ᶠ z in 𝓝[≠] (2 : ℂ), P z := by
  have hlim : Tendsto (fun n : ℕ => (2 + 1 / ((n : ℝ) + 1))) atTop (𝓝 (2 : ℝ)) := by
    have h0 : Tendsto (fun n : ℕ => 1 / ((n : ℝ) + 1)) atTop (𝓝 (0 : ℝ)) :=
      tendsto_one_div_add_atTop_nhds_zero_nat
    simpa using (tendsto_const_nhds (x := (2 : ℝ)) (f := (atTop : Filter ℕ))).add h0
  have hu : Tendsto (fun n : ℕ => ((2 + 1 / ((n : ℝ) + 1) : ℝ) : ℂ)) atTop (𝓝[≠] (2 : ℂ)) := by
    apply tendsto_nhdsWithin_of_tendsto_nhds_of_eventually_within
    · exact (Complex.continuous_ofReal.tendsto (2 : ℝ)).comp hlim
    · filter_upwards with n
      simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
      intro h2
      have h3 : (2 + 1 / ((n : ℝ) + 1)) = 2 := by exact_mod_cast h2
      have hpos : 0 < 1 / ((n : ℝ) + 1) := by positivity
      linarith
  refine hu.frequently (Frequently.of_forall fun n => h _ ?_)
  have hpos : 0 < 1 / ((n : ℝ) + 1) := by positivity
  linarith

/-- **Schwarz reflection for `Λ₀`**: `Λ₀ (conj s) = conj (Λ₀ s)`. -/
theorem completedRiemannZeta₀_conj (s : ℂ) :
    completedRiemannZeta₀ (starRingEnd ℂ s) = starRingEnd ℂ (completedRiemannZeta₀ s) := by
  set g : ℂ → ℂ := fun w => starRingEnd ℂ (completedRiemannZeta₀ (starRingEnd ℂ w)) with hg
  have hgd : Differentiable ℂ g := differentiable_conj_reflect differentiable_completedZeta₀
  have hΛ₀ : AnalyticOnNhd ℂ completedRiemannZeta₀ Set.univ :=
    differentiable_completedZeta₀.differentiableOn.analyticOnNhd isOpen_univ
  have hgan : AnalyticOnNhd ℂ g Set.univ := hgd.differentiableOn.analyticOnNhd isOpen_univ
  have hfreq : ∃ᶠ z in 𝓝[≠] (2 : ℂ), completedRiemannZeta₀ z = g z := by
    refine frequently_of_real_ray fun x hx => ?_
    simp only [hg, Complex.conj_ofReal]
    exact (completedZeta₀_conj_of_real hx).symm
  have heq : completedRiemannZeta₀ = g := hΛ₀.eq_of_frequently_eq hgan hfreq
  have hs := congrFun heq (starRingEnd ℂ s)
  simpa [hg] using hs

/-- **Schwarz reflection for the completed zeta function**: `Λ (conj s) = conj (Λ s)`. -/
theorem completedRiemannZeta_conj (s : ℂ) :
    completedRiemannZeta (starRingEnd ℂ s) = starRingEnd ℂ (completedRiemannZeta s) := by
  rw [completedRiemannZeta_eq, completedRiemannZeta_eq, completedRiemannZeta₀_conj]
  simp

/-- **Schwarz reflection for the Riemann zeta function**: `ζ (conj s) = conj (ζ s)`. -/
theorem riemannZeta_conj (s : ℂ) :
    riemannZeta (starRingEnd ℂ s) = starRingEnd ℂ (riemannZeta s) := by
  rcases eq_or_ne s 0 with rfl | hs
  · simp [riemannZeta_zero, conj_two]
  · have hs' : starRingEnd ℂ s ≠ 0 := by simpa using hs
    rw [riemannZeta_def_of_ne_zero hs, riemannZeta_def_of_ne_zero hs',
      completedRiemannZeta_conj, Gammaℝ_conj, ← map_div₀]

end RequestProject.Support
