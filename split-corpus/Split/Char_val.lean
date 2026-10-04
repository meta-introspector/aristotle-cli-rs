import Mathlib

set_option pp.all true
-- spec: Char.val : Char -> UInt32
def Char.val : Char -> UInt32 :=
  fun (self : Char) => self.1
