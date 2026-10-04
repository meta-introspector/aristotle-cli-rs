import Mathlib

set_option pp.all true
-- spec: ST.Ref.set : forall {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.3103831427._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type}, (ST.Ref σ α) -> α -> (m Unit)
def ST.Ref.set : forall {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.3103831427._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type}, (ST.Ref σ α) -> α -> (m Unit) :=
  fun {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.3103831427._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type} (r : ST.Ref σ α) (a : α) => liftM.{0, 0, 0} (ST σ) m inst._@.Init.System.ST.3103831427._hygCtx._hyg.9 Unit (ST.Prim.Ref.set σ α r a)
