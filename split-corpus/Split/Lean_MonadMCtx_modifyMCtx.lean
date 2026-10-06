import Mathlib

set_option pp.all true
-- spec: Lean.MonadMCtx.modifyMCtx : forall {m : Type -> Type} [self : Lean.MonadMCtx m], (Lean.MetavarContext -> Lean.MetavarContext) -> (m Unit)
def Lean.MonadMCtx.modifyMCtx : forall {m : Type -> Type} [self : Lean.MonadMCtx m], (Lean.MetavarContext -> Lean.MetavarContext) -> (m Unit) :=
  fun (m : Type -> Type) [self : Lean.MonadMCtx m] => self.2
