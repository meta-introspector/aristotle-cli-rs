import Mathlib

set_option pp.all true
-- spec: Option.getD : forall {α : Type.{u_1}}, (Option.{u_1} α) -> α -> α
def Option.getD : forall {α : Type.{u_1}}, (Option.{u_1} α) -> α -> α :=
  fun {α : Type.{u_1}} (opt : Option.{u_1} α) (dflt : α) => Option.getD.match_1.{u_1, succ u_1} α (fun (opt._@.Init.Prelude.3502629364._hygCtx._hyg.11 : Option.{u_1} α) => α) opt (fun (x : α) => x) (fun (_ : Unit) => dflt)
