import Mathlib

set_option pp.all true
-- spec: MicroLean.OwnershipMode.ctorIdx : MicroLean.OwnershipMode -> Nat
def MicroLean.OwnershipMode.ctorIdx : MicroLean.OwnershipMode -> Nat :=
  fun (x : MicroLean.OwnershipMode) => MicroLean.OwnershipMode.casesOn.{1} (fun (x : MicroLean.OwnershipMode) => Nat) x 0 1
