import Mathlib

set_option pp.all true
-- spec: Lean.MonadBacktrack.saveState : forall {s : outParam.{2} Type} {m : Type -> Type} [self : Lean.MonadBacktrack s m], m s
def Lean.MonadBacktrack.saveState : forall {s : outParam.{2} Type} {m : Type -> Type} [self : Lean.MonadBacktrack s m], m s :=
  fun {s : outParam.{2} Type} (m : Type -> Type) [self : Lean.MonadBacktrack s m] => self.1
