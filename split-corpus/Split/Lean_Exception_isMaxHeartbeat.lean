import Mathlib

set_option pp.all true
-- spec: Lean.Exception.isMaxHeartbeat : Lean.Exception -> Bool
def Lean.Exception.isMaxHeartbeat : Lean.Exception -> Bool :=
  fun (ex : Lean.Exception) => _private.Lean.CoreM.0.Lean.Exception.isMaxHeartbeat.match_1.{1} (fun (ex._@.Lean.CoreM.2473288629._hygCtx._hyg.9 : Lean.Exception) => Bool) ex (fun (ref._@.Lean.CoreM.2473288629._hygCtx._hyg.17 : Lean.Syntax) (msg : Lean.MessageData) => BEq.beq.{0} Lean.Name Lean.Name.instBEq (Lean.MessageData.kind (Lean.MessageData.stripNestedTags msg)) (Lean.Name.mkStr2 "runtime" "maxHeartbeats")) (fun (x._@.Lean.CoreM.2473288629._hygCtx._hyg.26 : Lean.Exception) => Bool.false)
