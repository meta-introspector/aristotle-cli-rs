import Mathlib

set_option pp.all true
-- spec: Lean.MonadLCtx.getLCtx : forall {m : Type -> Type} [self : Lean.MonadLCtx m], m Lean.LocalContext
def Lean.MonadLCtx.getLCtx : forall {m : Type -> Type} [self : Lean.MonadLCtx m], m Lean.LocalContext :=
  fun (m : Type -> Type) [self : Lean.MonadLCtx m] => self.1
