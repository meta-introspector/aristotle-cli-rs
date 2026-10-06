import Mathlib

set_option pp.all true
-- spec: instHOrElseOfOrElse : forall {α : Type.{u_1}} [inst._@.Init.Prelude.2219996198._hygCtx._hyg.5 : OrElse.{u_1} α], HOrElse.{u_1, u_1, u_1} α α α
def instHOrElseOfOrElse : forall {α : Type.{u_1}} [inst._@.Init.Prelude.2219996198._hygCtx._hyg.5 : OrElse.{u_1} α], HOrElse.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.2219996198._hygCtx._hyg.5 : OrElse.{u_1} α] => HOrElse.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : Unit -> α) => OrElse.orElse.{u_1} α inst._@.Init.Prelude.2219996198._hygCtx._hyg.5 a b)
