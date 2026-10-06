import Mathlib

set_option pp.all true
-- spec: instAddFloat : Add.{0} Float
def instAddFloat : Add.{0} Float :=
  Add.mk.{0} Float Float.add
