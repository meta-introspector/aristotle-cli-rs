import Mathlib

set_option pp.all true
-- spec: BitVec.instHShiftRightNat : forall {w : Nat}, HShiftRight.{0, 0, 0} (BitVec w) Nat (BitVec w)
def BitVec.instHShiftRightNat : forall {w : Nat}, HShiftRight.{0, 0, 0} (BitVec w) Nat (BitVec w) :=
  fun {w : Nat} => HShiftRight.mk.{0, 0, 0} (BitVec w) Nat (BitVec w) (BitVec.ushiftRight w)
