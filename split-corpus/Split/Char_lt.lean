import Mathlib

set_option pp.all true
-- spec: Char.lt : Char -> Char -> Prop
def Char.lt : Char -> Char -> Prop :=
  fun (a : Char) (b : Char) => LT.lt.{0} UInt32 instLTUInt32 (Char.val a) (Char.val b)
