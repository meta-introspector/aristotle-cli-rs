import Mathlib

set_option pp.all true
-- spec: Lean.KVMap.instValueNat : Lean.KVMap.Value Nat
def Lean.KVMap.instValueNat : Lean.KVMap.Value Nat :=
  Lean.KVMap.Value.mk Nat Lean.DataValue.ofNat (fun (x._@.Lean.Data.KVMap.843274827._hygCtx._hyg.6 : Lean.DataValue) => Lean.KVMap.instValueNat.match_1.{1} (fun (x._@.Lean.Data.KVMap.843274827._hygCtx.6.Lean.Data.KVMap.843274827._hygCtx._hyg.19 : Lean.DataValue) => Option.{0} Nat) x._@.Lean.Data.KVMap.843274827._hygCtx._hyg.6 (fun (n : Nat) => Option.some.{0} Nat n) (fun (x._@.Lean.Data.KVMap.843274827._hygCtx._hyg.30 : Lean.DataValue) => Option.none.{0} Nat))
