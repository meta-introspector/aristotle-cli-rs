import Mathlib

set_option pp.all true
-- spec: Lean.PersistentHashMap.shift : USize
def Lean.PersistentHashMap.shift : USize :=
  OfNat.ofNat.{0} USize 5 (USize.instOfNat 5)
