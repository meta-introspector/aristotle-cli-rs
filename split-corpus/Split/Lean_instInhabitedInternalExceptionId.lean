import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedInternalExceptionId : Inhabited.{1} Lean.InternalExceptionId
def Lean.instInhabitedInternalExceptionId : Inhabited.{1} Lean.InternalExceptionId :=
  Inhabited.mk.{1} Lean.InternalExceptionId Lean.instInhabitedInternalExceptionId.default
