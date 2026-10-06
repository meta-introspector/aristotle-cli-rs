import Mathlib

set_option pp.all true
-- spec: Char.toUInt8 : Char -> UInt8
def Char.toUInt8 : Char -> UInt8 :=
  fun (c : Char) => UInt32.toUInt8 (Char.val c)
