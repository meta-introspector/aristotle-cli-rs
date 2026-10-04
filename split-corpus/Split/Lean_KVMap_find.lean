import Mathlib

set_option pp.all true
-- spec: Lean.KVMap.find : Lean.KVMap -> Lean.Name -> (Option.{0} Lean.DataValue)
def Lean.KVMap.find : Lean.KVMap -> Lean.Name -> (Option.{0} Lean.DataValue) :=
  fun (x._@.Lean.Data.KVMap.1364543548._hygCtx._hyg.8 : Lean.KVMap) (x._@.Lean.Data.KVMap.1364543548._hygCtx._hyg.9 : Lean.Name) => _private.Lean.Data.KVMap.0.Lean.KVMap.find.match_1.{1} (fun (x._@.Lean.Data.KVMap.1364543548._hygCtx.8.Lean.Data.KVMap.1364543548._hygCtx._hyg.27 : Lean.KVMap) (x._@.Lean.Data.KVMap.1364543548._hygCtx.9.Lean.Data.KVMap.1364543548._hygCtx._hyg.30 : Lean.Name) => Option.{0} Lean.DataValue) x._@.Lean.Data.KVMap.1364543548._hygCtx._hyg.8 x._@.Lean.Data.KVMap.1364543548._hygCtx._hyg.9 (fun (m : List.{0} (Prod.{0, 0} Lean.Name Lean.DataValue)) (k : Lean.Name) => Lean.KVMap.findCore m k)
