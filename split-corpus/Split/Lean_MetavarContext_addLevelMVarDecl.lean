import Mathlib

set_option pp.all true
-- spec: Lean.MetavarContext.addLevelMVarDecl : Lean.MetavarContext -> Lean.LMVarId -> Lean.MetavarContext
def Lean.MetavarContext.addLevelMVarDecl : Lean.MetavarContext -> Lean.LMVarId -> Lean.MetavarContext :=
  fun (mctx : Lean.MetavarContext) (mvarId : Lean.LMVarId) => Lean.MetavarContext.mk (Lean.MetavarContext.depth mctx) (Lean.MetavarContext.levelAssignDepth mctx) (Lean.MetavarContext.mvarCounter mctx) (Lean.PersistentHashMap.insert.{0, 0} Lean.LMVarId Nat Lean.instBEqLevelMVarId Lean.instHashableLevelMVarId (Lean.MetavarContext.lDepth mctx) mvarId (Lean.MetavarContext.depth mctx)) (Lean.MetavarContext.decls mctx) (Lean.MetavarContext.userNames mctx) (Lean.MetavarContext.lAssignment mctx) (Lean.MetavarContext.eAssignment mctx) (Lean.MetavarContext.dAssignment mctx)
