import Mathlib

set_option pp.all true
-- spec: instDecidableEqBool : DecidableEq.{1} Bool
def instDecidableEqBool : DecidableEq.{1} Bool :=
  Bool.decEq
