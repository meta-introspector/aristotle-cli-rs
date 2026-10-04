import Mathlib

set_option pp.all true
-- spec: Lean.MonadEnv.getEnv : forall {m : Type -> Type} [self : Lean.MonadEnv m], m Lean.Environment
def Lean.MonadEnv.getEnv : forall {m : Type -> Type} [self : Lean.MonadEnv m], m Lean.Environment :=
  fun (m : Type -> Type) [self : Lean.MonadEnv m] => self.1
