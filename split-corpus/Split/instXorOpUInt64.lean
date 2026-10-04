import Mathlib

set_option pp.all true
-- spec: instXorOpUInt64 : XorOp.{0} UInt64
def instXorOpUInt64 : XorOp.{0} UInt64 :=
  XorOp.mk.{0} UInt64 UInt64.xor
