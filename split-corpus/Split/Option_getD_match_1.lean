import Mathlib

set_option pp.all true
-- spec: Option.getD.match_1 : forall {α : Type.{u_1}} (motive : (Option.{u_1} α) -> Sort.{u_2}) (opt._@.Init.Prelude.3502629364._hygCtx._hyg.11 : Option.{u_1} α), (forall (x : α), motive (Option.some.{u_1} α x)) -> (Unit -> (motive (Option.none.{u_1} α))) -> (motive opt._@.Init.Prelude.3502629364._hygCtx._hyg.11)
def Option.getD.match_1 : forall {α : Type.{u_1}} (motive : (Option.{u_1} α) -> Sort.{u_2}) (opt._@.Init.Prelude.3502629364._hygCtx._hyg.11 : Option.{u_1} α), (forall (x : α), motive (Option.some.{u_1} α x)) -> (Unit -> (motive (Option.none.{u_1} α))) -> (motive opt._@.Init.Prelude.3502629364._hygCtx._hyg.11) :=
  fun {α : Type.{u_1}} (motive : (Option.{u_1} α) -> Sort.{u_2}) (opt._@.Init.Prelude.3502629364._hygCtx._hyg.11 : Option.{u_1} α) (h_1 : forall (x : α), motive (Option.some.{u_1} α x)) (h_2 : Unit -> (motive (Option.none.{u_1} α))) => Option.casesOn.{u_2, u_1} α (fun (x : Option.{u_1} α) => motive x) opt._@.Init.Prelude.3502629364._hygCtx._hyg.11 (h_2 Unit.unit) (fun (val._@.Init.Prelude.3502629364._hygCtx._hyg.24 : α) => h_1 val._@.Init.Prelude.3502629364._hygCtx._hyg.24)
