import Mathlib

set_option pp.all true
-- spec: Array.forIn' : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.8 : Monad.{v, w} m] (as : Array.{u} α), β -> (forall (a : α), (Membership.mem.{u, u} α (Array.{u} α) (Array.instMembership.{u} α) as a) -> β -> (m (ForInStep.{v} β))) -> (m β)
def Array.forIn' : forall {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.8 : Monad.{v, w} m] (as : Array.{u} α), β -> (forall (a : α), (Membership.mem.{u, u} α (Array.{u} α) (Array.instMembership.{u} α) as a) -> β -> (m (ForInStep.{v} β))) -> (m β) :=
  fun {α : Type.{u}} {β : Type.{v}} {m : Type.{v} -> Type.{w}} [inst._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.8 : Monad.{v, w} m] (as : Array.{u} α) (b : β) (f : forall (a : α), (Membership.mem.{u, u} α (Array.{u} α) (Array.instMembership.{u} α) as a) -> β -> (m (ForInStep.{v} β))) => Array.forIn'.loop.{u, v, w} α β m inst._@.Init.Data.Array.Basic.4042975923._hygCtx._hyg.8 as f (Array.size.{u} α as) (Array.forIn'._proof_2.{u} α as) b
