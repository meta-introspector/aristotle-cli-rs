import Mathlib

set_option pp.all true
-- spec: Nat.toDigits : Nat -> Nat -> (List.{0} Char)
def Nat.toDigits : Nat -> Nat -> (List.{0} Char) :=
  fun (base : Nat) (n : Nat) => Nat.toDigitsCore base (HAdd.hAdd.{0, 0, 0} Nat Nat Nat (instHAdd.{0} Nat instAddNat) n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1))) n (List.nil.{0} Char)
