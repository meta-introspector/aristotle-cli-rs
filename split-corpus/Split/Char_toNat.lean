import Mathlib

set_option pp.all true
-- spec: Char.toNat : Char -> Nat
def Char.toNat : Char -> Nat :=
  fun (c : Char) => UInt32.toNat (Char.val c)
