import Mathlib

-- spec: opaque Lean.Elab.abortTermExceptionId : Lean.InternalExceptionId
opaque Lean.Elab.abortTermExceptionId : Lean.InternalExceptionId :=
  Inhabited.default.{1} Lean.InternalExceptionId Lean.instInhabitedInternalExceptionId
