import Mathlib

set_option pp.all true
-- spec: instDecidableEqString : DecidableEq.{1} String
def instDecidableEqString : DecidableEq.{1} String :=
  String.decEq
