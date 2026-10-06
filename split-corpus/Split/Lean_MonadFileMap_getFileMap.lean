import Mathlib

set_option pp.all true
-- spec: Lean.MonadFileMap.getFileMap : forall {m : Type -> Type} [self : Lean.MonadFileMap m], m Lean.FileMap
def Lean.MonadFileMap.getFileMap : forall {m : Type -> Type} [self : Lean.MonadFileMap m], m Lean.FileMap :=
  fun (m : Type -> Type) [self : Lean.MonadFileMap m] => self.1
