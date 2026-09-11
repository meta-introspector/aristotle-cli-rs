/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The asymptotic behaviour of the digamma function on a vertical line,

  `Re ψ(a + i b) = (1/2) log (a² + b²) - E(a,b)`,   `|E(a,b)| ≤ 1/(a²+b²) + π/(2b)`,

hence `Re ψ(a + i b) - log b → 0` as `b → +∞`.  This is the classical Stirling asymptotic
`ψ(z) ~ log z`, restricted to a vertical line, and it is exactly what is needed for the
asymptotic `θ'(t) ~ (1/2) log (t/2π)` of the Riemann–Siegel angular function used in §2 of

  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

The proof is elementary and self-contained, starting from the Gauss partial-fraction
expansion `hasSum_digamma` of `RequestProject/Digamma.lean`:

* taking real parts, `Re ψ(a+ib) + γ = ∑_{n≥0} (1/(n+1) - f(n))` with
  `f(x) = (x+a)/((x+a)²+b²)`;
* `f` has the explicit primitive `L(x) = (1/2) log((x+a)²+b²)`, so the partial sums of
  `f(n)` telescope up to the error `e_n = f(n) - (L(n+1) - L(n))`, which is bounded by
  `1/((n+a)²+b²)` by the mean value theorem (`|f'| ≤ 1/((x+a)²+b²)`);
* `∑_n 1/((n+a)²+b²) ≤ 1/(a²+b²) + π/(2b)` by a telescoping comparison with `arctan`;
* the harmonic numbers contribute `γ` (`Real.tendsto_harmonic_sub_log`), and
  `log N - L(N) → 0`.
-/
import RequestProject.Imported.OutputFinal2.Digamma

noncomputable section

open Real Filter Topology Set

namespace ConnesConsani.WeilPositivity

/-! ## The summand and its primitive -/

/-- `poleTerm a b x = (x+a)/((x+a)²+b²)`, the real part of `1/(x+a+ib)`. -/
def poleTerm (a b x : ℝ) : ℝ := (x + a) / ((x + a) ^ 2 + b ^ 2)

/-- `logTerm a b x = (1/2) log((x+a)²+b²)`, a primitive of `poleTerm a b`. -/
def logTerm (a b x : ℝ) : ℝ := Real.log ((x + a) ^ 2 + b ^ 2) / 2

variable {a b : ℝ}

theorem poleDen_pos (hb : b ≠ 0) (a x : ℝ) : 0 < (x + a) ^ 2 + b ^ 2 := by positivity

theorem hasDerivAt_logTerm (hb : b ≠ 0) (x : ℝ) :
    HasDerivAt (logTerm a b) (poleTerm a b x) x := by
  have hden := poleDen_pos hb a x
  have h1 : HasDerivAt (fun x : ℝ => (x + a) ^ 2 + b ^ 2) (2 * (x + a)) x := by
    have := ((hasDerivAt_id x).add_const a).pow 2
    simpa using this.add_const (b ^ 2)
  have h2 := (h1.log hden.ne').div_const 2
  convert h2 using 1
  rw [poleTerm]
  field_simp

theorem hasDerivAt_poleTerm (hb : b ≠ 0) (x : ℝ) :
    HasDerivAt (poleTerm a b) ((b ^ 2 - (x + a) ^ 2) / ((x + a) ^ 2 + b ^ 2) ^ 2) x := by
  have hden := poleDen_pos hb a x
  have h1 : HasDerivAt (fun x : ℝ => (x + a) ^ 2 + b ^ 2) (2 * (x + a)) x := by
    have := ((hasDerivAt_id x).add_const a).pow 2
    simpa using this.add_const (b ^ 2)
  have h0 : HasDerivAt (fun x : ℝ => x + a) 1 x := by simpa using (hasDerivAt_id x).add_const a
  have h2 := h0.div h1 hden.ne'
  convert h2 using 1
  field_simp
  ring

theorem abs_deriv_poleTerm_le (hb : b ≠ 0) (x : ℝ) :
    |(b ^ 2 - (x + a) ^ 2) / ((x + a) ^ 2 + b ^ 2) ^ 2| ≤ 1 / ((x + a) ^ 2 + b ^ 2) := by
  have hden := poleDen_pos hb a x
  have habs : |b ^ 2 - (x + a) ^ 2| ≤ (x + a) ^ 2 + b ^ 2 := by
    rw [abs_le]
    constructor <;> nlinarith [sq_nonneg (x + a), sq_nonneg b]
  rw [abs_div, abs_of_pos (by positivity : (0:ℝ) < ((x + a) ^ 2 + b ^ 2) ^ 2)]
  calc |b ^ 2 - (x + a) ^ 2| / ((x + a) ^ 2 + b ^ 2) ^ 2
      ≤ ((x + a) ^ 2 + b ^ 2) / ((x + a) ^ 2 + b ^ 2) ^ 2 := by gcongr
    _ = 1 / ((x + a) ^ 2 + b ^ 2) := by
        rw [sq]
        field_simp

/-- The mean value estimate for `poleTerm`: on `[x, x+1]` with `x ≥ 0` and `a > 0` the
increment of `f` is at most `1/((x+a)²+b²)`. -/
theorem abs_poleTerm_sub_le (ha : 0 < a) (hb : 0 < b) {x y : ℝ} (hx : 0 ≤ x) (hxy : x ≤ y)
    (hy : y ≤ x + 1) : |poleTerm a b y - poleTerm a b x| ≤ 1 / ((x + a) ^ 2 + b ^ 2) := by
  have hbne : b ≠ 0 := hb.ne'
  have hdx := poleDen_pos hbne a x
  rcases eq_or_lt_of_le hxy with h | h
  · subst h
    simp only [sub_self, abs_zero]
    positivity
  obtain ⟨c, hc, hslope⟩ := exists_hasDerivAt_eq_slope (poleTerm a b)
    (fun z => (b ^ 2 - (z + a) ^ 2) / ((z + a) ^ 2 + b ^ 2) ^ 2) h
    (fun z _ => (hasDerivAt_poleTerm hbne z).continuousAt.continuousWithinAt)
    (fun z _ => hasDerivAt_poleTerm hbne z)
  have hcx : x ≤ c := hc.1.le
  have hmono : 1 / ((c + a) ^ 2 + b ^ 2) ≤ 1 / ((x + a) ^ 2 + b ^ 2) := by
    apply one_div_le_one_div_of_le hdx
    nlinarith
  have hb1 : |(b ^ 2 - (c + a) ^ 2) / ((c + a) ^ 2 + b ^ 2) ^ 2| ≤ 1 / ((x + a) ^ 2 + b ^ 2) :=
    (abs_deriv_poleTerm_le hbne c).trans hmono
  have hyx : 0 < y - x := by linarith
  have hval : poleTerm a b y - poleTerm a b x
      = (b ^ 2 - (c + a) ^ 2) / ((c + a) ^ 2 + b ^ 2) ^ 2 * (y - x) := by
    rw [hslope]
    field_simp
  rw [hval, abs_mul, abs_of_pos hyx]
  calc |(b ^ 2 - (c + a) ^ 2) / ((c + a) ^ 2 + b ^ 2) ^ 2| * (y - x)
      ≤ 1 / ((x + a) ^ 2 + b ^ 2) * 1 := by
        apply mul_le_mul hb1 (by linarith) hyx.le
        positivity
    _ = 1 / ((x + a) ^ 2 + b ^ 2) := by ring

/-! ## The error terms -/

/-- The error in replacing `∑_{n<N} f(n)` by the telescoping sum of the primitive. -/
def errTerm (a b : ℝ) (n : ℕ) : ℝ :=
  poleTerm a b n - (logTerm a b (n + 1) - logTerm a b n)

theorem abs_errTerm_le (ha : 0 < a) (hb : 0 < b) (n : ℕ) :
    |errTerm a b n| ≤ 1 / (((n : ℝ) + a) ^ 2 + b ^ 2) := by
  have hbne : b ≠ 0 := hb.ne'
  have hlt : (n : ℝ) < (n : ℝ) + 1 := by linarith
  obtain ⟨c, hc, hslope⟩ := exists_hasDerivAt_eq_slope (logTerm a b) (poleTerm a b) hlt
    (fun z _ => (hasDerivAt_logTerm hbne z).continuousAt.continuousWithinAt)
    (fun z _ => hasDerivAt_logTerm hbne z)
  have hval : logTerm a b ((n : ℝ) + 1) - logTerm a b (n : ℝ) = poleTerm a b c := by
    rw [hslope, show ((n : ℝ) + 1 - (n : ℝ)) = 1 by ring, div_one]
  rw [errTerm, hval, ← abs_neg, neg_sub]
  exact abs_poleTerm_sub_le ha hb n.cast_nonneg hc.1.le hc.2.le

/-! ## The bound `∑ 1/((n+a)²+b²) ≤ 1/(a²+b²) + π/(2b)` -/

theorem inv_poleDen_le_arctan_sub (ha : 0 < a) (hb : 0 < b) (n : ℕ) :
    1 / ((((n : ℝ) + 1) + a) ^ 2 + b ^ 2)
      ≤ (arctan ((((n : ℝ) + 1) + a) / b) - arctan (((n : ℝ) + a) / b)) / b := by
  set u : ℝ := ((n : ℝ) + a) / b with hu
  set v : ℝ := (((n : ℝ) + 1) + a) / b with hv
  have hu0 : 0 ≤ u := by
    rw [hu]
    positivity
  have huv : u < v := by
    rw [hu, hv]
    gcongr
    linarith
  obtain ⟨c, hc, hslope⟩ := exists_hasDerivAt_eq_slope arctan (fun x => 1 / (1 + x ^ 2)) huv
    (fun z _ => (hasDerivAt_arctan z).continuousAt.continuousWithinAt)
    (fun z _ => hasDerivAt_arctan z)
  have hc0 : 0 < c := lt_of_le_of_lt hu0 hc.1
  have hcv : c < v := hc.2
  have hvu : v - u = 1 / b := by
    rw [hu, hv]
    field_simp
    ring
  have hne : v - u ≠ 0 := sub_ne_zero.mpr huv.ne'
  have hdiff : arctan v - arctan u = 1 / (1 + c ^ 2) * (1 / b) := by
    rw [hslope, ← hvu, div_mul_cancel₀ _ hne]
  have hden : ((((n : ℝ) + 1) + a) ^ 2 + b ^ 2) = b ^ 2 * (1 + v ^ 2) := by
    rw [hv]
    field_simp
    ring
  have hR : (1 / (1 + c ^ 2) * (1 / b)) / b = 1 / (b ^ 2 * (1 + c ^ 2)) := by
    field_simp
  rw [hdiff, hden, hR]
  gcongr

theorem sum_inv_poleDen_le (ha : 0 < a) (hb : 0 < b) (N : ℕ) :
    ∑ n ∈ Finset.range N, 1 / (((n : ℝ) + a) ^ 2 + b ^ 2) ≤ 1 / (a ^ 2 + b ^ 2) + π / (2 * b) := by
  have key : ∀ M : ℕ, ∑ n ∈ Finset.range (M + 1), 1 / (((n : ℝ) + a) ^ 2 + b ^ 2)
      ≤ 1 / (a ^ 2 + b ^ 2) + (arctan (((M : ℝ) + a) / b) - arctan (a / b)) / b := by
    intro M
    induction M with
    | zero => norm_num
    | succ K ih =>
        rw [Finset.sum_range_succ]
        have h := inv_poleDen_le_arctan_sub ha hb K
        push_cast at ih h ⊢
        have hbpos : 0 < b := hb
        have hsplit : (arctan (((K : ℝ) + 1 + a) / b) - arctan (a / b)) / b
            = (arctan (((K : ℝ) + a) / b) - arctan (a / b)) / b
              + (arctan (((K : ℝ) + 1 + a) / b) - arctan (((K : ℝ) + a) / b)) / b := by
          field_simp
          ring
        rw [hsplit]
        linarith
  have hπ : arctan (((N : ℝ) + a) / b) - arctan (a / b) ≤ π / 2 := by
    have h1 : arctan (((N : ℝ) + a) / b) < π / 2 := arctan_lt_pi_div_two _
    have h2 : 0 ≤ arctan (a / b) := Real.arctan_nonneg.mpr (by positivity)
    linarith
  have hle : ∑ n ∈ Finset.range N, 1 / (((n : ℝ) + a) ^ 2 + b ^ 2)
      ≤ ∑ n ∈ Finset.range (N + 1), 1 / (((n : ℝ) + a) ^ 2 + b ^ 2) := by
    rw [Finset.sum_range_succ]
    have : 0 ≤ 1 / (((N : ℝ) + a) ^ 2 + b ^ 2) := by positivity
    linarith
  have hfin := (key N)
  have hdiv : (arctan (((N : ℝ) + a) / b) - arctan (a / b)) / b ≤ (π / 2) / b := by
    gcongr
  have hval : (π / 2) / b = π / (2 * b) := by
    field_simp
  linarith [hle.trans hfin]

theorem summable_inv_poleDen (ha : 0 < a) (hb : 0 < b) :
    Summable (fun n : ℕ => 1 / (((n : ℝ) + a) ^ 2 + b ^ 2)) :=
  summable_of_sum_range_le (fun n => by positivity) (sum_inv_poleDen_le ha hb)

theorem summable_errTerm (ha : 0 < a) (hb : 0 < b) : Summable (errTerm a b) :=
  Summable.of_norm_bounded (summable_inv_poleDen ha hb) fun n => by
    simpa [Real.norm_eq_abs] using abs_errTerm_le ha hb n

theorem abs_tsum_errTerm_le (ha : 0 < a) (hb : 0 < b) :
    |∑' n, errTerm a b n| ≤ 1 / (a ^ 2 + b ^ 2) + π / (2 * b) := by
  have h1 : |∑' n, errTerm a b n| ≤ ∑' n, |errTerm a b n| := by
    have hs : Summable (fun n : ℕ => ‖errTerm a b n‖) :=
      Summable.of_norm_bounded (summable_inv_poleDen ha hb) fun n => by
        simpa [Real.norm_eq_abs] using abs_errTerm_le ha hb n
    simpa [Real.norm_eq_abs] using norm_tsum_le_tsum_norm hs
  have h2 : ∑' n, |errTerm a b n| ≤ ∑' n : ℕ, 1 / (((n : ℝ) + a) ^ 2 + b ^ 2) :=
    Summable.tsum_le_tsum (fun n => abs_errTerm_le ha hb n)
      (Summable.of_norm_bounded (summable_inv_poleDen ha hb) fun n => by
        simpa [Real.norm_eq_abs] using abs_errTerm_le ha hb n)
      (summable_inv_poleDen ha hb)
  have h3 : ∑' n : ℕ, 1 / (((n : ℝ) + a) ^ 2 + b ^ 2) ≤ 1 / (a ^ 2 + b ^ 2) + π / (2 * b) :=
    tsum_le_of_sum_range_le (fun n => by positivity) (sum_inv_poleDen_le ha hb)
  linarith

/-! ## The exact formula -/

/-- `log N - (1/2) log((N+a)²+b²) → 0`. -/
theorem tendsto_log_sub_logTerm (a : ℝ) (hb : b ≠ 0) :
    Tendsto (fun N : ℕ => Real.log N - logTerm a b N) atTop (𝓝 0) := by
  have hone : Tendsto (fun N : ℕ => (1 : ℝ) / (N : ℝ)) atTop (𝓝 0) :=
    tendsto_one_div_atTop_nhds_zero_nat
  have hratio : Tendsto (fun N : ℕ => (((N : ℝ) + a) ^ 2 + b ^ 2) / (N : ℝ) ^ 2) atTop (𝓝 1) := by
    have hlim : Tendsto
        (fun N : ℕ => 1 + 2 * a * (1 / (N : ℝ)) + (a ^ 2 + b ^ 2) * (1 / (N : ℝ)) ^ 2)
        atTop (𝓝 (1 + 2 * a * 0 + (a ^ 2 + b ^ 2) * 0 ^ 2)) := by
      exact ((tendsto_const_nhds.add ((tendsto_const_nhds).mul hone)).add
        ((tendsto_const_nhds).mul (hone.pow 2)))
    have heq : ∀ᶠ N : ℕ in atTop,
        1 + 2 * a * (1 / (N : ℝ)) + (a ^ 2 + b ^ 2) * (1 / (N : ℝ)) ^ 2
          = (((N : ℝ) + a) ^ 2 + b ^ 2) / (N : ℝ) ^ 2 := by
      filter_upwards [eventually_ge_atTop 1] with N hN
      have hN0 : (0 : ℝ) < N := by exact_mod_cast hN
      field_simp
      ring
    have : (1 : ℝ) + 2 * a * 0 + (a ^ 2 + b ^ 2) * 0 ^ 2 = 1 := by ring
    rw [this] at hlim
    exact hlim.congr' heq
  have hlog : Tendsto (fun N : ℕ => Real.log ((((N : ℝ) + a) ^ 2 + b ^ 2) / (N : ℝ) ^ 2))
      atTop (𝓝 0) := by
    have := (Real.continuousAt_log (by norm_num : (1:ℝ) ≠ 0)).tendsto.comp hratio
    simpa using this
  have hfinal := hlog.const_mul (-(1 : ℝ) / 2)
  rw [mul_zero] at hfinal
  refine hfinal.congr' ?_
  filter_upwards [eventually_ge_atTop 1] with N hN
  have hN0 : (0 : ℝ) < N := by exact_mod_cast hN
  have hz : ((N : ℝ) + a) ^ 2 + b ^ 2 ≠ 0 := (poleDen_pos hb a N).ne'
  rw [Real.log_div hz (by positivity), Real.log_pow]
  simp only [logTerm]
  push_cast
  ring

/-- **The exact formula for the real part of the digamma function on a vertical line.** -/
theorem digamma_re_eq (ha : 0 < a) (hb : 0 < b) :
    (Complex.digamma ((a : ℂ) + Complex.I * b)).re
      = Real.log (a ^ 2 + b ^ 2) / 2 - ∑' n, errTerm a b n := by
  set s : ℂ := (a : ℂ) + Complex.I * b with hs
  have hsre : 0 < s.re := by
    have : s.re = a := by simp [hs]
    rw [this]; exact ha
  have hsum := hasSum_digamma hsre
  have hterm : ∀ n : ℕ, ((1 / ((n : ℂ) + 1) - 1 / ((n : ℂ) + s)).re)
      = 1 / ((n : ℝ) + 1) - poleTerm a b n := by
    intro n
    have h1 : ((1 : ℂ) / ((n : ℂ) + 1)).re = 1 / ((n : ℝ) + 1) := by
      have hcast : ((n : ℂ) + 1) = (((n : ℝ) + 1 : ℝ) : ℂ) := by push_cast; ring
      rw [hcast, ← Complex.ofReal_one, ← Complex.ofReal_div, Complex.ofReal_re]
    have hz : ((n : ℂ) + s) = (((n : ℝ) + a : ℝ) : ℂ) + Complex.I * ((b : ℝ) : ℂ) := by
      rw [hs]; push_cast; ring
    have hzre : ((((n : ℝ) + a : ℝ) : ℂ) + Complex.I * ((b : ℝ) : ℂ)).re = (n : ℝ) + a := by simp
    have hzsq : Complex.normSq ((((n : ℝ) + a : ℝ) : ℂ) + Complex.I * ((b : ℝ) : ℂ))
        = ((n : ℝ) + a) ^ 2 + b ^ 2 := by
      simp [Complex.normSq_apply]
      ring
    have h2 : ((1 : ℂ) / ((n : ℂ) + s)).re = poleTerm a b n := by
      rw [hz, one_div, Complex.inv_re, hzre, hzsq, poleTerm]
    rw [Complex.sub_re, h1, h2]
  have hsumR : HasSum (fun n : ℕ => 1 / ((n : ℝ) + 1) - poleTerm a b n)
      ((Complex.digamma s).re + Real.eulerMascheroniConstant) := by
    have h := Complex.reCLM.hasSum hsum
    simp only [Complex.reCLM_apply, Complex.add_re, Complex.ofReal_re] at h
    rw [funext hterm] at h
    exact h
  -- the partial sums
  have hpartial : ∀ N : ℕ, ∑ n ∈ Finset.range N, (1 / ((n : ℝ) + 1) - poleTerm a b n)
      = ((harmonic N : ℚ) : ℝ) - (logTerm a b N - logTerm a b 0)
        - ∑ n ∈ Finset.range N, errTerm a b n := by
    intro N
    have hpole : ∑ n ∈ Finset.range N, poleTerm a b n
        = ∑ n ∈ Finset.range N, errTerm a b n + (logTerm a b N - logTerm a b 0) := by
      have htel := Finset.sum_range_sub (fun n : ℕ => logTerm a b n) N
      have hsplit : ∀ n ∈ Finset.range N, poleTerm a b (n : ℝ)
          = errTerm a b n + (logTerm a b ((n : ℕ) + 1 : ℕ) - logTerm a b (n : ℕ)) := by
        intro n _
        simp only [errTerm]
        push_cast
        ring
      rw [Finset.sum_congr rfl hsplit, Finset.sum_add_distrib, htel]
      push_cast
      ring
    have hharm : ((harmonic N : ℚ) : ℝ) = ∑ n ∈ Finset.range N, 1 / ((n : ℝ) + 1) := by
      simp [harmonic]
    rw [Finset.sum_sub_distrib, hpole, hharm]
    ring
  -- the limit of the partial sums
  have hlim1 : Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N, (1 / ((n : ℝ) + 1) - poleTerm a b n))
      atTop (𝓝 ((Complex.digamma s).re + Real.eulerMascheroniConstant)) := hsumR.tendsto_sum_nat
  have hlim2 : Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N, (1 / ((n : ℝ) + 1) - poleTerm a b n))
      atTop (𝓝 (Real.eulerMascheroniConstant + logTerm a b 0 - ∑' n, errTerm a b n)) := by
    have hA : Tendsto (fun N : ℕ => ((harmonic N : ℚ) : ℝ) - Real.log N) atTop
        (𝓝 Real.eulerMascheroniConstant) := Real.tendsto_harmonic_sub_log
    have hB : Tendsto (fun N : ℕ => Real.log N - logTerm a b N) atTop (𝓝 0) :=
      tendsto_log_sub_logTerm a hb.ne'
    have hC : Tendsto (fun N : ℕ => ∑ n ∈ Finset.range N, errTerm a b n) atTop
        (𝓝 (∑' n, errTerm a b n)) := (summable_errTerm ha hb).hasSum.tendsto_sum_nat
    have hsum2 := ((hA.add hB).add (tendsto_const_nhds (x := logTerm a b 0))).sub hC
    have hval : Real.eulerMascheroniConstant + 0 + logTerm a b 0 - ∑' n, errTerm a b n
        = Real.eulerMascheroniConstant + logTerm a b 0 - ∑' n, errTerm a b n := by ring
    rw [hval] at hsum2
    refine hsum2.congr fun N => ?_
    rw [hpartial N]
    ring
  have heq := tendsto_nhds_unique hlim1 hlim2
  have hL0 : logTerm a b 0 = Real.log (a ^ 2 + b ^ 2) / 2 := by
    simp [logTerm]
  rw [hL0] at heq
  linarith [heq]

/-! ## The asymptotic -/

/-- **`Re ψ(a + i b) - log b → 0` as `b → +∞`.** -/
theorem tendsto_digamma_re_sub_log (ha : 0 < a) :
    Tendsto (fun b : ℝ => (Complex.digamma ((a : ℂ) + Complex.I * b)).re - Real.log b)
      atTop (𝓝 0) := by
  have hE : Tendsto (fun b : ℝ => ∑' n, errTerm a b n) atTop (𝓝 0) := by
    refine squeeze_zero_norm' (a := fun b : ℝ => 1 / (a ^ 2 + b ^ 2) + π / (2 * b)) ?_ ?_
    · filter_upwards [eventually_gt_atTop (0 : ℝ)] with b hb
      simpa [Real.norm_eq_abs] using abs_tsum_errTerm_le ha hb
    · have h1 : Tendsto (fun b : ℝ => 1 / (a ^ 2 + b ^ 2)) atTop (𝓝 0) := by
        have : Tendsto (fun b : ℝ => a ^ 2 + b ^ 2) atTop atTop := by
          apply Filter.tendsto_atTop_add_const_left
          exact tendsto_pow_atTop (by norm_num)
        exact this.const_div_atTop 1
      have h2 : Tendsto (fun b : ℝ => π / (2 * b)) atTop (𝓝 0) := by
        have : Tendsto (fun b : ℝ => 2 * b) atTop atTop :=
          Filter.Tendsto.const_mul_atTop (by norm_num : (0:ℝ) < 2) tendsto_id
        exact this.const_div_atTop π
      have h3 := h1.add h2
      rw [add_zero] at h3
      exact h3
  have hlog : Tendsto (fun b : ℝ => Real.log (a ^ 2 + b ^ 2) / 2 - Real.log b) atTop (𝓝 0) := by
    have hratio : Tendsto (fun b : ℝ => (a ^ 2 + b ^ 2) / b ^ 2) atTop (𝓝 1) := by
      have hinv : Tendsto (fun b : ℝ => 1 / b ^ 2) atTop (𝓝 0) := by
        have : Tendsto (fun b : ℝ => b ^ 2) atTop atTop := tendsto_pow_atTop (by norm_num)
        exact this.const_div_atTop 1
      have hlim : Tendsto (fun b : ℝ => 1 + a ^ 2 * (1 / b ^ 2)) atTop (𝓝 (1 + a ^ 2 * 0)) :=
        tendsto_const_nhds.add (tendsto_const_nhds.mul hinv)
      rw [show (1 : ℝ) + a ^ 2 * 0 = 1 by ring] at hlim
      refine hlim.congr' ?_
      filter_upwards [eventually_gt_atTop (0 : ℝ)] with b hb
      field_simp
      ring
    have hcomp : Tendsto (fun b : ℝ => Real.log ((a ^ 2 + b ^ 2) / b ^ 2)) atTop (𝓝 0) := by
      have := (Real.continuousAt_log (by norm_num : (1:ℝ) ≠ 0)).tendsto.comp hratio
      simpa using this
    have hhalf := hcomp.const_mul ((1 : ℝ) / 2)
    rw [mul_zero] at hhalf
    refine hhalf.congr' ?_
    filter_upwards [eventually_gt_atTop (0 : ℝ)] with b hb
    have hb2 : (b : ℝ) ^ 2 ≠ 0 := by positivity
    have hnum : a ^ 2 + b ^ 2 ≠ 0 := by positivity
    rw [Real.log_div hnum hb2, Real.log_pow]
    push_cast
    ring
  have hmain : Tendsto
      (fun b : ℝ => (Real.log (a ^ 2 + b ^ 2) / 2 - Real.log b) - ∑' n, errTerm a b n)
      atTop (𝓝 (0 - 0)) := hlog.sub hE
  rw [sub_zero] at hmain
  refine hmain.congr' ?_
  filter_upwards [eventually_gt_atTop (0 : ℝ)] with b hb
  rw [digamma_re_eq ha hb]
  ring

end ConnesConsani.WeilPositivity
