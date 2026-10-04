import Mathlib

set_option pp.all true
-- spec: instHSub : forall {α : Type.{u_1}} [inst._@.Init.Prelude.4034066273._hygCtx._hyg.5 : Sub.{u_1} α], HSub.{u_1, u_1, u_1} α α α
def instHSub : forall {α : Type.{u_1}} [inst._@.Init.Prelude.4034066273._hygCtx._hyg.5 : Sub.{u_1} α], HSub.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.4034066273._hygCtx._hyg.5 : Sub.{u_1} α] => HSub.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => Sub.sub.{u_1} α inst._@.Init.Prelude.4034066273._hygCtx._hyg.5 a b)
