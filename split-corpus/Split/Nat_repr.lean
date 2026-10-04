import Mathlib

set_option pp.all true
-- spec: Nat.repr : Nat -> String
def Nat.repr : Nat -> String :=
  fun (n : Nat) => String.ofList (Nat.toDigits (OfNat.ofNat.{0} Nat 10 (instOfNatNat 10)) n)
