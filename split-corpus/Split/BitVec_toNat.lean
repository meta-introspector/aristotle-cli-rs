import Mathlib

set_option pp.all true
-- spec: BitVec.toNat : forall {w : Nat}, (BitVec w) -> Nat
def BitVec.toNat : forall {w : Nat}, (BitVec w) -> Nat :=
  fun {w : Nat} (x : BitVec w) => Fin.val (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) w) (BitVec.toFin w x)
