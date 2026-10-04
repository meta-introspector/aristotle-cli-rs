import Mathlib

set_option pp.all true
-- spec: MicroLean.MutMode.toCtorIdx : MicroLean.MutMode -> Nat
def MicroLean.MutMode.toCtorIdx : MicroLean.MutMode -> Nat :=
  MicroLean.MutMode.ctorIdx
