import Mathlib

set_option pp.all true
-- spec: List.contains : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.2396568098._hygCtx._hyg.5 : BEq.{u} α], (List.{u} α) -> α -> Bool
def List.contains : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.2396568098._hygCtx._hyg.5 : BEq.{u} α], (List.{u} α) -> α -> Bool :=
  fun {α : Type.{u}} [inst._@.Init.Data.List.Basic.2396568098._hygCtx._hyg.5 : BEq.{u} α] (as : List.{u} α) (a : α) => List.elem.{u} α inst._@.Init.Data.List.Basic.2396568098._hygCtx._hyg.5 a as
