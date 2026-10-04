import Mathlib

set_option pp.all true
-- spec: instDecidableEqSomething : DecidableEq.{1} Something
def instDecidableEqSomething : DecidableEq.{1} Something :=
  instDecidableEqSomething.decEq
