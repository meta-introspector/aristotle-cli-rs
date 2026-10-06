import Mathlib

set_option pp.all true
-- spec: EStateM.instMonadExceptOfOfBacktrackable : forall {ε : Type.{u}} {σ : Type.{u}} {δ : Type.{u}} [inst._@.Init.Prelude.1932068865._hygCtx._hyg.7 : EStateM.Backtrackable.{u} δ σ], MonadExceptOf.{u, u, u} ε (EStateM.{u} ε σ)
def EStateM.instMonadExceptOfOfBacktrackable : forall {ε : Type.{u}} {σ : Type.{u}} {δ : Type.{u}} [inst._@.Init.Prelude.1932068865._hygCtx._hyg.7 : EStateM.Backtrackable.{u} δ σ], MonadExceptOf.{u, u, u} ε (EStateM.{u} ε σ) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {δ : Type.{u}} [inst._@.Init.Prelude.1932068865._hygCtx._hyg.7 : EStateM.Backtrackable.{u} δ σ] => MonadExceptOf.mk.{u, u, u} ε (EStateM.{u} ε σ) (fun {α._@.Init.Prelude.1932068865._hygCtx._hyg.22 : Type.{u}} => EStateM.throw.{u} ε σ α._@.Init.Prelude.1932068865._hygCtx._hyg.22) (fun {α._@.Init.Prelude.1932068865._hygCtx._hyg.24 : Type.{u}} => EStateM.tryCatch.{u} ε σ δ inst._@.Init.Prelude.1932068865._hygCtx._hyg.7 α._@.Init.Prelude.1932068865._hygCtx._hyg.24)
