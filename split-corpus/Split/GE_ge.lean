import Mathlib

set_option pp.all true
-- spec: GE.ge : forall {α : Type.{u}} [inst._@.Init.Prelude.1058783946._hygCtx._hyg.3 : LE.{u} α], α -> α -> Prop
def GE.ge : forall {α : Type.{u}} [inst._@.Init.Prelude.1058783946._hygCtx._hyg.3 : LE.{u} α], α -> α -> Prop :=
  fun {α : Type.{u}} [inst._@.Init.Prelude.1058783946._hygCtx._hyg.3 : LE.{u} α] (a : α) (b : α) => LE.le.{u} α inst._@.Init.Prelude.1058783946._hygCtx._hyg.3 b a
