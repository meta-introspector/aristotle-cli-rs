import Mathlib

set_option pp.all true
-- spec: Int.instDecidableEq : DecidableEq.{1} Int
def Int.instDecidableEq : DecidableEq.{1} Int :=
  Int.decEq
