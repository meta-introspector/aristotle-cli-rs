import Mathlib

set_option pp.all true
-- spec: EStateM.run : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}}, (EStateM.{u} ε σ α) -> σ -> (EStateM.Result.{u} ε σ α)
def EStateM.run : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}}, (EStateM.{u} ε σ α) -> σ -> (EStateM.Result.{u} ε σ α) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} (x : EStateM.{u} ε σ α) (s : σ) => x s
