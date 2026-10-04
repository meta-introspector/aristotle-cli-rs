import Mathlib

set_option pp.all true
-- spec: BitVec.instHShiftLeft : forall {m : Nat} {n : Nat}, HShiftLeft.{0, 0, 0} (BitVec m) (BitVec n) (BitVec m)
def BitVec.instHShiftLeft : forall {m : Nat} {n : Nat}, HShiftLeft.{0, 0, 0} (BitVec m) (BitVec n) (BitVec m) :=
  fun {m : Nat} {n : Nat} => HShiftLeft.mk.{0, 0, 0} (BitVec m) (BitVec n) (BitVec m) (fun (x : BitVec m) (y : BitVec n) => HShiftLeft.hShiftLeft.{0, 0, 0} (BitVec m) Nat (BitVec m) (BitVec.instHShiftLeftNat m) x (BitVec.toNat n y))
