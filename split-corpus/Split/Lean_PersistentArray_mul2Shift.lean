import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.mul2Shift : USize -> USize -> USize
def Lean.PersistentArray.mul2Shift : USize -> USize -> USize :=
  fun (i : USize) (shift : USize) => USize.shiftLeft i shift
