import Mathlib

set_option pp.all true
-- spec: EStateM.bind : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}}, (EStateM.{u} ε σ α) -> (α -> (EStateM.{u} ε σ β)) -> (EStateM.{u} ε σ β)
def EStateM.bind : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}}, (EStateM.{u} ε σ α) -> (α -> (EStateM.{u} ε σ β)) -> (EStateM.{u} ε σ β) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}} (x : EStateM.{u} ε σ α) (f : α -> (EStateM.{u} ε σ β)) (s : σ) => EStateM.bind.match_1.{u, succ u} ε σ α (fun (x._@.Init.Prelude.3640351541._hygCtx._hyg.31 : EStateM.Result.{u} ε σ α) => EStateM.Result.{u} ε σ β) (x s) (fun (a : α) (s : σ) => f a s) (fun (e : ε) (s : σ) => EStateM.Result.error.{u} ε σ β e s)
