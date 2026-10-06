import Mathlib

set_option pp.all true
-- spec: BitVec.instHShiftLeftNat : forall {w : Nat}, HShiftLeft.{0, 0, 0} (BitVec w) Nat (BitVec w)
def BitVec.instHShiftLeftNat : forall {w : Nat}, HShiftLeft.{0, 0, 0} (BitVec w) Nat (BitVec w) :=
  fun {w : Nat} => HShiftLeft.mk.{0, 0, 0} (BitVec w) Nat (BitVec w) (BitVec.shiftLeft w)
