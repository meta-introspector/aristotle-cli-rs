import Mathlib

set_option pp.all true
-- spec: StateRefT'.get : forall {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.1017806716._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m], StateRefT' ω σ m σ
def StateRefT'.get : forall {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.1017806716._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m], StateRefT' ω σ m σ :=
  fun {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.1017806716._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m] (ref : ST.Ref ω σ) => ST.Ref.get ω m inst._@.Init.Control.StateRef.1017806716._hygCtx._hyg.8 σ ref
