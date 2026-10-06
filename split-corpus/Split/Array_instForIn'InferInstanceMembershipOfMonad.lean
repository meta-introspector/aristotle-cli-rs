import Mathlib

set_option pp.all true
-- spec: Array.instForIn'InferInstanceMembershipOfMonad : forall {α : Type.{u}} {m : Type.{u_1} -> Type.{u_2}} [inst._@.Init.Data.Array.Basic.2120995222._hygCtx._hyg.6 : Monad.{u_1, u_2} m], ForIn'.{u, u, u_1, u_2} m (Array.{u} α) α (inferInstance.{succ u} (Membership.{u, u} α (Array.{u} α)) (Array.instMembership.{u} α))
def Array.instForIn'InferInstanceMembershipOfMonad : forall {α : Type.{u}} {m : Type.{u_1} -> Type.{u_2}} [inst._@.Init.Data.Array.Basic.2120995222._hygCtx._hyg.6 : Monad.{u_1, u_2} m], ForIn'.{u, u, u_1, u_2} m (Array.{u} α) α (inferInstance.{succ u} (Membership.{u, u} α (Array.{u} α)) (Array.instMembership.{u} α)) :=
  fun {α : Type.{u}} {m : Type.{u_1} -> Type.{u_2}} [inst._@.Init.Data.Array.Basic.2120995222._hygCtx._hyg.6 : Monad.{u_1, u_2} m] => ForIn'.mk.{u, u, u_1, u_2} m (Array.{u} α) α (inferInstance.{succ u} (Membership.{u, u} α (Array.{u} α)) (Array.instMembership.{u} α)) (fun {β._@.Init.Data.Array.Basic.2120995222._hygCtx._hyg.21 : Type.{u_1}} => Array.forIn'.{u, u_1, u_2} α β._@.Init.Data.Array.Basic.2120995222._hygCtx._hyg.21 m inst._@.Init.Data.Array.Basic.2120995222._hygCtx._hyg.6)
