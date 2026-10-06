import Mathlib

set_option pp.all true
-- spec: instHAppendOfAppend : forall {α : Type.{u_1}} [inst._@.Init.Prelude.1106143736._hygCtx._hyg.5 : Append.{u_1} α], HAppend.{u_1, u_1, u_1} α α α
def instHAppendOfAppend : forall {α : Type.{u_1}} [inst._@.Init.Prelude.1106143736._hygCtx._hyg.5 : Append.{u_1} α], HAppend.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.1106143736._hygCtx._hyg.5 : Append.{u_1} α] => HAppend.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => Append.append.{u_1} α inst._@.Init.Prelude.1106143736._hygCtx._hyg.5 a b)
