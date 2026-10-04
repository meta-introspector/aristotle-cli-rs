import Mathlib

set_option pp.all true
-- spec: instDecidableEqUInt32 : DecidableEq.{1} UInt32
def instDecidableEqUInt32 : DecidableEq.{1} UInt32 :=
  UInt32.decEq
