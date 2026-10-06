import Mathlib

set_option pp.all true
-- spec: Option.orElse : forall {α : Type.{u_1}}, (Option.{u_1} α) -> (Unit -> (Option.{u_1} α)) -> (Option.{u_1} α)
def Option.orElse : forall {α : Type.{u_1}}, (Option.{u_1} α) -> (Unit -> (Option.{u_1} α)) -> (Option.{u_1} α) :=
  fun {α : Type.{u_1}} (x._@.Init.Data.Option.Basic.551632357._hygCtx._hyg.17 : Option.{u_1} α) (x._@.Init.Data.Option.Basic.551632357._hygCtx._hyg.18 : Unit -> (Option.{u_1} α)) => Option.orElse.match_1.{u_1, succ u_1} α (fun (x._@.Init.Data.Option.Basic.551632357._hygCtx.17.Init.Data.Option.Basic.551632357._hygCtx._hyg.36 : Option.{u_1} α) (x._@.Init.Data.Option.Basic.551632357._hygCtx.18.Init.Data.Option.Basic.551632357._hygCtx._hyg.39 : Unit -> (Option.{u_1} α)) => Option.{u_1} α) x._@.Init.Data.Option.Basic.551632357._hygCtx._hyg.17 x._@.Init.Data.Option.Basic.551632357._hygCtx._hyg.18 (fun (a : α) (x._@.Init.Data.Option.Basic.551632357._hygCtx._hyg.48 : Unit -> (Option.{u_1} α)) => Option.some.{u_1} α a) (fun (b : Unit -> (Option.{u_1} α)) => b Unit.unit)
