import Mathlib

set_option pp.all true
-- spec: Int.instNegInt : Neg.{0} Int
def Int.instNegInt : Neg.{0} Int :=
  Neg.mk.{0} Int Int.neg
