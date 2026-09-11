/-
Copyright (c) 2026 Aristotle contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
-/
import Mathlib.NumberTheory.LSeries.Nonvanishing
import Mathlib.NumberTheory.Harmonic.ZetaAsymp
import Mathlib.Analysis.Analytic.Order
import Mathlib.Analysis.Analytic.IsolatedZeros
import Mathlib.Analysis.SpecialFunctions.Complex.Analytic
import Mathlib.MeasureTheory.Integral.IntervalIntegral.Basic
import Mathlib.MeasureTheory.Integral.Bochner.ContinuousLinearMap

/-!
# Backports

This file provides, for the Lean/Mathlib version used by this project, a handful of results
about the Riemann zeta function which are available in later versions of Mathlib:

* `riemannZeta_conj`, the conjugation symmetry `ζ (conj s) = conj (ζ s)`;
* `analyticOn_riemannZeta`, analyticity of `ζ` away from `s = 1`;
* `riemannZetaZeros` and the finiteness of the zeros of `ζ` in a compact set.

The proofs are those of `Mathlib.NumberTheory.Harmonic.ZetaAsymp` and
`Mathlib.NumberTheory.LSeries.ZetaZeros` (Apache 2.0 licensed, authors Huanyu Zheng and the
Mathlib contributors), adapted where the intervening Mathlib API changed.
-/

open Complex Filter Asymptotics Set
open scoped ComplexConjugate Topology

/-- If `f` is complex differentiable at `conj z`, then `z ↦ conj (f (conj z))` is complex
differentiable at `z`, with the conjugate derivative. -/
theorem hasDerivAt_conj_conj {f : ℂ → ℂ} {z w : ℂ} (h : HasDerivAt f w (conj z)) :
    HasDerivAt (fun x => conj (f (conj x))) (conj w) z := by
  rw [hasDerivAt_iff_isLittleO] at h ⊢
  have hcont : Tendsto (fun x : ℂ => conj x) (𝓝 z) (𝓝 (conj z)) :=
    Complex.continuous_conj.tendsto z
  have h2 := h.comp_tendsto hcont
  rw [isLittleO_iff] at h2 ⊢
  intro c hc
  filter_upwards [h2 hc] with x hx
  have e1 : ‖conj (f (conj x)) - conj (f (conj z)) - (x - z) • conj w‖
      = ‖f (conj x) - f (conj z) - (conj x - conj z) • w‖ := by
    rw [← Complex.norm_conj]
    congr 1
    simp [smul_eq_mul]
  have e2 : ‖x - z‖ = ‖conj x - conj z‖ := by
    rw [← map_sub, Complex.norm_conj]
  rw [e1, e2]
  exact hx

theorem differentiableAt_conj_conj {f : ℂ → ℂ} {z : ℂ} (h : DifferentiableAt ℂ f (conj z)) :
    DifferentiableAt ℂ (fun x => conj (f (conj x))) z :=
  (hasDerivAt_conj_conj h.hasDerivAt).differentiableAt

/-- The Riemann zeta function is differentiable away from `s = 1`. -/
theorem differentiableOn_riemannZeta : DifferentiableOn ℂ riemannZeta {1}ᶜ :=
  fun _ hs => (differentiableAt_riemannZeta hs).differentiableWithinAt

/-- The Riemann zeta function is analytic away from `s = 1`. -/
theorem analyticOn_riemannZeta : AnalyticOnNhd ℂ riemannZeta {1}ᶜ :=
  differentiableOn_riemannZeta.analyticOnNhd isOpen_compl_singleton

/-- **Conjugation symmetry of the Riemann zeta function**: `ζ (conj s) = conj (ζ s)`. -/
@[simp]
theorem riemannZeta_conj (s : ℂ) : riemannZeta (conj s) = conj (riemannZeta s) := by
  rcases eq_or_ne s 1 with rfl | hs
  · have h : riemannZeta 1 = ((Real.eulerMascheroniConstant - Real.log (4 * Real.pi)) / 2 : ℝ) := by
      rw [riemannZeta_one, ofReal_div, ofReal_sub,
        ofReal_log (by positivity : (0 : ℝ) ≤ 4 * Real.pi)]
      norm_cast
    rw [map_one, h, conj_ofReal]
  · have hg_an : AnalyticOnNhd ℂ (fun z => conj (riemannZeta (conj z))) {1}ᶜ := by
      refine DifferentiableOn.analyticOnNhd (fun z hz => ?_) isOpen_compl_singleton
      refine DifferentiableAt.differentiableWithinAt ?_
      refine differentiableAt_conj_conj (differentiableAt_riemannZeta ?_)
      simpa using (map_ne_one_iff (starRingEnd ℂ) (starRingEnd ℂ).injective).mpr hz
    have hgz : ∀ z : ℂ, 1 < z.re → conj (riemannZeta (conj z)) = riemannZeta z := by
      intro z hz
      rw [zeta_eq_tsum_one_div_nat_cpow (by rwa [conj_re]), conj_tsum,
        zeta_eq_tsum_one_div_nat_cpow hz]
      refine tsum_congr fun n => ?_
      rw [map_div₀, map_one, ← conj_cpow _ _ (by rw [natCast_arg]; positivity), conj_natCast]
    have heq : EqOn (fun z => conj (riemannZeta (conj z))) riemannZeta {1}ᶜ :=
      hg_an.eqOn_of_preconnected_of_eventuallyEq analyticOn_riemannZeta
        (isConnected_compl_singleton_of_one_lt_rank (by simp) 1).isPreconnected
        (by norm_num : (2 : ℂ) ∈ _)
        (eventuallyEq_of_mem
          ((isOpen_lt continuous_const continuous_re).mem_nhds (by norm_num)) hgz)
    simpa using congrArg (starRingEnd ℂ) (heq hs)

theorem riemannZeta_eventually_ne_zero_nhds_one : ∀ᶠ s in 𝓝 1, riemannZeta s ≠ 0 := by
  have h := eventually_nhdsWithin_iff.1 <| riemannZeta_residue_one.eventually_ne one_ne_zero
  filter_upwards [h] with s hs
  rcases eq_or_ne s 1 with rfl | hne
  · exact riemannZeta_one_ne_zero
  · intro hzero
    exact (hs hne) (by rw [hzero, mul_zero])

/-- The zeros of Riemann's ζ-function. -/
noncomputable def riemannZetaZeros : Set ℂ := riemannZeta ⁻¹' {0}

theorem mem_riemannZetaZeros {z : ℂ} : z ∈ riemannZetaZeros ↔ riemannZeta z = 0 := Iff.rfl

private theorem riemannZetaZeros_codiscreteWithin_compl_one :
    riemannZetaZerosᶜ ∈ Filter.codiscreteWithin {1}ᶜ := by
  refine analyticOn_riemannZeta.preimage_zero_mem_codiscreteWithin (x := 2) ?_ (by simp) ?_
  · exact riemannZeta_ne_zero_of_one_le_re Nat.one_le_ofNat
  · exact isConnected_compl_singleton_of_one_lt_rank (by simp) 1

private theorem compl_riemannZetaZeros_mem_codiscrete :
    riemannZetaZerosᶜ ∈ Filter.codiscrete ℂ := by
  have h := riemannZetaZeros_codiscreteWithin_compl_one
  simp only [mem_codiscreteWithin, Set.mem_compl_iff, Set.mem_singleton_iff, sdiff_compl,
    Set.inf_eq_inter, Filter.disjoint_principal_right, mem_codiscrete, compl_compl] at h ⊢
  intro x
  rcases eq_or_ne x 1 with rfl | hx
  · exact riemannZeta_eventually_ne_zero_nhds_one.filter_mono nhdsWithin_le_nhds
  · refine Filter.mem_of_superset (h x hx) fun y hy hmem => hy ⟨?_, hmem⟩
    intro hy1
    rw [Set.mem_singleton_iff] at hy1
    subst hy1
    exact riemannZeta_one_ne_zero hmem

theorem isClosed_riemannZetaZeros : IsClosed riemannZetaZeros := by
  simpa using (mem_codiscrete'.mp compl_riemannZetaZeros_mem_codiscrete).1

theorem isDiscrete_riemannZetaZeros : IsDiscrete riemannZetaZeros := by
  simpa using (mem_codiscrete'.mp compl_riemannZetaZeros_mem_codiscrete).2

/-- Any compact subset of `ℂ` contains only finitely many zeros of the Riemann zeta function. -/
theorem IsCompact.inter_riemannZetaZeros_finite {S : Set ℂ} (hS : IsCompact S) :
    (S ∩ riemannZetaZeros).Finite := by
  apply (hS.inter_right isClosed_riemannZetaZeros).finite
  exact isDiscrete_riemannZetaZeros.mono Set.inter_subset_right

/-- Conjugation commutes with the interval integral. -/
theorem intervalIntegral_conj {f : ℝ → ℂ} {a b : ℝ} :
    ∫ x in a..b, conj (f x) = conj (∫ x in a..b, f x) := by
  simp only [intervalIntegral, map_sub, integral_conj]

/-- The topological support of a derivative is contained in that of the function. -/
theorem tsupport_deriv_subset {F : Type*} [NormedAddCommGroup F] [NormedSpace ℝ F]
    {f : ℝ → F} : tsupport (deriv f) ⊆ tsupport f :=
  closure_minimal support_deriv_subset isClosed_closure

open Module in
/-- The target of a surjective linear map from a finite module has at most its rank. -/
theorem LinearMap.finrank_le_finrank_of_surjective {R : Type*} {M N : Type*} [Ring R]
    [StrongRankCondition R] [AddCommGroup M] [Module R M] [AddCommGroup N] [Module R N]
    [Module.Finite R M] {f : M →ₗ[R] N} (hf : Function.Surjective f) :
    finrank R N ≤ finrank R M := by
  have h1 : Cardinal.lift.{_, _} (Module.rank R N) ≤ Cardinal.lift.{_, _} (Module.rank R M) :=
    f.lift_rank_le_of_surjective hf
  have h2 : Module.rank R M < Cardinal.aleph0 := Module.rank_lt_aleph0 R M
  have h3 : Cardinal.toNat (Cardinal.lift.{_, _} (Module.rank R N))
      ≤ Cardinal.toNat (Cardinal.lift.{_, _} (Module.rank R M)) :=
    Cardinal.toNat_le_toNat h1 (Cardinal.lift_lt_aleph0.2 h2)
  simpa [finrank] using h3
