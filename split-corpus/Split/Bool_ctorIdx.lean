import Mathlib

set_option pp.all true
-- spec: Bool.ctorIdx : Bool -> Nat
def Bool.ctorIdx : Bool -> Nat :=
  fun (x : Bool) => Bool.casesOn.{1} (fun (x : Bool) => Nat) x 0 1
