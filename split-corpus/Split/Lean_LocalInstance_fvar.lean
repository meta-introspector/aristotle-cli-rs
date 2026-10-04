import Mathlib

set_option pp.all true
-- spec: Lean.LocalInstance.fvar : Lean.LocalInstance -> Lean.Expr
def Lean.LocalInstance.fvar : Lean.LocalInstance -> Lean.Expr :=
  fun (self : Lean.LocalInstance) => self.2
