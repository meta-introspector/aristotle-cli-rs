import Mathlib

set_option pp.all true
-- spec: Lean.MonadError.toAddErrorMessageContext : forall {m : Type -> Type} [self : Lean.MonadError m], Lean.AddErrorMessageContext m
def Lean.MonadError.toAddErrorMessageContext : forall {m : Type -> Type} [self : Lean.MonadError m], Lean.AddErrorMessageContext m :=
  fun (m : Type -> Type) [self : Lean.MonadError m] => self.3
