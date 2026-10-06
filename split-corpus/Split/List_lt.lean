import Mathlib

set_option pp.all true
-- spec: List.lt : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.2635099425._hygCtx._hyg.5 : LT.{u} α], (List.{u} α) -> (List.{u} α) -> Prop
def List.lt : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.2635099425._hygCtx._hyg.5 : LT.{u} α], (List.{u} α) -> (List.{u} α) -> Prop :=
  fun {α : Type.{u}} [inst._@.Init.Data.List.Basic.2635099425._hygCtx._hyg.5 : LT.{u} α] => List.Lex.{u} α (fun (x1._@.Init.Data.List.Basic.2635099425._hygCtx._hyg.18 : α) (x2._@.Init.Data.List.Basic.2635099425._hygCtx._hyg.18 : α) => LT.lt.{u} α inst._@.Init.Data.List.Basic.2635099425._hygCtx._hyg.5 x1._@.Init.Data.List.Basic.2635099425._hygCtx._hyg.18 x2._@.Init.Data.List.Basic.2635099425._hygCtx._hyg.18)
