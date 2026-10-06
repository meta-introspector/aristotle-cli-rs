import Mathlib

set_option pp.all true
-- spec: BitVec.and : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n)
def BitVec.and : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n) :=
  fun {n : Nat} (x : BitVec n) (y : BitVec n) => BitVec.ofNatLT n (HAnd.hAnd.{0, 0, 0} Nat Nat Nat (instHAndOfAndOp.{0} Nat Nat.instAndOp) (BitVec.toNat n x) (BitVec.toNat n y)) (BitVec.and._proof_1 n x y)
