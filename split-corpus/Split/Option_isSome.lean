import Mathlib

set_option pp.all true
-- spec: Option.isSome : forall {α : Type.{u_1}}, (Option.{u_1} α) -> Bool
def Option.isSome : forall {α : Type.{u_1}}, (Option.{u_1} α) -> Bool :=
  fun {α : Type.{u_1}} (x._@.Init.Data.Option.Basic.3879652157._hygCtx._hyg.9 : Option.{u_1} α) => Option.isSome.match_1.{u_1, 1} α (fun (x._@.Init.Data.Option.Basic.3879652157._hygCtx.9.Init.Data.Option.Basic.3879652157._hygCtx._hyg.20 : Option.{u_1} α) => Bool) x._@.Init.Data.Option.Basic.3879652157._hygCtx._hyg.9 (fun (val._@.Init.Data.Option.Basic.3879652157._hygCtx._hyg.27 : α) => Bool.true) (fun (_ : Unit) => Bool.false)
