import Mathlib

set_option pp.all true
-- spec: StateRefT'.set : forall {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.3103831426._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m], σ -> (StateRefT' ω σ m PUnit.{1})
def StateRefT'.set : forall {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.3103831426._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m], σ -> (StateRefT' ω σ m PUnit.{1}) :=
  fun {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.3103831426._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m] (s : σ) (ref : ST.Ref ω σ) => ST.Ref.set ω m inst._@.Init.Control.StateRef.3103831426._hygCtx._hyg.8 σ ref s
