import Mathlib

set_option pp.all true
-- spec: Zero.ofOfNat0 : forall {α : Type.{u_1}} [inst._@.Init.Data.Zero.1081659293._hygCtx._hyg.3 : OfNat.{u_1} α 0], Zero.{u_1} α
def Zero.ofOfNat0 : forall {α : Type.{u_1}} [inst._@.Init.Data.Zero.1081659293._hygCtx._hyg.3 : OfNat.{u_1} α 0], Zero.{u_1} α :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.Zero.1081659293._hygCtx._hyg.3 : OfNat.{u_1} α 0] => Zero.mk.{u_1} α (OfNat.ofNat.{u_1} α 0 inst._@.Init.Data.Zero.1081659293._hygCtx._hyg.3)
