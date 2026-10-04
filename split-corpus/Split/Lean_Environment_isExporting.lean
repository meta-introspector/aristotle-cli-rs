import Mathlib

set_option pp.all true
-- spec: Lean.Environment.isExporting : Lean.Environment -> Bool
def Lean.Environment.isExporting : Lean.Environment -> Bool :=
  fun (self : Lean.Environment) => self.9
