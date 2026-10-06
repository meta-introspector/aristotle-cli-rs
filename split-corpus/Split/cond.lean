import Mathlib

set_option pp.all true
-- spec: cond : forall {α : Sort.{u}}, Bool -> α -> α -> α
def cond : forall {α : Sort.{u}}, Bool -> α -> α -> α :=
  fun {α : Sort.{u}} (c : Bool) (x : α) (y : α) => cond.match_1.{u} (fun (c._@.Init.Prelude.3301329888._hygCtx._hyg.10 : Bool) => α) c (fun (_ : Unit) => x) (fun (_ : Unit) => y)
