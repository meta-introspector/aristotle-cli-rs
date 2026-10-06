import Mathlib

set_option pp.all true
-- spec: Lean.MonadResolveName.getOpenDecls : forall {m : Type -> Type} [self : Lean.MonadResolveName m], m (List.{0} Lean.OpenDecl)
def Lean.MonadResolveName.getOpenDecls : forall {m : Type -> Type} [self : Lean.MonadResolveName m], m (List.{0} Lean.OpenDecl) :=
  fun (m : Type -> Type) [self : Lean.MonadResolveName m] => self.2
