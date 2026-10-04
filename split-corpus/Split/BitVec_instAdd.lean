import Mathlib

set_option pp.all true
-- spec: BitVec.instAdd : forall {n : Nat}, Add.{0} (BitVec n)
def BitVec.instAdd : forall {n : Nat}, Add.{0} (BitVec n) :=
  fun {n : Nat} => Add.mk.{0} (BitVec n) (BitVec.add n)
