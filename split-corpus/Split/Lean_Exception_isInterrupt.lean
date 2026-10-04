import Mathlib

set_option pp.all true
-- spec: Lean.Exception.isInterrupt : Lean.Exception -> Bool
def Lean.Exception.isInterrupt : Lean.Exception -> Bool :=
  fun (x._@.Lean.Exception.2995918997._hygCtx._hyg.5 : Lean.Exception) => _private.Lean.Exception.0.Lean.Exception.isInterrupt.match_1.{1} (fun (x._@.Lean.Exception.2995918997._hygCtx.5.Lean.Exception.2995918997._hygCtx._hyg.16 : Lean.Exception) => Bool) x._@.Lean.Exception.2995918997._hygCtx._hyg.5 (fun (id : Lean.InternalExceptionId) (extra._@.Lean.Exception.2995918997._hygCtx._hyg.24 : Lean.KVMap) => BEq.beq.{0} Lean.InternalExceptionId Lean.instBEqInternalExceptionId id Lean.interruptExceptionId) (fun (x._@.Lean.Exception.2995918997._hygCtx._hyg.34 : Lean.Exception) => Bool.false)
