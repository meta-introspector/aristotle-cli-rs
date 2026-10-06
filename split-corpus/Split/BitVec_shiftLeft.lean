import Mathlib

set_option pp.all true
-- spec: BitVec.shiftLeft : forall {n : Nat}, (BitVec n) -> Nat -> (BitVec n)
def BitVec.shiftLeft : forall {n : Nat}, (BitVec n) -> Nat -> (BitVec n) :=
  fun {n : Nat} (x : BitVec n) (s : Nat) => BitVec.ofNat n (HShiftLeft.hShiftLeft.{0, 0, 0} Nat Nat Nat (instHShiftLeftOfShiftLeft.{0} Nat Nat.instShiftLeft) (BitVec.toNat n x) s)
