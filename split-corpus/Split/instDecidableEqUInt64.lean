import Mathlib

set_option pp.all true
-- spec: instDecidableEqUInt64 : DecidableEq.{1} UInt64
def instDecidableEqUInt64 : DecidableEq.{1} UInt64 :=
  UInt64.decEq
