import Mathlib

set_option pp.all true
-- spec: BitVec.ushiftRight : forall {n : Nat}, (BitVec n) -> Nat -> (BitVec n)
def BitVec.ushiftRight : forall {n : Nat}, (BitVec n) -> Nat -> (BitVec n) :=
  fun {n : Nat} (x : BitVec n) (s : Nat) => BitVec.ofNatLT n (HShiftRight.hShiftRight.{0, 0, 0} Nat Nat Nat (instHShiftRightOfShiftRight.{0} Nat Nat.instShiftRight) (BitVec.toNat n x) s) (BitVec.ushiftRight._proof_3 n x s)
