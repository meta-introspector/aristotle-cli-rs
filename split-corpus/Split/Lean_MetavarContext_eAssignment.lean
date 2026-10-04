import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.eAssignment : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.MVarId Lean.Expr Lean.instBEqMVarId Lean.instHashableMVarId)
def Lean.MetavarContext.eAssignment : Lean.MetavarContext -> (Lean.PersistentHashMap.{0, 0} Lean.MVarId Lean.Expr Lean.instBEqMVarId Lean.instHashableMVarId) :=
  fun (self : Lean.MetavarContext) => self.8
