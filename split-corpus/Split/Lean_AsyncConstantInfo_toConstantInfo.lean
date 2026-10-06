import Mathlib

set_option pp.all true
-- spec: Lean.AsyncConstantInfo.toConstantInfo : Lean.AsyncConstantInfo -> Lean.ConstantInfo
def Lean.AsyncConstantInfo.toConstantInfo : Lean.AsyncConstantInfo -> Lean.ConstantInfo :=
  fun (c : Lean.AsyncConstantInfo) => Task.get.{0} Lean.ConstantInfo (Lean.AsyncConstantInfo.constInfo c)
