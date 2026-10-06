import Mathlib

set_option pp.all true
-- spec: Nat.instShiftRight : ShiftRight.{0} Nat
def Nat.instShiftRight : ShiftRight.{0} Nat :=
  ShiftRight.mk.{0} Nat Nat.shiftRight
