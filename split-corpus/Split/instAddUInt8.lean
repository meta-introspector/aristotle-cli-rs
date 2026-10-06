import Mathlib

set_option pp.all true
-- spec: instAddUInt8 : Add.{0} UInt8
def instAddUInt8 : Add.{0} UInt8 :=
  Add.mk.{0} UInt8 UInt8.add
