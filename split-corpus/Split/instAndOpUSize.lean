import Mathlib

set_option pp.all true
-- spec: instAndOpUSize : AndOp.{0} USize
def instAndOpUSize : AndOp.{0} USize :=
  AndOp.mk.{0} USize USize.land
