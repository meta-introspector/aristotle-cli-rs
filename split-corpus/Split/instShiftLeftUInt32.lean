import Mathlib

set_option pp.all true
-- spec: instShiftLeftUInt32 : ShiftLeft.{0} UInt32
def instShiftLeftUInt32 : ShiftLeft.{0} UInt32 :=
  ShiftLeft.mk.{0} UInt32 UInt32.shiftLeft
