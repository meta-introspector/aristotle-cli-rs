/-
Copyright (c) 2026 PIE Lab / DULA Collaboration. All rights reserved.
License: Apache 2.0 (compatible with Sphere-Packing-Lean / Mathlib).

# CohnElkiesFunction.lean — Generalized Cohn-Elkies Function Class

## Purpose

The Sphere-Packing-Lean project (Birkbeck, Hariharan, Lee, Ma, Mehta,
Viazovska) formalized the Cohn-Elkies linear programming bound as
Theorem 5.1/5.2 in their blueprint.

This file bundles the CE conditions into a reusable `CohnElkiesFunction d r`
structure parametrized by:
  • d : ℕ — the ambient dimension
  • r : ℝ — the separation radius (the threshold for condition CE1)

## Design choices

• Uses `SchwartzMap` from Mathlib (same as Sphere-Packing-Lean).
• The underlying Schwartz function is ℂ-valued (required by
  `SchwartzMap.fourierTransformCLM`), with a `real_valued` field
  asserting that it takes real values.
• Uses `SchwartzMap.fourierTransformCLM` (same as Sphere-Packing-Lean).
• Dimension as type parameter, not baked in, so d=1, d=8, d=24 all work.
• Separation radius r as parameter: d=8 uses r=√2 (rescaled), d=1 uses r=1.
-/

import Mathlib
import RequestProject.Imported.Sess48ee92df.FourierDilation

open Real SchwartzMap MeasureTheory Complex
open scoped BigOperators FourierTransform

noncomputable section

namespace CohnElkies

-- ============================================================================
-- THE STRUCTURE
-- ============================================================================

/-- **Cohn-Elkies admissible function** in dimension `d` with separation radius `r`.

    A Schwartz function `f : ℝ^d → ℝ` is CE-admissible if:
    • (RV)  `f` is real-valued
    • (CE1) `f(x) ≤ 0` whenever `‖x‖ ≥ r` (negativity outside the separation ball)
    • (CE2) `f̂(t) ≥ 0` for all `t ∈ ℝ^d` (Fourier non-negativity, including reality)
    • (CE3) `f` is not identically zero
    • (CE4) `f̂(0) > 0` (non-degeneracy of the Fourier transform at origin)

    The underlying Schwartz function is ℂ-valued to be compatible with
    `SchwartzMap.fourierTransformCLM`; the `real_valued` field ensures it
    actually takes real values. -/
structure CohnElkiesFunction (d : ℕ) (r : ℝ) where
  /-- The underlying Schwartz function (ℂ-valued for Fourier transform compatibility). -/
  toSchwartz : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ
  /-- The function is real-valued: imaginary part is zero everywhere. -/
  real_valued : ∀ x : EuclideanSpace ℝ (Fin d), (toSchwartz x).im = 0
  /-- (CE1) Negativity outside the separation ball of radius `r`. -/
  ce1 : ∀ x : EuclideanSpace ℝ (Fin d), ‖x‖ ≥ r → (toSchwartz x).re ≤ 0
  /-- (CE2) Non-negativity of the Fourier transform everywhere (real part). -/
  ce2_re : ∀ x : EuclideanSpace ℝ (Fin d),
          0 ≤ ((SchwartzMap.fourierTransformCLM ℝ toSchwartz : _ → ℂ) x).re
  /-- (CE2b) The Fourier transform is also real-valued. -/
  ce2_im : ∀ x : EuclideanSpace ℝ (Fin d),
          ((SchwartzMap.fourierTransformCLM ℝ toSchwartz : _ → ℂ) x).im = 0
  /-- (CE3) Non-triviality: f is not identically zero. -/
  ce3 : toSchwartz ≠ 0
  /-- (CE4) Non-degeneracy at origin in Fourier domain. -/
  ce4 : 0 < ((SchwartzMap.fourierTransformCLM ℝ toSchwartz : _ → ℂ) 0).re

/-- Apply a CE function to get real values directly. -/
instance (d : ℕ) (r : ℝ) :
    CoeFun (CohnElkiesFunction d r) (fun _ => EuclideanSpace ℝ (Fin d) → ℝ) :=
  ⟨fun f => fun x => (f.toSchwartz x).re⟩

-- ============================================================================
-- BASIC PROPERTIES
-- ============================================================================

variable {d : ℕ} {r : ℝ}

/-- The Fourier transform of a CE function, extracted as a real-valued function. -/
def fourierPart (f : CohnElkiesFunction d r) :
    EuclideanSpace ℝ (Fin d) → ℝ :=
  fun x => ((SchwartzMap.fourierTransformCLM ℝ f.toSchwartz : _ → ℂ) x).re

/-- The Fourier transform at origin is strictly positive. -/
lemma fourierPart_zero_pos (f : CohnElkiesFunction d r) :
    0 < fourierPart f 0 := f.ce4

/-- The Fourier transform is non-negative everywhere. -/
lemma fourierPart_nonneg (f : CohnElkiesFunction d r)
    (x : EuclideanSpace ℝ (Fin d)) : 0 ≤ fourierPart f x := f.ce2_re x

/-- The function is non-positive outside the separation ball. -/
lemma apply_nonpos_of_norm_ge (f : CohnElkiesFunction d r)
    {x : EuclideanSpace ℝ (Fin d)} (hx : ‖x‖ ≥ r) : f x ≤ 0 := f.ce1 x hx

-- ============================================================================
-- SCALING / DILATION
-- ============================================================================

/-- Scaling by a nonzero real as a ContinuousLinearEquiv on EuclideanSpace. -/
def scaleEquiv (d : ℕ) {c : ℝ} (hc : c ≠ 0) :
    EuclideanSpace ℝ (Fin d) ≃L[ℝ] EuclideanSpace ℝ (Fin d) where
  toLinearEquiv := {
    toFun := fun x => c • x
    map_add' := fun x y => smul_add c x y
    map_smul' := fun a x => by
      simp only [RingHom.id_apply]
      exact (smul_comm a c x).symm
    invFun := fun x => c⁻¹ • x
    left_inv := fun x => by simp [smul_smul, inv_mul_cancel₀ hc]
    right_inv := fun x => by simp [smul_smul, mul_inv_cancel₀ hc]
  }
  continuous_toFun := continuous_const_smul c
  continuous_invFun := continuous_const_smul c⁻¹

@[simp]
lemma scaleEquiv_apply {c : ℝ} (hc : c ≠ 0) (x : EuclideanSpace ℝ (Fin d)) :
    scaleEquiv d hc x = c • x := rfl

@[simp]
lemma scaleEquiv_symm_apply {c : ℝ} (hc : c ≠ 0) (x : EuclideanSpace ℝ (Fin d)) :
    (scaleEquiv d hc).symm x = c⁻¹ • x := rfl

/-- The Schwartz function obtained by composing with `x ↦ lam⁻¹ • x`,
    i.e., the dilation `x ↦ f(x/lam)`. -/
def dilateSchwartz (f : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ)
    {lam : ℝ} (hlam : lam ≠ 0) : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ :=
  (SchwartzMap.compCLMOfContinuousLinearEquiv ℝ (scaleEquiv d (inv_ne_zero hlam))) f

lemma dilateSchwartz_apply (f : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ)
    {lam : ℝ} (hlam : lam ≠ 0) (x : EuclideanSpace ℝ (Fin d)) :
    dilateSchwartz f hlam x = f (lam⁻¹ • x) := by
  simp [dilateSchwartz, SchwartzMap.compCLMOfContinuousLinearEquiv_apply]

/-
A dilated Schwartz function is nonzero if the original is nonzero.
-/
lemma dilateSchwartz_ne_zero (f : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ)
    {lam : ℝ} (hlam : lam ≠ 0) (hf : f ≠ 0) :
    dilateSchwartz f hlam ≠ 0 := by
      contrapose! hf;
      ext x; have := congr_arg ( fun g => g ( lam • x ) ) hf; norm_num [ dilateSchwartz ] at this; aesop;

/-
CE1 transfers under dilation: if f(x) ≤ 0 for ‖x‖ ≥ r, then
    f(x/lam) ≤ 0 for ‖x‖ ≥ lam * r.
-/
lemma dilate_ce1 (f : CohnElkiesFunction d r) {lam : ℝ} (hlam : 0 < lam) :
    ∀ x : EuclideanSpace ℝ (Fin d),
      ‖x‖ ≥ lam * r → (dilateSchwartz f.toSchwartz (ne_of_gt hlam) x).re ≤ 0 := by
  intro x hx
  have h_norm : ‖lam⁻¹ • x‖ ≥ r := by
    rw [ norm_smul, Real.norm_of_nonneg ( inv_nonneg.mpr hlam.le ), inv_mul_eq_div, ge_iff_le, le_div_iff₀' hlam ] ; linarith;
  convert f.ce1 _ h_norm using 1

/-
The Fourier transform of a dilated Schwartz function relates to the original
    via the dilation identity: FT(f(lam⁻¹ • ·))(w) = |lam|^d • FT(f)(lam • w).
-/
lemma fourierTransform_dilateSchwartz (f : SchwartzMap (EuclideanSpace ℝ (Fin d)) ℂ)
    {lam : ℝ} (hlam : lam ≠ 0) (w : EuclideanSpace ℝ (Fin d)) :
    ((fourierTransformCLM ℝ (dilateSchwartz f hlam) : _ → ℂ) w) =
      ↑(|(lam) ^ (Module.finrank ℝ (EuclideanSpace ℝ (Fin d)))|) •
        ((fourierTransformCLM ℝ f : _ → ℂ) (lam • w)) := by
  convert FourierDilation.fourier_comp_smul ( inv_ne_zero hlam ) ( fun x => f x ) w using 1;
  norm_num;
  exact Or.inl rfl

/-- Dilating a CE function by `lam > 0` produces a CE function with rescaled
    separation radius. If `f` is CE-admissible with separation `r`, then
    `x ↦ f(x/lam)` is CE-admissible with separation `lam * r`. -/
def dilate (f : CohnElkiesFunction d r) {lam : ℝ} (hlam : 0 < lam) :
    CohnElkiesFunction d (lam * r) where
  toSchwartz := dilateSchwartz f.toSchwartz (ne_of_gt hlam)
  real_valued := by
    intro x
    rw [dilateSchwartz_apply]
    exact f.real_valued _
  ce1 := dilate_ce1 f hlam
  ce2_re := by
    intro x
    rw [fourierTransform_dilateSchwartz]
    simp only [Complex.smul_re]
    apply mul_nonneg (abs_nonneg _) (f.ce2_re _)
  ce2_im := by
    intro x
    rw [fourierTransform_dilateSchwartz]
    simp only [Complex.smul_im]
    rw [f.ce2_im]
    simp
  ce3 := dilateSchwartz_ne_zero f.toSchwartz (ne_of_gt hlam) f.ce3
  ce4 := by
    rw [fourierTransform_dilateSchwartz]
    simp only [Complex.smul_re, smul_zero]
    apply mul_pos (abs_pos.mpr (pow_ne_zero _ (ne_of_gt hlam))) f.ce4

-- ============================================================================
-- SPECIALIZATIONS FOR SPECIFIC DIMENSIONS
-- ============================================================================

/-- **1D CE functions** — the class used in analytic number theory. -/
abbrev CohnElkiesFunction1D (r : ℝ) := CohnElkiesFunction 1 r

/-- **8D CE functions at separation √2** — the class used in Viazovska's proof. -/
abbrev CohnElkiesFunction8 := CohnElkiesFunction 8 (Real.sqrt 2)

/-- **24D CE functions at separation 2** — for the Leech lattice case. -/
abbrev CohnElkiesFunction24 := CohnElkiesFunction 24 2

-- ============================================================================
-- CONNECTION TO SPHERE-PACKING-LEAN
-- ============================================================================

/-- Bridge theorem: a `CohnElkiesFunction8` yields exactly the hypotheses
    needed for the LP bound. -/
theorem to_sphere_packing_hypotheses (f : CohnElkiesFunction8) :
    (∀ x : EuclideanSpace ℝ (Fin 8), ‖x‖ ≥ Real.sqrt 2 → f x ≤ 0) ∧
    (∀ x : EuclideanSpace ℝ (Fin 8), 0 ≤ fourierPart f x) ∧
    (f.toSchwartz ≠ 0) :=
  ⟨f.ce1, f.ce2_re, f.ce3⟩

-- ============================================================================
-- CONNECTION TO DULA / CONJECTURE A
-- ============================================================================

/-- **Dilation family of a 1D CE function.** -/
def dilationFamily (f : CohnElkiesFunction1D r) :
    Set (SchwartzMap (EuclideanSpace ℝ (Fin 1)) ℂ) :=
  { g | ∃ lam : ℝ, ∃ hlam : 0 < lam, g = (dilate f hlam).toSchwartz }

/-- **Conjecture A (statement).** -/
def ConjectureA_statement : Prop :=
  ∀ (f : CohnElkiesFunction1D 1),
    DenseRange (fun g : dilationFamily f => (g.val : _))

end CohnElkies

end