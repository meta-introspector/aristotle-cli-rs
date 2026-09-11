import Mathlib
import RequestProject.Imported.Loose.DulaViazovska
import RequestProject.Imported.Loose.KernelSummation

/-!
# Poisson Rigidity stub
Provides `lattice_density` and `lattice_density_pos`.
-/

open Real

/-- The packing density of the densest lattice in dimension `d`. -/
noncomputable def lattice_density (d : ℕ) : ℝ :=
  if d = 24 then Real.pi ^ 12 / Nat.factorial 12
  else if d = 8 then Real.pi ^ 4 / (16 * Nat.factorial 4)
  else if d = 4 then Real.pi ^ 2 / 16
  else 0

lemma lattice_density_pos {d : ℕ} (hd : d ∈ ({4, 8, 24} : Set ℕ)) :
    lattice_density d > 0 := by
  simp only [Set.mem_insert_iff, Set.mem_singleton_iff] at hd
  rcases hd with rfl | rfl | rfl <;> simp [lattice_density] <;> positivity
