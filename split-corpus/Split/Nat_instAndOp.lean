import Mathlib

set_option pp.all true
-- spec: Nat.instAndOp : AndOp.{0} Nat
def Nat.instAndOp : AndOp.{0} Nat :=
  AndOp.mk.{0} Nat Nat.land
