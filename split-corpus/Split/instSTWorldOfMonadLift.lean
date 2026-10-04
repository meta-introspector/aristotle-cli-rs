import Mathlib

set_option pp.all true
-- spec: instSTWorldOfMonadLift : forall {σ : Type} {m : Type -> Type} {n : Type -> Type} [inst._@.Init.System.ST.151399605._hygCtx._hyg.5 : MonadLift.{0, 0, 0} m n] [inst._@.Init.System.ST.151399605._hygCtx._hyg.9 : STWorld σ m], STWorld σ n
def instSTWorldOfMonadLift : forall {σ : Type} {m : Type -> Type} {n : Type -> Type} [inst._@.Init.System.ST.151399605._hygCtx._hyg.5 : MonadLift.{0, 0, 0} m n] [inst._@.Init.System.ST.151399605._hygCtx._hyg.9 : STWorld σ m], STWorld σ n :=
  fun {σ : Type} {m : Type -> Type} {n : Type -> Type} [inst._@.Init.System.ST.151399605._hygCtx._hyg.5 : MonadLift.{0, 0, 0} m n] [inst._@.Init.System.ST.151399605._hygCtx._hyg.9 : STWorld σ m] => STWorld.mk σ n
