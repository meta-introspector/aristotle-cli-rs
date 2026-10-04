import Mathlib

set_option pp.all true
-- spec: Lean.MonadResolveName.getCurrNamespace : forall {m : Type -> Type} [self : Lean.MonadResolveName m], m Lean.Name
def Lean.MonadResolveName.getCurrNamespace : forall {m : Type -> Type} [self : Lean.MonadResolveName m], m Lean.Name :=
  fun (m : Type -> Type) [self : Lean.MonadResolveName m] => self.1
