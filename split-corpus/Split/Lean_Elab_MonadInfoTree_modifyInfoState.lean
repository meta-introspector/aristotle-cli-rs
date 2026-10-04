import Mathlib

set_option pp.all true
-- spec: Lean.Elab.MonadInfoTree.modifyInfoState : forall {m : Type -> Type} [self : Lean.Elab.MonadInfoTree m], (Lean.Elab.InfoState -> Lean.Elab.InfoState) -> (m Unit)
def Lean.Elab.MonadInfoTree.modifyInfoState : forall {m : Type -> Type} [self : Lean.Elab.MonadInfoTree m], (Lean.Elab.InfoState -> Lean.Elab.InfoState) -> (m Unit) :=
  fun (m : Type -> Type) [self : Lean.Elab.MonadInfoTree m] => self.2
