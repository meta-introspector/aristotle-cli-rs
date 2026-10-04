import Mathlib

set_option pp.all true
-- spec: Lean.Name.mkNum : Lean.Name -> Nat -> Lean.Name
def Lean.Name.mkNum : Lean.Name -> Nat -> Lean.Name :=
  fun (p : Lean.Name) (v : Nat) => Lean.Name.num p v
