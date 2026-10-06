import Mathlib

set_option pp.all true
-- spec: instShiftRightUInt64 : ShiftRight.{0} UInt64
def instShiftRightUInt64 : ShiftRight.{0} UInt64 :=
  ShiftRight.mk.{0} UInt64 UInt64.shiftRight
