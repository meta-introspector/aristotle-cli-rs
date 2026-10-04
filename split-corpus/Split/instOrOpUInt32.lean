import Mathlib

set_option pp.all true
-- spec: instOrOpUInt32 : OrOp.{0} UInt32
def instOrOpUInt32 : OrOp.{0} UInt32 :=
  OrOp.mk.{0} UInt32 UInt32.lor
