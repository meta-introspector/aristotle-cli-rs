import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.decls : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.MVarId Lean.MetavarDecl Lean.instBEqMVarId Lean.instHashableMVarId)
def Lean.MetavarContext.decls : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.MVarId Lean.MetavarDecl Lean.instBEqMVarId Lean.instHashableMVarId) :=
  fun (self : Lean.MetavarContext) => self.5
