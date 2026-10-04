import Mathlib

set_option pp.all true
-- spec: Lean.AsyncConstantInfo.ofConstantInfo : Lean.ConstantInfo -> Lean.AsyncConstantInfo
def Lean.AsyncConstantInfo.ofConstantInfo : Lean.ConstantInfo -> Lean.AsyncConstantInfo :=
  fun (c : Lean.ConstantInfo) => Lean.AsyncConstantInfo.mk (Lean.ConstantInfo.name c) (Lean.ConstantKind.ofConstantInfo c) (Task.pure.{0} Lean.ConstantVal (Lean.ConstantInfo.toConstantVal c)) (Task.pure.{0} Lean.ConstantInfo c)
