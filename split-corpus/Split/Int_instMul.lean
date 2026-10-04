import Mathlib

set_option pp.all true
-- spec: Int.instMul : Mul.{0} Int
def Int.instMul : Mul.{0} Int :=
  Mul.mk.{0} Int Int.mul
