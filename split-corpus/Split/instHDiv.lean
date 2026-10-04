import Mathlib

set_option pp.all true
-- spec: instHDiv : forall {α : Type.{u_1}} [inst._@.Init.Prelude.852891874._hygCtx._hyg.5 : Div.{u_1} α], HDiv.{u_1, u_1, u_1} α α α
def instHDiv : forall {α : Type.{u_1}} [inst._@.Init.Prelude.852891874._hygCtx._hyg.5 : Div.{u_1} α], HDiv.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.852891874._hygCtx._hyg.5 : Div.{u_1} α] => HDiv.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => Div.div.{u_1} α inst._@.Init.Prelude.852891874._hygCtx._hyg.5 a b)
