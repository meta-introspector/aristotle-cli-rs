import Mathlib

set_option pp.all true
-- spec: Array.instBEq : forall {α : Type.{u}} [inst._@.Init.Data.Array.Basic.3277237202._hygCtx._hyg.3 : BEq.{u} α], BEq.{u} (Array.{u} α)
def Array.instBEq : forall {α : Type.{u}} [inst._@.Init.Data.Array.Basic.3277237202._hygCtx._hyg.3 : BEq.{u} α], BEq.{u} (Array.{u} α) :=
  fun {α : Type.{u}} [inst._@.Init.Data.Array.Basic.3277237202._hygCtx._hyg.3 : BEq.{u} α] => BEq.mk.{u} (Array.{u} α) (fun (xs : Array.{u} α) (ys : Array.{u} α) => Array.isEqv.{u} α xs ys (BEq.beq.{u} α inst._@.Init.Data.Array.Basic.3277237202._hygCtx._hyg.3))
