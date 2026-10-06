import Mathlib

set_option pp.all true
-- spec: Array.map : forall {α : Type.{u}} {β : Type.{v}}, (α -> β) -> (Array.{u} α) -> (Array.{v} β)
def Array.map : forall {α : Type.{u}} {β : Type.{v}}, (α -> β) -> (Array.{u} α) -> (Array.{v} β) :=
  fun {α : Type.{u}} {β : Type.{v}} (f : α -> β) (as : Array.{u} α) => Id.run.{v} (Array.{v} β) (Array.mapM.{u, v, v} α β Id.{v} Id.instMonad.{v} (fun (x._@.Init.Data.Array.Basic.3880878766._hygCtx._hyg.18 : α) => Pure.pure.{v, v} Id.{v} (Applicative.toPure.{v, v} Id.{v} (Monad.toApplicative.{v, v} Id.{v} Id.instMonad.{v})) β (f x._@.Init.Data.Array.Basic.3880878766._hygCtx._hyg.18)) as)
