import Mathlib

set_option pp.all true
-- spec: UInt32.instOfNat : forall {n : Nat}, OfNat.{0} UInt32 n
def UInt32.instOfNat : forall {n : Nat}, OfNat.{0} UInt32 n :=
  fun {n : Nat} => OfNat.mk.{0} UInt32 n (UInt32.ofNat n)
