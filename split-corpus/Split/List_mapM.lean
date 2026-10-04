import Mathlib

set_option pp.all true
-- spec: List.mapM : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Data.List.Control.3811891879._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{w}} {β : Type.{u}}, (α -> (m β)) -> (List.{w} α) -> (m (List.{u} β))
def List.mapM : forall {m : Type.{u} -> Type.{v}} [inst._@.Init.Data.List.Control.3811891879._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{w}} {β : Type.{u}}, (α -> (m β)) -> (List.{w} α) -> (m (List.{u} β)) :=
  fun {m : Type.{u} -> Type.{v}} [inst._@.Init.Data.List.Control.3811891879._hygCtx._hyg.5 : Monad.{u, v} m] {α : Type.{w}} {β : Type.{u}} (f : α -> (m β)) (as : List.{w} α) => List.mapM.loop.{u, v, w} m inst._@.Init.Data.List.Control.3811891879._hygCtx._hyg.5 α β f as (List.nil.{u} β)
