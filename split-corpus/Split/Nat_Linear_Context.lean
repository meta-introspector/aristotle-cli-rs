import Mathlib

set_option pp.all true
-- spec: Nat.Linear.Context : Type
def Nat.Linear.Context : Type :=
  Lean.RArray.{0} Nat
