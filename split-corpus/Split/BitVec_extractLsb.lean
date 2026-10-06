import Mathlib

set_option pp.all true
-- spec: BitVec.extractLsb : forall {n : Nat} (hi : Nat) (lo : Nat), (BitVec n) -> (BitVec (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) hi lo) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))))
def BitVec.extractLsb : forall {n : Nat} (hi : Nat) (lo : Nat), (BitVec n) -> (BitVec (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) hi lo) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)))) :=
  fun {n : Nat} (hi : Nat) (lo : Nat) (x : BitVec n) => BitVec.extractLsb' n lo (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) (HSub.hSub.{0, 0, 0} Nat Nat Nat (instHSub.{0} Nat instSubNat) hi lo) (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) x
