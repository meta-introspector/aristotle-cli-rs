import Mathlib

set_option pp.all true
-- spec: BitVec.instXorOp : forall {w : Nat}, XorOp.{0} (BitVec w)
def BitVec.instXorOp : forall {w : Nat}, XorOp.{0} (BitVec w) :=
  fun {w : Nat} => XorOp.mk.{0} (BitVec w) (BitVec.xor w)
