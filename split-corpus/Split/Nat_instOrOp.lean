import Mathlib

set_option pp.all true
-- spec: Nat.instOrOp : OrOp.{0} Nat
def Nat.instOrOp : OrOp.{0} Nat :=
  OrOp.mk.{0} Nat Nat.lor
