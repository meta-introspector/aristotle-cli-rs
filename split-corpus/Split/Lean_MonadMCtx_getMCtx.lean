import Mathlib

set_option pp.all true
-- spec: Lean.MonadMCtx.getMCtx : forall {m : Type -> Type} [self : Lean.MonadMCtx m], m Lean.MetavarContext
def Lean.MonadMCtx.getMCtx : forall {m : Type -> Type} [self : Lean.MonadMCtx m], m Lean.MetavarContext :=
  fun (m : Type -> Type) [self : Lean.MonadMCtx m] => self.1
