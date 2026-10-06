import Mathlib

set_option pp.all true
-- spec: Nat.instShiftLeft : ShiftLeft.{0} Nat
def Nat.instShiftLeft : ShiftLeft.{0} Nat :=
  ShiftLeft.mk.{0} Nat Nat.shiftLeft
