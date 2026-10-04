import Mathlib

set_option pp.all true
-- spec: ST.Prim.Ref.modifyGet : forall {σ : Type} {α : Type} {β : Type}, (ST.Ref σ α) -> (α -> (Prod.{0, 0} β α)) -> (ST σ β)
def ST.Prim.Ref.modifyGet : forall {σ : Type} {α : Type} {β : Type}, (ST.Ref σ α) -> (α -> (Prod.{0, 0} β α)) -> (ST σ β) :=
  fun {σ : Type} {α : Type} {β : Type} (r : ST.Ref σ α) (f : α -> (Prod.{0, 0} β α)) => Bind.bind.{0, 0} (ST σ) (Monad.toBind.{0, 0} (ST σ) (instMonadST σ)) α β (ST.Prim.Ref.get σ α r) (fun (v : α) => _private.Init.System.ST.0.ST.Prim.Ref.modifyGetUnsafe.match_1.{1} α β (fun (x._@.Init.System.ST.2882318218._hygCtx._hyg.55 : Prod.{0, 0} β α) => ST σ β) (f v) (fun (b : β) (a : α) => Bind.bind.{0, 0} (ST σ) (Monad.toBind.{0, 0} (ST σ) (instMonadST σ)) Unit β (ST.Prim.Ref.set σ α r a) (fun (x._@.Init.System.ST.2882318218._hygCtx._hyg.79 : PUnit.{1}) => Pure.pure.{0, 0} (ST σ) (Applicative.toPure.{0, 0} (ST σ) (Monad.toApplicative.{0, 0} (ST σ) (instMonadST σ))) β b)))
