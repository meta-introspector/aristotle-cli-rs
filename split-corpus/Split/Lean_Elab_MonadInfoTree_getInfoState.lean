import Mathlib

set_option pp.all true
-- spec: Lean.Elab.MonadInfoTree.getInfoState : forall {m : Type -> Type} [self : Lean.Elab.MonadInfoTree m], m Lean.Elab.InfoState
def Lean.Elab.MonadInfoTree.getInfoState : forall {m : Type -> Type} [self : Lean.Elab.MonadInfoTree m], m Lean.Elab.InfoState :=
  fun (m : Type -> Type) [self : Lean.Elab.MonadInfoTree m] => self.1
