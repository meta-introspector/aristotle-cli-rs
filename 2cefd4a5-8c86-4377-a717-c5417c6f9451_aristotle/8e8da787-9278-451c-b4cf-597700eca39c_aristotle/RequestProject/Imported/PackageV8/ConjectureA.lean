import Mathlib
import RequestProject.Imported.PackageV8.WeilTestFunction
import RequestProject.Imported.PackageV8.ContinuityHelpers

/-!
# Conjecture A — restated on WeilTestFunction

## Migration note

The original version stated `Conjecture_A_Strong` on `EvenSchwartz`, requiring
density of the image of Φ in `EvenSchwartz`. The conditional reduction
`Conjecture_A_Strong → RH` relied on continuity of `g ↦ WeilDistribution
(autocorrelation g)` on `EvenSchwartz`, which is **false** (the von Mangoldt
sum diverges for generic Schwartz functions).

This version restates everything on `WeilTestFunction`, where:
- The Weil distribution is well-defined (von Mangoldt sum converges).
- Continuity is plausible and numerically supported.
- The conditional reduction is honest.

Restricting to `WeilTestFunction` (a smaller space) makes the density
condition easier to satisfy, but the conjecture is about a different
(more natural) test function class.
-/

open Real MeasureTheory Filter Topology
open scoped BigOperators

noncomputable section

-- ============================================================================
-- 1. THE COHN–ELKIES CONDITION (unchanged)
-- ============================================================================

/-- A radial auxiliary function satisfying the Cohn–Elkies conditions. -/
structure CohnElkiesFunction (n : ℕ) where
  h : ℝ → ℝ
  h_hat : ℝ → ℝ
  pos_at_origin : h 0 > 0
  nonpos_beyond : ∀ r : ℝ, r ≥ Real.sqrt (2 * n / (n - 1) : ℝ) → h r ≤ 0
  fourier_nonneg : ∀ t : ℝ, h_hat t ≥ 0
  root_at_contact : h (Real.sqrt (2 * n / (n - 1) : ℝ)) = 0
  deriv_root_at_contact : deriv h (Real.sqrt (2 * n / (n - 1) : ℝ)) = 0

-- ============================================================================
-- 2. THE WEAK FORM (on WTF)
-- ============================================================================

def Conjecture_A_Weak_WTF : Prop :=
  ∃ Φ : CohnElkiesFunction 24 → WeilTestFunction,
    ∀ f : CohnElkiesFunction 24,
      WeilDistribution_WTF (autocorrelation_WTF (Φ f)) ≥ 0

-- ============================================================================
-- 3. THE STRONG FORM (on WTF)
-- ============================================================================

/-- Conjecture A (strong form) on `WeilTestFunction`.

    There exists a family Φ of Weil test functions, parametrized by
    Cohn–Elkies functions, such that:
    1. Each Φ(f₂₄, n) satisfies Weil positivity.
    2. The sequence {Φ(f₂₄, n)} is dense in WeilTestFunction.

    Density in `WeilTestFunction` (smaller space than `EvenSchwartz`)
    is easier to achieve, and the conjecture is consistent with the
    standard Weil/Cohn–Elkies formulations. -/
def Conjecture_A_Strong_WTF : Prop :=
  ∃ (Φ : CohnElkiesFunction 24 → ℕ → WeilTestFunction)
    (f₂₄ : CohnElkiesFunction 24),
    (∀ n : ℕ, WeilDistribution_WTF (autocorrelation_WTF (Φ f₂₄ n)) ≥ 0) ∧
    (∀ g : WeilTestFunction, ∃ φ : ℕ → ℕ,
      Filter.Tendsto (fun k => Φ f₂₄ (φ k)) Filter.atTop
        (nhds g))

-- ============================================================================
-- 4. THE CONTINUITY LEMMA (on WTF)
-- ============================================================================

/-- Continuity of the Weil functional on autocorrelations of WTF. -/
theorem weilDistribution_autocorrelation_continuous :
    Continuous (fun g : WeilTestFunction =>
      WeilDistribution_WTF (autocorrelation_WTF g)) :=
  weilDistribution_autocorrelation_continuous_WTF

-- ============================================================================
-- 5. THE CONDITIONAL MAIN THEOREM
-- ============================================================================

/-- If Conjecture A (strong form, on WTF) holds, then RH follows.

    The proof uses:
    1. Continuity of `g ↦ WeilDistribution_WTF (autocorrelation_WTF g)` on WTF.
    2. Density of {Φ(f₂₄, n)} in WTF to extend positivity from the
       sequence to all of WTF.
    3. `WeilCriterion_WTF` to convert Weil positivity to RH.

    **STATUS: PROOF RELIES ON A FALSE PREMISE.** This theorem typechecks,
    but its proof invokes `weilDistribution_autocorrelation_continuous_WTF`
    (step 1), which in turn depends on `weil_component2_continuous_WTF`.
    That lemma is now known to be **false** in the current Schwartz subspace
    topology on `WeilTestFunction` (see its docstring in `ContinuityHelpers.lean`
    for a rigorous counterexample).

    Therefore, this "proof" of `Conjecture_A_Strong_WTF → RH` is not
    formally valid despite Lean accepting it (Lean compiles the proof
    because the false lemma is admitted via `sorry`/`sorryAx`).

    **Honest project state:** This is a structural skeleton of the intended
    conditional reduction. The decomposition into components and the
    density-implies-positivity argument are correct. The single structurally
    incorrect step is the continuity of component 2 in the Schwartz subspace
    topology. To make this proof genuinely valid, one must either:
    - Strengthen the WTF topology to control exponential decay witnesses, or
    - Restructure the conditional reduction to avoid continuity of
      the von Mangoldt sum in the Schwartz topology. -/
theorem conjecture_a_strong_wtf_implies_rh :
    Conjecture_A_Strong_WTF → RiemannHypothesis := by
  intro hA
  rw [← WeilCriterion_WTF]
  intro g
  obtain ⟨Φ, f₂₄, hPos, hDense⟩ := hA
  obtain ⟨φ, hφ⟩ := hDense g
  set F : WeilTestFunction → ℝ :=
    fun h => WeilDistribution_WTF (autocorrelation_WTF h) with hF_def
  have h_seq_nonneg : ∀ k : ℕ, 0 ≤ F (Φ f₂₄ (φ k)) := by
    intro k; simp only [hF_def]; exact hPos (φ k)
  have hF_cont : Continuous F := weilDistribution_autocorrelation_continuous
  have h_lim : Filter.Tendsto (fun k => F (Φ f₂₄ (φ k)))
      Filter.atTop (nhds (F g)) :=
    (hF_cont.tendsto g).comp hφ
  exact ge_of_tendsto' h_lim h_seq_nonneg

end
