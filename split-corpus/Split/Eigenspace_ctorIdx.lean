import Mathlib

set_option pp.all true
-- spec: Eigenspace.ctorIdx : Eigenspace -> Nat
def Eigenspace.ctorIdx : Eigenspace -> Nat :=
  fun (x : Eigenspace) => Eigenspace.casesOn.{1} (fun (x : Eigenspace) => Nat) x 0 1 2 3
