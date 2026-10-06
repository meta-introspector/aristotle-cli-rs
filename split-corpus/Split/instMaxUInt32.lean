import Mathlib

set_option pp.all true
-- spec: instMaxUInt32 : Max.{0} UInt32
def instMaxUInt32 : Max.{0} UInt32 :=
  maxOfLe.{0} UInt32 instLEUInt32 UInt32.decLe
