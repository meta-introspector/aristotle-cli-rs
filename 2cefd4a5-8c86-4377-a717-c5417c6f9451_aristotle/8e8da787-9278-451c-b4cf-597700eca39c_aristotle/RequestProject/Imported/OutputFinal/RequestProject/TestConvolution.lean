/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The convolution algebra `C_c(ℝ⋆₊)` and the multiplicativity of the integrated scaling
representation, following §1 of arXiv:2006.13771 (Connes–Consani, *Weil positivity and
Trace formula – the archimedean place*).

`RequestProject/ScalingIntegrated.lean` defines the integrated operators
`ϑ(f) ξ = ∫ f(λ) ϑ(λ) ξ d*λ` for `f ∈ C_c(ℝ⋆₊)` and proves `ϑ(f)* = ϑ(f^♯)`.  Here we
supply the missing algebraic half: the convolution product

  `(f ∗ g)(ρ) = ∫ f(α) g(α⁻¹ρ) d*α`

on `C_c(ℝ⋆₊)` (continuity is obtained by transporting to the additive picture, where it is
Mathlib's convolution of two continuous compactly supported functions on `ℝ`), and the
identity `ϑ(f ∗ g) = ϑ(f) ϑ(g)`.  Combined with `adjoint_scalingOp` this gives
`ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)*`, the form in which the positivity of `L` is used.
-/
import RequestProject.Imported.OutputFinal.RequestProject.ScalingIntegrated

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory

open scoped CompactlySupported Pointwise

namespace ConnesConsani.WeilPositivity

/-! ## The convolution product on `C_c(ℝ⋆₊)` -/

/-- A test function on `ℝ⋆₊` read in logarithmic coordinates. -/
def logTest (g : C_c(Rplus, ℂ)) : ℝ → ℂ := fun t => g (Rplus.expHomeo t)

theorem continuous_logTest (g : C_c(Rplus, ℂ)) : Continuous (logTest g) :=
  (map_continuous g).comp Rplus.expHomeo.continuous

theorem hasCompactSupport_logTest (g : C_c(Rplus, ℂ)) : HasCompactSupport (logTest g) :=
  g.hasCompactSupport.comp_homeomorph Rplus.expHomeo

/-- The convolution `(f ∗ g)(ρ) = ∫ f(α) g(α⁻¹ρ) d*α` of two test functions, as a bare
function. -/
def convFun (f g : C_c(Rplus, ℂ)) : Rplus → ℂ :=
  fun ρ => ∫ α, f α * g (α⁻¹ * ρ) ∂(Rplus.haar)

/-- In logarithmic coordinates the multiplicative convolution becomes the ordinary
convolution of `ℝ`. -/
theorem convFun_expHomeo (f g : C_c(Rplus, ℂ)) (s : ℝ) :
    convFun f g (Rplus.expHomeo s)
      = convolution (logTest f) (logTest g) (ContinuousLinearMap.mul ℝ ℂ) volume s := by
  rw [convFun, Rplus.integral_haar, convolution_def]
  refine integral_congr_ae (.of_forall fun t => ?_)
  dsimp only
  have h : (Rplus.expHomeo t)⁻¹ * Rplus.expHomeo s = Rplus.expHomeo (s - t) := by
    apply Subtype.ext
    show (Real.exp t)⁻¹ * Real.exp s = Real.exp (s - t)
    rw [Real.exp_sub, div_eq_mul_inv, mul_comm]
  rw [h]
  simp [logTest]

theorem continuous_convFun (f g : C_c(Rplus, ℂ)) : Continuous (convFun f g) := by
  have hconv : Continuous
      (convolution (logTest f) (logTest g) (ContinuousLinearMap.mul ℝ ℂ) volume) :=
    (hasCompactSupport_logTest g).continuous_convolution_right _
      (continuous_logTest f).locallyIntegrable (continuous_logTest g)
  have h : convFun f g
      = (convolution (logTest f) (logTest g) (ContinuousLinearMap.mul ℝ ℂ) volume)
        ∘ Rplus.expHomeo.symm := by
    funext ρ
    have := convFun_expHomeo f g (Rplus.expHomeo.symm ρ)
    rwa [Rplus.expHomeo.apply_symm_apply] at this
  rw [h]
  exact hconv.comp Rplus.expHomeo.symm.continuous

theorem hasCompactSupport_convFun (f g : C_c(Rplus, ℂ)) : HasCompactSupport (convFun f g) := by
  have hK : IsCompact (tsupport (f : Rplus → ℂ) * tsupport (g : Rplus → ℂ)) :=
    IsCompact.mul f.hasCompactSupport g.hasCompactSupport
  refine HasCompactSupport.intro hK ?_
  intro ρ hρ
  refine integral_eq_zero_of_ae (.of_forall fun α => ?_)
  dsimp only
  by_cases hf : f α = 0
  · simp [hf]
  by_cases hg : g (α⁻¹ * ρ) = 0
  · simp [hg]
  exact absurd ⟨α, subset_tsupport _ hf, α⁻¹ * ρ, subset_tsupport _ hg, by group⟩ hρ

/-- **The convolution product** `(f ∗ g)(ρ) = ∫ f(α) g(α⁻¹ρ) d*α` on the algebra
`C_c(ℝ⋆₊)` of test functions. -/
def testConv (f g : C_c(Rplus, ℂ)) : C_c(Rplus, ℂ) where
  toFun := convFun f g
  continuous_toFun := continuous_convFun f g
  hasCompactSupport' := hasCompactSupport_convFun f g

@[simp] theorem testConv_apply (f g : C_c(Rplus, ℂ)) (ρ : Rplus) :
    testConv f g ρ = ∫ α, f α * g (α⁻¹ * ρ) ∂(Rplus.haar) := rfl

/-! ## Multiplicativity of the integrated representation -/

section Multiplicative

variable (f g : C_c(Rplus, ℂ)) (xi : L2Rplus)

/-- The two-variable integrand `(α, ρ) ↦ f(α) g(α⁻¹ρ) ϑ(ρ)ξ` of the Fubini argument. -/
def convIntegrand (α ρ : Rplus) : L2Rplus := (f α * g (α⁻¹ * ρ)) • scaling ρ xi

theorem continuous_uncurry_convIntegrand :
    Continuous (Function.uncurry (convIntegrand f g xi)) := by
  have h1 : Continuous fun p : Rplus × Rplus => f p.1 * g (p.1⁻¹ * p.2) :=
    ((map_continuous f).comp continuous_fst).mul
      ((map_continuous g).comp ((continuous_fst.inv).mul continuous_snd))
  exact h1.smul ((continuous_scaling_apply xi).comp continuous_snd)

theorem hasCompactSupport_uncurry_convIntegrand :
    HasCompactSupport (Function.uncurry (convIntegrand f g xi)) := by
  refine HasCompactSupport.intro
    (K := tsupport (f : Rplus → ℂ) ×ˢ
      (tsupport (f : Rplus → ℂ) * tsupport (g : Rplus → ℂ)))
    (IsCompact.prod f.hasCompactSupport
      (IsCompact.mul f.hasCompactSupport g.hasCompactSupport)) ?_
  rintro ⟨α, ρ⟩ hp
  by_cases hf : f α = 0
  · simp [Function.uncurry, convIntegrand, hf]
  by_cases hg : g (α⁻¹ * ρ) = 0
  · simp [Function.uncurry, convIntegrand, hg]
  exact absurd ⟨subset_tsupport _ hf,
    ⟨α, subset_tsupport _ hf, α⁻¹ * ρ, subset_tsupport _ hg, by group⟩⟩ hp

theorem integrable_uncurry_convIntegrand :
    Integrable (Function.uncurry (convIntegrand f g xi)) (Rplus.haar.prod Rplus.haar) :=
  (continuous_uncurry_convIntegrand f g xi).integrable_of_hasCompactSupport
    (hasCompactSupport_uncurry_convIntegrand f g xi)

/-- Applying `ϑ(α)` under the Bochner integral defining `ϑ(g) ξ`. -/
theorem scaling_scalingOp_apply (α : Rplus) :
    scaling α (scalingOp g xi) = ∫ β, g β • scaling (α * β) xi ∂(Rplus.haar) := by
  have key := ContinuousLinearMap.integral_comp_comm
    (scalingₗᵢ α).toContinuousLinearMap (integrable_smul_scaling g xi)
  rw [scalingOp_apply]
  show (scalingₗᵢ α).toContinuousLinearMap _ = _
  rw [← key]
  refine integral_congr_ae (.of_forall fun β => ?_)
  show scaling α (g β • scaling β xi) = g β • scaling (α * β) xi
  rw [map_smul, ← scaling_mul]

/-- The inner integral, after the change of variables `β = α⁻¹ρ`. -/
theorem integral_convIntegrand_eq (α : Rplus) :
    ∫ ρ, convIntegrand f g xi α ρ ∂(Rplus.haar)
      = f α • ∫ β, g β • scaling (α * β) xi ∂(Rplus.haar) := by
  rw [← integral_mul_left_eq_self (convIntegrand f g xi α) α, ← integral_smul]
  refine integral_congr_ae (.of_forall fun β => ?_)
  show (f α * g (α⁻¹ * (α * β))) • scaling (α * β) xi = f α • (g β • scaling (α * β) xi)
  rw [show α⁻¹ * (α * β) = β from by group, mul_smul]

/-- **Multiplicativity of the integrated representation**: `ϑ(f ∗ g) = ϑ(f) ϑ(g)`. -/
theorem scalingOp_testConv :
    scalingOp (testConv f g) = scalingOp f ∘L scalingOp g := by
  refine ContinuousLinearMap.ext fun xi => ?_
  have hleft : (scalingOp f ∘L scalingOp g) xi
      = ∫ α, ∫ ρ, convIntegrand f g xi α ρ ∂(Rplus.haar) ∂(Rplus.haar) := by
    show scalingOp f (scalingOp g xi) = _
    rw [scalingOp_apply]
    refine integral_congr_ae (.of_forall fun α => ?_)
    dsimp only
    rw [integral_convIntegrand_eq f g xi α, scaling_scalingOp_apply g xi α]
  rw [hleft, integral_integral_swap (integrable_uncurry_convIntegrand f g xi), scalingOp_apply]
  refine integral_congr_ae (.of_forall fun ρ => ?_)
  dsimp only
  rw [testConv_apply, ← integral_smul_const]
  rfl

end Multiplicative

/-- `ϑ(g ∗ g^♯) = ϑ(g) ϑ(g)*`: the integrated representation turns the positive elements
`g ∗ g^♯` of the convolution algebra into positive operators. -/
theorem scalingOp_testConv_starTest (g : C_c(Rplus, ℂ)) :
    scalingOp (testConv g (starTest g))
      = scalingOp g ∘L ContinuousLinearMap.adjoint (scalingOp g) := by
  rw [scalingOp_testConv, adjoint_scalingOp]

/-- The operator `ϑ(g ∗ g^♯)` is positive. -/
theorem scalingOp_testConv_starTest_isPositive (g : C_c(Rplus, ℂ)) :
    (scalingOp (testConv g (starTest g))).IsPositive := by
  rw [scalingOp_testConv_starTest]
  exact ContinuousLinearMap.isPositive_self_comp_adjoint _

end ConnesConsani.WeilPositivity
