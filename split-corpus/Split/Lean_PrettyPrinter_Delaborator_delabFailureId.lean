import Mathlib

-- spec: opaque Lean.PrettyPrinter.Delaborator.delabFailureId : Lean.InternalExceptionId
opaque Lean.PrettyPrinter.Delaborator.delabFailureId : Lean.InternalExceptionId :=
  Inhabited.default.{1} Lean.InternalExceptionId Lean.instInhabitedInternalExceptionId
