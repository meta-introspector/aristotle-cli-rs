import Mathlib

set_option pp.all true
-- spec: Lean.MonadEnv.modifyEnv : forall {m : Type -> Type} [self : Lean.MonadEnv m], (Lean.Environment -> Lean.Environment) -> (m Unit)
def Lean.MonadEnv.modifyEnv : forall {m : Type -> Type} [self : Lean.MonadEnv m], (Lean.Environment -> Lean.Environment) -> (m Unit) :=
  fun (m : Type -> Type) [self : Lean.MonadEnv m] => self.2
