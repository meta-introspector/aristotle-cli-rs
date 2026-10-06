import Mathlib

set_option pp.all true
-- spec: instSubFloat : Sub.{0} Float
def instSubFloat : Sub.{0} Float :=
  Sub.mk.{0} Float Float.sub
