import Mathlib
import RequestProject.Imported.SanityCheckEisensteinOrbit.EisensteinIntegers_Root

/-!
# Bridge definitions for the Eisenstein theta function

Defines `θ = 1 - ω`, the generator of the unique prime above 3 in `ℤ[ω]`.
-/

namespace EisensteinThetaBridge

open Eisenstein

/-- `θ = 1 - ω = ⟨1, -1⟩`. -/
def θ : Eisenstein := ⟨1, -1⟩

end EisensteinThetaBridge
