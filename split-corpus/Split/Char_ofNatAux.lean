import Mathlib

set_option pp.all true
-- spec: Char.ofNatAux : forall (n : [mdata borrowed:1 Nat]), (Nat.isValidChar n) -> Char
def Char.ofNatAux : forall (n : [mdata borrowed:1 Nat]), (Nat.isValidChar n) -> Char :=
  fun (n : Nat) (h : Nat.isValidChar n) => Char.mk (UInt32.ofBitVec (BitVec.ofNatLT (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) n (Char.ofNatAux._private_1 n h))) h
