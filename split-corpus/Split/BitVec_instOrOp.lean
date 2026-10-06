import Mathlib

set_option pp.all true
-- spec: BitVec.instOrOp : forall {w : Nat}, OrOp.{0} (BitVec w)
def BitVec.instOrOp : forall {w : Nat}, OrOp.{0} (BitVec w) :=
  fun {w : Nat} => OrOp.mk.{0} (BitVec w) (BitVec.or w)
