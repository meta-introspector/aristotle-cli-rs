import Mathlib

-- spec: opaque Lean.Meta.isDefEqStuckExceptionId : Lean.InternalExceptionId
opaque Lean.Meta.isDefEqStuckExceptionId : Lean.InternalExceptionId :=
  Inhabited.default.{1} Lean.InternalExceptionId Lean.instInhabitedInternalExceptionId
