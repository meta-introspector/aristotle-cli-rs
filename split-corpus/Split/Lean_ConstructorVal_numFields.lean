import Mathlib

set_option pp.all true
-- spec: Lean.ConstructorVal.numFields : Lean.ConstructorVal -> Nat
def Lean.ConstructorVal.numFields : Lean.ConstructorVal -> Nat :=
  fun (self : Lean.ConstructorVal) => self.5
