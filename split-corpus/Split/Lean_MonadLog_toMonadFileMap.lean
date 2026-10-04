import Mathlib

set_option pp.all true
-- spec: Lean.MonadLog.toMonadFileMap : forall {m : Type -> Type} [self : Lean.MonadLog m], Lean.MonadFileMap m
def Lean.MonadLog.toMonadFileMap : forall {m : Type -> Type} [self : Lean.MonadLog m], Lean.MonadFileMap m :=
  fun (m : Type -> Type) [self : Lean.MonadLog m] => self.1
