import Mathlib
import RequestProject.Imported.SanityCheckEisensteinOrbit.EisensteinIntegers_Root

/-!
# Units of the Eisenstein integers

The six units of `ℤ[ω]`: `{1, -1, ω, -ω, ω², -ω²}`.
-/

namespace EisensteinUnits

open Eisenstein

/-- The set of all 6 units in `ℤ[ω]`, as a `Finset`. -/
def unitSet : Finset Eisenstein :=
  {⟨1, 0⟩, ⟨-1, 0⟩, ⟨0, 1⟩, ⟨0, -1⟩, ⟨-1, -1⟩, ⟨1, 1⟩}

/-- `unitSet` has exactly 6 elements. -/
theorem unitSet_card : unitSet.card = 6 := by native_decide

end EisensteinUnits
