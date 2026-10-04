import Mathlib

set_option pp.all true
-- spec: Option.instBEq : forall {α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13 : Type.{u_1}} [inst._@.Init.Data.Option.Basic.3277237202._hygCtx._hyg.3 : BEq.{u_1} α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13], BEq.{u_1} (Option.{u_1} α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13)
def Option.instBEq : forall {α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13 : Type.{u_1}} [inst._@.Init.Data.Option.Basic.3277237202._hygCtx._hyg.3 : BEq.{u_1} α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13], BEq.{u_1} (Option.{u_1} α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13) :=
  fun {α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13 : Type.{u_1}} [inst._@.Init.Data.Option.Basic.3277237202._hygCtx._hyg.3 : BEq.{u_1} α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13] => BEq.mk.{u_1} (Option.{u_1} α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13) (Option.instBEq.beq.{u_1} α._@.Init.Data.Option.Basic.3000094388._hygCtx._hyg.13 inst._@.Init.Data.Option.Basic.3277237202._hygCtx._hyg.3)
