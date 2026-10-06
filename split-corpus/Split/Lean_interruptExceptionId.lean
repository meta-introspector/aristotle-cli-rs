import Mathlib

-- spec: opaque Lean.interruptExceptionId : Lean.InternalExceptionId
opaque Lean.interruptExceptionId : Lean.InternalExceptionId :=
  Inhabited.default.{1} Lean.InternalExceptionId Lean.instInhabitedInternalExceptionId
