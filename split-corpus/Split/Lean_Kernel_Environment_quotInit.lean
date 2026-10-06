import Mathlib

set_option pp.all true
-- spec: Lean.Kernel.Environment.quotInit : Lean.Kernel.Environment -> Bool
def Lean.Kernel.Environment.quotInit : Lean.Kernel.Environment -> Bool :=
  fun (self : Lean.Kernel.Environment) => self.2
