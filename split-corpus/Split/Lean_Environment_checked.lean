import Mathlib

set_option pp.all true
-- spec: Lean.Environment.checked : Lean.Environment -> (Task.{0} Lean.Kernel.Environment)
def Lean.Environment.checked : Lean.Environment -> (Task.{0} Lean.Kernel.Environment) :=
  fun (self : Lean.Environment) => self.3
