import Mathlib

set_option pp.all true
-- spec: Nat.isValidChar : Nat -> Prop
def Nat.isValidChar : Nat -> Prop :=
  fun (n : Nat) => Or (LT.lt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 55296 (instOfNatNat 55296))) (And (LT.lt.{0} Nat instLTNat (OfNat.ofNat.{0} Nat 57343 (instOfNatNat 57343)) n) (LT.lt.{0} Nat instLTNat n (OfNat.ofNat.{0} Nat 1114112 (instOfNatNat 1114112))))
