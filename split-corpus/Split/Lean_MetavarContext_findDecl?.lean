import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.findDecl? : Lean.MetavarContext -> Lean.MVarId -> (Option.{0} Lean.MetavarDecl)
def Lean.MetavarContext.findDecl? : Lean.MetavarContext -> Lean.MVarId -> (Option.{0} Lean.MetavarDecl) :=
  fun (mctx : Lean.MetavarContext) (mvarId : Lean.MVarId) => Lean.PersistentHashMap.find?.{0, 0} Lean.MVarId Lean.MetavarDecl Lean.instBEqMVarId Lean.instHashableMVarId (Lean.MetavarContext.decls mctx) mvarId
