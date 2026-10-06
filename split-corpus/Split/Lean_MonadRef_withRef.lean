import Mathlib

set_option pp.all true
-- spec: Lean.MonadRef.withRef : forall {m : Type -> Type} [self : Lean.MonadRef m] {α : Type}, Lean.Syntax -> (m α) -> (m α)
def Lean.MonadRef.withRef : forall {m : Type -> Type} [self : Lean.MonadRef m] {α : Type}, Lean.Syntax -> (m α) -> (m α) :=
  fun (m : Type -> Type) [self : Lean.MonadRef m] => self.2
