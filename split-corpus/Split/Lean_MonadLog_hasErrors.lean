import Mathlib

set_option pp.all true
-- spec: Lean.MonadLog.hasErrors : forall {m : Type -> Type} [self : Lean.MonadLog m], m Bool
def Lean.MonadLog.hasErrors : forall {m : Type -> Type} [self : Lean.MonadLog m], m Bool :=
  fun (m : Type -> Type) [self : Lean.MonadLog m] => self.4
