import Mathlib

set_option pp.all true
-- spec: instHMul : forall {α : Type.{u_1}} [inst._@.Init.Prelude.3013044039._hygCtx._hyg.5 : Mul.{u_1} α], HMul.{u_1, u_1, u_1} α α α
def instHMul : forall {α : Type.{u_1}} [inst._@.Init.Prelude.3013044039._hygCtx._hyg.5 : Mul.{u_1} α], HMul.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.3013044039._hygCtx._hyg.5 : Mul.{u_1} α] => HMul.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => Mul.mul.{u_1} α inst._@.Init.Prelude.3013044039._hygCtx._hyg.5 a b)
