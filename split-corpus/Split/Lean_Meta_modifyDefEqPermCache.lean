import Mathlib

set_option pp.all true
-- spec: Lean.Meta.modifyDefEqPermCache : (Lean.Meta.DefEqCache -> Lean.Meta.DefEqCache) -> (Lean.Meta.MetaM Unit)
def Lean.Meta.modifyDefEqPermCache : (Lean.Meta.DefEqCache -> Lean.Meta.DefEqCache) -> (Lean.Meta.MetaM Unit) :=
  fun (f : Lean.Meta.DefEqCache -> Lean.Meta.DefEqCache) => Lean.Meta.modifyCache (fun (x._@.Lean.Meta.Basic.2263729884._hygCtx._hyg.21 : Lean.Meta.Cache) => _private.Lean.Meta.Basic.0.Lean.Meta.modifyInferTypeCache.match_1.{1} (fun (x._@.Lean.Meta.Basic.2263729884._hygCtx.21.Lean.Meta.Basic.2263729884._hygCtx._hyg.28 : Lean.Meta.Cache) => Lean.Meta.Cache) x._@.Lean.Meta.Basic.2263729884._hygCtx._hyg.21 (fun (c1 : Lean.Meta.InferTypeCache) (c2 : Lean.Meta.FunInfoCache) (c3 : Lean.Meta.SynthInstanceCache) (c4 : Lean.Meta.WhnfCache) (c5 : Lean.Meta.DefEqCache) (defeqPerm : Lean.Meta.DefEqCache) => Lean.Meta.Cache.mk c1 c2 c3 c4 c5 (f defeqPerm)))
