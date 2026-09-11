/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The near-diagonal semi-local kernel, and the two missing estimates.**

`RequestProject/SemiLocalDiagonal.lean` isolates the diagonal value

  `d(Λ) = κ_Λ(1) = Tr(S^{(Λ)}) = ‖B_Λ‖²_{HS}`,   `S^{(Λ)} = P^{(Λ)} P̂^{(Λ)} P^{(Λ)}`,
  `B_Λ = P̂^{(Λ)} P^{(Λ)}`,

of the semi-local kernel `κ_Λ(λ) = Tr(ϑ(λ) S^{(Λ)})`, proves that it diverges, and proves
the *lower* bound on its divergence rate.  The matching *upper* bound
`d(Λ) ≤ 2 log Λ + C` is still missing.  This file prepares the ground for it, on the
operator-theoretic side only — no Fourier analysis is used or needed here.

Three groups of results.

* **The kernel in near-diagonal form.**  The two-variable kernel
  `K_Λ(μ, ν) = κ_Λ(μ⁻¹ν)` (`semiLocalKernel`) is the shape in which a short-distance
  expansion is usually written; it is invariant under the diagonal action of `ℝ⋆₊`
  (`semiLocalKernel_smul`), Hermitian (`semiLocalKernel_conj_symm`), maximal on the diagonal
  (`norm_semiLocalKernel_le_diag`), and its diagonal value is `d(Λ)`
  (`semiLocalKernel_diag`).  The *near-diagonal defect*

    `ε_Λ(λ) := d(Λ) - Re κ_Λ(λ) ≥ 0`   (`kernelDefect`, `kernelDefect_nonneg`)

  vanishes at `λ = 1` (`kernelDefect_one`), is symmetric under `λ ↦ λ⁻¹`
  (`kernelDefect_inv`), is continuous, and is exactly what a short-distance expansion of
  the kernel has to control.  The Hilbert–Schmidt mechanism behind such an expansion is
  proved here in full:

    `ε_Λ(λ) ≤ ∑ᵢ ‖B_Λ^* eᵢ‖ · ‖(1 - ϑ(λ)) B_Λ^* eᵢ‖`   (`kernelDefect_le_tsum`),

  i.e. the modulus of continuity of `κ_Λ` at the diagonal is governed by the modulus of
  continuity of translation on the Hilbert–Schmidt operator `B_Λ^*`.

* **The two missing estimates, stated precisely.**  Both are `Prop`s (hypotheses), never
  axioms, and neither is proved:

  1. `DiagLogUpperBound U b C` : `d(Λ) ≤ 2 log Λ + C` for all large `Λ`;
     `HasDiagLogUpperBound U b` : such a `C` exists.
  2. `ShortDistanceModulus U b M` : `ε_Λ(λ) ≤ M Λ · |log λ|` for all `Λ ≥ 1` and all `λ`,
     a Lipschitz modulus of continuity at the diagonal in the invariant distance
     `|log λ|` (`Rplus.logSize`), with a scale-dependent constant `M Λ`;
     `HasShortDistanceModulus U b` : such an `M` exists.

  Proved about them: the upper bound follows from the conjectural diagonal asymptotics
  (`HasDiagLogAsymptotics.diagLogUpperBound`); together with a matching lower bound it
  pins the divergence rate, `d(Λ)/log Λ → 2` (`tendsto_diagDensity_div_log_of_bounds`);
  and it bounds the whole cut-off trace, `|Tr(ϑ(f) S^{(Λ)})| ≤ ‖f‖_{L¹}(2 log Λ + C)`
  (`eventually_norm_cutTrace_le_of_diagLogUpperBound`).

* **The elementary averaging inequality**, proved outright with the existing
  Hilbert–Schmidt/trace machinery.  For a nonnegative real test function `g`,

    `Re Tr(ϑ(g) S^{(Λ)}) = ‖g‖_{L¹} · d(Λ) - ∫ g(λ) ε_Λ(λ) d*λ`
    (`re_cutTrace_eq_diagDensity_sub_integral_defect`),

  hence, if `ε_Λ ≤ w` on the support of `g` and `‖g‖_{L¹} = 1`,

    `d(Λ) ≤ Re Tr(ϑ(g) S^{(Λ)}) + w`   (`diagDensity_le_re_cutTrace_add`).

  This is the reduction of the missing upper bound to a bound on a single averaged trace
  plus a short-distance bound (`diagLogUpperBound_of_modulus_of_traceBound`).  See the
  discussion at the end of the file for the exact analytic input that is still required.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SemiLocalDiagonal

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory ContinuousLinearMap Filter Topology

open scoped CompactlySupported ENNReal

namespace ConnesConsani.WeilPositivity

/-! ## The invariant distance to the diagonal -/

namespace Rplus

/-- The invariant distance from `λ` to the unit of `ℝ⋆₊`, `|log λ|`.  In the logarithmic
coordinates in which `ϑ` is the translation representation this is the ordinary distance
to the origin. -/
def logSize (lam : Rplus) : ℝ := |Real.log (lam : ℝ)|

theorem logSize_nonneg (lam : Rplus) : 0 ≤ logSize lam := abs_nonneg _

@[simp] theorem logSize_one : logSize 1 = 0 := by
  simp [logSize]

@[simp] theorem logSize_inv (lam : Rplus) : logSize lam⁻¹ = logSize lam := by
  have h : ((lam⁻¹ : Rplus) : ℝ) = (lam : ℝ)⁻¹ := rfl
  rw [logSize, logSize, h, Real.log_inv, abs_neg]

theorem logSize_eq_zero_iff (lam : Rplus) : logSize lam = 0 ↔ lam = 1 := by
  constructor
  · intro h
    have hlog : Real.log (lam : ℝ) = 0 := abs_eq_zero.1 h
    have : (lam : ℝ) = 1 := by
      have := Real.exp_log lam.2
      rw [hlog] at this
      simpa using this.symm
    exact Subtype.ext this
  · rintro rfl; simp

end Rplus

variable {ι : Type*} (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

/-! ## The two-variable near-diagonal kernel -/

/-- **The two-variable semi-local kernel** `K_Λ(μ, ν) = κ_Λ(μ⁻¹ν) = Tr(ϑ(μ⁻¹ν) S^{(Λ)})`.
This is the form in which the short-distance expansion of the kernel is written: `K_Λ`
depends only on the invariant `μ⁻¹ν`, and the whole logarithmic divergence sits at
`μ = ν`. -/
def semiLocalKernel (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (mu nu : Rplus) : ℂ :=
  traceDensityCut U b cut (mu⁻¹ * nu)

theorem semiLocalKernel_eq (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (mu nu : Rplus) :
    semiLocalKernel U b cut mu nu = traceDensityCut U b cut (mu⁻¹ * nu) := rfl

/-- The kernel depends only on the ratio: it is invariant under the diagonal action of
`ℝ⋆₊`. -/
theorem semiLocalKernel_smul (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (a mu nu : Rplus) :
    semiLocalKernel U b cut (a * mu) (a * nu) = semiLocalKernel U b cut mu nu := by
  have h : (a * mu)⁻¹ * (a * nu) = mu⁻¹ * nu := by
    rw [mul_inv, mul_comm a⁻¹ mu⁻¹, mul_assoc, ← mul_assoc a⁻¹ a nu, inv_mul_cancel, one_mul]
  rw [semiLocalKernel, semiLocalKernel, h]

/-- On the diagonal the kernel is the diagonal density `d(Λ)`. -/
theorem semiLocalKernel_diag (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (mu : Rplus) :
    semiLocalKernel U b cut mu mu = (diagDensity U b cut : ℂ) := by
  have h : mu⁻¹ * mu = (1 : Rplus) := inv_mul_cancel mu
  rw [semiLocalKernel, h, traceDensityCut_one_eq_ofReal, diagDensity, re_traceDensityCut_one]

/-- The kernel is Hermitian: `K_Λ(ν, μ) = conj K_Λ(μ, ν)`. -/
theorem semiLocalKernel_conj_symm (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (mu nu : Rplus) :
    semiLocalKernel U b cut nu mu = starRingEnd ℂ (semiLocalKernel U b cut mu nu) := by
  rw [semiLocalKernel, semiLocalKernel, conj_traceDensityCut]
  congr 1
  simp [mul_inv_rev]

/-- The kernel is maximal on the diagonal: `|K_Λ(μ, ν)| ≤ d(Λ)`. -/
theorem norm_semiLocalKernel_le_diag (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (mu nu : Rplus) :
    ‖semiLocalKernel U b cut mu nu‖ ≤ diagDensity U b cut :=
  norm_traceDensityCut_le_diagDensity U b cut _

/-- The kernel is continuous in each variable. -/
theorem continuous_semiLocalKernel (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (mu : Rplus) :
    Continuous fun nu : Rplus => semiLocalKernel U b cut mu nu :=
  (continuous_traceDensityCut U b cut).comp (continuous_const.mul continuous_id)

/-! ## The near-diagonal defect -/

/-- **The near-diagonal defect** `ε_Λ(λ) = d(Λ) - Re κ_Λ(λ)`: the drop of the semi-local
kernel off the diagonal.  A short-distance expansion of the kernel is exactly a bound on
this quantity in terms of the invariant distance `|log λ|`. -/
def kernelDefect (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) : ℝ :=
  diagDensity U b cut - (traceDensityCut U b cut lam).re

theorem re_traceDensityCut_eq (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    (traceDensityCut U b cut lam).re = diagDensity U b cut - kernelDefect U b cut lam := by
  rw [kernelDefect]; ring

/-- The defect is nonnegative: the kernel is maximal on the diagonal. -/
theorem kernelDefect_nonneg (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    0 ≤ kernelDefect U b cut lam := by
  have h : (traceDensityCut U b cut lam).re ≤ ‖traceDensityCut U b cut lam‖ :=
    Complex.re_le_norm _
  have h' := norm_traceDensityCut_le_diagDensity U b cut lam
  rw [kernelDefect]
  linarith

/-- The defect vanishes on the diagonal. -/
@[simp] theorem kernelDefect_one (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    kernelDefect U b cut 1 = 0 := by
  rw [kernelDefect, diagDensity]; ring

/-- The defect is symmetric under `λ ↦ λ⁻¹`. -/
theorem kernelDefect_inv (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    kernelDefect U b cut lam⁻¹ = kernelDefect U b cut lam := by
  rw [kernelDefect, kernelDefect, ← conj_traceDensityCut]
  simp

/-- The defect is at most twice the diagonal density. -/
theorem kernelDefect_le_two_mul (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    kernelDefect U b cut lam ≤ 2 * diagDensity U b cut := by
  have h' := norm_traceDensityCut_le_diagDensity U b cut lam
  have h2 : |(traceDensityCut U b cut lam).re| ≤ diagDensity U b cut :=
    (Complex.abs_re_le_norm _).trans h'
  rw [kernelDefect]
  linarith [(abs_le.1 h2).1]

theorem continuous_kernelDefect (b : HilbertBasis ι ℂ L2R) (cut : ℝ) :
    Continuous fun lam : Rplus => kernelDefect U b cut lam :=
  continuous_const.sub (Complex.continuous_re.comp (continuous_traceDensityCut U b cut))

/-- **The Hilbert–Schmidt mechanism for a short-distance bound.**  The near-diagonal defect
is controlled by the modulus of continuity of the translation representation on the
Hilbert–Schmidt operator `B_Λ^* = P^{(Λ)} P̂^{(Λ)}`:

  `ε_Λ(λ) ≤ ∑ᵢ ‖B_Λ^* eᵢ‖ · ‖B_Λ^* eᵢ - ϑ(λ) B_Λ^* eᵢ‖`.

Any bound on `‖(1 - ϑ(λ)) B_Λ^*‖_{HS}` of order `|log λ|` therefore yields a
`ShortDistanceModulus`. -/
theorem kernelDefect_le_tsum (b : HilbertBasis ι ℂ L2R) (cut : ℝ) (lam : Rplus) :
    kernelDefect U b cut lam
      ≤ ∑' i, ‖soninHalfCut cut (b i)‖ *
          ‖soninHalfCut cut (b i) - thetaUnitOf U lam (soninHalfCut cut (b i))‖ := by
  set v : ι → L2R := fun i => soninHalfCut cut (b i) with hv
  have hsq : Summable fun i => ‖v i‖ ^ 2 :=
    (isHilbertSchmidt_soninHalfCut b cut).summable_norm_sq
  have hinner : Summable fun i => (inner ℂ (v i) (thetaUnitOf U lam (v i)) : ℂ) :=
    summable_inner_thetaUnitOf_soninHalfCut U b cut lam
  have hre : Summable fun i => (inner ℂ (v i) (thetaUnitOf U lam (v i)) : ℂ).re :=
    hinner.map (Complex.reAddGroupHom) Complex.continuous_re
  -- the majorant is summable
  have hmaj : Summable fun i => ‖v i‖ * ‖v i - thetaUnitOf U lam (v i)‖ := by
    refine Summable.of_nonneg_of_le (fun i => by positivity) (fun i => ?_) (hsq.mul_left 2)
    have h1 : ‖v i - thetaUnitOf U lam (v i)‖ ≤ 2 * ‖v i‖ := by
      calc ‖v i - thetaUnitOf U lam (v i)‖ ≤ ‖v i‖ + ‖thetaUnitOf U lam (v i)‖ :=
            norm_sub_le _ _
        _ = 2 * ‖v i‖ := by rw [norm_thetaUnitOf_apply]; ring
    calc ‖v i‖ * ‖v i - thetaUnitOf U lam (v i)‖ ≤ ‖v i‖ * (2 * ‖v i‖) := by
          exact mul_le_mul_of_nonneg_left h1 (norm_nonneg _)
      _ = 2 * ‖v i‖ ^ 2 := by ring
  -- the defect is the sum of the termwise defects
  have hdefect : kernelDefect U b cut lam
      = ∑' i, (‖v i‖ ^ 2 - (inner ℂ (v i) (thetaUnitOf U lam (v i)) : ℂ).re) := by
    rw [kernelDefect, diagDensity, re_traceDensityCut_one, traceDensityCut_eq_tsum,
      Complex.re_tsum hinner, ← hsq.tsum_sub hre]
  rw [hdefect]
  refine Summable.tsum_le_tsum (fun i => ?_) (hsq.sub hre) hmaj
  have hexp : ‖v i‖ ^ 2 - (inner ℂ (v i) (thetaUnitOf U lam (v i)) : ℂ).re
      = (inner ℂ (v i) (v i - thetaUnitOf U lam (v i)) : ℂ).re := by
    rw [inner_sub_right, Complex.sub_re, inner_self_eq_norm_sq_to_K]
    simp [pow_two, Complex.mul_re]
  rw [hexp]
  calc (inner ℂ (v i) (v i - thetaUnitOf U lam (v i)) : ℂ).re
      ≤ ‖(inner ℂ (v i) (v i - thetaUnitOf U lam (v i)) : ℂ)‖ := Complex.re_le_norm _
    _ ≤ ‖v i‖ * ‖v i - thetaUnitOf U lam (v i)‖ := norm_inner_le_norm _ _

/-! ## The two missing estimates -/

/-- **Missing estimate 1: the logarithmic upper bound on the diagonal density.**

  `d(Λ) ≤ 2 log Λ + C`   for all large `Λ`.

This is the exact counterpart of the lower bound already proved in
`RequestProject/SemiLocalDiagonal.lean`
(`eventually_diagDensity_lower_bound`).  It is a `Prop`, not an axiom, and it is not
proved here. -/
def DiagLogUpperBound (b : HilbertBasis ι ℂ L2R) (C : ℝ) : Prop :=
  ∀ᶠ cut : ℝ in atTop, diagDensity U b cut ≤ 2 * Real.log cut + C

/-- The existential form of the missing upper bound: `d(Λ) = 2 log Λ + O(1)` from above. -/
def HasDiagLogUpperBound (b : HilbertBasis ι ℂ L2R) : Prop :=
  ∃ C : ℝ, DiagLogUpperBound U b C

/-- **Missing estimate 2: a short-distance (modulus of continuity) bound for the
semi-local kernel at the diagonal.**

  `ε_Λ(λ) = d(Λ) - Re κ_Λ(λ) ≤ M Λ · |log λ|`   for `Λ ≥ 1` and all `λ ∈ ℝ⋆₊`,

a Lipschitz bound in the invariant distance `|log λ|` with a scale-dependent constant
`M Λ`.  By `kernelDefect_le_tsum` it suffices to bound
`‖(1 - ϑ(λ)) B_Λ^*‖_{HS}` by `(M Λ / ‖B_Λ‖_{HS}) |log λ|`.  It is a `Prop`, not an axiom,
and it is not proved here. -/
def ShortDistanceModulus (b : HilbertBasis ι ℂ L2R) (M : ℝ → ℝ) : Prop :=
  ∀ cut : ℝ, 1 ≤ cut → ∀ lam : Rplus,
    kernelDefect U b cut lam ≤ M cut * Rplus.logSize lam

/-- The existential form of the missing short-distance bound. -/
def HasShortDistanceModulus (b : HilbertBasis ι ℂ L2R) : Prop :=
  ∃ M : ℝ → ℝ, ShortDistanceModulus U b M

/-- A short-distance modulus is automatically nonnegative wherever it is tested at a
non-diagonal point. -/
theorem ShortDistanceModulus.nonneg_of_ne_one {b : HilbertBasis ι ℂ L2R} {M : ℝ → ℝ}
    (h : ShortDistanceModulus U b M) {cut : ℝ} (hcut : 1 ≤ cut) {lam : Rplus}
    (hlam : lam ≠ 1) : 0 ≤ M cut := by
  have hpos : 0 < Rplus.logSize lam :=
    lt_of_le_of_ne (Rplus.logSize_nonneg lam) fun hzero =>
      hlam ((Rplus.logSize_eq_zero_iff lam).1 hzero.symm)
  have h1 := (kernelDefect_nonneg U b cut lam).trans (h cut hcut lam)
  nlinarith

/-- The conjectural diagonal asymptotics implies the missing upper bound. -/
theorem HasDiagLogAsymptotics.diagLogUpperBound {b : HilbertBasis ι ℂ L2R} {c : ℝ}
    (h : HasDiagLogAsymptotics U b c) : DiagLogUpperBound U b (c + 1) := by
  have h' : ∀ᶠ cut : ℝ in atTop, ‖(diagDensity U b cut - 2 * Real.log cut) - c‖ ≤ 1 := by
    have := h.eventually (Metric.closedBall_mem_nhds c zero_lt_one)
    filter_upwards [this] with cut hcut
    rw [← dist_eq_norm]
    exact hcut
  filter_upwards [h'] with cut hcut
  have := (abs_le.1 (by simpa [Real.norm_eq_abs] using hcut)).2
  linarith

/-- **The upper bound pins the divergence rate.**  If the diagonal density is trapped
between `2 log Λ - C₁` and `2 log Λ + C₂`, then `d(Λ)/log Λ → 2`. -/
theorem tendsto_diagDensity_div_log_of_bounds {b : HilbertBasis ι ℂ L2R} {C₁ C₂ : ℝ}
    (hl : ∀ᶠ cut : ℝ in atTop, 2 * Real.log cut - C₁ ≤ diagDensity U b cut)
    (hu : DiagLogUpperBound U b C₂) :
    Tendsto (fun cut : ℝ => diagDensity U b cut / Real.log cut) atTop (𝓝 2) := by
  have hinv : Tendsto (fun cut : ℝ => (Real.log cut)⁻¹) atTop (𝓝 0) :=
    Real.tendsto_log_atTop.inv_tendsto_atTop
  have hlow : Tendsto (fun cut : ℝ => 2 - C₁ * (Real.log cut)⁻¹) atTop (𝓝 2) := by
    simpa using tendsto_const_nhds.sub (hinv.const_mul C₁)
  have hhigh : Tendsto (fun cut : ℝ => 2 + C₂ * (Real.log cut)⁻¹) atTop (𝓝 2) := by
    simpa using tendsto_const_nhds.add (hinv.const_mul C₂)
  refine tendsto_of_tendsto_of_tendsto_of_le_of_le' hlow hhigh ?_ ?_
  · filter_upwards [hl, Real.tendsto_log_atTop.eventually_gt_atTop 0] with cut hcut hpos
    rw [le_div_iff₀ hpos]
    have : C₁ * (Real.log cut)⁻¹ * Real.log cut = C₁ := by field_simp
    nlinarith
  · filter_upwards [hu, Real.tendsto_log_atTop.eventually_gt_atTop 0] with cut hcut hpos
    rw [div_le_iff₀ hpos]
    have : C₂ * (Real.log cut)⁻¹ * Real.log cut = C₂ := by field_simp
    nlinarith

/-- The missing upper bound would bound the whole cut-off trace:
`|Tr(ϑ(f) S^{(Λ)})| ≤ ‖f‖_{L¹}(2 log Λ + C)` for all large `Λ`. -/
theorem eventually_norm_cutTrace_le_of_diagLogUpperBound [Countable ι]
    {b : HilbertBasis ι ℂ L2R} {C : ℝ} (h : DiagLogUpperBound U b C) (g : C_c(Rplus, ℂ)) :
    ∀ᶠ cut : ℝ in atTop,
      ‖cutTrace b U cut g‖ ≤ l1Norm g * (2 * Real.log cut + C) := by
  filter_upwards [h] with cut hcut
  refine (norm_cutTrace_le_l1Norm_mul_diagDensity U b cut g).trans ?_
  exact mul_le_mul_of_nonneg_left hcut (l1Norm_nonneg g)

/-! ## The elementary averaging inequality -/

section Averaging

variable {b : HilbertBasis ι ℂ L2R} (cut : ℝ) (g : C_c(Rplus, ℂ))

/-- A nonnegative real test function: `g(λ) ∈ ℝ` and `g(λ) ≥ 0`. -/
structure IsNonnegReal (g : C_c(Rplus, ℂ)) : Prop where
  real : ∀ lam : Rplus, ((g lam).re : ℂ) = g lam
  nonneg : ∀ lam : Rplus, 0 ≤ (g lam).re

theorem IsNonnegReal.norm_eq (hg : IsNonnegReal g) (lam : Rplus) : ‖g lam‖ = (g lam).re := by
  conv_lhs => rw [← hg.real lam]
  rw [Complex.norm_real, Real.norm_eq_abs, abs_of_nonneg (hg.nonneg lam)]

theorem IsNonnegReal.im_eq_zero (hg : IsNonnegReal g) (lam : Rplus) : (g lam).im = 0 := by
  have h := congrArg Complex.im (hg.real lam)
  simpa using h.symm

theorem IsNonnegReal.integrable_re (hg : IsNonnegReal g) :
    Integrable (fun lam : Rplus => (g lam).re) Rplus.haar :=
  (integrable_norm g).congr (.of_forall fun lam => hg.norm_eq g lam)

theorem IsNonnegReal.integral_re (hg : IsNonnegReal g) :
    ∫ lam, (g lam).re ∂(Rplus.haar) = l1Norm g := by
  rw [l1Norm]
  exact (integral_congr_ae (.of_forall fun lam => (hg.norm_eq g lam).symm))

theorem integrable_re_mul_traceDensityCut :
    Integrable (fun lam : Rplus => (g lam).re * (traceDensityCut U b cut lam).re)
      Rplus.haar := by
  have hcont : Continuous fun lam : Rplus =>
      (g lam).re * (traceDensityCut U b cut lam).re :=
    (Complex.continuous_re.comp (map_continuous g)).mul
      (Complex.continuous_re.comp (continuous_traceDensityCut U b cut))
  refine hcont.integrable_of_hasCompactSupport ?_
  refine HasCompactSupport.mul_right ?_
  exact (g.hasCompactSupport.comp_left (g := Complex.re) rfl)

theorem integrable_re_mul_kernelDefect :
    Integrable (fun lam : Rplus => (g lam).re * kernelDefect U b cut lam) Rplus.haar := by
  have hcont : Continuous fun lam : Rplus => (g lam).re * kernelDefect U b cut lam :=
    (Complex.continuous_re.comp (map_continuous g)).mul (continuous_kernelDefect U b cut)
  refine hcont.integrable_of_hasCompactSupport ?_
  refine HasCompactSupport.mul_right ?_
  exact (g.hasCompactSupport.comp_left (g := Complex.re) rfl)

/-- The real part of the cut-off trace of a nonnegative real test function is the average
of the real part of the kernel against `g`. -/
theorem re_cutTrace_eq_integral [Countable ι] (hg : IsNonnegReal g) :
    (cutTrace b U cut g).re
      = ∫ lam, (g lam).re * (traceDensityCut U b cut lam).re ∂(Rplus.haar) := by
  have hint : Integrable (fun lam : Rplus => g lam * traceDensityCut U b cut lam)
      Rplus.haar := by
    have hcont : Continuous fun lam : Rplus => g lam * traceDensityCut U b cut lam :=
      (map_continuous g).mul (continuous_traceDensityCut U b cut)
    exact hcont.integrable_of_hasCompactSupport (g.hasCompactSupport.mul_right)
  have hri := integral_re hint
  simp only [RCLike.re_to_complex] at hri
  rw [cutTrace_eq_integral U b cut g, ← hri]
  refine integral_congr_ae (.of_forall fun lam => ?_)
  show (g lam * traceDensityCut U b cut lam).re = (g lam).re * (traceDensityCut U b cut lam).re
  rw [Complex.mul_re, hg.im_eq_zero g lam]
  ring

/-- **The averaging identity**: for a nonnegative real test function `g`,

  `Re Tr(ϑ(g) S^{(Λ)}) = ‖g‖_{L¹} · d(Λ) - ∫ g(λ) ε_Λ(λ) d*λ`.

The diagonal density is thus the averaged trace plus the averaged near-diagonal defect. -/
theorem re_cutTrace_eq_diagDensity_sub_integral_defect [Countable ι] (hg : IsNonnegReal g) :
    (cutTrace b U cut g).re
      = l1Norm g * diagDensity U b cut
        - ∫ lam, (g lam).re * kernelDefect U b cut lam ∂(Rplus.haar) := by
  have hsplit : ∀ lam : Rplus,
      (g lam).re * (traceDensityCut U b cut lam).re
        = (g lam).re * diagDensity U b cut - (g lam).re * kernelDefect U b cut lam := by
    intro lam
    rw [re_traceDensityCut_eq]
    ring
  rw [re_cutTrace_eq_integral U cut g hg,
    integral_congr_ae (.of_forall hsplit),
    integral_sub ((hg.integrable_re g).mul_const _) (integrable_re_mul_kernelDefect U cut g),
    integral_mul_const, hg.integral_re g]

/-- **The elementary upper bound on the diagonal density.**  If the near-diagonal defect is
at most `w` on the support of a nonnegative real test function `g`, then

  `‖g‖_{L¹} · d(Λ) ≤ Re Tr(ϑ(g) S^{(Λ)}) + ‖g‖_{L¹} · w`. -/
theorem l1Norm_mul_diagDensity_le [Countable ι] (hg : IsNonnegReal g) {w : ℝ}
    (hw : ∀ lam : Rplus, g lam ≠ 0 → kernelDefect U b cut lam ≤ w) :
    l1Norm g * diagDensity U b cut ≤ (cutTrace b U cut g).re + l1Norm g * w := by
  have hpt : ∀ lam : Rplus,
      (g lam).re * kernelDefect U b cut lam ≤ (g lam).re * w := by
    intro lam
    by_cases hzero : g lam = 0
    · have : (g lam).re = 0 := by rw [hzero]; simp
      rw [this]; simp
    · exact mul_le_mul_of_nonneg_left (hw lam hzero) (hg.nonneg lam)
  have hle : ∫ lam, (g lam).re * kernelDefect U b cut lam ∂(Rplus.haar)
      ≤ ∫ lam, (g lam).re * w ∂(Rplus.haar) :=
    integral_mono (integrable_re_mul_kernelDefect U cut g)
      ((hg.integrable_re g).mul_const _) hpt
  rw [integral_mul_const, hg.integral_re g] at hle
  rw [re_cutTrace_eq_diagDensity_sub_integral_defect U cut g hg]
  linarith

/-- The normalized form of the averaging bound: for a nonnegative real test function of
total mass one whose support carries a near-diagonal defect at most `w`,

  `d(Λ) ≤ Re Tr(ϑ(g) S^{(Λ)}) + w`. -/
theorem diagDensity_le_re_cutTrace_add [Countable ι] (hg : IsNonnegReal g)
    (hmass : l1Norm g = 1) {w : ℝ}
    (hw : ∀ lam : Rplus, g lam ≠ 0 → kernelDefect U b cut lam ≤ w) :
    diagDensity U b cut ≤ (cutTrace b U cut g).re + w := by
  have := l1Norm_mul_diagDensity_le U cut g hg hw
  rw [hmass] at this
  linarith

end Averaging

/-- **Reduction of the missing upper bound.**  Suppose a fixed nonnegative real test
function `g` of total mass one is given, together with

* a bound `Re Tr(ϑ(g) S^{(Λ)}) ≤ 2 log Λ + C₀` on its cut-off trace, and
* a short-distance modulus `M` for the kernel, with `M Λ · r ≤ C₁` on the support of `g`
  (where `r` bounds the invariant distance `|log λ|` on that support),

then the diagonal density satisfies the missing upper bound with `C = C₀ + C₁`. -/
theorem diagLogUpperBound_of_modulus_of_traceBound [Countable ι]
    {b : HilbertBasis ι ℂ L2R} {M : ℝ → ℝ} (hM : ShortDistanceModulus U b M)
    (g : C_c(Rplus, ℂ)) (hg : IsNonnegReal g) (hmass : l1Norm g = 1) {r C₀ C₁ : ℝ}
    (hr : ∀ lam : Rplus, g lam ≠ 0 → Rplus.logSize lam ≤ r) (hC₁ : 0 ≤ C₁)
    (hMC : ∀ᶠ cut : ℝ in atTop, M cut * r ≤ C₁)
    (htrace : ∀ᶠ cut : ℝ in atTop, (cutTrace b U cut g).re ≤ 2 * Real.log cut + C₀) :
    DiagLogUpperBound U b (C₀ + C₁) := by
  filter_upwards [hMC, htrace, eventually_ge_atTop (1 : ℝ)] with cut hMcut htr hcut1
  have hw : ∀ lam : Rplus, g lam ≠ 0 → kernelDefect U b cut lam ≤ C₁ := by
    intro lam hlam
    rcases le_total 0 (M cut) with hM0 | hM0
    · calc kernelDefect U b cut lam ≤ M cut * Rplus.logSize lam := hM cut hcut1 lam
        _ ≤ M cut * r := mul_le_mul_of_nonneg_left (hr lam hlam) hM0
        _ ≤ C₁ := hMcut
    · have h1 := hM cut hcut1 lam
      have h2 := Rplus.logSize_nonneg lam
      nlinarith
  have := diagDensity_le_re_cutTrace_add U cut g hg hmass hw
  linarith

/-! ## How the two hypotheses combine, quantitatively -/

section Combining

variable {b : HilbertBasis ι ℂ L2R}

/-- For a nonnegative real test function the cut-off trace never exceeds the diagonal
term: `Re Tr(ϑ(g) S^{(Λ)}) ≤ ‖g‖_{L¹} · d(Λ)`, the difference being the averaged
near-diagonal defect.  (The two-sided companion of `diagDensity_le_re_cutTrace_add`.) -/
theorem re_cutTrace_le_l1Norm_mul_diagDensity [Countable ι] (cut : ℝ) (g : C_c(Rplus, ℂ))
    (hg : IsNonnegReal g) :
    (cutTrace b U cut g).re ≤ l1Norm g * diagDensity U b cut := by
  have hnn : 0 ≤ ∫ lam, (g lam).re * kernelDefect U b cut lam ∂(Rplus.haar) :=
    integral_nonneg fun lam =>
      mul_nonneg (hg.nonneg lam) (kernelDefect_nonneg U b cut lam)
  rw [re_cutTrace_eq_diagDensity_sub_integral_defect U cut g hg]
  linarith

/-- **The quantitative form of the combination.**  Let `g` be a nonnegative real test
function of total mass one whose support has invariant log-width at most `r`.  A
short-distance modulus `M` for the kernel then makes the averaged trace compute the
diagonal density to accuracy `M Λ · r`:

  `|d(Λ) - Re Tr(ϑ(g) S^{(Λ)})| ≤ w`   whenever `M Λ · r ≤ w` and `0 ≤ w`, `Λ ≥ 1`.

Only the averaging identity and `ShortDistanceModulus` are used; no Fourier input. -/
theorem abs_diagDensity_sub_re_cutTrace_le [Countable ι] {M : ℝ → ℝ}
    (hM : ShortDistanceModulus U b M) (cut : ℝ) (hcut : 1 ≤ cut) (g : C_c(Rplus, ℂ))
    (hg : IsNonnegReal g) (hmass : l1Norm g = 1) {r w : ℝ}
    (hr : ∀ lam : Rplus, g lam ≠ 0 → Rplus.logSize lam ≤ r) (hw0 : 0 ≤ w)
    (hMr : M cut * r ≤ w) :
    |diagDensity U b cut - (cutTrace b U cut g).re| ≤ w := by
  have hup : ∀ lam : Rplus, g lam ≠ 0 → kernelDefect U b cut lam ≤ w := by
    intro lam hlam
    rcases le_total 0 (M cut) with hM0 | hM0
    · calc kernelDefect U b cut lam ≤ M cut * Rplus.logSize lam := hM cut hcut lam
        _ ≤ M cut * r := mul_le_mul_of_nonneg_left (hr lam hlam) hM0
        _ ≤ w := hMr
    · have h1 := hM cut hcut lam
      have h2 := Rplus.logSize_nonneg lam
      nlinarith
  have h1 := diagDensity_le_re_cutTrace_add U cut g hg hmass hup
  have h2 := re_cutTrace_le_l1Norm_mul_diagDensity (b := b) U cut g hg
  rw [hmass, one_mul] at h2
  rw [abs_le]
  constructor <;> linarith

/-- **The two hypotheses, combined with a scale-dependent bump, give the diagonal
asymptotics.**  Suppose a short-distance modulus `M` is available, and a family `G Λ` of
nonnegative real test functions of mass one, of log-width `r Λ`, is chosen so that the
balance `M Λ · r Λ ≤ w Λ → 0` holds (the modulus degrades as `Λ → ∞`, the bump has to be
narrowed accordingly).  If the *traces* of the bumps have the expected logarithmic
asymptotics with finite part `c`, then so has the diagonal density:

  `d(Λ) = 2 log Λ + c + o(1)`.

This is the precise sense in which `ShortDistanceModulus` transfers information from the
trace side to the diagonal; the missing `DiagLogUpperBound` then follows
(`hasDiagLogUpperBound_of_modulus_of_traceAsymptotics`). -/
theorem hasDiagLogAsymptotics_of_modulus_of_traceAsymptotics [Countable ι] {M : ℝ → ℝ}
    (hM : ShortDistanceModulus U b M) (G : ℝ → C_c(Rplus, ℂ)) (r w : ℝ → ℝ)
    (hG : ∀ cut : ℝ, IsNonnegReal (G cut)) (hmass : ∀ cut : ℝ, l1Norm (G cut) = 1)
    (hr : ∀ cut : ℝ, ∀ lam : Rplus, (G cut) lam ≠ 0 → Rplus.logSize lam ≤ r cut)
    (hw0 : ∀ cut : ℝ, 0 ≤ w cut) (hMr : ∀ cut : ℝ, M cut * r cut ≤ w cut)
    (hw : Tendsto w atTop (𝓝 0)) {c : ℝ}
    (htrace : Tendsto (fun cut : ℝ => (cutTrace b U cut (G cut)).re - 2 * Real.log cut)
      atTop (𝓝 c)) :
    HasDiagLogAsymptotics U b c := by
  have hdiff : Tendsto
      (fun cut : ℝ => diagDensity U b cut - (cutTrace b U cut (G cut)).re) atTop (𝓝 0) := by
    refine squeeze_zero_norm' ?_ hw
    filter_upwards [eventually_ge_atTop (1 : ℝ)] with cut hcut
    simpa [Real.norm_eq_abs] using
      abs_diagDensity_sub_re_cutTrace_le U hM cut hcut (G cut) (hG cut) (hmass cut)
        (hr cut) (hw0 cut) (hMr cut)
  have hsum : Tendsto (fun cut : ℝ => diagDensity U b cut - 2 * Real.log cut) atTop
      (𝓝 (c + 0)) := (htrace.add hdiff).congr fun cut => by ring
  simpa using hsum

/-- The same hypotheses give the missing upper bound `d(Λ) ≤ 2 log Λ + O(1)`. -/
theorem hasDiagLogUpperBound_of_modulus_of_traceAsymptotics [Countable ι] {M : ℝ → ℝ}
    (hM : ShortDistanceModulus U b M) (G : ℝ → C_c(Rplus, ℂ)) (r w : ℝ → ℝ)
    (hG : ∀ cut : ℝ, IsNonnegReal (G cut)) (hmass : ∀ cut : ℝ, l1Norm (G cut) = 1)
    (hr : ∀ cut : ℝ, ∀ lam : Rplus, (G cut) lam ≠ 0 → Rplus.logSize lam ≤ r cut)
    (hw0 : ∀ cut : ℝ, 0 ≤ w cut) (hMr : ∀ cut : ℝ, M cut * r cut ≤ w cut)
    (hw : Tendsto w atTop (𝓝 0)) {c : ℝ}
    (htrace : Tendsto (fun cut : ℝ => (cutTrace b U cut (G cut)).re - 2 * Real.log cut)
      atTop (𝓝 c)) :
    HasDiagLogUpperBound U b :=
  ⟨c + 1, HasDiagLogAsymptotics.diagLogUpperBound U
    (hasDiagLogAsymptotics_of_modulus_of_traceAsymptotics U hM G r w hG hmass hr hw0 hMr
      hw htrace)⟩

end Combining

/-!
## What is still required, analytically

The two `Prop`s above are the only inputs missing for the upper half of the diagonal
asymptotics `d(Λ) = 2 log Λ + O(1)`.  Concretely:

1. **`DiagLogUpperBound`** — `‖B_Λ‖²_{HS} ≤ 2 log Λ + C`, i.e. an upper bound for the
   Hilbert–Schmidt norm of `B_Λ = P̂^{(Λ)} P^{(Λ)}`.  In kernel form this is the integral
   of `|k_Λ(x, y)|²` over the cut-off region, where `k_Λ` is the kernel of the Fourier
   transform truncated in both space and frequency; this is a genuinely Fourier-side
   computation and is deliberately not attempted in this operator-theoretic module.  The
   lower bound of the same shape is already proved (`eventually_diagDensity_lower_bound`),
   so this single estimate closes the rate.

2. **`ShortDistanceModulus`** — a bound `‖(1 - ϑ(λ)) B_Λ^*‖_{HS} ≤ c(Λ) |log λ|`.  By
   `kernelDefect_le_tsum` this is what a short-distance expansion of `κ_Λ` amounts to; it
   requires a derivative estimate for `B_Λ^*` in the logarithmic variable (equivalently, an
   `L²` bound on `∂ₓ k_Λ` over the cut-off region), again a Fourier-side input.

`diagLogUpperBound_of_modulus_of_traceBound` records exactly how the two combine with the
elementary averaging identity: with a mass-one bump of log-width `r`, the averaged trace
controls `d(Λ)` up to `M Λ · r`, so the two estimates must be balanced in `r` (the trace
term degrades as `r → 0`, the modulus term as `r` grows).  Nothing beyond those two inputs
is used in this file.

**Correction (see `RequestProject/DiagonalQuadraticGrowth.lean`).**  Estimate 1 above is
*false*.  With the present cut-offs `P^{(Λ)} = 1_{[-Λ,Λ]}`, `P̂^{(Λ)} = 𝓕⁻¹ 1_{[-Λ,Λ]} 𝓕`
the diagonal density is of phase-space-area size,

  `(8/π²) Λ² − 4/π² ≤ d(Λ) ≤ 4 Λ²`

(`diagDensity_ge_quadratic`, `diagDensity_le_four_mul_sq`), so `d(Λ) = Θ(Λ²)` and
`DiagLogUpperBound U b C` fails for every `C` (`not_diagLogUpperBound`), as does
`HasDiagLogAsymptotics U b c` for every `c` (`not_hasDiagLogAsymptotics`).  The statements
of this file are unaffected — they are conditional implications — but two consequences
should be noted:

* the `2 log Λ` counter-term of the renormalized trace cannot be extracted from the
  diagonal value `d(Λ)` of the semi-local kernel; the logarithm lives in the *averaged*
  trace `Tr(ϑ(f) S^{(Λ)})`, the kernel `κ_Λ` being concentrated in a window of width
  `~Λ⁻²` around the diagonal, where it reaches the height `Θ(Λ²)`;
* consequently the transfer theorem `hasDiagLogAsymptotics_of_modulus_of_traceAsymptotics`
  now reads as an *incompatibility*: a short-distance modulus `M` together with a balanced
  bump family (`M Λ · r Λ → 0`) forbids the logarithmic trace asymptotics
  (`not_traceAsymptotics_of_modulus`).  Any correct route to the counter-term must either
  use a modulus that is not balanced in this sense, or a smoothed cut-off family for which
  the diagonal value is genuinely logarithmic.
-/

end ConnesConsani.WeilPositivity
