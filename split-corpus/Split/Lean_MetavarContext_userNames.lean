import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.userNames : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.Name Lean.MVarId Lean.Name.instBEq Lean.instHashableName)
def Lean.MetavarContext.userNames : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.Name Lean.MVarId Lean.Name.instBEq Lean.instHashableName) :=
  fun (self : Lean.MetavarContext) => self.6
