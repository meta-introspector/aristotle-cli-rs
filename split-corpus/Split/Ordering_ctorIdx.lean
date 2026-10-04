import Mathlib

set_option pp.all true
-- spec: Ordering.ctorIdx : Ordering -> Nat
def Ordering.ctorIdx : Ordering -> Nat :=
  fun (x : Ordering) => Ordering.casesOn.{1} (fun (x : Ordering) => Nat) x 0 1 2
