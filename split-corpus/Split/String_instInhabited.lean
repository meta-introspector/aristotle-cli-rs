import Mathlib

set_option pp.all true
-- spec: String.instInhabited : Inhabited.{1} String
def String.instInhabited : Inhabited.{1} String :=
  Inhabited.mk.{1} String ""
