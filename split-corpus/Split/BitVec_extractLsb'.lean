import Mathlib

set_option pp.all true
-- spec: BitVec.extractLsb' : forall {n : Nat}, Nat -> (forall (len : Nat), (BitVec n) -> (BitVec len))
def BitVec.extractLsb' : forall {n : Nat}, Nat -> (forall (len : Nat), (BitVec n) -> (BitVec len)) :=
  fun {n : Nat} (start : Nat) (len : Nat) (x : BitVec n) => BitVec.ofNat len (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) (BitVec.toNat n x) start)
