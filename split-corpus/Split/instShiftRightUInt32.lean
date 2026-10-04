import Mathlib

set_option pp.all true
-- spec: instShiftRightUInt32 : ShiftRight.{0} UInt32
def instShiftRightUInt32 : ShiftRight.{0} UInt32 :=
  ShiftRight.mk.{0} UInt32 UInt32.shiftRight
