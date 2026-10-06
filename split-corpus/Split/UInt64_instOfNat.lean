import Mathlib

set_option pp.all true
-- spec: UInt64.instOfNat : forall {n : Nat}, OfNat.{0} UInt64 n
def UInt64.instOfNat : forall {n : Nat}, OfNat.{0} UInt64 n :=
  fun {n : Nat} => OfNat.mk.{0} UInt64 n (UInt64.ofNat n)
