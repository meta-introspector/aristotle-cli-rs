import Mathlib

set_option pp.all true
-- spec: Option.toLOption : forall {α : Type.{u}}, (Option.{u} α) -> (Lean.LOption.{u} α)
def Option.toLOption : forall {α : Type.{u}}, (Option.{u} α) -> (Lean.LOption.{u} α) :=
  fun {α : Type.{u}} (x._@.Lean.Data.LOption.1396438090._hygCtx._hyg.8 : Option.{u} α) => _private.Lean.Data.LOption.0.Option.toLOption.match_1.{u, succ u} α (fun (x._@.Lean.Data.LOption.1396438090._hygCtx.8.Lean.Data.LOption.1396438090._hygCtx._hyg.19 : Option.{u} α) => Lean.LOption.{u} α) x._@.Lean.Data.LOption.1396438090._hygCtx._hyg.8 (fun (_ : Unit) => Lean.LOption.none.{u} α) (fun (a : α) => Lean.LOption.some.{u} α a)
