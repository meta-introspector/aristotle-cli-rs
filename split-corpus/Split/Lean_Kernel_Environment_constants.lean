import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Environment.constants : Lean.Kernel.Environment -> Lean.ConstMap
def Lean.Kernel.Environment.constants : Lean.Kernel.Environment -> Lean.ConstMap :=
  fun (self : Lean.Kernel.Environment) => self.1
