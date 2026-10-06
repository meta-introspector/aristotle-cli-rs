import Mathlib

set_option pp.all true
-- spec: Char.ofNat : Nat -> Char
def Char.ofNat : Nat -> Char :=
  fun (n : Nat) => dite.{1} Char (Nat.isValidChar n) (instDecidableOr (LT.lt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 55296 (instOfNatNat 55296))) (And (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 57343 (instOfNatNat 57343)) n) (LT.lt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 1114112 (instOfNatNat 1114112)))) (Nat.decLt n (OfNat.ofNat.{0} Nat 55296 (instOfNatNat 55296))) (instDecidableAnd (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 57343 (instOfNatNat 57343)) n) (LT.lt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 1114112 (instOfNatNat 1114112))) (Nat.decLt (OfNat.ofNat.{0} Nat 57343 (instOfNatNat 57343)) n) (Nat.decLt n (OfNat.ofNat.{0} Nat 1114112 (instOfNatNat 1114112))))) (fun (h : Nat.isValidChar n) => Char.ofNatAux n h) (fun (x._@.Init.Prelude.197636209._hygCtx._hyg.20 : Not (Nat.isValidChar n)) => Char.mk (UInt32.ofBitVec (BitVec.ofNatLT (OfNat.ofNat.{0} Nat 32 (instOfNatNat 32)) (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) Char.ofNat._proof_1)) Char.ofNat._proof_2)
