import Mathlib

set_option pp.all true
-- spec: Lean.instBEqMessageSeverity : BEq.{0} Lean.MessageSeverity
def Lean.instBEqMessageSeverity : BEq.{0} Lean.MessageSeverity :=
  BEq.mk.{0} Lean.MessageSeverity Lean.instBEqMessageSeverity.beq
