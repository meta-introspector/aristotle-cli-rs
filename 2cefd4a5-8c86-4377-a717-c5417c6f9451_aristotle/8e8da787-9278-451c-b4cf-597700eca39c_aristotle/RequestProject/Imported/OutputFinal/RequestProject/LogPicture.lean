/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The logarithmic picture: the unitary identification `L²(ℝ⋆₊, d*ρ) ≃ L²(ℝ, dt)` and the
integrated scaling representation transported to `L²(ℝ)`, for arXiv:2006.13771
(Connes–Consani, *Weil positivity and Trace formula – the archimedean place*).

`RequestProject/Scaling.lean` builds the linear isometry `logCoordinates` induced by
`t ↦ e^t`; here we upgrade it to a unitary `logEquiv`, and, more generally, we transport
the integrated operators `ϑ(f)` of `RequestProject/ScalingIntegrated.lean` from
`L²(ℝ⋆₊, d*ρ)` to `L²(ℝ)` **along an arbitrary unitary identification** `U` of the two
Hilbert spaces (`thetaOpOf U f`).  `L²(ℝ)` is the space on which the two cutoff
projections `P₁`, `P̂₁` of `RequestProject/Sonin.lean` act, and in which the trace formula
`L(f) = Tr(ϑ(f) P P̂ P)` of the paper is stated.

Keeping `U` general is deliberate.  The unitary of the paper is
`ξ ↦ (x ↦ |x|^{-1/2} ξ(|x|)/√2)`, which identifies `L²(ℝ⋆₊, d*ρ)` with the *even* part of
`L²(ℝ, dx)`, and is **not** `logEquiv`: the latter is the passage to the additive picture
of the group, in which `ϑ` becomes the translation representation but the Fourier
transform of `L²(ℝ, dx)` refers to the additive variable.  All the operator-theoretic
statements below hold for every `U`, so nothing depends on that choice; the construction
of the paper's `U` is recorded in `RequestProject/Skeleton.lean` as remaining work.

The transported operators `thetaOpOf U f` inherit all the properties of `ϑ(f)`:

* the `L¹`-bound `‖ϑ(f)‖ ≤ ‖f‖₁`;
* multiplicativity `ϑ(f ∗ g) = ϑ(f) ϑ(g)`;
* compatibility with the involutions, `ϑ(f)* = ϑ(f^♯)`;
* positivity: `ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)* ≥ 0`.

We also record the dictionary between the multiplicative picture and the logarithmic one
used in the analytic part of the project: `logTest` turns the convolution product `testConv`
into `convLog` and the involution `starTest` into `starLog`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.TestConvolution
import RequestProject.Imported.OutputFinal.RequestProject.Mellin
import RequestProject.Imported.OutputFinal.RequestProject.Sonin

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

/-! ## The unitary `L²(ℝ⋆₊, d*ρ) ≃ L²(ℝ, dt)` -/

/-- `t ↦ e^t` is measure preserving from the line to `ℝ⋆₊` with its Haar measure. -/
theorem measurePreserving_expHomeo :
    MeasurePreserving (Rplus.expHomeo : ℝ → Rplus) volume Rplus.haar :=
  ⟨Rplus.expHomeo.continuous.measurable, rfl⟩

/-- The inverse change of coordinates `ρ ↦ log ρ`. -/
theorem measurePreserving_expHomeo_symm :
    MeasurePreserving (Rplus.expHomeo.symm : Rplus → ℝ) Rplus.haar volume :=
  MeasurePreserving.symm Rplus.expHomeo.toMeasurableEquiv measurePreserving_expHomeo

/-- Passing from `L²(ℝ)` to `L²(ℝ⋆₊, d*ρ)` by `ρ ↦ log ρ`. -/
def expCoordinates : L2R →ₗᵢ[ℂ] L2Rplus :=
  Lp.compMeasurePreservingₗᵢ ℂ (Rplus.expHomeo.symm : Rplus → ℝ) measurePreserving_expHomeo_symm

theorem coeFn_expCoordinates (f : L2R) :
    (expCoordinates f : Rplus → ℂ)
      =ᵐ[Rplus.haar] fun ρ => (f : ℝ → ℂ) (Rplus.expHomeo.symm ρ) :=
  Lp.coeFn_compMeasurePreserving f _

theorem logCoordinates_expCoordinates (f : L2R) : logCoordinates (expCoordinates f) = f := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_logCoordinates (expCoordinates f),
    (coeFn_expCoordinates f).comp_tendsto
      measurePreserving_expHomeo.quasiMeasurePreserving.tendsto_ae] with t h1 h2
  rw [h1]
  simpa using h2

theorem logCoordinates_surjective : Function.Surjective (logCoordinates : L2Rplus → L2R) :=
  fun f => ⟨expCoordinates f, logCoordinates_expCoordinates f⟩

/-- **The unitary identification of the two pictures**, `L²(ℝ⋆₊, d*ρ) ≃ L²(ℝ, dt)`, given by
the change of variables `ρ = e^t`. -/
def logEquiv : L2Rplus ≃ₗᵢ[ℂ] L2R :=
  LinearIsometryEquiv.ofSurjective logCoordinates logCoordinates_surjective

@[simp] theorem logEquiv_apply (f : L2Rplus) : logEquiv f = logCoordinates f := rfl

theorem inner_logEquiv_left (a : L2Rplus) (y : L2R) :
    inner ℂ (logEquiv a) y = inner ℂ a (logEquiv.symm y) := by
  rw [← logEquiv.inner_map_map a (logEquiv.symm y), LinearIsometryEquiv.apply_symm_apply]

/-! ## The integrated scaling representation on `L²(ℝ)` -/

variable (U : L2Rplus ≃ₗᵢ[ℂ] L2R)

/-- **The integrated scaling representation on `L²(ℝ)`**: the operator `ϑ(f)`, transported
from `L²(ℝ⋆₊, d*ρ)` along a unitary identification `U` of the two Hilbert spaces. -/
def thetaOpOf (g : C_c(Rplus, ℂ)) : L2R →L[ℂ] L2R :=
  (U.toContinuousLinearEquiv : L2Rplus →L[ℂ] L2R) ∘L scalingOp g ∘L
    (U.symm.toContinuousLinearEquiv : L2R →L[ℂ] L2Rplus)

theorem thetaOpOf_apply (g : C_c(Rplus, ℂ)) (f : L2R) :
    thetaOpOf U g f = U (scalingOp g (U.symm f)) := rfl

/-- The integrated representation in the logarithmic (translation) picture. -/
abbrev thetaOp (g : C_c(Rplus, ℂ)) : L2R →L[ℂ] L2R := thetaOpOf logEquiv g

/-- The `L¹`-bound `‖ϑ(f) ξ‖ ≤ ‖f‖₁ ‖ξ‖` in the logarithmic picture. -/
theorem norm_thetaOpOf_apply_le (g : C_c(Rplus, ℂ)) (f : L2R) :
    ‖thetaOpOf U g f‖ ≤ l1Norm g * ‖f‖ := by
  rw [thetaOpOf_apply, LinearIsometryEquiv.norm_map]
  simpa using norm_scalingOp_apply_le g (U.symm f)

/-- The operator norm of `ϑ(f)` is at most the `L¹`-norm of `f`. -/
theorem norm_thetaOpOf_le (g : C_c(Rplus, ℂ)) : ‖thetaOpOf U g‖ ≤ l1Norm g :=
  ContinuousLinearMap.opNorm_le_bound _ (l1Norm_nonneg g) (norm_thetaOpOf_apply_le U g)

/-- `f ↦ ϑ(f)` is additive. -/
theorem thetaOpOf_add (g₁ g₂ : C_c(Rplus, ℂ)) :
    thetaOpOf U (g₁ + g₂) = thetaOpOf U g₁ + thetaOpOf U g₂ := by
  refine ContinuousLinearMap.ext fun f => ?_
  simp only [thetaOpOf_apply, scalingOp_add, ContinuousLinearMap.add_apply, map_add]

/-- `f ↦ ϑ(f)` is `ℂ`-homogeneous. -/
theorem thetaOpOf_smul (c : ℂ) (g : C_c(Rplus, ℂ)) :
    thetaOpOf U (c • g) = c • thetaOpOf U g := by
  refine ContinuousLinearMap.ext fun f => ?_
  simp only [thetaOpOf_apply, scalingOp_smul, ContinuousLinearMap.smul_apply, map_smul]

@[simp] theorem thetaOpOf_zero : thetaOpOf U (0 : C_c(Rplus, ℂ)) = 0 := by
  refine ContinuousLinearMap.ext fun f => ?_
  simp [thetaOpOf_apply]

/-- **Multiplicativity**: `ϑ(f ∗ g) = ϑ(f) ϑ(g)` in the logarithmic picture. -/
theorem thetaOpOf_testConv (f g : C_c(Rplus, ℂ)) :
    thetaOpOf U (testConv f g) = thetaOpOf U f ∘L thetaOpOf U g := by
  refine ContinuousLinearMap.ext fun xi => ?_
  simp only [thetaOpOf_apply, ContinuousLinearMap.comp_apply,
    LinearIsometryEquiv.symm_apply_apply]
  rw [show scalingOp (testConv f g) (U.symm xi)
      = (scalingOp f ∘L scalingOp g) (U.symm xi) from
    congrArg (fun T : L2Rplus →L[ℂ] L2Rplus => T (U.symm xi)) (scalingOp_testConv f g)]
  rfl

/-- **Compatibility with the involutions**: `ϑ(f)* = ϑ(f^♯)`. -/
theorem adjoint_thetaOpOf (g : C_c(Rplus, ℂ)) :
    ContinuousLinearMap.adjoint (thetaOpOf U g) = thetaOpOf U (starTest g) := by
  refine ((ContinuousLinearMap.eq_adjoint_iff _ _).2 fun h f => ?_).symm
  have hadj : ∀ a b : L2Rplus,
      inner ℂ (scalingOp (starTest g) a) b = inner ℂ a (scalingOp g b) := by
    intro a b
    rw [← adjoint_scalingOp g]
    exact ContinuousLinearMap.adjoint_inner_left _ _ _
  have hU : ∀ (a : L2Rplus) (y : L2R), inner ℂ (U a) y = inner ℂ a (U.symm y) := by
    intro a y
    rw [← U.inner_map_map a (U.symm y), LinearIsometryEquiv.apply_symm_apply]
  rw [thetaOpOf_apply, thetaOpOf_apply, hU, hadj]
  have hmap := U.inner_map_map (U.symm h) (scalingOp g (U.symm f))
  rw [LinearIsometryEquiv.apply_symm_apply] at hmap
  exact hmap.symm

/-- `ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)*`. -/
theorem thetaOpOf_testConv_starTest (g : C_c(Rplus, ℂ)) :
    thetaOpOf U (testConv g (starTest g))
      = thetaOpOf U g ∘L ContinuousLinearMap.adjoint (thetaOpOf U g) := by
  rw [thetaOpOf_testConv, adjoint_thetaOpOf]

/-- **Positivity on the positive elements of the convolution algebra**: the operator
`ϑ(g ∗ g^♯)` is positive. -/
theorem thetaOpOf_testConv_starTest_isPositive (g : C_c(Rplus, ℂ)) :
    (thetaOpOf U (testConv g (starTest g))).IsPositive := by
  rw [thetaOpOf_testConv_starTest]
  exact ContinuousLinearMap.isPositive_self_comp_adjoint _

/-! ## The dictionary with the logarithmic coordinate used in the analytic modules -/

/-- The involution of the convolution algebra, read in logarithmic coordinates, is the
involution `F^*(t) = conj (F (-t))` of `RequestProject/Mellin.lean`. -/
theorem logTest_starTest (g : C_c(Rplus, ℂ)) :
    logTest (starTest g) = starLog (logTest g) := by
  funext t
  show starRingEnd ℂ (g (Rplus.expHomeo t)⁻¹) = starRingEnd ℂ (g (Rplus.expHomeo (-t)))
  congr 2
  apply Subtype.ext
  show (Real.exp t)⁻¹ = Real.exp (-t)
  rw [Real.exp_neg]

/-- The convolution product of the algebra `C_c(ℝ⋆₊)`, read in logarithmic coordinates, is
the convolution `convLog` of `RequestProject/Mellin.lean`. -/
theorem logTest_testConv (f g : C_c(Rplus, ℂ)) :
    logTest (testConv f g) = convLog (logTest f) (logTest g) := by
  funext s
  exact convFun_expHomeo f g s

end ConnesConsani.WeilPositivity
