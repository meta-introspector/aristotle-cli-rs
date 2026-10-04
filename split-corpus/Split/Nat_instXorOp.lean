import Mathlib

set_option pp.all true
-- spec: Nat.instXorOp : XorOp.{0} Nat
def Nat.instXorOp : XorOp.{0} Nat :=
  XorOp.mk.{0} Nat Nat.xor
