import Mathlib

set_option pp.all true
-- spec: instOfNatNat : forall (n : Nat), OfNat.{0} Nat n
def instOfNatNat : forall (n : Nat), OfNat.{0} Nat n :=
  fun (n : Nat) => OfNat.mk.{0} Nat n n
