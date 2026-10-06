import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.initShift : USize
def Lean.PersistentArray.initShift : USize :=
  OfNat.ofNat.{0} USize 5 (USize.instOfNat 5)
