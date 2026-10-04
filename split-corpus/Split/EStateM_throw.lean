import Mathlib

set_option pp.all true
-- spec: EStateM.throw : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}}, ε -> (EStateM.{u} ε σ α)
def EStateM.throw : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}}, ε -> (EStateM.{u} ε σ α) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} (e : ε) (s : σ) => EStateM.Result.error.{u} ε σ α e s
