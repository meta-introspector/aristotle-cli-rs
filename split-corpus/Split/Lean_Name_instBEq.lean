import Mathlib

set_option pp.all true
-- spec: Lean.Name.instBEq : BEq.{0} Lean.Name
def Lean.Name.instBEq : BEq.{0} Lean.Name :=
  BEq.mk.{0} Lean.Name Lean.Name.beq
