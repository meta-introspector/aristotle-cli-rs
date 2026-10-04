import Mathlib

set_option pp.all true
-- spec: Lean.instBEqInternalExceptionId : BEq.{0} Lean.InternalExceptionId
def Lean.instBEqInternalExceptionId : BEq.{0} Lean.InternalExceptionId :=
  BEq.mk.{0} Lean.InternalExceptionId Lean.instBEqInternalExceptionId.beq
