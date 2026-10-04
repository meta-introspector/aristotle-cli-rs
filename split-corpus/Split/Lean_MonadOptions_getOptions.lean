import Mathlib

set_option pp.all true
-- spec: Lean.MonadOptions.getOptions : forall {m : Type -> Type} [self : Lean.MonadOptions m], m Lean.Options
def Lean.MonadOptions.getOptions : forall {m : Type -> Type} [self : Lean.MonadOptions m], m Lean.Options :=
  fun (m : Type -> Type) [self : Lean.MonadOptions m] => self.1
