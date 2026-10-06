import Mathlib

set_option pp.all true
-- spec: ST.Ref.modifyGet : forall {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.2882318219._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type} {β : Type}, (ST.Ref σ α) -> (α -> (Prod.{0, 0} β α)) -> (m β)
def ST.Ref.modifyGet : forall {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.2882318219._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type} {β : Type}, (ST.Ref σ α) -> (α -> (Prod.{0, 0} β α)) -> (m β) :=
  fun {σ : Type} {m : Type -> Type} [inst._@.Init.System.ST.2882318219._hygCtx._hyg.9 : MonadLiftT.{0, 0, 0} (ST σ) m] {α : Type} {β : Type} (r : ST.Ref σ α) (f : α -> (Prod.{0, 0} β α)) => liftM.{0, 0, 0} (ST σ) m inst._@.Init.System.ST.2882318219._hygCtx._hyg.9 β (ST.Prim.Ref.modifyGet σ α β r f)
