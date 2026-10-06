import Mathlib

set_option pp.all true
-- spec: Lean.MonadQuotation.getCurrMacroScope : forall {m : Type -> Type} [self : Lean.MonadQuotation m], m Lean.MacroScope
def Lean.MonadQuotation.getCurrMacroScope : forall {m : Type -> Type} [self : Lean.MonadQuotation m], m Lean.MacroScope :=
  fun (m : Type -> Type) [self : Lean.MonadQuotation m] => self.2
