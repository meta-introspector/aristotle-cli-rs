import Mathlib

set_option pp.all true
-- spec: List.isEmpty : forall {α : Type.{u}}, (List.{u} α) -> Bool
def List.isEmpty : forall {α : Type.{u}}, (List.{u} α) -> Bool :=
  fun {α : Type.{u}} (x._@.Init.Data.List.Basic.2043245998._hygCtx._hyg.9 : List.{u} α) => List.getLast?.match_1.{u, 1} α (fun (x._@.Init.Data.List.Basic.2043245998._hygCtx.9.Init.Data.List.Basic.2043245998._hygCtx._hyg.20 : List.{u} α) => Bool) x._@.Init.Data.List.Basic.2043245998._hygCtx._hyg.9 (fun (_ : Unit) => Bool.true) (fun (head._@.Init.Data.List.Basic.2043245998._hygCtx._hyg.37 : α) (tail._@.Init.Data.List.Basic.2043245998._hygCtx._hyg.38 : List.{u} α) => Bool.false)
