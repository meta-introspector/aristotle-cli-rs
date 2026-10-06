import Mathlib

set_option pp.all true
-- spec: Eigenspace.toCtorIdx : Eigenspace -> Nat
def Eigenspace.toCtorIdx : Eigenspace -> Nat :=
  Eigenspace.ctorIdx
