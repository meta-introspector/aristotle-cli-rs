import Mathlib

set_option pp.all true
-- spec: instAddUInt32 : Add.{0} UInt32
def instAddUInt32 : Add.{0} UInt32 :=
  Add.mk.{0} UInt32 UInt32.add
