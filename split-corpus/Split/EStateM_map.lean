import Mathlib

set_option pp.all true
-- spec: EStateM.map : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}}, (α -> β) -> (EStateM.{u} ε σ α) -> (EStateM.{u} ε σ β)
def EStateM.map : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}}, (α -> β) -> (EStateM.{u} ε σ α) -> (EStateM.{u} ε σ β) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}} (f : α -> β) (x : EStateM.{u} ε σ α) (s : σ) => EStateM.bind.match_1.{u, succ u} ε σ α (fun (x._@.Init.Prelude.3880878768._hygCtx._hyg.28 : EStateM.Result.{u} ε σ α) => EStateM.Result.{u} ε σ β) (x s) (fun (a : α) (s : σ) => EStateM.Result.ok.{u} ε σ β (f a) s) (fun (e : ε) (s : σ) => EStateM.Result.error.{u} ε σ β e s)
