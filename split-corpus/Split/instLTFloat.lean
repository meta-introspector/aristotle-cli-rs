import Mathlib

set_option pp.all true
-- spec: instLTFloat : LT.{0} Float
def instLTFloat : LT.{0} Float :=
  LT.mk.{0} Float Float.lt
