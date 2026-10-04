import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.lAssignment : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.LMVarId Lean.Level Lean.instBEqLevelMVarId Lean.instHashableLevelMVarId)
def Lean.MetavarContext.lAssignment : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.LMVarId Lean.Level Lean.instBEqLevelMVarId Lean.instHashableLevelMVarId) :=
  fun (self : Lean.MetavarContext) => self.7
