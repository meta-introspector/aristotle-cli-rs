import Mathlib

-- spec: recursor EStateM.Result.rec : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} {motive : (EStateM.Result.{u} ε σ α) -> Sort.{u_1}}, (forall (a._@._internal._hyg.0 : α) (a_1._@._internal._hyg.0 : σ), motive (EStateM.Result.ok.{u} ε σ α a._@._internal._hyg.0 a_1._@._internal._hyg.0)) -> (forall (a._@._internal._hyg.0 : ε) (a_1._@._internal._hyg.0 : σ), motive (EStateM.Result.error.{u} ε σ α a._@._internal._hyg.0 a_1._@._internal._hyg.0)) -> (forall (t : EStateM.Result.{u} ε σ α), motive t)
