import Mathlib

set_option pp.all true
-- spec: instAddUSize : Add.{0} USize
def instAddUSize : Add.{0} USize :=
  Add.mk.{0} USize USize.add
