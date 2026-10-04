import Mathlib

set_option pp.all true
-- spec: BitVec.add : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n)
def BitVec.add : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n) :=
  fun {n : Nat} (x : BitVec n) (y : BitVec n) => BitVec.ofNat n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (BitVec.toNat n x) (BitVec.toNat n y))
