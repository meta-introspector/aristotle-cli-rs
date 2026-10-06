import Mathlib

set_option pp.all true
-- spec: Lean.MonadQuotation.toMonadRef : forall {m : Type -> Type} [self : Lean.MonadQuotation m], Lean.MonadRef m
def Lean.MonadQuotation.toMonadRef : forall {m : Type -> Type} [self : Lean.MonadQuotation m], Lean.MonadRef m :=
  fun (m : Type -> Type) [self : Lean.MonadQuotation m] => self.1
