import Mathlib

set_option pp.all true
-- spec: Lean.MonadLog.getRef : forall {m : Type -> Type} [self : Lean.MonadLog m], m Lean.Syntax
def Lean.MonadLog.getRef : forall {m : Type -> Type} [self : Lean.MonadLog m], m Lean.Syntax :=
  fun (m : Type -> Type) [self : Lean.MonadLog m] => self.2
