import Mathlib

set_option pp.all true
-- spec: instMulNat : Mul.{0} Nat
def instMulNat : Mul.{0} Nat :=
  Mul.mk.{0} Nat Nat.mul
