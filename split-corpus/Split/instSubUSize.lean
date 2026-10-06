import Mathlib

set_option pp.all true
-- spec: instSubUSize : Sub.{0} USize
def instSubUSize : Sub.{0} USize :=
  Sub.mk.{0} USize USize.sub
