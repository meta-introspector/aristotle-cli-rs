import Mathlib

set_option pp.all true
-- spec: Lean.AsyncConstantInfo.kind : Lean.AsyncConstantInfo -> Lean.ConstantKind
def Lean.AsyncConstantInfo.kind : Lean.AsyncConstantInfo -> Lean.ConstantKind :=
  fun (self : Lean.AsyncConstantInfo) => self.2
