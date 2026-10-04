import Mathlib

set_option pp.all true
-- spec: UInt8.instOfNat : forall {n : Nat}, OfNat.{0} UInt8 n
def UInt8.instOfNat : forall {n : Nat}, OfNat.{0} UInt8 n :=
  fun {n : Nat} => OfNat.mk.{0} UInt8 n (UInt8.ofNat n)
