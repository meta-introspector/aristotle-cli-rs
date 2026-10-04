import Mathlib

set_option pp.all true
-- spec: Lean.setMCtx : forall {m : Type -> Type} [inst._@.Lean.MetavarContext.1943747785._hygCtx._hyg.5 : Lean.MonadMCtx m], Lean.MetavarContext -> (m Unit)
def Lean.setMCtx : forall {m : Type -> Type} [inst._@.Lean.MetavarContext.1943747785._hygCtx._hyg.5 : Lean.MonadMCtx m], Lean.MetavarContext -> (m Unit) :=
  fun {m : Type -> Type} [inst._@.Lean.MetavarContext.1943747785._hygCtx._hyg.5 : Lean.MonadMCtx m] (mctx : Lean.MetavarContext) => Lean.MonadMCtx.modifyMCtx m inst._@.Lean.MetavarContext.1943747785._hygCtx._hyg.5 (fun (x._@.Lean.MetavarContext.1943747785._hygCtx._hyg.14 : Lean.MetavarContext) => mctx)
