import Mathlib

set_option pp.all true
-- spec: List.getLast? : forall {α : Type.{u}}, (List.{u} α) -> (Option.{u} α)
def List.getLast? : forall {α : Type.{u}}, (List.{u} α) -> (Option.{u} α) :=
  fun {α : Type.{u}} (x._@.Init.Data.List.Basic.417363870._hygCtx._hyg.10 : List.{u} α) => List.getLast?.match_1.{u, succ u} α (fun (x._@.Init.Data.List.Basic.417363870._hygCtx.10.Init.Data.List.Basic.417363870._hygCtx._hyg.21 : List.{u} α) => Option.{u} α) x._@.Init.Data.List.Basic.417363870._hygCtx._hyg.10 (fun (_ : Unit) => Option.none.{u} α) (fun (a : α) (as : List.{u} α) => Option.some.{u} α (List.getLast.{u} α (List.cons.{u} α a as) (List.getLast._proof_2.{u} α a as)))
