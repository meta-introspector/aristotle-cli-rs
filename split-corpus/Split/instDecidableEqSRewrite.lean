import Mathlib

set_option pp.all true
-- spec: instDecidableEqSRewrite : DecidableEq.{1} SRewrite
def instDecidableEqSRewrite : DecidableEq.{1} SRewrite :=
  instDecidableEqSRewrite.decEq
