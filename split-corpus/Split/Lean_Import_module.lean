import Mathlib

set_option pp.all true
-- spec: Lean.Import.module : Lean.Import -> Lean.Name
def Lean.Import.module : Lean.Import -> Lean.Name :=
  fun (self : Lean.Import) => self.1
