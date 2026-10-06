import Mathlib

set_option pp.all true
-- spec: EStateM.seqRight : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}}, (EStateM.{u} ε σ α) -> (Unit -> (EStateM.{u} ε σ β)) -> (EStateM.{u} ε σ β)
def EStateM.seqRight : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}}, (EStateM.{u} ε σ α) -> (Unit -> (EStateM.{u} ε σ β)) -> (EStateM.{u} ε σ β) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {β : Type.{u}} (x : EStateM.{u} ε σ α) (y : Unit -> (EStateM.{u} ε σ β)) (s : σ) => EStateM.bind.match_1.{u, succ u} ε σ α (fun (x._@.Init.Prelude.784445917._hygCtx._hyg.31 : EStateM.Result.{u} ε σ α) => EStateM.Result.{u} ε σ β) (x s) (fun (a._@._internal.0.Init.Prelude.784445917._hygCtx._hyg.42 : α) (s : σ) => y Unit.unit s) (fun (e : ε) (s : σ) => EStateM.Result.error.{u} ε σ β e s)
