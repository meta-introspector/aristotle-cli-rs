import Mathlib

set_option pp.all true
-- spec: Lean.MonadWithOptions.withOptions : forall {m : Type -> Type} [self : Lean.MonadWithOptions m] {α : Type}, (Lean.Options -> Lean.Options) -> (m α) -> (m α)
def Lean.MonadWithOptions.withOptions : forall {m : Type -> Type} [self : Lean.MonadWithOptions m] {α : Type}, (Lean.Options -> Lean.Options) -> (m α) -> (m α) :=
  fun (m : Type -> Type) [self : Lean.MonadWithOptions m] => self.1
