import Mathlib

set_option pp.all true
-- spec: Lean.MonadQuotation.getContext : forall {m : Type -> Type} [self : Lean.MonadQuotation m], m Lean.Name
def Lean.MonadQuotation.getContext : forall {m : Type -> Type} [self : Lean.MonadQuotation m], m Lean.Name :=
  fun (m : Type -> Type) [self : Lean.MonadQuotation m] => self.3
