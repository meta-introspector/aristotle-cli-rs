import Mathlib

set_option pp.all true
-- spec: StateRefT'.lift : forall {ω : Type} {σ : Type} {m : Type -> Type} {α : Type}, (m α) -> (StateRefT' ω σ m α)
def StateRefT'.lift : forall {ω : Type} {σ : Type} {m : Type -> Type} {α : Type}, (m α) -> (StateRefT' ω σ m α) :=
  fun {ω : Type} {σ : Type} {m : Type -> Type} {α : Type} (x : m α) (x._@.Init.Control.StateRef.1136412005._hygCtx._hyg.17 : ST.Ref ω σ) => x
