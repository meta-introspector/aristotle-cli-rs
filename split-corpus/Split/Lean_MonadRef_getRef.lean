import Mathlib

set_option pp.all true
-- spec: Lean.MonadRef.getRef : forall {m : Type -> Type} [self : Lean.MonadRef m], m Lean.Syntax
def Lean.MonadRef.getRef : forall {m : Type -> Type} [self : Lean.MonadRef m], m Lean.Syntax :=
  fun (m : Type -> Type) [self : Lean.MonadRef m] => self.1
