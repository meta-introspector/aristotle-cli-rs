import Mathlib

set_option pp.all true
-- spec: Lean.MonadNameGenerator.setNGen : forall {m : Type -> Type} [self : Lean.MonadNameGenerator m], Lean.NameGenerator -> (m Unit)
def Lean.MonadNameGenerator.setNGen : forall {m : Type -> Type} [self : Lean.MonadNameGenerator m], Lean.NameGenerator -> (m Unit) :=
  fun (m : Type -> Type) [self : Lean.MonadNameGenerator m] => self.2
