import Mathlib

set_option pp.all true
-- spec: Char.instLT : LT.{0} Char
def Char.instLT : LT.{0} Char :=
  LT.mk.{0} Char Char.lt
