import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.lDepth : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.LMVarId Nat Lean.instBEqLevelMVarId Lean.instHashableLevelMVarId)
def Lean.MetavarContext.lDepth : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.LMVarId Nat Lean.instBEqLevelMVarId Lean.instHashableLevelMVarId) :=
  fun (self : Lean.MetavarContext) => self.4
