import Mathlib

set_option pp.all true
-- spec: Lean.Elab.MonadMacroAdapter.toMonadQuotation : forall {m : Type -> Type} [self : Lean.Elab.MonadMacroAdapter m], Lean.MonadQuotation m
def Lean.Elab.MonadMacroAdapter.toMonadQuotation : forall {m : Type -> Type} [self : Lean.Elab.MonadMacroAdapter m], Lean.MonadQuotation m :=
  fun (m : Type -> Type) [self : Lean.Elab.MonadMacroAdapter m] => self.1
