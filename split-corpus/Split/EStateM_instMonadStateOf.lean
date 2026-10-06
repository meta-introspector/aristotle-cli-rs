import Mathlib

set_option pp.all true
-- spec: EStateM.instMonadStateOf : forall {ε : Type.{u}} {σ : Type.{u}}, MonadStateOf.{u, u} σ (EStateM.{u} ε σ)
def EStateM.instMonadStateOf : forall {ε : Type.{u}} {σ : Type.{u}}, MonadStateOf.{u, u} σ (EStateM.{u} ε σ) :=
  fun {ε : Type.{u}} {σ : Type.{u}} => MonadStateOf.mk.{u, u} σ (EStateM.{u} ε σ) (EStateM.get.{u} ε σ) (EStateM.set.{u} ε σ) (fun {α._@.Init.Prelude.4058739024._hygCtx._hyg.19 : Type.{u}} => EStateM.modifyGet.{u} ε σ α._@.Init.Prelude.4058739024._hygCtx._hyg.19)
