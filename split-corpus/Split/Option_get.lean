import Mathlib

set_option pp.all true
-- spec: Option.get : forall {α : Type.{u}} (o : Option.{u} α), (Eq.{1} Bool (Option.isSome.{u} α o) Bool.true) -> α
def Option.get : forall {α : Type.{u}} (o : Option.{u} α), (Eq.{1} Bool (Option.isSome.{u} α o) Bool.true) -> α :=
  fun {α : Type.{u}} (x._@.Init.Data.Option.Basic.1017806716._hygCtx._hyg.10 : Option.{u} α) (x._@.Init.Data.Option.Basic.1017806716._hygCtx._hyg.11 : Eq.{1} Bool (Option.isSome.{u} α x._@.Init.Data.Option.Basic.1017806716._hygCtx._hyg.10) Bool.true) => Option.get.match_1.{u, succ u} α (fun (x._@.Init.Data.Option.Basic.1017806716._hygCtx.10.Init.Data.Option.Basic.1017806716._hygCtx._hyg.29 : Option.{u} α) (x._@.Init.Data.Option.Basic.1017806716._hygCtx.11.Init.Data.Option.Basic.1017806716._hygCtx._hyg.32 : Eq.{1} Bool (Option.isSome.{u} α x._@.Init.Data.Option.Basic.1017806716._hygCtx.10.Init.Data.Option.Basic.1017806716._hygCtx._hyg.29) Bool.true) => α) x._@.Init.Data.Option.Basic.1017806716._hygCtx._hyg.10 x._@.Init.Data.Option.Basic.1017806716._hygCtx._hyg.11 (fun (x : α) (x._@.Init.Data.Option.Basic.1017806716._hygCtx._hyg.41 : Eq.{1} Bool (Option.isSome.{u} α (Option.some.{u} α x)) Bool.true) => x)
