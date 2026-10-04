import Mathlib

set_option pp.all true
-- spec: List.instLT : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.3763976999._hygCtx._hyg.5 : LT.{u} α], LT.{u} (List.{u} α)
def List.instLT : forall {α : Type.{u}} [inst._@.Init.Data.List.Basic.3763976999._hygCtx._hyg.5 : LT.{u} α], LT.{u} (List.{u} α) :=
  fun {α : Type.{u}} [inst._@.Init.Data.List.Basic.3763976999._hygCtx._hyg.5 : LT.{u} α] => LT.mk.{u} (List.{u} α) (List.lt.{u} α inst._@.Init.Data.List.Basic.3763976999._hygCtx._hyg.5)
