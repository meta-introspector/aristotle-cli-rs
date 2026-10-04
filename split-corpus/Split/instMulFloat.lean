import Mathlib

set_option pp.all true
-- spec: instMulFloat : Mul.{0} Float
def instMulFloat : Mul.{0} Float :=
  Mul.mk.{0} Float Float.mul
