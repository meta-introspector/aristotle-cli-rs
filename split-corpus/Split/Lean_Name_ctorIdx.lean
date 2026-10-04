import Mathlib

set_option pp.all true
-- spec: Lean.Name.ctorIdx : Lean.Name -> Nat
def Lean.Name.ctorIdx : Lean.Name -> Nat :=
  fun (x : Lean.Name) => Lean.Name.casesOn.{1} (fun (x : Lean.Name) => Nat) x 0 (fun (pre : Lean.Name) (str : String) => 1) (fun (pre : Lean.Name) (i : Nat) => 2)
