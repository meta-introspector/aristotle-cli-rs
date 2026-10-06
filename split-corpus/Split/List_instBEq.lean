import Mathlib

set_option pp.all true
-- spec: List.instBEq : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.3277237202._hygCtx._hyg.5 : BEq.{u} α], BEq.{u} (List.{u} α)
def List.instBEq : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.3277237202._hygCtx._hyg.5 : BEq.{u} α], BEq.{u} (List.{u} α) :=
  fun {α : Type.{u}} [inst._@.Init.Data.List.Basic.3277237202._hygCtx._hyg.5 : BEq.{u} α] => BEq.mk.{u} (List.{u} α) (List.beq.{u} α inst._@.Init.Data.List.Basic.3277237202._hygCtx._hyg.5)
