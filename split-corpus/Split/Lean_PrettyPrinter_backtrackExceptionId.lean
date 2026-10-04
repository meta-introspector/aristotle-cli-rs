import Mathlib

-- spec: opaque Lean.PrettyPrinter.backtrackExceptionId : Lean.InternalExceptionId
opaque Lean.PrettyPrinter.backtrackExceptionId : Lean.InternalExceptionId :=
  Inhabited.default.{1} Lean.InternalExceptionId Lean.instInhabitedInternalExceptionId
