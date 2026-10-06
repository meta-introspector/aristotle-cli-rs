import Mathlib

set_option pp.all true
-- spec: Lean.KVMap.instValueBool : Lean.KVMap.Value Bool
def Lean.KVMap.instValueBool : Lean.KVMap.Value Bool :=
  Lean.KVMap.Value.mk Bool Lean.DataValue.ofBool (fun (x._@.Lean.Data.KVMap.507998743._hygCtx._hyg.6 : Lean.DataValue) => Lean.KVMap.instValueBool.match_1.{1} (fun (x._@.Lean.Data.KVMap.507998743._hygCtx.6.Lean.Data.KVMap.507998743._hygCtx._hyg.19 : Lean.DataValue) => Option.{0} Bool) x._@.Lean.Data.KVMap.507998743._hygCtx._hyg.6 (fun (b : Bool) => Option.some.{0} Bool b) (fun (x._@.Lean.Data.KVMap.507998743._hygCtx._hyg.30 : Lean.DataValue) => Option.none.{0} Bool))
