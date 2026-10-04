import Mathlib

set_option pp.all true
-- spec: USize.instOfNat : forall {n : Nat}, OfNat.{0} USize n
def USize.instOfNat : forall {n : Nat}, OfNat.{0} USize n :=
  fun {n : Nat} => OfNat.mk.{0} USize n (USize.ofNat n)
