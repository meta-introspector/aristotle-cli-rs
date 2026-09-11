/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

Formalization support for
  Alain Connes & Caterina Consani,
  "Weil positivity and Trace formula – the archimedean place", arXiv:2006.13771.

This file develops the multiplicative group `ℝ⋆₊ = (0,∞)` together with its Haar
measure `d*ρ = dρ/ρ`, in the form used throughout the paper.
-/
import Mathlib

noncomputable section

open MeasureTheory Real Set

namespace ConnesConsani.WeilPositivity

/-! ## The multiplicative group `ℝ⋆₊` -/

/-- The multiplicative group `ℝ⋆₊ = (0, ∞)`. -/
abbrev Rplus := {x : ℝ // 0 < x}

namespace Rplus

instance : IsTopologicalGroup Rplus where
  continuous_mul :=
    Continuous.subtype_mk
      ((continuous_subtype_val.comp continuous_fst).mul
        (continuous_subtype_val.comp continuous_snd)) _
  continuous_inv :=
    Continuous.subtype_mk (continuous_subtype_val.inv₀ fun x => ne_of_gt x.2) _

instance : MeasurableMul₂ Rplus := ⟨(continuous_mul (M := Rplus)).measurable⟩

instance : MeasurableInv Rplus := ⟨(continuous_inv (G := Rplus)).measurable⟩

/-- The exponential, viewed as a homeomorphism from the additive line onto `ℝ⋆₊`. -/
def expHomeo : ℝ ≃ₜ Rplus where
  toFun t := ⟨Real.exp t, Real.exp_pos t⟩
  invFun x := Real.log x.1
  left_inv := Real.log_exp
  right_inv x := Subtype.ext (Real.exp_log x.2)
  continuous_toFun := Continuous.subtype_mk Real.continuous_exp _
  continuous_invFun := by
    rw [continuous_iff_continuousAt]
    intro x
    exact (Real.continuousAt_log (ne_of_gt x.2)).comp continuous_subtype_val.continuousAt

@[simp] lemma expHomeo_apply (t : ℝ) : (expHomeo t : ℝ) = Real.exp t := rfl

@[simp] lemma expHomeo_symm_apply (x : Rplus) : expHomeo.symm x = Real.log (x : ℝ) := rfl

instance : LocallyCompactSpace Rplus := expHomeo.locallyCompactSpace_iff.1 inferInstance

/-- `exp` as an isomorphism of topological groups from `(ℝ, +)` to `ℝ⋆₊`. -/
def expMulEquiv : Multiplicative ℝ ≃* Rplus where
  toFun t := expHomeo (Multiplicative.toAdd t)
  invFun x := Multiplicative.ofAdd (expHomeo.symm x)
  left_inv t := by simp
  right_inv x := expHomeo.apply_symm_apply x
  map_mul' s t := by
    apply Subtype.ext
    simpa using Real.exp_add (Multiplicative.toAdd s) (Multiplicative.toAdd t)

/-! ## The multiplicative Haar measure `d*ρ = dρ/ρ` -/

/-- The Haar measure `d*ρ = dρ/ρ` of `ℝ⋆₊`, normalized as the pushforward of the
Lebesgue measure under `t ↦ e^t`. -/
def haar : Measure Rplus := Measure.map expHomeo volume

lemma haar_def : haar = Measure.map expHomeo volume := rfl

/-- `haar` is the pushforward of Lebesgue measure along the measurable equivalence `exp`. -/
lemma haar_apply {s : Set Rplus} (hs : MeasurableSet s) :
    haar s = volume (expHomeo ⁻¹' s) :=
  Measure.map_apply expHomeo.continuous.measurable hs

instance : haar.IsMulLeftInvariant := by
  constructor
  intro g
  show Measure.map (g * ·) (Measure.map expHomeo volume) = _
  rw [Measure.map_map (measurable_const_mul g) expHomeo.continuous.measurable]
  have h : ((g * ·) ∘ (expHomeo : ℝ → Rplus))
      = (expHomeo : ℝ → Rplus) ∘ (fun t => Real.log g.1 + t) := by
    funext t
    apply Subtype.ext
    show g.1 * Real.exp t = Real.exp (Real.log g.1 + t)
    rw [Real.exp_add, Real.exp_log g.2]
  rw [h, ← Measure.map_map expHomeo.continuous.measurable (measurable_const_add _),
    Measure.IsAddLeftInvariant.map_add_left_eq_self]
  rfl

instance : SigmaFinite haar :=
  expHomeo.toMeasurableEquiv.sigmaFinite_map (μ := volume)

instance : haar.IsHaarMeasure := by
  refine Measure.isHaarMeasure_of_isCompact_nonempty_interior haar (expHomeo '' (Icc 0 1))
    ((isCompact_Icc).image expHomeo.continuous) ?_ ?_ ?_
  · refine ⟨expHomeo (1/2), ?_⟩
    have : IsOpen (expHomeo '' (Ioo 0 1)) := expHomeo.isOpenMap _ isOpen_Ioo
    refine mem_interior.2 ⟨expHomeo '' (Ioo 0 1), image_mono Ioo_subset_Icc_self, this, ?_⟩
    exact ⟨1/2, by norm_num, rfl⟩
  · rw [haar_apply (((isCompact_Icc).image expHomeo.continuous).measurableSet),
      expHomeo.preimage_image]
    simp
  · rw [haar_apply (((isCompact_Icc).image expHomeo.continuous).measurableSet),
      expHomeo.preimage_image]
    simp

/-- Integration against the multiplicative Haar measure, in logarithmic coordinates:
`∫ f(ρ) d*ρ = ∫ f(e^t) dt`. -/
lemma integral_haar {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] (f : Rplus → E) :
    ∫ ρ, f ρ ∂haar = ∫ t : ℝ, f (expHomeo t) := by
  rw [haar_def]
  exact integral_map_equiv expHomeo.toMeasurableEquiv f

/-- Integrability against the multiplicative Haar measure, in logarithmic coordinates. -/
lemma integrable_haar_iff {E : Type*} [NormedAddCommGroup E] (f : Rplus → E) :
    Integrable f haar ↔ Integrable (fun t : ℝ => f (expHomeo t)) volume := by
  rw [haar_def]
  exact MeasureTheory.integrable_map_equiv expHomeo.toMeasurableEquiv f

/-- The multiplicative Haar measure is inversion invariant: `d*(ρ⁻¹) = d*ρ`. -/
lemma integral_haar_inv {E : Type*} [NormedAddCommGroup E] [NormedSpace ℝ E] (f : Rplus → E) :
    ∫ ρ, f ρ⁻¹ ∂haar = ∫ ρ, f ρ ∂haar := by
  rw [integral_haar, integral_haar]
  have h : ∀ t : ℝ, f (expHomeo t)⁻¹ = f (expHomeo (-t)) := by
    intro t
    congr 1
    apply Subtype.ext
    show (Real.exp t)⁻¹ = Real.exp (-t)
    rw [Real.exp_neg]
  simp_rw [h]
  exact integral_neg_eq_self (fun t => f (expHomeo t)) volume

end Rplus

end ConnesConsani.WeilPositivity
