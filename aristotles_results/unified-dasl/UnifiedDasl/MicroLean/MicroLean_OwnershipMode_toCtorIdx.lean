import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.toCtorIdx : MicroLean.OwnershipMode -> Nat
def MicroLean.OwnershipMode.toCtorIdx : MicroLean.OwnershipMode -> Nat :=
  MicroLean.OwnershipMode.ctorIdx
