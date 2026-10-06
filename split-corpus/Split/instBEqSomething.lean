import Mathlib

set_option pp.all true
-- spec: instBEqSomething : BEq.{0} Something
def instBEqSomething : BEq.{0} Something :=
  BEq.mk.{0} Something instBEqSomething.beq
