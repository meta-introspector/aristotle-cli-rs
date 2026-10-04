import Mathlib

set_option pp.all true
-- spec: Array.mapM : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.3811891879._hygCtx._hyg.8 : Monad.{v, w} m], (α -> (m β)) -> (Array.{u} α) -> (m (Array.{v} β))
def Array.mapM : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.3811891879._hygCtx._hyg.8 : Monad.{v, w} m], (α -> (m β)) -> (Array.{u} α) -> (m (Array.{v} β)) :=
  fun {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.3811891879._hygCtx._hyg.8 : Monad.{v, w} m] (f : α -> (m β)) (as : Array.{u} α) => _private.Init.Data.Array.Basic.0.Array.mapM.map.{u, v, w} α β m inst._@.Init.Data.Array.Basic.3811891879._hygCtx._hyg.8 f as (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0)) (Array.emptyWithCapacity.{v} β (Array.size.{u} α as))
