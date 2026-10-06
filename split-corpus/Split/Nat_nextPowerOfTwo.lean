import Mathlib

set_option pp.all true
-- spec: Nat.nextPowerOfTwo : Nat -> Nat
def Nat.nextPowerOfTwo : Nat -> Nat :=
  fun (n : Nat) => _private.Init.Data.Nat.Power2.Basic.0.Nat.nextPowerOfTwo.go n (OfNat.ofNat.{0} Nat 1 (instOfNatNat 1)) _private.Init.Data.Nat.Power2.Basic.0.Nat.nextPowerOfTwo._proof_1
