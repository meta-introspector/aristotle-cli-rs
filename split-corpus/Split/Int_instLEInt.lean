import Mathlib

set_option pp.all true
-- spec: Int.instLEInt : LE.{0} Int
def Int.instLEInt : LE.{0} Int :=
  LE.mk.{0} Int Int.le
