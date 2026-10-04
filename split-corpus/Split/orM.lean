import Mathlib

set_option pp.all true
-- spec: orM : forall {m : Type.{u} -> Type.{v}} {β : Type.{u}} [inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.13 : Monad.{u, v} m] [inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.16 : ToBool.{u} β], (m β) -> (m β) -> (m β)
def orM : forall {m : Type.{u} -> Type.{v}} {β : Type.{u}} [inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.13 : Monad.{u, v} m] [inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.16 : ToBool.{u} β], (m β) -> (m β) -> (m β) :=
  fun {m : Type.{u} -> Type.{v}} {β : Type.{u}} [inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.13 : Monad.{u, v} m] [inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.16 : ToBool.{u} β] (x : m β) (y : m β) => Bind.bind.{u, v} m (Monad.toBind.{u, v} m inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.13) β β x (fun (b : β) => bool.match_1.{succ v} (fun (x._@.Init.Control.Basic.2371644405._hygCtx._hyg.57 : Bool) => m β) (ToBool.toBool.{u} β inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.16 b) (fun (_ : Unit) => Pure.pure.{u, v} m (Applicative.toPure.{u, v} m (Monad.toApplicative.{u, v} m inst._@.Init.Control.Basic.2371644405._hygCtx._hyg.13)) β b) (fun (_ : Unit) => y))
