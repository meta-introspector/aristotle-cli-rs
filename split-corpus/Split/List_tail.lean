import Mathlib

set_option pp.all true
-- spec: List.tail : forall {α : Type.{u}}, (List.{u} α) -> (List.{u} α)
def List.tail : forall {α : Type.{u}}, (List.{u} α) -> (List.{u} α) :=
  fun {α : Type.{u}} (x._@.Init.Data.List.Basic.3020360278._hygCtx._hyg.10 : List.{u} α) => List.getLast?.match_1.{u, succ u} α (fun (x._@.Init.Data.List.Basic.3020360278._hygCtx.10.Init.Data.List.Basic.3020360278._hygCtx._hyg.21 : List.{u} α) => List.{u} α) x._@.Init.Data.List.Basic.3020360278._hygCtx._hyg.10 (fun (_ : Unit) => List.nil.{u} α) (fun (head._@.Init.Data.List.Basic.3020360278._hygCtx._hyg.39 : α) (as : List.{u} α) => as)
