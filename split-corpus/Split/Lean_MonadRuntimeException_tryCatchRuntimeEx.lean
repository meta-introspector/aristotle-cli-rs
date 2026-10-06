import Mathlib

set_option pp.all true
-- spec: Lean.MonadRuntimeException.tryCatchRuntimeEx : forall {m : Type -> Type} [self : Lean.MonadRuntimeException m] {α : Type}, (m α) -> (Lean.Exception -> (m α)) -> (m α)
def Lean.MonadRuntimeException.tryCatchRuntimeEx : forall {m : Type -> Type} [self : Lean.MonadRuntimeException m] {α : Type}, (m α) -> (Lean.Exception -> (m α)) -> (m α) :=
  fun (m : Type -> Type) [self : Lean.MonadRuntimeException m] => self.1
