import Mathlib

set_option pp.all true
-- spec: BitVec.instOfNat : forall {n : Nat} {i : Nat}, OfNat.{0} (BitVec n) i
def BitVec.instOfNat : forall {n : Nat} {i : Nat}, OfNat.{0} (BitVec n) i :=
  fun {n : Nat} {i : Nat} => OfNat.mk.{0} (BitVec n) i (BitVec.ofNat n i)
