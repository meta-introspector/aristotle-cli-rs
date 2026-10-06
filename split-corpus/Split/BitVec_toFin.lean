import Mathlib

set_option pp.all true
-- spec: BitVec.toFin : forall {w : Nat}, (BitVec w) -> (Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w))
def BitVec.toFin : forall {w : Nat}, (BitVec w) -> (Fin (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w)) :=
  fun (w : Nat) (self : BitVec w) => self.1
