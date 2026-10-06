import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Diagnostics.enabled : Lean.Kernel.Diagnostics -> Bool
def Lean.Kernel.Diagnostics.enabled : Lean.Kernel.Diagnostics -> Bool :=
  fun (self : Lean.Kernel.Diagnostics) => self.2
