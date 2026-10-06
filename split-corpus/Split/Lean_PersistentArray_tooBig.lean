import Mathlib

set_option pp.all true
-- spec: Lean.PersistentArray.tooBig : Nat
def Lean.PersistentArray.tooBig : Nat :=
  HDiv.hDiv.{0, 0, 0} Nat Nat Nat (instHDiv.{0} Nat Nat.instDiv) USize.size (OfNat.ofNat.{0} Nat 8 (instOfNatNat 8))
