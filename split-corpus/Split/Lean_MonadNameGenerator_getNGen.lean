import Mathlib

set_option pp.all true
-- spec: Lean.MonadNameGenerator.getNGen : forall {m : Type -> Type} [self : Lean.MonadNameGenerator m], m Lean.NameGenerator
def Lean.MonadNameGenerator.getNGen : forall {m : Type -> Type} [self : Lean.MonadNameGenerator m], m Lean.NameGenerator :=
  fun (m : Type -> Type) [self : Lean.MonadNameGenerator m] => self.1
