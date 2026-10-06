import Mathlib

set_option pp.all true
-- spec: Lean.MonadLog.getFileName : forall {m : Type -> Type} [self : Lean.MonadLog m], m String
def Lean.MonadLog.getFileName : forall {m : Type -> Type} [self : Lean.MonadLog m], m String :=
  fun (m : Type -> Type) [self : Lean.MonadLog m] => self.3
