import Mathlib

set_option pp.all true
-- spec: Lean.Meta.resetDefEqPermCaches : Lean.Meta.MetaM Unit
def Lean.Meta.resetDefEqPermCaches : Lean.Meta.MetaM Unit :=
  Lean.Meta.modifyDefEqPermCache (fun (x._@.Lean.Meta.Basic.3579022640._hygCtx._hyg.18 : Lean.Meta.DefEqCache) => Lean.PersistentHashMap.mk.{0, 0} Lean.Meta.DefEqCacheKey Bool Lean.Meta.instBEqDefEqCacheKey Lean.Meta.instHashableDefEqCacheKey (Lean.PersistentHashMap.Node.entries.{0, 0} Lean.Meta.DefEqCacheKey Bool (Lean.PersistentHashMap.mkEmptyEntriesArray.{0, 0} Lean.Meta.DefEqCacheKey Bool)))
