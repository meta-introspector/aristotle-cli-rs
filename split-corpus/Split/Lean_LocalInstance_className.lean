import Mathlib

set_option pp.all true
-- spec: Lean.LocalInstance.className : Lean.LocalInstance -> Lean.Name
def Lean.LocalInstance.className : Lean.LocalInstance -> Lean.Name :=
  fun (self : Lean.LocalInstance) => self.1
