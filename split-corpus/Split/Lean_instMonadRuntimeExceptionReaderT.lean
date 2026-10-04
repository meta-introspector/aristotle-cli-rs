import Mathlib

set_option pp.all true
-- spec: Lean.instMonadRuntimeExceptionReaderT : forall {m : Type -> Type} {ρ : Type} [inst._@.Lean.CoreM.3131163303._hygCtx._hyg.13 : Lean.MonadRuntimeException m], Lean.MonadRuntimeException (ReaderT.{0, 0} ρ m)
def Lean.instMonadRuntimeExceptionReaderT : forall {m : Type -> Type} {ρ : Type} [inst._@.Lean.CoreM.3131163303._hygCtx._hyg.13 : Lean.MonadRuntimeException m], Lean.MonadRuntimeException (ReaderT.{0, 0} ρ m) :=
  fun {m : Type -> Type} {ρ : Type} [inst._@.Lean.CoreM.3131163303._hygCtx._hyg.13 : Lean.MonadRuntimeException m] => Lean.MonadRuntimeException.mk (ReaderT.{0, 0} ρ m) (fun {α._@.Lean.CoreM.3131163303._hygCtx._hyg.27 : Type} (x : ReaderT.{0, 0} ρ m α._@.Lean.CoreM.3131163303._hygCtx._hyg.27) (c : Lean.Exception -> (ReaderT.{0, 0} ρ m α._@.Lean.CoreM.3131163303._hygCtx._hyg.27)) (r : ρ) => Lean.MonadRuntimeException.tryCatchRuntimeEx m inst._@.Lean.CoreM.3131163303._hygCtx._hyg.13 α._@.Lean.CoreM.3131163303._hygCtx._hyg.27 (x r) (fun (e : Lean.Exception) => c e r))
