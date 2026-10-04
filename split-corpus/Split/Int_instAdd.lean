import Mathlib

set_option pp.all true
-- spec: Int.instAdd : Add.{0} Int
def Int.instAdd : Add.{0} Int :=
  Add.mk.{0} Int Int.add
