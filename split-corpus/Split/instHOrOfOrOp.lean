import Mathlib

set_option pp.all true
-- spec: instHOrOfOrOp : forall {α : Type.{u_1}} [inst._@.Init.Prelude.3361591579._hygCtx._hyg.5 : OrOp.{u_1} α], HOr.{u_1, u_1, u_1} α α α
def instHOrOfOrOp : forall {α : Type.{u_1}} [inst._@.Init.Prelude.3361591579._hygCtx._hyg.5 : OrOp.{u_1} α], HOr.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.3361591579._hygCtx._hyg.5 : OrOp.{u_1} α] => HOr.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => OrOp.or.{u_1} α inst._@.Init.Prelude.3361591579._hygCtx._hyg.5 a b)
