import Mathlib

set_option pp.all true
-- spec: BitVec.ofNat : forall (n : Nat), Nat -> (BitVec n)
def BitVec.ofNat : forall (n : Nat), Nat -> (BitVec n) :=
  fun (n : Nat) (i : Nat) => BitVec.ofFin n (Fin.Internal.ofNat (HPow.hPow.{0, 0, 0} Nat Nat Nat (instHPow.{0, 0} Nat Nat (instPowNat.{0} Nat instNatPowNat)) (OfNat.ofNat.{0} Nat 2 (instOfNatNat 2)) n) (BitVec.ofNat._proof_1 n) i)
