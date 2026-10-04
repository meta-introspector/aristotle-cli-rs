import Mathlib

set_option pp.all true
-- spec: Lean.Exception.isRuntime : Lean.Exception -> Bool
def Lean.Exception.isRuntime : Lean.Exception -> Bool :=
  fun (ex : Lean.Exception) => Bool.or (Lean.Exception.isMaxHeartbeat ex) (Lean.Exception.isMaxRecDepth ex)
