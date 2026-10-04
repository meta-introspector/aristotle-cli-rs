import Mathlib

set_option pp.all true
-- spec: instHAndOfAndOp : forall {α : Type.{u_1}} [inst._@.Init.Prelude.4020180932._hygCtx._hyg.5 : AndOp.{u_1} α], HAnd.{u_1, u_1, u_1} α α α
def instHAndOfAndOp : forall {α : Type.{u_1}} [inst._@.Init.Prelude.4020180932._hygCtx._hyg.5 : AndOp.{u_1} α], HAnd.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.4020180932._hygCtx._hyg.5 : AndOp.{u_1} α] => HAnd.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => AndOp.and.{u_1} α inst._@.Init.Prelude.4020180932._hygCtx._hyg.5 a b)
