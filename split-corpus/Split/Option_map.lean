import Mathlib

set_option pp.all true
-- spec: Option.map : forall {α : Type.{u_1}} {β : Type.{u_2}}, (α -> β) -> (Option.{u_1} α) -> (Option.{u_2} β)
def Option.map : forall {α : Type.{u_1}} {β : Type.{u_2}}, (α -> β) -> (Option.{u_1} α) -> (Option.{u_2} β) :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} (f : α -> β) (x._@.Init.Prelude.3880878766._hygCtx._hyg.15 : Option.{u_1} α) => Option.getD.match_1.{u_1, succ u_2} α (fun (x._@.Init.Prelude.3880878766._hygCtx.15.Init.Prelude.3880878766._hygCtx._hyg.26 : Option.{u_1} α) => Option.{u_2} β) x._@.Init.Prelude.3880878766._hygCtx._hyg.15 (fun (x : α) => Option.some.{u_2} β (f x)) (fun (_ : Unit) => Option.none.{u_2} β)
