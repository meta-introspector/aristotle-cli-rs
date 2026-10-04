import Mathlib

set_option pp.all true
-- spec: BitVec.umod : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n)
def BitVec.umod : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n) :=
  fun {n : Nat} (x : BitVec n) (y : BitVec n) => BitVec.ofNatLT n (HMod.hMod.{0, 0, 0} Nat Nat Nat (instHMod.{0} Nat Nat.instMod) (BitVec.toNat n x) (BitVec.toNat n y)) (BitVec.umod._proof_1 n x y)
