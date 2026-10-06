import Mathlib

set_option pp.all true
-- spec: EStateM.modifyGet : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (EStateM.{u} ε σ α)
def EStateM.modifyGet : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}}, (σ -> (Prod.{u, u} α σ)) -> (EStateM.{u} ε σ α) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} (f : σ -> (Prod.{u, u} α σ)) (s : σ) => EStateM.modifyGet.match_1.{u, succ u} σ α (fun (x._@.Init.Prelude.2882318218._hygCtx._hyg.26 : Prod.{u, u} α σ) => EStateM.Result.{u} ε σ α) (f s) (fun (a : α) (s : σ) => EStateM.Result.ok.{u} ε σ α a s)
