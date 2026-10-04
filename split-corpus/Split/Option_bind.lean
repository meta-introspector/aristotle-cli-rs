import Mathlib

set_option pp.all true
-- spec: Option.bind : forall {α : Type.{u_1}} {β : Type.{u_2}}, (Option.{u_1} α) -> (α -> (Option.{u_2} β)) -> (Option.{u_2} β)
def Option.bind : forall {α : Type.{u_1}} {β : Type.{u_2}}, (Option.{u_1} α) -> (α -> (Option.{u_2} β)) -> (Option.{u_2} β) :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} (x._@.Init.Data.Option.Basic.3640351540._hygCtx._hyg.27 : Option.{u_1} α) (x._@.Init.Data.Option.Basic.3640351540._hygCtx._hyg.28 : α -> (Option.{u_2} β)) => Option.bind.match_1.{u_1, u_2, succ u_2} α β (fun (x._@.Init.Data.Option.Basic.3640351540._hygCtx.27.Init.Data.Option.Basic.3640351540._hygCtx._hyg.46 : Option.{u_1} α) (x._@.Init.Data.Option.Basic.3640351540._hygCtx.28.Init.Data.Option.Basic.3640351540._hygCtx._hyg.49 : α -> (Option.{u_2} β)) => Option.{u_2} β) x._@.Init.Data.Option.Basic.3640351540._hygCtx._hyg.27 x._@.Init.Data.Option.Basic.3640351540._hygCtx._hyg.28 (fun (x._@.Init.Data.Option.Basic.3640351540._hygCtx._hyg.56 : α -> (Option.{u_2} β)) => Option.none.{u_2} β) (fun (a : α) (f : α -> (Option.{u_2} β)) => f a)
