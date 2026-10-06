import Mathlib

set_option pp.all true
-- spec: Lean.InternalExceptionId.idx : Lean.InternalExceptionId -> Nat
def Lean.InternalExceptionId.idx : Lean.InternalExceptionId -> Nat :=
  fun (self : Lean.InternalExceptionId) => self.1
