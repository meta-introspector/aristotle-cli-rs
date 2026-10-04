import Mathlib

set_option pp.all true
-- spec: instNatPowNat : NatPow.{0} Nat
def instNatPowNat : NatPow.{0} Nat :=
  NatPow.mk.{0} Nat Nat.pow
