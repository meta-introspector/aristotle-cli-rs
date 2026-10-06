import Mathlib

set_option pp.all true
-- spec: Lean.AsyncConstantInfo.sig : Lean.AsyncConstantInfo -> (Task.{0} Lean.ConstantVal)
def Lean.AsyncConstantInfo.sig : Lean.AsyncConstantInfo -> (Task.{0} Lean.ConstantVal) :=
  fun (self : Lean.AsyncConstantInfo) => self.3
