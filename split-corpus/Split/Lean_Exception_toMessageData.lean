import Mathlib

set_option pp.all true
-- spec: Lean.Exception.toMessageData : Lean.Exception -> Lean.MessageData
def Lean.Exception.toMessageData : Lean.Exception -> Lean.MessageData :=
  fun (x._@.Lean.Exception.1550868492._hygCtx._hyg.5 : Lean.Exception) => _private.Lean.Exception.0.Lean.Exception.toMessageData.match_1.{1} (fun (x._@.Lean.Exception.1550868492._hygCtx.5.Lean.Exception.1550868492._hygCtx._hyg.16 : Lean.Exception) => Lean.MessageData) x._@.Lean.Exception.1550868492._hygCtx._hyg.5 (fun (ref._@.Lean.Exception.1550868492._hygCtx._hyg.24 : Lean.Syntax) (msg : Lean.MessageData) => msg) (fun (id : Lean.InternalExceptionId) (extra._@.Lean.Exception.1550868492._hygCtx._hyg.34 : Lean.KVMap) => Function.comp.{1, 1, 1} String Std.Format Lean.MessageData Lean.MessageData.ofFormat (Std.ToFormat.format.{0} String Std.instToFormatString) (Lean.InternalExceptionId.toString id))
