import Mathlib

set_option pp.all true
-- spec: Lean.MonadError.toMonadExceptOf : forall {m : Type -> Type} [self : Lean.MonadError m], MonadExceptOf.{0, 0, 0} Lean.Exception m
def Lean.MonadError.toMonadExceptOf : forall {m : Type -> Type} [self : Lean.MonadError m], MonadExceptOf.{0, 0, 0} Lean.Exception m :=
  fun (m : Type -> Type) [self : Lean.MonadError m] => self.1
