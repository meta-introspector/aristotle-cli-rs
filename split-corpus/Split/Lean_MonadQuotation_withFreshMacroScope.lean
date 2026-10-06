import Mathlib

set_option pp.all true
-- spec: Lean.MonadQuotation.withFreshMacroScope : forall {m : Type -> Type} [self : Lean.MonadQuotation m] {α : Type}, (m α) -> (m α)
def Lean.MonadQuotation.withFreshMacroScope : forall {m : Type -> Type} [self : Lean.MonadQuotation m] {α : Type}, (m α) -> (m α) :=
  fun (m : Type -> Type) [self : Lean.MonadQuotation m] => self.4
