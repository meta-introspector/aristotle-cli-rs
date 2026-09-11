/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Growth and monotonicity of the Fourier side `2θ' + δ̂` of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

Corollary 2.3 of the paper asserts the pointwise inequality `2θ'(t) + δ̂(t) ≥ 0`.  With the
Gauss partial-fraction expansion available (`RequestProject/Digamma.lean`) the *shape* of
this function can be analysed unconditionally:

* `2θ'` is **increasing in `|t|`** (`thetaDeriv_monotoneOn`), because in the expansion
  `2θ'(t) = -log π + ψ(1/4) + ∑_n (t²/4)/((n+1/4)((n+1/4)² + t²/4))`
  every term is increasing in `t²`;
* `2θ'(t) → ∞` as `|t| → ∞` (`tendsto_thetaDeriv_atTop`), because the limits `1/(n+1/4)`
  of the individual terms are not summable;
* `δ̂` is bounded by `δ̂(0)` (proved earlier), so the whole Fourier side tends to `+∞`
  (`tendsto_fourierSide_atTop`).

Consequently the inequality of Corollary 2.3 **holds outside a bounded interval**
(`fourierSide_nonneg_of_le_abs`, `exists_fourierSide_nonneg_of_le_abs`): what remains of it
is a statement on a compact interval of `t`'s, quantified by the single numerical
comparison `δ̂(0) ≤ 2θ'(T)`.

The last section makes this **effective**, using the exact formula for `Re ψ` on a vertical
line of `RequestProject/DigammaAsymptotic.lean`: `2θ'(t) ≥ log(t/2π) - 4/t² - π/t`
(`two_thetaDeriv_ge`), so the inequality holds as soon as
`|t| ≥ max 1 (2π exp(δ̂(0) + 4 + π))` (`fourierSide_nonneg_of_exp_le_abs`).  With the
explicit bound `δ̂(0) ≤ 16π + 16` coming from the decay of `δ` this gives an unconditional
numerical threshold: the inequality holds for `|t| ≥ 2π exp(17π + 20)`
(`fourierSide_nonneg_of_explicit_le_abs`).

That threshold is astronomically large because it uses only the crude bound
`|δ̂(t)| ≤ δ̂(0)`.  The last section of this file combines the same lower bound for `2θ'`
with the *decaying* bound `|δ̂(t)| ≤ 104/|t|` of `RequestProject/DeltaDecay.lean` and
obtains the practical threshold

  `|t| ≥ 60  ⟹  2θ'(t) + δ̂(t) ≥ 0`   (`fourierSide_nonneg_of_sixty_le_abs`).

What remains open of Corollary 2.3 (ii) is therefore its restriction to the compact
interval `|t| ≤ 60`.  That compact case is **still open**; it is analysed in
`RequestProject/CompactInterval.lean`, which

* reduces the inequality at the origin to the single explicit numerical statement
  `δ̂(0) ≥ 5.3765` (the true value is `δ̂(0) = 5.4212541…`, so the margin is `0.045`), by
  bounding `log π + γ + 3 log 2 + π/2 < 5.3765`;
* records why the two elementary routes to the compact case fail — the margin is
  `f(0) ≈ 0.049` while both `2θ'` and `δ̂` are of size `5`, and the second moments of the
  two competing terms `Θ` and `Δ` agree to four significant digits, so no sign-blind
  estimate separates them.

The route that avoids numerics altogether is the exact representation
`f(t) = (2/π) ∫_{2π}^∞ |∫_a^∞ y^{-1/2+it} cos y dy|² da/a` of
`RequestProject/TailEnergy.lean`, whose right-hand side is manifestly nonnegative; it is
the archimedean explicit formula, and is not proved in this project either.
-/
import RequestProject.Imported.OutputFinal2.ArchimedeanExplicit
import RequestProject.Imported.OutputFinal2.DeltaDecay

noncomputable section

open MeasureTheory Set Real Filter Topology

namespace ConnesConsani.WeilPositivity

/-! ## The expansion of `2θ'` -/

/-- `2θ'(t) = -log π + ψ(1/4) + P(t)`, where `P = digammaDiff` is the increment of the
digamma function along the line `Re s = 1/4`. -/
theorem two_thetaDeriv_eq (t : ℝ) :
    2 * thetaDeriv t
      = -Real.log π + (Complex.digamma (1 / 4 : ℂ)).re + digammaDiff t := by
  rw [thetaDeriv, digammaDiff]
  ring

/-- The individual terms of the expansion are increasing in `|t|`. -/
theorem digammaTerm_mono (n : ℕ) {t₁ t₂ : ℝ} (h : t₁ ^ 2 ≤ t₂ ^ 2) :
    digammaTerm n t₁ ≤ digammaTerm n t₂ := by
  have ha : 0 < poleA n := poleA_pos n
  have hd₁ : (0:ℝ) < poleA n * (poleA n ^ 2 + t₁ ^ 2 / 4) := by positivity
  have hd₂ : (0:ℝ) < poleA n * (poleA n ^ 2 + t₂ ^ 2 / 4) := by positivity
  rw [digammaTerm, digammaTerm, div_le_div_iff₀ hd₁ hd₂]
  nlinarith [mul_le_mul_of_nonneg_left h (by positivity : (0:ℝ) ≤ poleA n ^ 3)]

/-- **`P` is increasing in `|t|`.** -/
theorem digammaDiff_mono {t₁ t₂ : ℝ} (h : t₁ ^ 2 ≤ t₂ ^ 2) : digammaDiff t₁ ≤ digammaDiff t₂ :=
  hasSum_le (fun n => digammaTerm_mono n h) (digammaPartialFractions t₁)
    (digammaPartialFractions t₂)

/-- **`θ'` is increasing on `[0,∞)`** (and hence increasing in `|t|`, being even). -/
theorem thetaDeriv_monotoneOn : MonotoneOn thetaDeriv (Ici (0:ℝ)) := by
  intro t₁ h₁ t₂ _ h
  have h₁' : (0:ℝ) ≤ t₁ := h₁
  have hsq : t₁ ^ 2 ≤ t₂ ^ 2 := by nlinarith
  have := digammaDiff_mono hsq
  have e₁ := two_thetaDeriv_eq t₁
  have e₂ := two_thetaDeriv_eq t₂
  linarith

/-- The monotonicity of `θ'` in `|t|`. -/
theorem thetaDeriv_le_of_abs_le {t₁ t₂ : ℝ} (h : |t₁| ≤ |t₂|) : thetaDeriv t₁ ≤ thetaDeriv t₂ := by
  have hsq : t₁ ^ 2 ≤ t₂ ^ 2 := by
    have h1 : t₁ ^ 2 = |t₁| ^ 2 := (sq_abs t₁).symm
    have h2 : t₂ ^ 2 = |t₂| ^ 2 := (sq_abs t₂).symm
    rw [h1, h2]
    nlinarith [abs_nonneg t₁, abs_nonneg t₂]
  have := digammaDiff_mono hsq
  have e₁ := two_thetaDeriv_eq t₁
  have e₂ := two_thetaDeriv_eq t₂
  linarith

/-! ## The divergence of the expansion -/

/-- The terms `1/(n+1/4)` of the expansion are not summable. -/
theorem not_summable_one_div_poleA : ¬ Summable (fun n : ℕ => 1 / poleA n) := by
  intro h
  have hcomp : Summable (fun n : ℕ => 1 / ((n : ℝ) + 1)) := by
    refine Summable.of_nonneg_of_le (fun n => by positivity) (fun n => ?_) h
    have ha : 0 < poleA n := poleA_pos n
    have hle : poleA n ≤ (n : ℝ) + 1 := by
      rw [poleA]; linarith
    exact one_div_le_one_div_of_le ha hle
  have : Summable (fun n : ℕ => 1 / (n : ℝ)) := by
    refine (summable_nat_add_iff 1).1 ?_
    refine hcomp.congr fun n => ?_
    push_cast
    ring
  exact Real.not_summable_one_div_natCast this

/-- The partial sums of `1/(n+1/4)` tend to `+∞`. -/
theorem tendsto_sum_one_div_poleA :
    Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N, 1 / poleA n) atTop atTop :=
  (not_summable_iff_tendsto_nat_atTop_of_nonneg
    (fun n => div_nonneg zero_le_one (poleA_pos n).le)).1 not_summable_one_div_poleA

/-- Each term of the expansion tends to `1/(n+1/4)` as `|t| → ∞`. -/
theorem tendsto_digammaTerm (n : ℕ) :
    Tendsto (fun t : ℝ => digammaTerm n t) atTop (𝓝 (1 / poleA n)) := by
  have ha : 0 < poleA n := poleA_pos n
  have hrw : ∀ t : ℝ, digammaTerm n t = 1 / poleA n - poleA n / (poleA n ^ 2 + t ^ 2 / 4) := by
    intro t
    have h1 : (0:ℝ) < poleA n ^ 2 + t ^ 2 / 4 := by positivity
    rw [digammaTerm]
    field_simp
    ring
  simp only [hrw]
  have hden : Tendsto (fun t : ℝ => poleA n ^ 2 + t ^ 2 / 4) atTop atTop := by
    refine tendsto_atTop_add_const_left _ _ ?_
    exact (tendsto_pow_atTop (by norm_num)).atTop_div_const (by norm_num)
  have : Tendsto (fun t : ℝ => poleA n / (poleA n ^ 2 + t ^ 2 / 4)) atTop (𝓝 0) :=
    tendsto_const_nhds.div_atTop hden
  simpa using tendsto_const_nhds.sub this

/-- **`P(t) → ∞`**: the increment of the digamma function along the line `Re s = 1/4`
diverges. -/
theorem tendsto_digammaDiff_atTop : Tendsto digammaDiff atTop atTop := by
  refine tendsto_atTop.2 fun M => ?_
  obtain ⟨N, hN⟩ := (tendsto_atTop.1 tendsto_sum_one_div_poleA (M + 1)).exists
  have hfin : Tendsto (fun t : ℝ => ∑ n ∈ Finset.range N, digammaTerm n t) atTop
      (𝓝 (∑ n ∈ Finset.range N, 1 / poleA n)) :=
    tendsto_finset_sum _ fun n _ => tendsto_digammaTerm n
  have hev : ∀ᶠ t : ℝ in atTop, M ≤ ∑ n ∈ Finset.range N, digammaTerm n t := by
    have hgt : M < ∑ n ∈ Finset.range N, 1 / poleA n := by linarith
    filter_upwards [hfin (Ioi_mem_nhds hgt)] with t ht using le_of_lt ht
  filter_upwards [hev] with t ht
  exact ht.trans (sum_digammaTerm_le _ t)

/-- **`2θ'(t) → ∞`** as `t → ∞`. -/
theorem tendsto_thetaDeriv_atTop : Tendsto thetaDeriv atTop atTop := by
  have h : Tendsto (fun t : ℝ => (-Real.log π + (Complex.digamma (1 / 4 : ℂ)).re
      + digammaDiff t) / 2) atTop atTop := by
    refine Tendsto.atTop_div_const (by norm_num) ?_
    exact tendsto_atTop_add_const_left _ _ tendsto_digammaDiff_atTop
  refine h.congr fun t => ?_
  rw [← two_thetaDeriv_eq t]
  ring

/-! ## The Fourier side outside a bounded interval -/

/-- The Fourier side is bounded below by `2θ' - δ̂(0)`. -/
theorem fourierSide_ge (t : ℝ) : 2 * thetaDeriv t - deltaFourier 0 ≤ fourierSide t := by
  have h := abs_deltaFourier_le t
  have h1 : -deltaFourier 0 ≤ deltaFourier t := neg_le_of_abs_le h
  rw [fourierSide]
  linarith

/-- **The Fourier side tends to `+∞`.** -/
theorem tendsto_fourierSide_atTop : Tendsto fourierSide atTop atTop := by
  refine tendsto_atTop_mono fourierSide_ge ?_
  refine tendsto_atTop_add_const_right _ _ ?_
  exact tendsto_thetaDeriv_atTop.const_mul_atTop (by norm_num)

/-- **The Fourier-side inequality of Corollary 2.3 holds outside a bounded interval**: as
soon as `2θ'(T) ≥ δ̂(0)` at one point `T ≥ 0`, the inequality `2θ'(t) + δ̂(t) ≥ 0` holds for
every `t` with `|t| ≥ T`. -/
theorem fourierSide_nonneg_of_le_abs {T : ℝ} (hT : 0 ≤ T) (hbound : deltaFourier 0 ≤ 2 * thetaDeriv T)
    {t : ℝ} (ht : T ≤ |t|) : 0 ≤ fourierSide t := by
  have habs : |T| ≤ |t| := by rwa [abs_of_nonneg hT]
  have hmono : thetaDeriv T ≤ thetaDeriv t := thetaDeriv_le_of_abs_le habs
  have := fourierSide_ge t
  linarith

/-- **The Fourier-side inequality holds outside a bounded interval** (unconditional form):
there is a `T` such that `2θ'(t) + δ̂(t) ≥ 0` for every `t` with `T ≤ |t|`. -/
theorem exists_fourierSide_nonneg_of_le_abs :
    ∃ T : ℝ, 0 ≤ T ∧ ∀ t : ℝ, T ≤ |t| → 0 ≤ fourierSide t := by
  obtain ⟨T₀, hT₀⟩ := (tendsto_atTop.1 tendsto_thetaDeriv_atTop (deltaFourier 0 / 2)).exists_forall_of_atTop
  refine ⟨max T₀ 0, le_max_right _ _, fun t ht => ?_⟩
  have hTle : T₀ ≤ max T₀ 0 := le_max_left _ _
  have hbound : deltaFourier 0 ≤ 2 * thetaDeriv (max T₀ 0) := by
    have := hT₀ (max T₀ 0) hTle
    linarith
  exact fourierSide_nonneg_of_le_abs (le_max_right _ _) hbound ht

/-! ## Effective bounds

The exact formula `Re ψ(a+ib) = (1/2) log(a²+b²) - E(a,b)` with the explicit bound
`|E(a,b)| ≤ 1/(a²+b²) + π/(2b)` of `RequestProject/DigammaAsymptotic.lean` turns the
qualitative statements above into effective ones. -/

/-- **An effective form of the asymptotic `2θ'(t) ≈ log(t/2π)`**:
`|2θ'(t) + log π - (1/2) log(1/16 + t²/4)| ≤ 1/(1/16 + t²/4) + π/t` for `t > 0`. -/
theorem abs_two_thetaDeriv_sub_log_le {t : ℝ} (ht : 0 < t) :
    |2 * thetaDeriv t + Real.log π - Real.log (1 / 16 + t ^ 2 / 4) / 2|
      ≤ 1 / (1 / 16 + t ^ 2 / 4) + π / t := by
  have hb : 0 < t / 2 := by linarith
  have hkey := digamma_re_eq (a := (1 / 4 : ℝ)) (b := t / 2) (by norm_num) hb
  have harg : ((1 / 4 : ℝ) : ℂ) + Complex.I * ((t / 2 : ℝ) : ℂ)
      = 1 / 4 + Complex.I * (t : ℂ) / 2 := by
    push_cast
    ring
  rw [harg] at hkey
  have hE := abs_tsum_errTerm_le (a := (1 / 4 : ℝ)) (b := t / 2) (by norm_num) hb
  have hsq : ((1 : ℝ) / 4) ^ 2 + (t / 2) ^ 2 = 1 / 16 + t ^ 2 / 4 := by ring
  rw [hsq] at hkey hE
  have hpi : π / (2 * (t / 2)) = π / t := by
    rw [show 2 * (t / 2) = t by ring]
  rw [hpi] at hE
  have h2 : 2 * thetaDeriv t
      = (Complex.digamma (1 / 4 + Complex.I * (t : ℂ) / 2)).re - Real.log π := by
    rw [thetaDeriv]
    ring
  rw [h2, hkey, show Real.log (1 / 16 + t ^ 2 / 4) / 2
      - (∑' n, errTerm (1 / 4) (t / 2) n) - Real.log π + Real.log π
      - Real.log (1 / 16 + t ^ 2 / 4) / 2 = -(∑' n, errTerm (1 / 4) (t / 2) n) from by ring,
    abs_neg]
  exact hE

/-- **An effective lower bound for `2θ'`**: `2θ'(t) ≥ log(t/2π) - 4/t² - π/t` for `t > 0`. -/
theorem two_thetaDeriv_ge {t : ℝ} (ht : 0 < t) :
    Real.log (t / (2 * π)) - 4 / t ^ 2 - π / t ≤ 2 * thetaDeriv t := by
  have h := abs_le.1 (abs_two_thetaDeriv_sub_log_le ht)
  have hlog : Real.log (t / (2 * π)) = Real.log (t / 2) - Real.log π := by
    rw [show t / (2 * π) = (t / 2) / π by ring, Real.log_div (by positivity) Real.pi_ne_zero]
  have h2 : Real.log (t / 2) ≤ Real.log (1 / 16 + t ^ 2 / 4) / 2 := by
    have hpow : Real.log ((t / 2) ^ 2) = 2 * Real.log (t / 2) := by
      rw [Real.log_pow]
      push_cast
      ring
    have hmono : Real.log ((t / 2) ^ 2) ≤ Real.log (1 / 16 + t ^ 2 / 4) :=
      Real.log_le_log (by positivity) (by nlinarith)
    linarith
  have h3 : 1 / (1 / 16 + t ^ 2 / 4) ≤ 4 / t ^ 2 := by
    rw [show (4 : ℝ) / t ^ 2 = 1 / (t ^ 2 / 4) by field_simp]
    exact one_div_le_one_div_of_le (by positivity) (by nlinarith)
  linarith [h.1, h.2]

/-- **An explicit threshold for the Fourier-side inequality.**  The inequality
`2θ'(t) + δ̂(t) ≥ 0` of Corollary 2.3 holds for every `t` with
`|t| ≥ max 1 (2π exp(δ̂(0) + 4 + π))`.  (The value of `δ̂(0) = ∫ δ` is not computed in this
project, so the threshold is explicit only in terms of that single number.) -/
theorem fourierSide_nonneg_of_exp_le_abs {t : ℝ} (h1 : 1 ≤ |t|)
    (h2 : 2 * π * Real.exp (deltaFourier 0 + 4 + π) ≤ |t|) : 0 ≤ fourierSide t := by
  set T : ℝ := |t| with hT
  have hTpos : 0 < T := lt_of_lt_of_le zero_lt_one h1
  have hlog : deltaFourier 0 + 4 + π ≤ Real.log (T / (2 * π)) := by
    rw [Real.le_log_iff_exp_le (by positivity), le_div_iff₀ (by positivity)]
    calc Real.exp (deltaFourier 0 + 4 + π) * (2 * π)
        = 2 * π * Real.exp (deltaFourier 0 + 4 + π) := by ring
      _ ≤ T := h2
  have hinv1 : 4 / T ^ 2 ≤ 4 := by
    rw [div_le_iff₀ (by positivity)]
    nlinarith
  have hinv2 : π / T ≤ π := by
    rw [div_le_iff₀ hTpos]
    nlinarith [Real.pi_pos]
  have hge : deltaFourier 0 ≤ 2 * thetaDeriv T := by
    have := two_thetaDeriv_ge hTpos
    linarith
  exact fourierSide_nonneg_of_le_abs hTpos.le hge (le_of_eq hT.symm)

/-- **The Fourier-side inequality of Corollary 2.3 (ii), with a fully explicit threshold.**
Combining the effective lower bound for `2θ'` with the explicit bound `δ̂(0) ≤ 16π + 16`
coming from the decay of `δ`, the inequality `2θ'(t) + δ̂(t) ≥ 0` holds unconditionally for
every `t` with `|t| ≥ 2π exp(17π + 20)`. -/
theorem fourierSide_nonneg_of_explicit_le_abs {t : ℝ}
    (ht : 2 * π * Real.exp (17 * π + 20) ≤ |t|) : 0 ≤ fourierSide t := by
  have hpi : (3 : ℝ) < π := Real.pi_gt_three
  have hmono : Real.exp (deltaFourier 0 + 4 + π) ≤ Real.exp (17 * π + 20) := by
    apply Real.exp_le_exp.2
    have := deltaFourier_zero_le_pi
    linarith
  have h2 : 2 * π * Real.exp (deltaFourier 0 + 4 + π) ≤ |t| := by
    refine le_trans ?_ ht
    have hpos : (0 : ℝ) ≤ 2 * π := by positivity
    exact mul_le_mul_of_nonneg_left hmono hpos
  have h1 : (1 : ℝ) ≤ |t| := by
    refine le_trans ?_ ht
    have hexp : (1 : ℝ) ≤ Real.exp (17 * π + 20) := Real.one_le_exp (by linarith)
    nlinarith
  exact fourierSide_nonneg_of_exp_le_abs h1 h2

/-! ## The practical threshold `T₀ = 60`

Combining the effective lower bound `2θ'(t) ≥ log(t/2π) - 4/t² - π/t` with the *decaying*
bound `|δ̂(t)| ≤ 104/|t|` of `RequestProject/DeltaDecay.lean` (instead of the crude
`|δ̂(t)| ≤ δ̂(0)`) replaces the threshold `2π exp(17π+20)` by `60`. -/

/-- `θ'` is even, in the form used below. -/
theorem thetaDeriv_abs (t : ℝ) : thetaDeriv |t| = thetaDeriv t := by
  rcases abs_cases t with ⟨h, _⟩ | ⟨h, _⟩
  · rw [h]
  · rw [h, thetaDeriv_even]

/-- `log(T/2π) ≥ 2` for `T ≥ 60`. -/
theorem two_le_log_div_two_pi {T : ℝ} (hT : 60 ≤ T) : 2 ≤ Real.log (T / (2 * π)) := by
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  have hpi0 : (0:ℝ) < π := Real.pi_pos
  have hexp2 : Real.exp 2 ≤ 7.39 := by
    have h1 : Real.exp 2 = Real.exp 1 * Real.exp 1 := by
      rw [← Real.exp_add]
      norm_num
    have h2 : Real.exp 1 < 2.7182818286 := Real.exp_one_lt_d9
    nlinarith [Real.exp_pos 1]
  rw [Real.le_log_iff_exp_le (by positivity), le_div_iff₀ (by positivity)]
  nlinarith

/-- **The Fourier-side inequality of Corollary 2.3 (ii) outside the interval `|t| ≤ 60`.**
This is the effective form of the corollary obtained here: `2θ'(t) + δ̂(t) ≥ 0` holds
unconditionally for every real `t` with `|t| ≥ 60`.  (The inequality on the remaining
compact interval `|t| ≤ 60` is *not* proved in this project.) -/
theorem fourierSide_nonneg_of_sixty_le_abs {t : ℝ} (ht : 60 ≤ |t|) : 0 ≤ fourierSide t := by
  have hpi : π ≤ 3.15 := by linarith [Real.pi_lt_d2]
  have hT0 : (0:ℝ) < |t| := by linarith
  -- the lower bound for `2θ'`
  have hge := two_thetaDeriv_ge hT0
  have hlog : 2 ≤ Real.log (|t| / (2 * π)) := two_le_log_div_two_pi ht
  have h4 : 4 / |t| ^ 2 ≤ 4 / 3600 := by
    apply div_le_div_of_nonneg_left (by norm_num) (by norm_num)
    nlinarith
  have hpiT : π / |t| ≤ 3.15 / 60 := by
    rw [div_le_div_iff₀ hT0 (by norm_num)]
    nlinarith
  have hth : 2 * thetaDeriv t = 2 * thetaDeriv |t| := by rw [thetaDeriv_abs]
  -- the decay of `δ̂`
  have hdec : |deltaFourier t| ≤ 104 / |t| := abs_deltaFourier_le_of_sixty_le ht
  have hdec' : 104 / |t| ≤ 104 / 60 := by
    apply div_le_div_of_nonneg_left (by norm_num) (by norm_num) ht
  have hlow : -deltaFourier t ≤ 104 / 60 := by
    have := neg_abs_le (deltaFourier t)
    linarith [le_abs_self (deltaFourier t), abs_le.1 hdec]
  rw [fourierSide, hth]
  linarith

end ConnesConsani.WeilPositivity
