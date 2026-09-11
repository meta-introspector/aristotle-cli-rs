/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The scaling representation `ϑ` of `ℝ⋆₊`, following §1 of arXiv:2006.13771.

In the paper, `ϑ` is the unitary representation of `ℝ⋆₊` on `L²(ℝ)_ev` given by
`(ϑ(λ)ξ)(x) = λ^{-1/2} ξ(λ^{-1}x)`.  Up to the standard unitary equivalence it is the
(left) regular representation of the multiplicative group `ℝ⋆₊` on `L²(ℝ⋆₊, d*ρ)`,
which is what we construct here; the regular representation is manifestly unitary and
the Haar measure `d*ρ` supplies the `λ^{-1/2}` normalization automatically.
-/
import RequestProject.Imported.OutputFinal2.Sonin

noncomputable section

open MeasureTheory Set

namespace ConnesConsani.WeilPositivity

/-- The Hilbert space `L²(ℝ⋆₊, d*ρ)` of the multiplicative group. -/
abbrev L2Rplus := Lp ℂ 2 Rplus.haar

/-- The scaling operator `ϑ(λ) : ξ ↦ ξ(λ⁻¹ ·)`, as a linear isometry of `L²(ℝ⋆₊, d*ρ)`. -/
def scalingₗᵢ (lam : Rplus) : L2Rplus →ₗᵢ[ℂ] L2Rplus :=
  Lp.compMeasurePreservingₗᵢ ℂ (fun ρ => lam⁻¹ * ρ)
    (measurePreserving_mul_left Rplus.haar lam⁻¹)

lemma coeFn_scalingₗᵢ (lam : Rplus) (f : L2Rplus) :
    (scalingₗᵢ lam f : Rplus → ℂ) =ᵐ[Rplus.haar] fun ρ => (f : Rplus → ℂ) (lam⁻¹ * ρ) :=
  Lp.coeFn_compMeasurePreserving f _

@[simp] lemma scalingₗᵢ_one : scalingₗᵢ 1 = LinearIsometry.id := by
  ext f
  filter_upwards [coeFn_scalingₗᵢ 1 f] with ρ h
  simpa using h

/-- `ϑ` is a representation: `ϑ(a b) = ϑ(a) ϑ(b)`. -/
theorem scalingₗᵢ_mul (a b : Rplus) :
    scalingₗᵢ (a * b) = (scalingₗᵢ a).comp (scalingₗᵢ b) := by
  ext f
  filter_upwards [coeFn_scalingₗᵢ (a * b) f, coeFn_scalingₗᵢ a (scalingₗᵢ b f),
    (coeFn_scalingₗᵢ b f).comp_tendsto
      (measurePreserving_mul_left Rplus.haar a⁻¹).quasiMeasurePreserving.tendsto_ae] with ρ h1 h2 h3
  simp only [Function.comp_apply] at h3
  rw [show ((scalingₗᵢ a).comp (scalingₗᵢ b)) f = scalingₗᵢ a (scalingₗᵢ b f) from rfl, h2, h3, h1]
  congr 1
  rw [mul_inv, mul_assoc]
  exact mul_left_comm _ _ _

/-- The scaling operator as a unitary of `L²(ℝ⋆₊, d*ρ)`; its inverse is `ϑ(λ⁻¹)`. -/
def scaling (lam : Rplus) : L2Rplus ≃ₗᵢ[ℂ] L2Rplus where
  toLinearMap := (scalingₗᵢ lam).toLinearMap
  invFun := scalingₗᵢ lam⁻¹
  left_inv f := by
    have h := congrArg (fun T : L2Rplus →ₗᵢ[ℂ] L2Rplus => T f) (scalingₗᵢ_mul lam⁻¹ lam).symm
    simpa using h
  right_inv f := by
    have h := congrArg (fun T : L2Rplus →ₗᵢ[ℂ] L2Rplus => T f) (scalingₗᵢ_mul lam lam⁻¹).symm
    simpa using h
  norm_map' := (scalingₗᵢ lam).norm_map

@[simp] lemma scaling_apply (lam : Rplus) (f : L2Rplus) : scaling lam f = scalingₗᵢ lam f := rfl

/-- The unitary scaling representation of `ℝ⋆₊` on `L²(ℝ⋆₊, d*ρ)`. -/
theorem scaling_mul (a b : Rplus) (f : L2Rplus) :
    scaling (a * b) f = scaling a (scaling b f) := by
  rw [scaling_apply, scalingₗᵢ_mul]
  rfl

/-- Passing to logarithmic coordinates `ρ = e^t` is a unitary equivalence between
`L²(ℝ⋆₊, d*ρ)` and `L²(ℝ, dt)`, under which the scaling action becomes translation. -/
def logCoordinates : L2Rplus →ₗᵢ[ℂ] L2R :=
  Lp.compMeasurePreservingₗᵢ ℂ (Rplus.expHomeo : ℝ → Rplus)
    ⟨Rplus.expHomeo.continuous.measurable, rfl⟩

lemma coeFn_logCoordinates (f : L2Rplus) :
    (logCoordinates f : ℝ → ℂ) =ᵐ[volume] fun t => (f : Rplus → ℂ) (Rplus.expHomeo t) :=
  Lp.coeFn_compMeasurePreserving f _

end ConnesConsani.WeilPositivity
