import Mathlib

set_option pp.all true
-- spec: instAndOpUInt8 : AndOp.{0} UInt8
def instAndOpUInt8 : AndOp.{0} UInt8 :=
  AndOp.mk.{0} UInt8 UInt8.land
