import Mathlib

set_option pp.all true
-- spec: instLTUInt64 : LT.{0} UInt64
def instLTUInt64 : LT.{0} UInt64 :=
  LT.mk.{0} UInt64 UInt64.lt
