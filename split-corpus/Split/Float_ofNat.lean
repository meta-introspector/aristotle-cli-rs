import Mathlib

set_option pp.all true
-- spec: Float.ofNat : Nat -> Float
def Float.ofNat : Nat -> Float :=
  fun (n : Nat) => OfScientific.ofScientific.{0} Float instOfScientificFloat n Bool.false (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
