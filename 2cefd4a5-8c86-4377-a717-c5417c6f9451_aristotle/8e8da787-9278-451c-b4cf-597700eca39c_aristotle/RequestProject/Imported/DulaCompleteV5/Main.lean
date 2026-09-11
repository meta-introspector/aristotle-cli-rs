import Mathlib
import RequestProject.Imported.DulaCompleteV5.AutocorrSmooth

/-!
# Weil Positivity Framework — Base Definitions

This file provides the foundational types and definitions:
- `EvenSchwartz` : Even Schwartz functions (using Mathlib's `SchwartzMap`)
- `WeilDistribution` : The concrete Weil distribution W(g) formula
- `autocorrelation` : g ⋆ g* with proven even symmetry

**Note on convergence:** The von Mangoldt sum in `WeilDistribution` does not
converge for generic Schwartz functions (only polynomial decay in `log n`).
The well-defined Weil distribution, positivity condition, and criterion are
formulated on `WeilTestFunction` (exponential decay) in `WeilTestFunction.lean`.
-/

open scoped BigOperators
open Real MeasureTheory

noncomputable section

-- ============================================================================
-- 1. EVEN SCHWARTZ FUNCTIONS
-- ============================================================================

/-- An even Schwartz function on ℝ. -/
structure EvenSchwartz where
  /-- The underlying Schwartz function ℝ → ℝ. -/
  toSchwartzMap : SchwartzMap ℝ ℝ
  /-- The function is even: f(-x) = f(x). -/
  even : ∀ x : ℝ, toSchwartzMap (-x) = toSchwartzMap x

instance : CoeFun EvenSchwartz (fun _ => ℝ → ℝ) where
  coe g := g.toSchwartzMap

/-- Topology on `EvenSchwartz` induced from the Schwartz topology via `toSchwartzMap`. -/
instance : TopologicalSpace EvenSchwartz :=
  TopologicalSpace.induced EvenSchwartz.toSchwartzMap inferInstance

@[simp]
lemma EvenSchwartz.coe_apply (g : EvenSchwartz) (x : ℝ) :
    g x = g.toSchwartzMap x := rfl

-- ============================================================================
-- 2. THE WEIL DISTRIBUTION (formula only — see WeilTestFunction.lean for
--    the well-defined version on the correct function class)
-- ============================================================================

/-- The Weil distribution W(g) for an even Schwartz function g : ℝ → ℝ.

    **Warning:** The von Mangoldt sum (term 2) does not converge for generic
    Schwartz functions. Lean's `tsum` returns 0 when non-summable, making
    this function mathematically incorrect on generic `EvenSchwartz`.
    Use `WeilDistribution_WTF` from `WeilTestFunction.lean` for the
    well-defined version on `WeilTestFunction`. -/
def WeilDistribution (g : EvenSchwartz) : ℝ :=
  g 0 * Real.log Real.pi
  - ∑' (n : ℕ), (ArithmeticFunction.vonMangoldt n : ℝ) / Real.sqrt n * g (Real.log n)
  + ∫ x in Set.Ioi (0 : ℝ), g x * (1 / (1 - Real.exp (-2 * x)) - 1 / (2 * x))

-- ============================================================================
-- 3. AUTOCORRELATION
-- ============================================================================

/-- The autocorrelation of an even Schwartz function:
    (g ⋆ g*)(x) = ∫ g(t) g(t + x) dt.
    For even functions, g* = g so this is just the self-convolution. -/
def autocorrelation (g : EvenSchwartz) : EvenSchwartz where
  toSchwartzMap := {
    toFun := fun x => ∫ t : ℝ, g t * g (t + x)
    smooth' := schwartz_conv_contDiff g.toSchwartzMap g.toSchwartzMap
    decay' := schwartz_conv_decay g.toSchwartzMap g.toSchwartzMap
  }
  even := by
    intro x
    show ∫ t : ℝ, g t * g (t + (-x)) = ∫ t : ℝ, g t * g (t + x)
    have h1 : ∫ t : ℝ, g t * g (t + (-x)) = ∫ u : ℝ, g (u + x) * g u := by
      rw [← integral_add_right_eq_self (fun t => g t * g (t + -x)) x]
      congr 1; ext u; ring_nf
    rw [h1]; congr 1; ext u; ring

-- Alias for the even property
lemma autocorrelation_even (g : EvenSchwartz) (x : ℝ) :
    (autocorrelation g) (-x) = (autocorrelation g) x :=
  (autocorrelation g).even x

end
