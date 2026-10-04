import Mathlib

set_option pp.all true
-- spec: instHXorOfXorOp : forall {α : Type.{u_1}} [inst._@.Init.Prelude.4046077614._hygCtx._hyg.5 : XorOp.{u_1} α], HXor.{u_1, u_1, u_1} α α α
def instHXorOfXorOp : forall {α : Type.{u_1}} [inst._@.Init.Prelude.4046077614._hygCtx._hyg.5 : XorOp.{u_1} α], HXor.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.4046077614._hygCtx._hyg.5 : XorOp.{u_1} α] => HXor.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => XorOp.xor.{u_1} α inst._@.Init.Prelude.4046077614._hygCtx._hyg.5 a b)
