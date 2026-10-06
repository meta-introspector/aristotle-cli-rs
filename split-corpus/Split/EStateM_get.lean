import Mathlib

set_option pp.all true
-- spec: EStateM.get : forall {ε : Type.{u}} {σ : Type.{u}}, EStateM.{u} ε σ σ
def EStateM.get : forall {ε : Type.{u}} {σ : Type.{u}}, EStateM.{u} ε σ σ :=
  fun {ε : Type.{u}} {σ : Type.{u}} (s : σ) => EStateM.Result.ok.{u} ε σ σ s s
