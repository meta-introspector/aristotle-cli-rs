import Mathlib

set_option pp.all true
-- spec: Lean.AsyncConstantInfo.constInfo : Lean.AsyncConstantInfo -> (Task.{0} Lean.ConstantInfo)
def Lean.AsyncConstantInfo.constInfo : Lean.AsyncConstantInfo -> (Task.{0} Lean.ConstantInfo) :=
  fun (self : Lean.AsyncConstantInfo) => self.4
