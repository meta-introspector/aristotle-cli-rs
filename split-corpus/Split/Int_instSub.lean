import Mathlib

set_option pp.all true
-- spec: Int.instSub : Sub.{0} Int
def Int.instSub : Sub.{0} Int :=
  Sub.mk.{0} Int Int.sub
