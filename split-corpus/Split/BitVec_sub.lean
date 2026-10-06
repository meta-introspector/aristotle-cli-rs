import Mathlib

set_option pp.all true
-- spec: BitVec.sub : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n)
def BitVec.sub : forall {n : Nat}, (BitVec n) -> (BitVec n) -> (BitVec n) :=
  fun {n : Nat} (x : BitVec n) (y : BitVec n) => BitVec.ofNat n (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) n) (BitVec.toNat n y)) (BitVec.toNat n x))
