import Mathlib

set_option pp.all true
-- spec: BitVec.instSub : forall {n : Nat}, Sub.{0} (BitVec n)
def BitVec.instSub : forall {n : Nat}, Sub.{0} (BitVec n) :=
  fun {n : Nat} => Sub.mk.{0} (BitVec n) (BitVec.sub n)
