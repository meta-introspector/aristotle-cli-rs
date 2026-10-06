import Mathlib

set_option pp.all true
-- spec: Nat.instDvd : Dvd.{0} Nat
def Nat.instDvd : Dvd.{0} Nat :=
  Dvd.mk.{0} Nat (fun (a : Nat) (b : Nat) => Exists.{1} Nat (fun (c : Nat) => Eq.{1} Nat b (HMul.hMul.{0, 0, 0} Nat Nat Nat (instHMul.{0} Nat instMulNat) a c)))
