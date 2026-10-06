import Mathlib

set_option pp.all true
-- spec: Lean.Exception.isMaxRecDepth : Lean.Exception -> Bool
def Lean.Exception.isMaxRecDepth : Lean.Exception -> Bool :=
  fun (ex : Lean.Exception) => _private.Lean.Exception.0.Lean.Exception.hasSyntheticSorry.match_1.{1} (fun (ex._@.Lean.Exception.1939040947._hygCtx._hyg.9 : Lean.Exception) => Bool) ex (fun (ref._@.Lean.Exception.1939040947._hygCtx._hyg.17 : Lean.Syntax) (msg : Lean.MessageData) => BEq.beq.{0} Lean.Name Lean.Name.instBEq (Lean.MessageData.kind (Lean.MessageData.stripNestedTags msg)) (Lean.Name.mkStr2 "runtime" "maxRecDepth")) (fun (x._@.Lean.Exception.1939040947._hygCtx._hyg.26 : Lean.Exception) => Bool.false)
