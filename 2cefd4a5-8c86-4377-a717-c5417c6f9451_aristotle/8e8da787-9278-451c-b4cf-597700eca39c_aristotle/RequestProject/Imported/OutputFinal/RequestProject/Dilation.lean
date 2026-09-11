/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

**The dilation representation of `ℝ⋆₊` on `L²(ℝ, dx)`**, for arXiv:2006.13771
(Connes–Consani, *Weil positivity and Trace formula – the archimedean place*).

The scaling representation of the paper is `ϑ(λ)ξ(x) = λ^{-1/2} ξ(λ^{-1}x)`, acting on the
even part of `L²(ℝ, dx)` — the space on which the two cut-off projections
`P^{(Λ)}`, `P̂^{(Λ)}` of `RequestProject/CutoffFamily.lean` live.  Until now the project
transported the regular representation of `ℝ⋆₊` to `L²(ℝ)` along an *arbitrary* unitary
identification `U` (`thetaOpOf U`, `RequestProject/LogPicture.lean`), which is enough for
every statement that does not need the kernel of the operators.  This file constructs the
concrete unitary action instead:

  `(D_a F)(x) = √a · F(a x)`,   `a ∈ ℝ⋆₊`,

so that `ϑ(λ) = D_{λ⁻¹}`.  It is a genuine unitary representation of `ℝ⋆₊` on the whole of
`L²(ℝ, dx)`:

* `dilFun`, `dilFun_dilFun`, `dilFun_one` — the action on functions, and the group law
  `D_a ∘ D_b = D_{ab}` (an equality of functions, not merely almost everywhere);
* `eLpNorm_dilFun` — the change of variables `‖D_a F‖₂ = ‖F‖₂`, from
  `Real.map_volume_mul_left`;
* `dil : Rplus → (L2R ≃ₗᵢ[ℂ] L2R)` — the unitary, with `dil_one`, `dil_mul`, `dil_symm`,
  `dil_inv_eq_symm` and `adjoint_dil`;
* `weilMap_scaling_eq_dil` — the intertwining relation with the representation already in
  the project: `w (ϑ(λ) ξ) = D_{λ⁻¹} (w ξ)`, where `w` is the unitary of
  `RequestProject/EvenPicture.lean` identifying `L²(ℝ⋆₊, d*ρ)` with the even part of
  `L²(ℝ)`.  So `dil` is the paper's scaling representation, written on `L²(ℝ)`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.EvenPicture

set_option maxHeartbeats 1000000
set_option synthInstance.maxHeartbeats 400000

noncomputable section

open MeasureTheory Set

open scoped ENNReal

namespace ConnesConsani.WeilPositivity

/-! ## 1. The dilation of functions on the line -/

/-- The unitary dilation of a function on the line, `(D_a F)(x) = √a · F(a x)`. -/
def dilFun (a : ℝ) (F : ℝ → ℂ) : ℝ → ℂ := fun x => (Real.sqrt a : ℝ) • F (a * x)

theorem dilFun_apply (a : ℝ) (F : ℝ → ℂ) (x : ℝ) :
    dilFun a F x = (Real.sqrt a : ℝ) • F (a * x) := rfl

theorem dilFun_eq_smul (a : ℝ) (F : ℝ → ℂ) :
    dilFun a F = (Real.sqrt a : ℝ) • (F ∘ fun x => a * x) := rfl

theorem measurable_dilFun {a : ℝ} {F : ℝ → ℂ} (hF : Measurable F) :
    Measurable (dilFun a F) := by
  rw [dilFun_eq_smul]
  exact (hF.comp (measurable_const_mul a)).const_smul (Real.sqrt a)

/-- **The group law**, at the level of functions: `D_a (D_b F) = D_{ab} F`. -/
theorem dilFun_dilFun {a b : ℝ} (ha : 0 ≤ a) (F : ℝ → ℂ) :
    dilFun a (dilFun b F) = dilFun (a * b) F := by
  funext x
  simp only [dilFun, smul_smul, Real.sqrt_mul ha]
  rw [show b * (a * x) = a * b * x by ring]

@[simp] theorem dilFun_one (F : ℝ → ℂ) : dilFun 1 F = F := by
  funext x; simp [dilFun]

theorem dilFun_add (a : ℝ) (F G : ℝ → ℂ) :
    dilFun a (F + G) = dilFun a F + dilFun a G := by
  funext x; simp [dilFun, smul_add]

theorem dilFun_smul (a : ℝ) (c : ℂ) (F : ℝ → ℂ) :
    dilFun a (c • F) = c • dilFun a F := by
  funext x
  simp only [dilFun, Pi.smul_apply]
  rw [smul_comm]

/-! ## 2. The change of variables -/

/-- The dilation `x ↦ a x` sends `volume` to `a⁻¹ · volume`. -/
theorem measurePreserving_mul_left_volume {a : ℝ} (ha : 0 < a) :
    MeasurePreserving (fun x : ℝ => a * x) volume (ENNReal.ofReal a⁻¹ • volume) := by
  refine ⟨measurable_const_mul a, ?_⟩
  rw [Real.map_volume_mul_left (ne_of_gt ha), abs_of_pos (inv_pos.2 ha)]

/-- The dilation preserves null sets. -/
theorem quasiMeasurePreserving_mul_left_volume {a : ℝ} (ha : 0 < a) :
    Measure.QuasiMeasurePreserving (fun x : ℝ => a * x) volume volume := by
  refine ⟨measurable_const_mul a, ?_⟩
  rw [Real.map_volume_mul_left (ne_of_gt ha)]
  exact Measure.absolutelyContinuous_of_le_smul le_rfl

theorem dilFun_congr_ae {a : ℝ} (ha : 0 < a) {F G : ℝ → ℂ} (h : F =ᵐ[volume] G) :
    dilFun a F =ᵐ[volume] dilFun a G := by
  filter_upwards [h.comp_tendsto
    (quasiMeasurePreserving_mul_left_volume ha).tendsto_ae] with x hx
  simp only [dilFun, Function.comp_apply] at hx ⊢
  rw [hx]

/-- **The dilation is an `L²` isometry**: `‖D_a F‖₂ = ‖F‖₂`. -/
theorem eLpNorm_dilFun {a : ℝ} (ha : 0 < a) {F : ℝ → ℂ}
    (hF : AEStronglyMeasurable F volume) :
    eLpNorm (dilFun a F) 2 volume = eLpNorm F 2 volume := by
  have hcne : (ENNReal.ofReal a⁻¹) ≠ 0 := (ENNReal.ofReal_pos.2 (inv_pos.2 ha)).ne'
  have hF' : AEStronglyMeasurable F (ENNReal.ofReal a⁻¹ • volume) := hF.smul_measure _
  rw [dilFun_eq_smul, eLpNorm_const_smul,
    eLpNorm_comp_measurePreserving hF' (measurePreserving_mul_left_volume ha),
    eLpNorm_smul_measure_of_ne_zero hcne]
  have hhalf : ((1 : ℝ≥0∞) / 2).toReal = (1 / 2 : ℝ) := by norm_num
  have hsqrt : ‖(Real.sqrt a : ℝ)‖ₑ = ENNReal.ofReal (Real.sqrt a) :=
    Real.enorm_eq_ofReal (Real.sqrt_nonneg a)
  have hpow : (ENNReal.ofReal a⁻¹) ^ (1 / 2 : ℝ) = ENNReal.ofReal (Real.sqrt a⁻¹) := by
    rw [Real.sqrt_eq_rpow, ENNReal.ofReal_rpow_of_pos (inv_pos.2 ha)]
  have hprod : ENNReal.ofReal (Real.sqrt a) * ENNReal.ofReal (Real.sqrt a⁻¹) = 1 := by
    rw [← ENNReal.ofReal_mul (Real.sqrt_nonneg a), ← Real.sqrt_mul ha.le,
      mul_inv_cancel₀ (ne_of_gt ha), Real.sqrt_one, ENNReal.ofReal_one]
  rw [hhalf, hsqrt, hpow, smul_eq_mul, ← mul_assoc, hprod, one_mul]

theorem memLp_dilFun {a : ℝ} (ha : 0 < a) {F : ℝ → ℂ} (hF : MemLp F 2 volume) :
    MemLp (dilFun a F) 2 volume := by
  have h1 : MemLp F 2 (ENNReal.ofReal a⁻¹ • volume) := hF.smul_measure (by finiteness)
  have h2 : MemLp (F ∘ fun x : ℝ => a * x) 2 volume :=
    h1.comp_measurePreserving (measurePreserving_mul_left_volume ha)
  rw [dilFun_eq_smul]
  exact h2.const_smul (Real.sqrt a)

/-! ## 3. The dilation as a unitary of `L²(ℝ)` -/

/-- The dilation, on `L²(ℝ)`. -/
def dilLp (a : Rplus) (xi : L2R) : L2R := (memLp_dilFun a.2 (Lp.memLp xi)).toLp _

theorem coeFn_dilLp (a : Rplus) (xi : L2R) :
    (dilLp a xi : ℝ → ℂ) =ᵐ[volume] dilFun (a : ℝ) ((xi : L2R) : ℝ → ℂ) :=
  MemLp.coeFn_toLp _

theorem norm_dilLp (a : Rplus) (xi : L2R) : ‖dilLp a xi‖ = ‖xi‖ := by
  rw [dilLp, Lp.norm_toLp, eLpNorm_dilFun a.2 (Lp.aestronglyMeasurable xi), ← Lp.norm_def]

theorem dilLp_add (a : Rplus) (xi eta : L2R) :
    dilLp a (xi + eta) = dilLp a xi + dilLp a eta := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_dilLp a (xi + eta), Lp.coeFn_add (dilLp a xi) (dilLp a eta),
    coeFn_dilLp a xi, coeFn_dilLp a eta,
    dilFun_congr_ae a.2 (Lp.coeFn_add xi eta)] with x h1 h2 h3 h4 h5
  rw [h1, h5, h2, Pi.add_apply, h3, h4, dilFun_add]
  simp

theorem dilLp_smul (a : Rplus) (c : ℂ) (xi : L2R) :
    dilLp a (c • xi) = c • dilLp a xi := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_dilLp a (c • xi), Lp.coeFn_smul c (dilLp a xi), coeFn_dilLp a xi,
    dilFun_congr_ae a.2 (Lp.coeFn_smul c xi)] with x h1 h2 h3 h4
  rw [h1, h4, h2, Pi.smul_apply, h3, dilFun_smul]
  simp

/-- The dilation, as a linear isometry of `L²(ℝ)`. -/
def dilₗᵢ (a : Rplus) : L2R →ₗᵢ[ℂ] L2R where
  toFun := dilLp a
  map_add' := dilLp_add a
  map_smul' := dilLp_smul a
  norm_map' := norm_dilLp a

@[simp] theorem dilₗᵢ_apply (a : Rplus) (xi : L2R) : dilₗᵢ a xi = dilLp a xi := rfl

theorem dilLp_dilLp (a b : Rplus) (xi : L2R) :
    dilLp a (dilLp b xi) = dilLp (a * b) xi := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_dilLp a (dilLp b xi), coeFn_dilLp (a * b) xi,
    dilFun_congr_ae a.2 (coeFn_dilLp b xi)] with x h1 h2 h3
  rw [h1, h3, h2, dilFun_dilFun a.2.le]
  rfl

@[simp] theorem dilLp_one (xi : L2R) : dilLp 1 xi = xi := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_dilLp 1 xi] with x h
  rw [h]
  simp only [dilFun]
  norm_num

/-- **The dilation representation of `ℝ⋆₊` on `L²(ℝ)`**, `(D_a ξ)(x) = √a ξ(a x)`.  The
paper's scaling representation is `ϑ(λ) = D_{λ⁻¹}`. -/
def dil (a : Rplus) : L2R ≃ₗᵢ[ℂ] L2R where
  toLinearEquiv :=
    { toFun := dilLp a
      map_add' := dilLp_add a
      map_smul' := dilLp_smul a
      invFun := dilLp a⁻¹
      left_inv := fun xi => by rw [dilLp_dilLp, inv_mul_cancel, dilLp_one]
      right_inv := fun xi => by rw [dilLp_dilLp, mul_inv_cancel, dilLp_one] }
  norm_map' := norm_dilLp a

@[simp] theorem dil_apply (a : Rplus) (xi : L2R) : dil a xi = dilLp a xi := rfl

@[simp] theorem dil_symm_apply (a : Rplus) (xi : L2R) : (dil a).symm xi = dilLp a⁻¹ xi := rfl

theorem coeFn_dil (a : Rplus) (xi : L2R) :
    (dil a xi : ℝ → ℂ) =ᵐ[volume] fun x => (Real.sqrt (a : ℝ) : ℝ) • (xi : ℝ → ℂ) (a * x) :=
  coeFn_dilLp a xi

@[simp] theorem dil_one : dil 1 = LinearIsometryEquiv.refl ℂ L2R := by
  ext xi; simp

/-- `D` is a representation of `ℝ⋆₊`: `D_{ab} = D_a D_b`. -/
theorem dil_mul (a b : Rplus) (xi : L2R) : dil (a * b) xi = dil a (dil b xi) :=
  (dilLp_dilLp a b xi).symm

theorem dil_symm (a : Rplus) : (dil a).symm = dil a⁻¹ := by
  ext xi; simp

/-- The dilation is unitary: its adjoint is the inverse dilation. -/
theorem adjoint_dil (a : Rplus) :
    ContinuousLinearMap.adjoint ((dil a).toContinuousLinearEquiv : L2R →L[ℂ] L2R)
      = ((dil a⁻¹).toContinuousLinearEquiv : L2R →L[ℂ] L2R) := by
  refine ContinuousLinearMap.ext fun xi => ?_
  refine ext_inner_left ℂ fun eta => ?_
  rw [ContinuousLinearMap.adjoint_inner_right]
  have h1 : inner ℂ ((dil a) eta) xi = inner ℂ ((dil a) eta) ((dil a) ((dil a⁻¹) xi)) := by
    rw [← dil_mul, mul_inv_cancel, dil_one]
    rfl
  simpa using h1.trans (LinearIsometryEquiv.inner_map_map (dil a) eta ((dil a⁻¹) xi))

/-! ## 4. The identification with the paper's scaling representation -/

/-- **`dil` is the paper's scaling representation**: the unitary `w` of
`RequestProject/EvenPicture.lean` intertwines the regular representation `ϑ(λ)` of `ℝ⋆₊` on
`L²(ℝ⋆₊, d*ρ)` with `D_{λ⁻¹}` on `L²(ℝ)`. -/
theorem weilMap_scaling_eq_dil (lam : Rplus) (xi : L2Rplus) :
    weilMap (scaling lam xi) = dil lam⁻¹ (weilMap xi) := by
  rw [Lp.ext_iff]
  filter_upwards [coeFn_weilMap_scaling lam xi, coeFn_dil lam⁻¹ (weilMap xi)] with x h1 h2
  rw [h1, h2]
  have hlam : (0:ℝ) < (lam : ℝ) := lam.2
  have hcoe : ((lam⁻¹ : Rplus) : ℝ) = (lam : ℝ)⁻¹ := rfl
  rw [hcoe, Real.sqrt_inv]

end ConnesConsani.WeilPositivity
