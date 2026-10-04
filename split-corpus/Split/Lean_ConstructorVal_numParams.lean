import Mathlib

set_option pp.all true
-- spec: Lean.ConstructorVal.numParams : Lean.ConstructorVal -> Nat
def Lean.ConstructorVal.numParams : Lean.ConstructorVal -> Nat :=
  fun (self : Lean.ConstructorVal) => self.4
