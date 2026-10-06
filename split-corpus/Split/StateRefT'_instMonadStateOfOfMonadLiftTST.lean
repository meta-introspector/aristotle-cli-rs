import Mathlib

set_option pp.all true
-- spec: StateRefT'.instMonadStateOfOfMonadLiftTST : forall {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.1430753632._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m], MonadStateOf.{0, 0} σ (StateRefT' ω σ m)
def StateRefT'.instMonadStateOfOfMonadLiftTST : forall {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.1430753632._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m], MonadStateOf.{0, 0} σ (StateRefT' ω σ m) :=
  fun {ω : Type} {σ : Type} {m : Type -> Type} [inst._@.Init.Control.StateRef.1430753632._hygCtx._hyg.8 : MonadLiftT.{0, 0, 0} (ST ω) m] => MonadStateOf.mk.{0, 0} σ (StateRefT' ω σ m) (StateRefT'.get ω σ m inst._@.Init.Control.StateRef.1430753632._hygCtx._hyg.8) (StateRefT'.set ω σ m inst._@.Init.Control.StateRef.1430753632._hygCtx._hyg.8) (fun {α._@.Init.Control.StateRef.1430753632._hygCtx._hyg.29 : Type} => StateRefT'.modifyGet ω σ m α._@.Init.Control.StateRef.1430753632._hygCtx._hyg.29 inst._@.Init.Control.StateRef.1430753632._hygCtx._hyg.8)
