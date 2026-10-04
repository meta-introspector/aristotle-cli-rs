import Mathlib

set_option pp.all true
-- spec: StateRefT'.modifyGet : forall {ω : Type} {σ : Type} {m : Type -> Type} {α : Type} [inst._@.Init.Control.StateRef.2882318218._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m], (σ -> (Prod.{0, 0} α σ)) -> (StateRefT' ω σ m α)
def StateRefT'.modifyGet : forall {ω : Type} {σ : Type} {m : Type -> Type} {α : Type} [inst._@.Init.Control.StateRef.2882318218._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m], (σ -> (Prod.{0, 0} α σ)) -> (StateRefT' ω σ m α) :=
  fun {ω : Type} {σ : Type} {m : Type -> Type} {α : Type} [inst._@.Init.Control.StateRef.2882318218._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m] (f : σ -> (Prod.{0, 0} α σ)) (ref : ST.Ref ω σ) => ST.Ref.modifyGet ω m inst._@.Init.Control.StateRef.2882318218._hygCtx._hyg.8 σ α ref f
