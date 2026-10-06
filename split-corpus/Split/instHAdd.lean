import Mathlib

set_option pp.all true
-- spec: instHAdd : forall {α : Type.{u_1}} [inst._@.Init.Prelude.1910291827._hygCtx._hyg.5 : Add.{u_1} α], HAdd.{u_1, u_1, u_1} α α α
def instHAdd : forall {α : Type.{u_1}} [inst._@.Init.Prelude.1910291827._hygCtx._hyg.5 : Add.{u_1} α], HAdd.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.1910291827._hygCtx._hyg.5 : Add.{u_1} α] => HAdd.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => Add.add.{u_1} α inst._@.Init.Prelude.1910291827._hygCtx._hyg.5 a b)
