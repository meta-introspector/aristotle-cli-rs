import Mathlib

set_option pp.all true
-- spec: BitVec.instMod : forall {n : Nat}, Mod.{0} (BitVec n)
def BitVec.instMod : forall {n : Nat}, Mod.{0} (BitVec n) :=
  fun {n : Nat} => Mod.mk.{0} (BitVec n) (BitVec.umod n)
