import Mathlib

set_option pp.all true
-- spec: instReprSomething : Repr.{0} Something
def instReprSomething : Repr.{0} Something :=
  Repr.mk.{0} Something instReprSomething.repr
