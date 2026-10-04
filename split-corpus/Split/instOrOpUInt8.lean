import Mathlib

set_option pp.all true
-- spec: instOrOpUInt8 : OrOp.{0} UInt8
def instOrOpUInt8 : OrOp.{0} UInt8 :=
  OrOp.mk.{0} UInt8 UInt8.lor
