import Mathlib

set_option pp.all true
-- spec: instDecidableEqUInt8 : DecidableEq.{1} UInt8
def instDecidableEqUInt8 : DecidableEq.{1} UInt8 :=
  UInt8.decEq
