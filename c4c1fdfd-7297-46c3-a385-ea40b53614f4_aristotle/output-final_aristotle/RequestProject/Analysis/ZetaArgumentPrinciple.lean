/-
Original to this repository (not part of the upstream ZetaZeros development).
-/
import ZetaZeros.Defs
import ZetaZeros.Compat.Mathlib
import RequestProject.Analysis.ArgumentPrinciple
import RequestProject.Analysis.RectangleArgumentPrinciple

/-!
# The argument principle for the Riemann zeta function

The general argument principle of `RequestProject/Analysis/ArgumentPrinciple.lean`, applied to
`riemannZeta`, which is holomorphic away from its pole at `s = 1`.  This is the shape in which the
argument principle enters the derivation of the Riemann–von Mangoldt formula: a contour integral of
`ζ'/ζ` computes the number of zeros inside the contour, counted with the multiplicity
`ZetaZeros.zeroMultiplicity` used throughout this development.
-/

namespace ZetaZeros.Analysis

open Complex Metric Set
open scoped Real Topology

/-- **The argument principle for `ζ`.**  For a disc avoiding the pole `s = 1` and with no zero of
`ζ` on its boundary circle, the contour integral of `ζ'/ζ` is `2πi` times the number of zeros of
`ζ` inside the disc, counted with multiplicity. -/
theorem circleIntegral_logDeriv_riemannZeta {c : ℂ} {R : ℝ} (hR : 0 < R)
    (h1 : (1 : ℂ) ∉ closedBall c R)
    (hbd : ∀ z ∈ sphere c R, riemannZeta z ≠ 0) :
    (∮ z in C(c, R), logDeriv riemannZeta z)
      = 2 * ↑π * I * ∑ᶠ ρ ∈ ball c R, (zeroMultiplicity ρ : ℂ) := by
  have hsub : closedBall c R ⊆ ({(1 : ℂ)}ᶜ : Set ℂ) := by
    intro z hz
    simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
    rintro rfl
    exact h1 hz
  simpa [zeroMultiplicity] using
    circleIntegral_logDeriv_eq_zeroCount_of_isOpen hR isOpen_compl_singleton hsub
      analyticOn_riemannZeta hbd

/-- **Counting simple zeros of `ζ`.**  If every zero of `ζ` in the disc is simple, the contour
integral of `ζ'/ζ` is `2πi` times their number. -/
theorem circleIntegral_logDeriv_riemannZeta_of_simple {c : ℂ} {R : ℝ} (hR : 0 < R)
    (h1 : (1 : ℂ) ∉ closedBall c R)
    (hbd : ∀ z ∈ sphere c R, riemannZeta z ≠ 0)
    (hsimple : ∀ ρ ∈ ball c R, riemannZeta ρ = 0 → zeroMultiplicity ρ = 1) :
    (∮ z in C(c, R), logDeriv riemannZeta z)
      = 2 * ↑π * I * ({ρ | ρ ∈ ball c R ∧ riemannZeta ρ = 0}.ncard : ℂ) := by
  classical
  -- pass to a slightly larger disc, still avoiding the pole
  obtain ⟨δ, hδ, hδU⟩ :=
    (isCompact_closedBall c R).exists_thickening_subset_open (isOpen_compl_singleton (x := (1:ℂ)))
      (fun z hz => by
        simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
        rintro rfl
        exact h1 hz)
  have hmono : closedBall c (R + δ / 2) ⊆ ({(1 : ℂ)}ᶜ : Set ℂ) :=
    (closedBall_subset_thickening_closedBall hR hδ).trans hδU
  exact circleIntegral_logDeriv_eq_card_of_simple hR (by linarith : R < R + δ / 2)
    (analyticOn_riemannZeta.mono hmono) hbd hsimple

/-- **The argument principle for `ζ` on a rectangle.**  For a rectangle whose closure sits inside a
larger rectangle avoiding the pole `s = 1`, and with no zero of `ζ` on its boundary, the integral of
`ζ'/ζ` over that boundary is `2πi` times the number of zeros of `ζ` inside, counted with
multiplicity. -/
theorem rectIntegral_logDeriv_riemannZeta {z w z' w' : ℂ} (hsub : rectClosed z w ⊆ rectOpen z' w')
    (h1 : (1 : ℂ) ∉ rectClosed z' w')
    (hbd : ∀ ζ ∈ rectBoundary z w, riemannZeta ζ ≠ 0) :
    rectIntegral (logDeriv riemannZeta) z w
      = 2 * ↑π * I * ∑ᶠ ρ ∈ rectOpen z w, (zeroMultiplicity ρ : ℂ) := by
  have hmono : rectClosed z' w' ⊆ ({(1 : ℂ)}ᶜ : Set ℂ) := by
    intro ζ hζ
    simp only [Set.mem_compl_iff, Set.mem_singleton_iff]
    rintro rfl
    exact h1 hζ
  simpa [zeroMultiplicity] using
    rectIntegral_logDeriv_eq_zeroCount hsub (analyticOn_riemannZeta.mono hmono) hbd

end ZetaZeros.Analysis
