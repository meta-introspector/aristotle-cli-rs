/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The integrated form `ϑ(f) = ∫ f(λ) ϑ(λ) d*λ` of the scaling representation of `ℝ⋆₊`,
following §1 of arXiv:2006.13771 (Connes–Consani, *Weil positivity and Trace formula –
the archimedean place*).

`RequestProject/Scaling.lean` constructs the unitary scaling representation
`ϑ : ℝ⋆₊ → U(L²(ℝ⋆₊, d*ρ))`.  Here we prove that it is **strongly continuous** and use this
to define the integrated operators

  `ϑ(f) ξ = ∫ f(λ) ϑ(λ) ξ d*λ`,  `f ∈ C_c(ℝ⋆₊)`,

as a Bochner integral of a continuous compactly supported `L²`-valued function.  We prove
the `L¹`-bound `‖ϑ(f)‖ ≤ ‖f‖₁`, linearity in `f`, and the adjoint formula
`ϑ(f)* = ϑ(f^♯)` with `f^♯(λ) = conj (f (λ⁻¹))`, which is the involution of the convolution
algebra `C_c(ℝ⋆₊)` used in the paper.
-/
import RequestProject.Imported.OutputFinal.RequestProject.Scaling

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory DomMulAct

open scoped CompactlySupported

namespace ConnesConsani.WeilPositivity

/-! ## Strong continuity of the scaling representation -/

/-- The scaling representation is the domain action of `ℝ⋆₊` on `L²(ℝ⋆₊, d*ρ)`. -/
theorem scaling_eq_domSMul (lam : Rplus) (f : L2Rplus) :
    scaling lam f = (DomMulAct.mk lam⁻¹ : Rplusᵈᵐᵃ) • f := rfl

/-- **Strong continuity** of the scaling representation: for a fixed `ξ ∈ L²(ℝ⋆₊)` the map
`λ ↦ ϑ(λ) ξ` is continuous. -/
theorem continuous_scaling_apply (f : L2Rplus) : Continuous fun lam : Rplus => scaling lam f := by
  haveI : Fact ((2 : ENNReal) ≠ ⊤) := ⟨by simp⟩
  have h : Continuous fun lam : Rplus => (DomMulAct.mk lam⁻¹ : Rplusᵈᵐᵃ) :=
    DomMulAct.continuous_mk.comp continuous_inv
  exact continuous_smul.comp (h.prodMk (continuous_const (y := f)))

/-! ## The integrated representation `ϑ(f)` -/

section Integrated

variable (g : C_c(Rplus, ℂ)) (f : L2Rplus)

theorem continuous_smul_scaling : Continuous fun lam : Rplus => g lam • scaling lam f :=
  (map_continuous g).smul (continuous_scaling_apply f)

theorem hasCompactSupport_smul_scaling :
    HasCompactSupport fun lam : Rplus => g lam • scaling lam f :=
  g.hasCompactSupport.smul_right

/-- The integrand of `ϑ(f)` is Bochner integrable: it is continuous with compact support. -/
theorem integrable_smul_scaling :
    Integrable (fun lam : Rplus => g lam • scaling lam f) Rplus.haar :=
  (continuous_smul_scaling g f).integrable_of_hasCompactSupport
    (hasCompactSupport_smul_scaling g f)

/-- The `L¹`-norm `‖f‖₁ = ∫ |f(λ)| d*λ` of a test function. -/
def l1Norm (g : C_c(Rplus, ℂ)) : ℝ := ∫ lam, ‖g lam‖ ∂(Rplus.haar)

theorem integrable_norm : Integrable (fun lam : Rplus => ‖g lam‖) Rplus.haar :=
  ((map_continuous g).norm).integrable_of_hasCompactSupport g.hasCompactSupport.norm

theorem l1Norm_nonneg : 0 ≤ l1Norm g :=
  integral_nonneg fun _ => norm_nonneg _

/-- The integrated operator `ϑ(f) ξ = ∫ f(λ) ϑ(λ) ξ d*λ`, as a linear map. -/
def scalingOpₗ (g : C_c(Rplus, ℂ)) : L2Rplus →ₗ[ℂ] L2Rplus where
  toFun f := ∫ lam, g lam • scaling lam f ∂(Rplus.haar)
  map_add' f₁ f₂ := by
    simp only [map_add, smul_add]
    exact integral_add (integrable_smul_scaling g f₁) (integrable_smul_scaling g f₂)
  map_smul' c f := by
    simp only [map_smul, RingHom.id_apply, smul_comm (g _) c, ← integral_smul]

theorem scalingOpₗ_apply : scalingOpₗ g f = ∫ lam, g lam • scaling lam f ∂(Rplus.haar) := rfl

theorem norm_scalingOpₗ_apply_le : ‖scalingOpₗ g f‖ ≤ l1Norm g * ‖f‖ := by
  rw [scalingOpₗ_apply]
  refine (norm_integral_le_integral_norm _).trans ?_
  have h : ∀ lam : Rplus, ‖g lam • scaling lam f‖ = ‖g lam‖ * ‖f‖ := by
    intro lam
    rw [norm_smul, LinearIsometryEquiv.norm_map]
  simp only [h, l1Norm]
  exact le_of_eq (integral_mul_const _ _)

end Integrated

/-- **The integrated representation** `ϑ(f) = ∫ f(λ) ϑ(λ) d*λ` of the convolution algebra
`C_c(ℝ⋆₊)`, as a bounded operator on `L²(ℝ⋆₊, d*ρ)`. -/
def scalingOp (g : C_c(Rplus, ℂ)) : L2Rplus →L[ℂ] L2Rplus :=
  LinearMap.mkContinuous (scalingOpₗ g) (l1Norm g) (norm_scalingOpₗ_apply_le g)

@[simp] theorem scalingOp_apply (g : C_c(Rplus, ℂ)) (f : L2Rplus) :
    scalingOp g f = ∫ lam, g lam • scaling lam f ∂(Rplus.haar) := rfl

/-- The `L¹`-bound `‖ϑ(f) ξ‖ ≤ ‖f‖₁ ‖ξ‖`. -/
theorem norm_scalingOp_apply_le (g : C_c(Rplus, ℂ)) (f : L2Rplus) :
    ‖scalingOp g f‖ ≤ l1Norm g * ‖f‖ := norm_scalingOpₗ_apply_le g f

/-- The operator norm of `ϑ(f)` is at most the `L¹`-norm of `f`. -/
theorem norm_scalingOp_le (g : C_c(Rplus, ℂ)) : ‖scalingOp g‖ ≤ l1Norm g :=
  LinearMap.mkContinuous_norm_le _ (l1Norm_nonneg g) _

/-- `f ↦ ϑ(f)` is additive. -/
theorem scalingOp_add (g₁ g₂ : C_c(Rplus, ℂ)) :
    scalingOp (g₁ + g₂) = scalingOp g₁ + scalingOp g₂ := by
  refine ContinuousLinearMap.ext fun f => ?_
  simp only [scalingOp_apply, ContinuousLinearMap.add_apply]
  have h : ∀ lam : Rplus, (g₁ + g₂) lam • scaling lam f
      = g₁ lam • scaling lam f + g₂ lam • scaling lam f := by
    intro lam
    simp [add_smul]
  simp only [h]
  exact integral_add (integrable_smul_scaling g₁ f) (integrable_smul_scaling g₂ f)

/-- `f ↦ ϑ(f)` is `ℂ`-homogeneous. -/
theorem scalingOp_smul (c : ℂ) (g : C_c(Rplus, ℂ)) :
    scalingOp (c • g) = c • scalingOp g := by
  refine ContinuousLinearMap.ext fun f => ?_
  simp only [scalingOp_apply, ContinuousLinearMap.smul_apply]
  have h : ∀ lam : Rplus, (c • g) lam • scaling lam f = c • (g lam • scaling lam f) := by
    intro lam
    show (c * g lam) • scaling lam f = c • (g lam • scaling lam f)
    rw [mul_smul]
  simp only [h]
  exact integral_smul c _

@[simp] theorem scalingOp_zero : scalingOp (0 : C_c(Rplus, ℂ)) = 0 := by
  refine ContinuousLinearMap.ext fun f => ?_
  simp

/-- The matrix coefficients of `ϑ(f)`. -/
theorem inner_scalingOp_apply (g : C_c(Rplus, ℂ)) (h f : L2Rplus) :
    inner ℂ h (scalingOp g f) = ∫ lam, g lam * inner ℂ h (scaling lam f) ∂(Rplus.haar) := by
  rw [scalingOp_apply, ← integral_inner (integrable_smul_scaling g f) h]
  exact integral_congr_ae (.of_forall fun lam => inner_smul_right _ _ _)

/-! ## The involution `f ↦ f^♯` and the adjoint of `ϑ(f)` -/

/-- The involution `f^♯(λ) = conj (f (λ⁻¹))` of the convolution algebra `C_c(ℝ⋆₊)`. -/
def starTest (g : C_c(Rplus, ℂ)) : C_c(Rplus, ℂ) where
  toFun lam := starRingEnd ℂ (g lam⁻¹)
  continuous_toFun := Complex.continuous_conj.comp ((map_continuous g).comp continuous_inv)
  hasCompactSupport' := by
    have h1 : HasCompactSupport fun lam : Rplus => g lam⁻¹ :=
      g.hasCompactSupport.comp_homeomorph (Homeomorph.inv Rplus)
    exact h1.comp_left (g := starRingEnd ℂ) (by simp)

@[simp] theorem starTest_apply (g : C_c(Rplus, ℂ)) (lam : Rplus) :
    starTest g lam = starRingEnd ℂ (g lam⁻¹) := rfl

/-- Unitarity of `ϑ(λ)`, in the form `⟪ϑ(λ) h, f⟫ = ⟪h, ϑ(λ⁻¹) f⟫`. -/
theorem inner_scaling_left (lam : Rplus) (h f : L2Rplus) :
    inner ℂ (scaling lam h) f = inner ℂ h (scaling lam⁻¹ f) := by
  have hff : scaling lam (scaling lam⁻¹ f) = f := by
    rw [← scaling_mul, mul_inv_cancel, scaling_apply, scalingₗᵢ_one]
    rfl
  calc inner ℂ (scaling lam h) f
      = inner ℂ (scaling lam h) (scaling lam (scaling lam⁻¹ f)) := by rw [hff]
    _ = inner ℂ h (scaling lam⁻¹ f) := (scaling lam).inner_map_map _ _

/-- **The adjoint of the integrated representation**: `ϑ(f)* = ϑ(f^♯)`. -/
theorem adjoint_scalingOp (g : C_c(Rplus, ℂ)) :
    ContinuousLinearMap.adjoint (scalingOp g) = scalingOp (starTest g) := by
  refine ((ContinuousLinearMap.eq_adjoint_iff _ _).2 fun h f => ?_).symm
  have step1 : inner ℂ (scalingOp (starTest g) h) f
      = ∫ lam, g lam⁻¹ * inner ℂ h (scaling lam⁻¹ f) ∂(Rplus.haar) := by
    rw [← inner_conj_symm, inner_scalingOp_apply, ← integral_conj]
    refine integral_congr_ae (.of_forall fun lam => ?_)
    simp only [starTest_apply, map_mul, Complex.conj_conj, inner_conj_symm, inner_scaling_left]
  rw [step1, inner_scalingOp_apply]
  exact Rplus.integral_haar_inv (fun lam : Rplus => g lam * inner ℂ h (scaling lam f))

end ConnesConsani.WeilPositivity
