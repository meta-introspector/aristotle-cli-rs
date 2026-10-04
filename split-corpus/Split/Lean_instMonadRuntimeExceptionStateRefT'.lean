import Mathlib

set_option pp.all true
-- spec: Lean.instMonadRuntimeExceptionStateRefT' : forall {m : Type -> Type} {ω : Type} {σ : Type} [inst._@.Lean.CoreM.2792093450._hygCtx._hyg.22 : Lean.MonadRuntimeException m], Lean.MonadRuntimeException (StateRefT' ω σ m)
def Lean.instMonadRuntimeExceptionStateRefT' : forall {m : Type -> Type} {ω : Type} {σ : Type} [inst._@.Lean.CoreM.2792093450._hygCtx._hyg.22 : Lean.MonadRuntimeException m], Lean.MonadRuntimeException (StateRefT' ω σ m) :=
  fun {m : Type -> Type} {ω : Type} {σ : Type} [inst._@.Lean.CoreM.2792093450._hygCtx._hyg.22 : Lean.MonadRuntimeException m] => Lean.MonadRuntimeException.mk (StateRefT' ω σ m) (fun {α._@.Lean.CoreM.2792093450._hygCtx._hyg.37 : Type} (x : StateRefT' ω σ m α._@.Lean.CoreM.2792093450._hygCtx._hyg.37) (c : Lean.Exception -> (StateRefT' ω σ m α._@.Lean.CoreM.2792093450._hygCtx._hyg.37)) (s : ST.Ref ω σ) => Lean.MonadRuntimeException.tryCatchRuntimeEx m inst._@.Lean.CoreM.2792093450._hygCtx._hyg.22 α._@.Lean.CoreM.2792093450._hygCtx._hyg.37 (x s) (fun (e : Lean.Exception) => c e s))
