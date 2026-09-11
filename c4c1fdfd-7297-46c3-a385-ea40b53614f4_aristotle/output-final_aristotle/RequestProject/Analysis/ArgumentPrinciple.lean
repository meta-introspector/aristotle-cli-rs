/-
Original to this repository (not part of the upstream ZetaZeros development).
-/
import Mathlib

/-!
# The argument principle for holomorphic functions

`RequestProject/Experiments/ArgumentPrinciple.lean` contains *toy* argument principles: the
contour integral of the logarithmic derivative of `z ^ n`, and of a polynomial given in factored
form.  This file proves the general statement those toys were standing in for.

The main result, `ZetaZeros.Analysis.circleIntegral_logDeriv_eq_zeroCount`, says that for a
function `f` holomorphic on a neighbourhood of the closed disc `closedBall c R` and without zeros
on the bounding circle,

`∮ z in C(c, R), logDeriv f z = 2 * π * I * (number of zeros of f in ball c R, with multiplicity)`,

the multiplicity of a zero being `analyticOrderNatAt f u`.  A version for an arbitrary open
domain, `circleIntegral_logDeriv_eq_zeroCount_of_isOpen`, and a corollary counting simple zeros,
`circleIntegral_logDeriv_eq_card_of_simple`, are also given.
-/

namespace ZetaZeros.Analysis

open Complex Filter Function Metric Set MeromorphicOn
open scoped Real Topology

/-! ## Generalities -/

/-- Two functions that are continuous on an open set `U` and agree on a codiscrete subset of `U`
agree on all of `U`. -/
theorem eqOn_of_eventuallyEq_codiscreteWithin {U : Set ℂ} (hU : IsOpen U) {f g : ℂ → ℂ}
    (hf : ContinuousOn f U) (hg : ContinuousOn g U) (h : f =ᶠ[codiscreteWithin U] g) :
    EqOn f g U := by
  intro x hx
  have hUx : U ∈ 𝓝 x := hU.mem_nhds hx
  have hdisj := mem_codiscreteWithin.mp h x hx
  rw [disjoint_principal_right] at hdisj
  have key : ∀ᶠ z in 𝓝[≠] x, f z = g z := by
    filter_upwards [hdisj, nhdsWithin_le_nhds hUx] with z hz hzU
    simp only [Set.mem_compl_iff, Set.mem_diff, not_and, not_not] at hz
    exact hz hzU
  exact tendsto_nhds_unique
    ((((hf x hx).continuousAt hUx).tendsto.mono_left nhdsWithin_le_nhds).congr' key)
    (((hg x hx).continuousAt hUx).tendsto.mono_left nhdsWithin_le_nhds)

/-- The circle integral of `(z - w)⁻¹` vanishes when `w` lies outside the closed disc. -/
theorem circleIntegral_sub_inv_of_notMem_closedBall {c w : ℂ} {R : ℝ} (hR : 0 ≤ R)
    (hw : w ∉ closedBall c R) :
    (∮ z in C(c, R), (z - w)⁻¹) = 0 := by
  rcases eq_or_lt_of_le hR with rfl | hR'
  · simp
  apply DiffContOnCl.circleIntegral_eq_zero hR
  constructor
  · intro z hz
    apply DifferentiableAt.differentiableWithinAt
    apply DifferentiableAt.inv (by fun_prop)
    intro hcon
    rw [sub_eq_zero] at hcon
    exact hw (hcon ▸ ball_subset_closedBall hz)
  · rw [closure_ball _ hR'.ne']
    intro z hz
    apply ContinuousAt.continuousWithinAt
    apply ContinuousAt.inv₀ (by fun_prop)
    intro hcon
    rw [sub_eq_zero] at hcon
    exact hw (hcon ▸ hz)

/-- The logarithmic derivative of a finite product of powers times a nonvanishing factor. -/
theorem logDeriv_prod_pow_mul {s : Finset ℂ} {m : ℂ → ℕ} {g : ℂ → ℂ} {z : ℂ}
    (hz : ∀ u ∈ s, z ≠ u) (hg : g z ≠ 0) (hdg : DifferentiableAt ℂ g z) :
    logDeriv (fun w ↦ (∏ u ∈ s, (w - u) ^ m u) * g w) z
      = (∑ u ∈ s, (m u : ℂ) * (z - u)⁻¹) + logDeriv g z := by
  have hsub : ∀ u ∈ s, z - u ≠ 0 := fun u hu => sub_ne_zero.mpr (hz u hu)
  have hP : (∏ u ∈ s, (z - u) ^ m u) ≠ 0 :=
    Finset.prod_ne_zero_iff.mpr fun u hu => pow_ne_zero _ (hsub u hu)
  have hdP : DifferentiableAt ℂ (fun w : ℂ ↦ ∏ u ∈ s, (w - u) ^ m u) z := by fun_prop
  rw [logDeriv_mul z hP hg hdP hdg,
    logDeriv_prod (f := fun u (w : ℂ) ↦ (w - u) ^ m u)
      (fun u hu => pow_ne_zero _ (hsub u hu)) (fun u hu => by fun_prop)]
  congr 1
  refine Finset.sum_congr rfl fun u hu => ?_
  rw [logDeriv_fun_pow (by fun_prop)]
  congr 1
  rw [logDeriv_apply]
  simp

/-! ## Factorization of a holomorphic function -/

/-- **Factorization of the zeros.**  A function holomorphic on a neighbourhood of a compact set
`K`, and not identically zero on a connected open subset `U` of `K`, factors on `U` as a finite
product of powers `(z - u) ^ (order of the zero at u)` times a nonvanishing holomorphic
function. -/
theorem exists_finset_factorization_of_isCompact {f : ℂ → ℂ} {U K : Set ℂ} (hUopen : IsOpen U)
    (hUconn : IsConnected U) (hUK : U ⊆ K) (hK : IsCompact K) (hf : AnalyticOnNhd ℂ f K)
    (hne : ∃ z ∈ U, f z ≠ 0) :
    ∃ (s : Finset ℂ) (g : ℂ → ℂ), ↑s ⊆ U ∧ AnalyticOnNhd ℂ g U ∧
      (∀ z ∈ U, g z ≠ 0) ∧
      (∀ z ∈ U, f z = (∏ u ∈ s, (z - u) ^ analyticOrderNatAt f u) * g z) ∧
      (∀ u ∈ s, analyticOrderNatAt f u ≠ 0) ∧
      (∀ u ∈ U, analyticOrderNatAt f u ≠ 0 → u ∈ s) := by
  have hfU : AnalyticOnNhd ℂ f U := hf.mono hUK
  have horders : ∀ u ∈ U, analyticOrderAt f u ≠ ⊤ := by
    obtain ⟨z, hz, hfz⟩ := hne
    have : ∃ u : U, analyticOrderAt f (u : ℂ) ≠ ⊤ :=
      ⟨⟨z, hz⟩, by rw [(hfU z hz).analyticOrderAt_eq_zero.mpr hfz]; simp⟩
    exact fun u hu => (hfU.exists_analyticOrderAt_ne_top_iff_forall hUconn).1 this ⟨u, hu⟩
  have hmero : MeromorphicOn f U := hfU.meromorphicOn
  have h₂f : ∀ u : U, meromorphicOrderAt f (u : ℂ) ≠ ⊤ := by
    rintro ⟨u, hu⟩
    rw [(hfU u hu).meromorphicOrderAt_eq]
    simpa using horders u hu
  have hdiv : ∀ u ∈ U, (divisor f U) u = (analyticOrderNatAt f u : ℤ) := by
    intro u hu
    rw [hmero.divisor_apply hu, (hfU u hu).meromorphicOrderAt_eq]
    cases h : analyticOrderAt f u with
    | top => simp [analyticOrderNatAt, h]
    | coe k => simp [analyticOrderNatAt, h]
  have h₃f : ((divisor f U).support).Finite := by
    have hmeroC : MeromorphicOn f K := hf.meromorphicOn
    have hfin := (divisor f K).finiteSupport hK
    apply hfin.subset
    intro u hu
    have huU : u ∈ U := (divisor f U).supportWithinDomain hu
    simp only [Function.mem_support] at hu ⊢
    rw [hmeroC.divisor_apply (hUK huU), ← hmero.divisor_apply huU]
    exact hu
  obtain ⟨g, hg₁, hg₂, hg₃⟩ := hmero.extract_zeros_poles h₂f h₃f
  refine ⟨h₃f.toFinset, g, ?_, hg₁, fun z hz => hg₂ ⟨z, hz⟩, ?_, ?_, ?_⟩
  · intro u hu
    simp only [Set.Finite.coe_toFinset] at hu
    exact (divisor f U).supportWithinDomain hu
  · have hFcont : ContinuousOn
        (fun z ↦ (∏ u ∈ h₃f.toFinset, (z - u) ^ analyticOrderNatAt f u) * g z) U :=
      ContinuousOn.mul (by fun_prop) hg₁.continuousOn
    refine eqOn_of_eventuallyEq_codiscreteWithin hUopen hfU.continuousOn hFcont ?_
    filter_upwards [hg₃] with z hz
    rw [hz]
    simp only [Pi.smul_apply', smul_eq_mul]
    congr 1
    rw [Function.FactorizedRational.finprod_eq_fun h₃f]
    show ∏ᶠ (u : ℂ), (z - u) ^ ((divisor f U) u) = _
    rw [finprod_eq_prod_of_mulSupport_subset _ (s := h₃f.toFinset) (fun u hu => by
      simp only [Function.mem_mulSupport] at hu
      simp only [Set.Finite.coe_toFinset, Function.mem_support]
      intro h
      exact hu (by rw [h]; simp))]
    refine Finset.prod_congr rfl fun u hu => ?_
    simp only [Set.Finite.mem_toFinset] at hu
    rw [hdiv u ((divisor f U).supportWithinDomain hu), zpow_natCast]
  · intro u hu
    simp only [Set.Finite.mem_toFinset, Function.mem_support] at hu
    have := hdiv u ((divisor f U).supportWithinDomain hu)
    intro hcon
    rw [hcon] at this
    exact hu (by simpa using this)
  · intro u hu hne0
    simp only [Set.Finite.mem_toFinset, Function.mem_support]
    rw [hdiv u hu]
    exact_mod_cast hne0

/-- **Factorization of the zeros on a disc**, the special case of
`exists_finset_factorization_of_isCompact` used by the argument principle. -/
theorem exists_finset_factorization {f : ℂ → ℂ} {c : ℂ} {R₁ : ℝ} (hR₁ : 0 < R₁)
    (hf : AnalyticOnNhd ℂ f (closedBall c R₁)) (hne : ∃ z ∈ ball c R₁, f z ≠ 0) :
    ∃ (s : Finset ℂ) (g : ℂ → ℂ), ↑s ⊆ ball c R₁ ∧ AnalyticOnNhd ℂ g (ball c R₁) ∧
      (∀ z ∈ ball c R₁, g z ≠ 0) ∧
      (∀ z ∈ ball c R₁, f z = (∏ u ∈ s, (z - u) ^ analyticOrderNatAt f u) * g z) ∧
      (∀ u ∈ s, analyticOrderNatAt f u ≠ 0) ∧
      (∀ u ∈ ball c R₁, analyticOrderNatAt f u ≠ 0 → u ∈ s) :=
  exists_finset_factorization_of_isCompact isOpen_ball (isConnected_ball hR₁)
    ball_subset_closedBall (isCompact_closedBall c R₁) hf hne

/-- The zeros of a function holomorphic on a neighbourhood of a closed disc, and not identically
zero there, form a finite set inside the open disc. -/
theorem finite_setOf_zeros {f : ℂ → ℂ} {c : ℂ} {R₁ : ℝ} (hR₁ : 0 < R₁)
    (hf : AnalyticOnNhd ℂ f (closedBall c R₁)) (hne : ∃ z ∈ ball c R₁, f z ≠ 0) :
    {u | u ∈ ball c R₁ ∧ f u = 0}.Finite := by
  obtain ⟨s, g, hs, hg₁, hg₂, hfac, hsz, hmem⟩ := exists_finset_factorization hR₁ hf hne
  refine Set.Finite.subset s.finite_toSet ?_
  rintro u ⟨hu, hfu⟩
  rw [hfac u hu] at hfu
  rcases mul_eq_zero.mp hfu with hprod | hgu
  · obtain ⟨v, hv, hv0⟩ := Finset.prod_eq_zero_iff.mp hprod
    have : u - v = 0 := by
      by_contra hcon
      exact absurd hv0 (pow_ne_zero _ hcon)
    rw [sub_eq_zero] at this
    exact this ▸ hv
  · exact absurd hgu (hg₂ u hu)

/-- A closed disc slightly larger than a given one still fits inside any thickening. -/
theorem closedBall_subset_thickening_closedBall {c : ℂ} {R δ : ℝ} (hR : 0 < R) (hδ : 0 < δ) :
    closedBall c (R + δ / 2) ⊆ thickening δ (closedBall c R) := by
  intro x hx
  rw [Metric.mem_thickening_iff]
  by_cases h : dist x c ≤ R
  · exact ⟨x, mem_closedBall.mpr h, by simpa using hδ⟩
  push_neg at h
  have hx0 : ‖x - c‖ ≠ 0 := by
    simp only [ne_eq, norm_eq_zero, sub_eq_zero]
    rintro rfl
    simp at h; linarith
  have hnorm : ‖x - c‖ = dist x c := by rw [dist_eq_norm]
  refine ⟨c + (R / ‖x - c‖ : ℝ) • (x - c), ?_, ?_⟩
  · simp only [mem_closedBall, dist_eq_norm, add_sub_cancel_left, norm_smul, Real.norm_eq_abs]
    rw [abs_of_nonneg (by positivity), div_mul_cancel₀ _ hx0]
  · have heq : x - (c + (R / ‖x - c‖ : ℝ) • (x - c)) = (1 - R / ‖x - c‖ : ℝ) • (x - c) := by
      rw [sub_smul, one_smul]; abel
    rw [dist_eq_norm, heq, norm_smul, Real.norm_eq_abs,
      abs_of_nonneg (by rw [sub_nonneg, div_le_one (by positivity), hnorm]; linarith),
      sub_mul, one_mul, div_mul_cancel₀ _ hx0, hnorm]
    have := mem_closedBall.mp hx
    linarith

/-! ## The argument principle -/

/-- **The argument principle on a disc.**  If `f` is holomorphic on a neighbourhood of the closed
disc `closedBall c R₁` and has no zero on the circle `sphere c R` (`R < R₁`), then the contour
integral of its logarithmic derivative over that circle counts the zeros of `f` inside, with
multiplicity. -/
theorem circleIntegral_logDeriv_eq_zeroCount {f : ℂ → ℂ} {c : ℂ} {R R₁ : ℝ} (hR : 0 < R)
    (hRR₁ : R < R₁) (hf : AnalyticOnNhd ℂ f (closedBall c R₁))
    (hbd : ∀ z ∈ sphere c R, f z ≠ 0) :
    (∮ z in C(c, R), logDeriv f z)
      = 2 * ↑π * I * ∑ᶠ u ∈ ball c R, (analyticOrderNatAt f u : ℂ) := by
  classical
  have hR₁ : 0 < R₁ := hR.trans hRR₁
  have hsph : sphere c R ⊆ ball c R₁ := fun z hz => by
    simp only [mem_sphere_iff_norm, mem_ball] at *
    simpa [dist_eq_norm, hz] using hRR₁
  have hcball : closedBall c R ⊆ ball c R₁ := fun z hz => by
    simp only [mem_closedBall, mem_ball] at *; linarith
  -- `f` is not identically zero: it does not vanish on the circle
  have hne : ∃ z ∈ ball c R₁, f z ≠ 0 := by
    refine ⟨c + R, hsph (by simp [mem_sphere_iff_norm, abs_of_pos hR]), ?_⟩
    exact hbd _ (by simp [mem_sphere_iff_norm, abs_of_pos hR])
  obtain ⟨s, g, hs, hg₁, hg₂, hfac, hsz, hmem⟩ := exists_finset_factorization hR₁ hf hne
  -- every point of `s` is a zero of `f`, hence off the circle
  have hsne : ∀ u ∈ s, u ∉ sphere c R := fun u hu hcon =>
    hbd u hcon (apply_eq_zero_of_analyticOrderNatAt_ne_zero (hsz u hu))
  -- the logarithmic derivative on the circle
  have hlog : ∀ z ∈ sphere c R, logDeriv f z
      = (∑ u ∈ s, (analyticOrderNatAt f u : ℂ) * (z - u)⁻¹) + logDeriv g z := by
    intro z hz
    have hzball : z ∈ ball c R₁ := hsph hz
    have heq : f =ᶠ[𝓝 z] fun w ↦ (∏ u ∈ s, (w - u) ^ analyticOrderNatAt f u) * g w := by
      filter_upwards [isOpen_ball.mem_nhds hzball] with w hw using hfac w hw
    rw [show logDeriv f z
        = logDeriv (fun w ↦ (∏ u ∈ s, (w - u) ^ analyticOrderNatAt f u) * g w) z by
      simp only [logDeriv_apply, heq.deriv_eq, heq.eq_of_nhds]]
    exact logDeriv_prod_pow_mul (fun u hu hcon => hsne u hu (hcon ▸ hz)) (hg₂ z hzball)
      (hg₁ z hzball).differentiableAt
  -- circle integrals only see the values on the circle
  have hcongr : ∀ {F G : ℂ → ℂ}, EqOn F G (sphere c R) →
      (∮ z in C(c,R), F z) = ∮ z in C(c,R), G z := by
    intro F G h
    simp only [circleIntegral]
    refine intervalIntegral.integral_congr fun θ _ => ?_
    have : circleMap c R θ ∈ sphere c R := by
      simp [abs_of_pos hR]
    simp [h this]
  -- integrability of the pieces
  have hint₁ : ∀ u ∈ s,
      CircleIntegrable (fun z ↦ (analyticOrderNatAt f u : ℂ) * (z - u)⁻¹) c R := by
    intro u hu
    refine ContinuousOn.circleIntegrable hR.le ?_
    apply ContinuousOn.mul continuousOn_const
    apply ContinuousOn.inv₀ (by fun_prop)
    intro z hz hcon
    rw [sub_eq_zero] at hcon
    exact hsne u hu (hcon ▸ hz)
  have hdg : ∀ z ∈ closedBall c R, DifferentiableAt ℂ (logDeriv g) z := by
    intro z hz
    have hz' : z ∈ ball c R₁ := hcball hz
    simp only [logDeriv]
    exact (((hg₁ z hz').deriv).div (hg₁ z hz') (hg₂ z hz')).differentiableAt
  have hint₂ : CircleIntegrable (logDeriv g) c R :=
    ContinuousOn.circleIntegrable hR.le fun z hz =>
      ((hdg z (sphere_subset_closedBall hz)).continuousAt).continuousWithinAt
  have hintS : CircleIntegrable (fun z ↦ ∑ u ∈ s, (analyticOrderNatAt f u : ℂ) * (z - u)⁻¹) c R :=
    CircleIntegrable.fun_sum s hint₁
  -- Cauchy's theorem kills the nonvanishing factor
  have hg0 : (∮ z in C(c,R), logDeriv g z) = 0 := by
    apply DiffContOnCl.circleIntegral_eq_zero hR.le
    constructor
    · exact fun z hz => (hdg z (ball_subset_closedBall hz)).differentiableWithinAt
    · rw [closure_ball _ hR.ne']
      exact fun z hz => (hdg z hz).continuousAt.continuousWithinAt
  rw [hcongr hlog, circleIntegral.integral_add hintS hint₂, hg0, add_zero,
    circleIntegral.integral_fun_sum hint₁]
  -- each simple pole contributes `2πi` times its multiplicity, and only if it lies inside
  have step1 : ∀ u ∈ s, (∮ z in C(c,R), (analyticOrderNatAt f u : ℂ) * (z - u)⁻¹)
      = if u ∈ ball c R then (analyticOrderNatAt f u : ℂ) * (2 * ↑π * I) else 0 := by
    intro u hu
    rw [circleIntegral.integral_const_mul]
    by_cases h : u ∈ ball c R
    · rw [if_pos h, circleIntegral.integral_sub_inv_of_mem_ball h]
    · rw [if_neg h, circleIntegral_sub_inv_of_notMem_closedBall hR.le (fun hcon => ?_), mul_zero]
      rcases lt_or_eq_of_le (mem_closedBall.mp hcon) with h' | h'
      · exact h (mem_ball.mpr h')
      · exact hsne u hu (by simp only [mem_sphere_iff_norm, ← dist_eq_norm]; exact h')
  rw [Finset.sum_congr rfl step1]
  have step2 : ∑ᶠ u ∈ ball c R, (analyticOrderNatAt f u : ℂ)
      = ∑ u ∈ s.filter (fun u => u ∈ ball c R), (analyticOrderNatAt f u : ℂ) := by
    refine finsum_mem_eq_sum_of_inter_support_eq _ ?_
    ext u
    simp only [Set.mem_inter_iff, Function.mem_support, ne_eq, Nat.cast_eq_zero,
      Finset.coe_filter, Set.mem_setOf_eq]
    constructor
    · rintro ⟨hu, hne'⟩
      exact ⟨⟨hmem u (ball_subset_ball hRR₁.le hu) hne', hu⟩, hne'⟩
    · rintro ⟨⟨_, hu⟩, hne'⟩
      exact ⟨hu, hne'⟩
  rw [step2, Finset.mul_sum, ← Finset.sum_filter]
  exact Finset.sum_congr rfl fun u hu => by ring

/-- **The argument principle on a disc, for an arbitrary holomorphic domain.**  Same statement as
`circleIntegral_logDeriv_eq_zeroCount`, with the hypothesis that `f` is holomorphic on an
arbitrary open set containing the closed disc. -/
theorem circleIntegral_logDeriv_eq_zeroCount_of_isOpen {f : ℂ → ℂ} {U : Set ℂ} {c : ℂ} {R : ℝ}
    (hR : 0 < R) (hU : IsOpen U) (hsub : closedBall c R ⊆ U) (hf : AnalyticOnNhd ℂ f U)
    (hbd : ∀ z ∈ sphere c R, f z ≠ 0) :
    (∮ z in C(c, R), logDeriv f z)
      = 2 * ↑π * I * ∑ᶠ u ∈ ball c R, (analyticOrderNatAt f u : ℂ) := by
  obtain ⟨δ, hδ, hδU⟩ := (isCompact_closedBall c R).exists_thickening_subset_open hU hsub
  refine circleIntegral_logDeriv_eq_zeroCount hR (R₁ := R + δ / 2) (by linarith)
    (hf.mono ?_) hbd
  exact (closedBall_subset_thickening_closedBall hR hδ).trans hδU

/-- **Counting simple zeros.**  If moreover every zero of `f` inside the disc is simple, the
contour integral of the logarithmic derivative is `2πi` times the *number* of zeros. -/
theorem circleIntegral_logDeriv_eq_card_of_simple {f : ℂ → ℂ} {c : ℂ} {R R₁ : ℝ} (hR : 0 < R)
    (hRR₁ : R < R₁) (hf : AnalyticOnNhd ℂ f (closedBall c R₁))
    (hbd : ∀ z ∈ sphere c R, f z ≠ 0)
    (hsimple : ∀ u ∈ ball c R, f u = 0 → analyticOrderNatAt f u = 1) :
    (∮ z in C(c, R), logDeriv f z)
      = 2 * ↑π * I * ({u | u ∈ ball c R ∧ f u = 0}.ncard : ℂ) := by
  classical
  have hR₁ : 0 < R₁ := hR.trans hRR₁
  have hball : ball c R ⊆ ball c R₁ := ball_subset_ball hRR₁.le
  have hne : ∃ z ∈ ball c R₁, f z ≠ 0 := by
    refine ⟨c + R, ?_, hbd _ (by simp [mem_sphere_iff_norm, abs_of_pos hR])⟩
    simp only [mem_ball, dist_eq_norm, add_sub_cancel_left]
    simpa [abs_of_pos hR] using hRR₁
  have hZfin : {u | u ∈ ball c R ∧ f u = 0}.Finite :=
    (finite_setOf_zeros hR₁ hf hne).subset (fun u hu => ⟨hball hu.1, hu.2⟩)
  rw [circleIntegral_logDeriv_eq_zeroCount hR hRR₁ hf hbd]
  congr 1
  have hsum : ∑ᶠ u ∈ ball c R, (analyticOrderNatAt f u : ℂ)
      = ∑ u ∈ hZfin.toFinset, (analyticOrderNatAt f u : ℂ) := by
    refine finsum_mem_eq_sum_of_inter_support_eq _ ?_
    ext u
    simp only [Set.mem_inter_iff, Function.mem_support, ne_eq, Nat.cast_eq_zero,
      Set.Finite.coe_toFinset, Set.mem_setOf_eq]
    constructor
    · rintro ⟨hu, hne'⟩
      exact ⟨⟨hu, apply_eq_zero_of_analyticOrderNatAt_ne_zero hne'⟩, hne'⟩
    · rintro ⟨⟨hu, _⟩, hne'⟩
      exact ⟨hu, hne'⟩
  rw [hsum, Set.ncard_eq_toFinset_card _ hZfin]
  rw [Finset.sum_congr rfl (g := fun _ => (1 : ℂ)) (fun u hu => ?_), Finset.sum_const,
    nsmul_eq_mul, mul_one]
  simp only [Set.Finite.mem_toFinset, Set.mem_setOf_eq] at hu
  rw [hsimple u hu.1 hu.2]
  norm_num

end ZetaZeros.Analysis
