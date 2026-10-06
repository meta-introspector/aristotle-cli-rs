import Mathlib

set_option pp.all true
-- spec: BitVec.instAndOp : forall {w : Nat}, AndOp.{0} (BitVec w)
def BitVec.instAndOp : forall {w : Nat}, AndOp.{0} (BitVec w) :=
  fun {w : Nat} => AndOp.mk.{0} (BitVec w) (BitVec.and w)
