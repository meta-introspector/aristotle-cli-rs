import Mathlib

set_option pp.all true
-- spec: Zero.toOfNat0 : forall {α : Type.{u_1}} [inst._@.Init.Data.Zero.533617599._hygCtx._hyg.3 : Zero.{u_1} α], OfNat.{u_1} α 0
def Zero.toOfNat0 : forall {α : Type.{u_1}} [inst._@.Init.Data.Zero.533617599._hygCtx._hyg.3 : Zero.{u_1} α], OfNat.{u_1} α 0 :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Zero.533617599._hygCtx._hyg.3 : Zero.{u_1} α] => OfNat.mk.{u_1} α 0 (Zero.zero.{u_1} α inst._@.Init.Data.Zero.533617599._hygCtx._hyg.3)
