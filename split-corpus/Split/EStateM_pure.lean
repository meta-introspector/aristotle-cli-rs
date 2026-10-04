import Mathlib

set_option pp.all true
-- spec: EStateM.pure : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}}, α -> (EStateM.{u} ε σ α)
def EStateM.pure : forall {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}}, α -> (EStateM.{u} ε σ α) :=
  fun {ε : Type.{u}} {σ : Type.{u}} {α : Type.{u}} (a : α) (s : σ) => EStateM.Result.ok.{u} ε σ α a s
