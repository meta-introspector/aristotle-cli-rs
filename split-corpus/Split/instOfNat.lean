import Mathlib

set_option pp.all true
-- spec: instOfNat : forall {n : Nat}, OfNat.{0} Int n
def instOfNat : forall {n : Nat}, OfNat.{0} Int n :=
  fun {n : Nat} => OfNat.mk.{0} Int n (Int.ofNat n)
