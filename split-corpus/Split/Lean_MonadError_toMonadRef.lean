import Mathlib

set_option pp.all true
-- spec: Lean.MonadError.toMonadRef : forall {m : Type -> Type} [self : Lean.MonadError m], Lean.MonadRef m
def Lean.MonadError.toMonadRef : forall {m : Type -> Type} [self : Lean.MonadError m], Lean.MonadRef m :=
  fun (m : Type -> Type) [self : Lean.MonadError m] => self.2
