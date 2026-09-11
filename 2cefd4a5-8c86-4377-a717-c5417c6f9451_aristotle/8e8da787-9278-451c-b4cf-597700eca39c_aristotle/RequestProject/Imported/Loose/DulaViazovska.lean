import Mathlib

/-!
# Dula-Viazovska Framework: Core Definitions
-/

open Real Complex

/-- The Dula spectral buffer constant B = 28.87. -/
noncomputable def dula_spectral_buffer : ℝ := 28.87

/-- The magic function h*(t, k) from the Dula-Viazovska framework. -/
noncomputable def dula_h_star (t k : ℝ) : ℂ :=
  ⟨29.4525 * Real.exp (-(t - k)^2), 0⟩

/-- The Dirichlet character χ₃ (mod 3) as an arithmetic function. -/
noncomputable def chi3 : ℕ → ℂ := fun n =>
  if n % 3 = 1 then 1
  else if n % 3 = 2 then -1
  else 0
