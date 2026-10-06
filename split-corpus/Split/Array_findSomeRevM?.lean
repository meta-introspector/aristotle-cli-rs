import Mathlib

set_option pp.all true
-- spec: Array.findSomeRevM? : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.2907896188._hygCtx._hyg.8 : Monad.{v, w} m], (α -> (m (Option.{v} β))) -> (Array.{u} α) -> (m (Option.{v} β))
def Array.findSomeRevM? : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.2907896188._hygCtx._hyg.8 : Monad.{v, w} m], (α -> (m (Option.{v} β))) -> (Array.{u} α) -> (m (Option.{v} β)) :=
  fun {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.2907896188._hygCtx._hyg.8 : Monad.{v, w} m] (f : α -> (m (Option.{v} β))) (as : Array.{u} α) => _private.Init.Data.Array.Basic.0.Array.findSomeRevM?.find.{u, v, w} α β m inst._@.Init.Data.Array.Basic.2907896188._hygCtx._hyg.8 f as (Array.size.{u} α as) (_private.Init.Data.Array.Basic.0.Array.isEqv._proof_1.{u} α as)
