import Mathlib

set_option pp.all true
-- spec: Lean.AsyncConstantInfo.toConstantVal : Lean.AsyncConstantInfo -> Lean.ConstantVal
def Lean.AsyncConstantInfo.toConstantVal : Lean.AsyncConstantInfo -> Lean.ConstantVal :=
  fun (c : Lean.AsyncConstantInfo) => Task.get.{0} Lean.ConstantVal (Lean.AsyncConstantInfo.sig c)
