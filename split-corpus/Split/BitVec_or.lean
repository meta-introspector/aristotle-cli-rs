import Mathlib

set_option pp.all true
-- spec: BitVec.or : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n)
def BitVec.or : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n) :=
  fun {n : Nat} (x : BitVec n) (y : BitVec n) => BitVec.ofNatLT n (HOr.hOr.{0, 0, 0} Nat Nat Nat (instHOrOfOrOp.{0} Nat Nat.instOrOp) (BitVec.toNat n x) (BitVec.toNat n y)) (BitVec.or._proof_1 n x y)
