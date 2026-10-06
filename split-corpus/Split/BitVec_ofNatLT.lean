import Mathlib

set_option pp.all true
-- spec: BitVec.ofNatLT : forall {w : Nat} (i : Nat), (LT.lt.{0} Nat instLTNat i (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)) -> (BitVec w)
def BitVec.ofNatLT : forall {w : Nat} (i : Nat), (LT.lt.{0} Nat instLTNat i (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)) -> (BitVec w) :=
  fun {w : Nat} (i : Nat) (p : LT.lt.{0} Nat instLTNat i (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)) => BitVec.ofFin w (Fin.mk (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w) i p)
