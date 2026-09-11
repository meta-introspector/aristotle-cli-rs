/-
Copyright (c) 2026. All rights reserved.
Released under Apache 2.0 license.

The trace remainder `δ` in logarithmic coordinates: it is smooth on each side of `ρ = 1`
and its derivative jumps by `2` there.  Combined with the corner integration by parts
formula of `RequestProject/JumpFormula.lean` this yields the essential negativity
identity `D(Q(ξ ∗ ξ*)) = -2‖ξ‖² + ⟨ξ, K ξ⟩` of §4 and §6 of arXiv:2006.13771, with the
remainder given by the pairing with `Qδ`.
-/
import RequestProject.Imported.OutputFinal.RequestProject.SiSmooth
import RequestProject.Imported.OutputFinal.RequestProject.TraceRemainder
import RequestProject.Imported.OutputFinal.RequestProject.JumpFormula

noncomputable section

open MeasureTheory Set Real

namespace ConnesConsani.WeilPositivity

/-! ## `δ` in logarithmic coordinates -/

/-- The trace remainder in logarithmic coordinates, on the side `ρ ≥ 1`:
`deltaLogAux t = δ(e^t)` for `t ≥ 0`. -/
def deltaLogAux (t : ℝ) : ℝ := deltaAux (Real.exp t)

theorem deltaLogAux_eq (t : ℝ) :
    deltaLogAux t = 2 * Real.exp (t / 2) *
      (siDiv (2 * π * (1 + Real.exp t)) + siDiv (2 * π * (Real.exp t - 1))) := by
  rw [deltaLogAux, deltaAux_explicit, ← Real.exp_half]

/-- `δ(e^t)` is a smooth function of `t`: the singularity of `δ` sits at `ρ = 1` only
through the symmetrization `ρ ↦ max(ρ, ρ⁻¹)`. -/
theorem contDiff_deltaLogAux (n : ℕ) : ContDiff ℝ n deltaLogAux := by
  have h : deltaLogAux = fun t : ℝ => 2 * Real.exp (t / 2) *
      (siDiv (2 * π * (1 + Real.exp t)) + siDiv (2 * π * (Real.exp t - 1))) :=
    funext deltaLogAux_eq
  rw [h]
  have hexp : ContDiff ℝ n (fun t : ℝ => Real.exp t) := Real.contDiff_exp
  have hexph : ContDiff ℝ n (fun t : ℝ => Real.exp (t / 2)) :=
    Real.contDiff_exp.comp (contDiff_id.div_const 2)
  have h1 : ContDiff ℝ n (fun t : ℝ => siDiv (2 * π * (1 + Real.exp t))) :=
    (contDiff_siDiv n).comp (by
      exact (contDiff_const.mul ((contDiff_const).add hexp)))
  have h2 : ContDiff ℝ n (fun t : ℝ => siDiv (2 * π * (Real.exp t - 1))) :=
    (contDiff_siDiv n).comp (by
      exact (contDiff_const.mul (hexp.sub contDiff_const)))
  exact (contDiff_const.mul hexph).mul (h1.add h2)

/-- The derivative of `t ↦ δ(e^t)` at `t = 0` equals `1`. -/
theorem hasDerivAt_deltaLogAux_zero : HasDerivAt deltaLogAux 1 0 := by
  have hexp : HasDerivAt Real.exp 1 0 := by simpa using Real.hasDerivAt_exp 0
  have hd : HasDerivAt deltaAux 1 (Real.exp 0) := by simpa using deltaAux_hasDerivAt_one
  simpa using hd.comp 0 hexp

/-! ## The two smooth pieces of `δ` -/

/-- The right-hand piece of `δ` in logarithmic coordinates, complex valued. -/
def deltaPieceR : ℝ → ℂ := fun t => ((deltaLogAux t : ℝ) : ℂ)

/-- The left-hand piece of `δ` in logarithmic coordinates, complex valued. -/
def deltaPieceL : ℝ → ℂ := fun t => ((deltaLogAux (-t) : ℝ) : ℂ)

theorem contDiff_deltaPieceR (n : ℕ) : ContDiff ℝ n deltaPieceR :=
  Complex.ofRealCLM.contDiff.comp (contDiff_deltaLogAux n)

theorem contDiff_deltaPieceL (n : ℕ) : ContDiff ℝ n deltaPieceL :=
  (Complex.ofRealCLM.contDiff.comp (contDiff_deltaLogAux n)).comp contDiff_neg

@[simp] theorem deltaPieceR_zero_eq : deltaPieceR 0 = deltaPieceL 0 := by
  simp [deltaPieceR, deltaPieceL]

theorem deriv_deltaPieceR_zero : deriv deltaPieceR 0 = 1 := by
  have h : HasDerivAt deltaPieceR ((1 : ℝ) : ℂ) 0 :=
    (Complex.ofRealCLM.hasFDerivAt.comp_hasDerivAt 0 hasDerivAt_deltaLogAux_zero)
  simpa using h.deriv

theorem deriv_deltaPieceL_zero : deriv deltaPieceL 0 = -1 := by
  have h0 : HasDerivAt (fun t : ℝ => -t) (-1 : ℝ) 0 := by
    simpa using (hasDerivAt_id (0:ℝ)).neg
  have hz : HasDerivAt deltaLogAux 1 (-0 : ℝ) := by simpa using hasDerivAt_deltaLogAux_zero
  have h1 : HasDerivAt (fun t : ℝ => deltaLogAux (-t)) ((1 : ℝ) * (-1)) 0 := hz.comp 0 h0
  have h : HasDerivAt deltaPieceL (((1 : ℝ) * (-1) : ℝ) : ℂ) 0 :=
    (Complex.ofRealCLM.hasFDerivAt.comp_hasDerivAt 0 h1)
  simpa using h.deriv

/-- The derivative of `δ` jumps by `2` at `ρ = 1`. -/
theorem deltaPiece_jump : deriv deltaPieceR 0 - deriv deltaPieceL 0 = 2 := by
  rw [deriv_deltaPieceR_zero, deriv_deltaPieceL_zero]
  ring

/-- In logarithmic coordinates `δ` is exactly the corner function built from its two
smooth pieces. -/
theorem corner_deltaPiece (t : ℝ) :
    corner deltaPieceR deltaPieceL t = ((delta (Rplus.expHomeo t) : ℝ) : ℂ) := by
  have hval : ((Rplus.expHomeo t : Rplus) : ℝ) = Real.exp t := rfl
  rcases le_or_gt 0 t with ht | ht
  · rw [corner_of_nonneg ht]
    have hmax : max (Real.exp t) (Real.exp t)⁻¹ = Real.exp t := by
      rw [max_eq_left]
      rw [← Real.exp_neg]
      exact Real.exp_le_exp.2 (by linarith)
    simp [deltaPieceR, deltaLogAux, delta, hval, hmax]
  · rw [corner_of_neg ht]
    have hmax : max (Real.exp t) (Real.exp (-t)) = Real.exp (-t) :=
      max_eq_right (Real.exp_le_exp.2 (by linarith))
    have hinv : (Real.exp t)⁻¹ = Real.exp (-t) := (Real.exp_neg t).symm
    simp [deltaPieceL, deltaLogAux, delta, hval, hinv, hmax]

/-! ## Essential negativity of `D ∘ Q` -/

/-- **Essential negativity of `D ∘ Q`.**  For a `C²` compactly supported test function `ξ`
on `ℝ⋆₊` (in logarithmic coordinates), the pairing of `Q(ξ ∗ ξ*)` with the trace remainder
`δ` equals `-2‖ξ‖²` plus the pairing of `ξ ∗ ξ*` with `Qδ`, the latter being a smooth
kernel on each side of `ρ = 1`.  This is the mechanism of §4 and §6 of the paper: the
negative term `-2‖ξ‖²` comes from the jump of `δ'` at `ρ = 1`. -/
theorem essential_negativity_delta {F : ℝ → ℂ}
    (hF : ContDiff ℝ 2 F) (hsF : HasCompactSupport F) :
    ∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ)
      = -2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)
        + ∫ t : ℝ, convLog F (starLog F) t
            * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t := by
  have hkey := integral_Qlog_convLog_starLog_mul_corner hF hsF
    (contDiff_deltaPieceR 2) (contDiff_deltaPieceL 2) deltaPieceR_zero_eq deltaPiece_jump
  rw [← hkey]
  exact integral_congr_ae (Filter.Eventually.of_forall fun t => by
    simp only [corner_deltaPiece])

/-- The same identity written as an integral over `ℝ⋆₊` against the multiplicative Haar
measure `d*ρ`. -/
theorem essential_negativity_delta_haar {F : ℝ → ℂ}
    (hF : ContDiff ℝ 2 F) (hsF : HasCompactSupport F) :
    ∫ ρ : Rplus, Qlog (convLog F (starLog F)) (Real.log ρ) * ((delta ρ : ℝ) : ℂ) ∂(Rplus.haar)
      = -2 * ((∫ s : ℝ, ‖F s‖ ^ 2 : ℝ) : ℂ)
        + ∫ ρ : Rplus, convLog F (starLog F) (Real.log ρ)
            * corner (Qlog deltaPieceR) (Qlog deltaPieceL) (Real.log ρ) ∂(Rplus.haar) := by
  have h1 : (∫ ρ : Rplus, Qlog (convLog F (starLog F)) (Real.log ρ) * ((delta ρ : ℝ) : ℂ)
        ∂(Rplus.haar))
      = ∫ t : ℝ, Qlog (convLog F (starLog F)) t * ((delta (Rplus.expHomeo t) : ℝ) : ℂ) := by
    rw [Rplus.integral_haar]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    simp only [Rplus.expHomeo_apply, Real.log_exp]
  have h2 : (∫ ρ : Rplus, convLog F (starLog F) (Real.log ρ)
        * corner (Qlog deltaPieceR) (Qlog deltaPieceL) (Real.log ρ) ∂(Rplus.haar))
      = ∫ t : ℝ, convLog F (starLog F) t
          * corner (Qlog deltaPieceR) (Qlog deltaPieceL) t := by
    rw [Rplus.integral_haar]
    refine integral_congr_ae (Filter.Eventually.of_forall fun t => ?_)
    simp only [Rplus.expHomeo_apply, Real.log_exp]
  rw [h1, h2]
  exact essential_negativity_delta hF hsF

end ConnesConsani.WeilPositivity
