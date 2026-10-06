import Mathlib

set_option pp.all true
-- spec: bne : forall {α : Type.{u}} [inst._@.Init.Core.905733142._hygCtx._hyg.3 : BEq.{u} α], α -> α -> Bool
def bne : forall {α : Type.{u}} [inst._@.Init.Core.905733142._hygCtx._hyg.3 : BEq.{u} α], α -> α -> Bool :=
  fun {α : Type.{u}} [inst._@.Init.Core.905733142._hygCtx._hyg.3 : BEq.{u} α] (a : α) (b : α) => Bool.not (BEq.beq.{u} α inst._@.Init.Core.905733142._hygCtx._hyg.3 a b)
