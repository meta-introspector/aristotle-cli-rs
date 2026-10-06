import Mathlib

set_option pp.all true
-- spec: Int.instLTInt : LT.{0} Int
def Int.instLTInt : LT.{0} Int :=
  LT.mk.{0} Int Int.lt
