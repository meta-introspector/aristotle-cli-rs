import Mathlib

set_option pp.all true
-- spec: BitVec.instHShiftRight : forall {m : Nat} {n : Nat}, HShiftRight.{0, 0, 0} (BitVec m) (BitVec n) (BitVec m)
def BitVec.instHShiftRight : forall {m : Nat} {n : Nat}, HShiftRight.{0, 0, 0} (BitVec m) (BitVec n) (BitVec m) :=
  fun {m : Nat} {n : Nat} => HShiftRight.mk.{0, 0, 0} (BitVec m) (BitVec n) (BitVec m) (fun (x : BitVec m) (y : BitVec n) => HShiftRight.hShiftRight.{0, 0, 0} (BitVec m) Nat (BitVec m) (BitVec.instHShiftRightNat m) x (BitVec.toNat n y))
