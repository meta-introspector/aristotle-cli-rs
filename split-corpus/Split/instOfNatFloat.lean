import Mathlib

set_option pp.all true
-- spec: instOfNatFloat : forall {n : Nat}, OfNat.{0} Float n
def instOfNatFloat : forall {n : Nat}, OfNat.{0} Float n :=
  fun {n : Nat} => OfNat.mk.{0} Float n (Float.ofNat n)
