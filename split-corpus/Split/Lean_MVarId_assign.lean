import Mathlib

set_option pp.all true
-- spec: Lean.MVarId.assign : forall {m : Type -> Type} [inst._@.Lean.MetavarContext.3756282238._hygCtx._hyg.5 : Lean.MonadMCtx m], Lean.MVarId -> Lean.Expr -> (m Unit)
def Lean.MVarId.assign : forall {m : Type -> Type} [inst._@.Lean.MetavarContext.3756282238._hygCtx._hyg.5 : Lean.MonadMCtx m], Lean.MVarId -> Lean.Expr -> (m Unit) :=
  fun {m : Type -> Type} [inst._@.Lean.MetavarContext.3756282238._hygCtx._hyg.5 : Lean.MonadMCtx m] (mvarId : Lean.MVarId) (val : Lean.Expr) => Lean.MonadMCtx.modifyMCtx m inst._@.Lean.MetavarContext.3756282238._hygCtx._hyg.5 (fun (m : Lean.MetavarContext) => Lean.MetavarContext.mk (Lean.MetavarContext.depth m) (Lean.MetavarContext.levelAssignDepth m) (Lean.MetavarContext.mvarCounter m) (Lean.MetavarContext.lDepth m) (Lean.MetavarContext.decls m) (Lean.MetavarContext.userNames m) (Lean.MetavarContext.lAssignment m) (Lean.PersistentHashMap.insert.{0, 0} Lean.MVarId Lean.Expr Lean.instBEqMVarId Lean.instHashableMVarId (Lean.MetavarContext.eAssignment m) mvarId val) (Lean.MetavarContext.dAssignment m))
