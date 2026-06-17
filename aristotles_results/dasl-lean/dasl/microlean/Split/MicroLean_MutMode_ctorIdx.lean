import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.ctorIdx : MicroLean.MutMode -> Nat
def MicroLean.MutMode.ctorIdx : MicroLean.MutMode -> Nat :=
  fun (x : MicroLean.MutMode) => MicroLean.MutMode.casesOn.{1} (fun (x : MicroLean.MutMode) => Nat) x 0 1 2
