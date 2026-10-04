import Mathlib

set_option pp.all true
-- spec: EStateM.tryCatch : forall {ε : Type.{u}} {σ : Type.{u}} {δ : Type.{u}} [inst._@.Init.Prelude.3561379600._hygCtx._hyg.7 : EStateM.Backtrackable.{u} δ σ] {α : Type.{u}}, (EStateM.{u} ε σ α) -> (ε -> (EStateM.{u} ε σ α)) -> (EStateM.{u} ε σ α)
def EStateM.tryCatch : forall {ε : Type.{u}} {σ : Type.{u}} {δ : Type.{u}} [inst._@.Init.Prelude.3561379600._hygCtx._hyg.7 : EStateM.Backtrackable.{u} δ σ] {α : Type.{u}}, (EStateM.{u} ε σ α) -> (ε -> (EStateM.{u} ε σ α)) -> (EStateM.{u} ε σ α) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {δ : Type.{u}} [inst._@.Init.Prelude.3561379600._hygCtx._hyg.7 : EStateM.Backtrackable.{u} δ σ] {α : Type.{u}} (x : EStateM.{u} ε σ α) (handle : ε -> (EStateM.{u} ε σ α)) (s : σ) => have d : δ := EStateM.Backtrackable.save.{u} δ σ inst._@.Init.Prelude.3561379600._hygCtx._hyg.7 s; EStateM.tryCatch.match_1.{u, succ u} ε σ α (fun (x._@.Init.Prelude.3561379600._hygCtx._hyg.41 : EStateM.Result.{u} ε σ α) => EStateM.Result.{u} ε σ α) (x s) (fun (e : ε) (s : σ) => handle e (EStateM.Backtrackable.restore.{u} δ σ inst._@.Init.Prelude.3561379600._hygCtx._hyg.7 s d)) (fun (ok : EStateM.Result.{u} ε σ α) => ok)
