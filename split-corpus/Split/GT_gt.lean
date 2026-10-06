import Mathlib

set_option pp.all true
-- spec: GT.gt : forall {α : Type.{u}} [inst._@.Init.Prelude.96198867._hygCtx._hyg.3 : LT.{u} α], α -> α -> Prop
def GT.gt : forall {α : Type.{u}} [inst._@.Init.Prelude.96198867._hygCtx._hyg.3 : LT.{u} α], α -> α -> Prop :=
  fun {α : Type.{u}} [inst._@.Init.Prelude.96198867._hygCtx._hyg.3 : LT.{u} α] (a : α) (b : α) => LT.lt.{u} α inst._@.Init.Prelude.96198867._hygCtx._hyg.3 b a
