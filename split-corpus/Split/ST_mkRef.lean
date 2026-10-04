import Mathlib

set_option pp.all true
-- spec: ST.mkRef : forall {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.1996808136._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type}, α -> (m (ST.Ref σ α))
def ST.mkRef : forall {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.1996808136._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type}, α -> (m (ST.Ref σ α)) :=
  fun {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.1996808136._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type} (a : α) => liftM.{0, 0, 0} (ST σ) m inst._@.Init.System.ST.1996808136._hygCtx._hyg.9 (ST.Ref σ α) (ST.Prim.mkRef σ α a)
