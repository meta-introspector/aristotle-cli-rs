import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedInternalExceptionId.default : Lean.InternalExceptionId
def Lean.instInhabitedInternalExceptionId.default : Lean.InternalExceptionId :=
  Lean.InternalExceptionId.mk (Inhabited.default.{1} Nat instInhabitedNat)
