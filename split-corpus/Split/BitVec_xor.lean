import Mathlib

set_option pp.all true
-- spec: BitVec.xor : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n)
def BitVec.xor : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n) :=
  fun {n : Nat} (x : BitVec n) (y : BitVec n) => BitVec.ofNatLT n (HXor.hXor.{0, 0, 0} Nat Nat Nat (instHXorOfXorOp.{0} Nat Nat.instXorOp) (BitVec.toNat n x) (BitVec.toNat n y)) (BitVec.xor._proof_1 n x y)
