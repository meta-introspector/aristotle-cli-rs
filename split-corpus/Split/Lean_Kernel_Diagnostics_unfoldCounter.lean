import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Diagnostics.unfoldCounter : Lean.Kernel.Diagnostics -> (Lean.PHashMap.{0, 0} Lean.Name Nat Lean.Name.instBEq Lean.instHashableName)
def Lean.Kernel.Diagnostics.unfoldCounter : Lean.Kernel.Diagnostics -> (Lean.PHashMap.{0, 0} Lean.Name Nat Lean.Name.instBEq Lean.instHashableName) :=
  fun (self : Lean.Kernel.Diagnostics) => self.1
