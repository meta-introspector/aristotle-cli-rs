import Mathlib

set_option pp.all true
-- spec: Duality.ctorIdx : Duality -> Nat
def Duality.ctorIdx : Duality -> Nat :=
  fun (x : Duality) => Duality.casesOn.{1} (fun (x : Duality) => Nat) x 0 1 2 3 4 5 (fun (a._@._internal._hyg.0 : Something) (a._@._internal._hyg.0 : Something) => 6) (fun (a._@._internal._hyg.0 : Something) (a._@._internal._hyg.0 : Something) => 7)
