import Mathlib

set_option pp.all true
-- spec: Trinity.ctorIdx : Trinity -> Nat
def Trinity.ctorIdx : Trinity -> Nat :=
  fun (x : Trinity) => Trinity.casesOn.{1} (fun (x : Trinity) => Nat) x 0 (fun (a._@._internal._hyg.0 : Something) (a._@._internal._hyg.0 : Something) (a._@._internal._hyg.0 : Something) => 1)
