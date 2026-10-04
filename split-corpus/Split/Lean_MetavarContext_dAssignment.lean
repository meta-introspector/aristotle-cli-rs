import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.dAssignment : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.MVarId Lean.DelayedMetavarAssignment Lean.instBEqMVarId Lean.instHashableMVarId)
def Lean.MetavarContext.dAssignment : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.MVarId Lean.DelayedMetavarAssignment Lean.instBEqMVarId Lean.instHashableMVarId) :=
  fun (self : Lean.MetavarContext) => self.9
