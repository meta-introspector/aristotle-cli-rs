import Mathlib

set_option pp.all true
-- spec: instHPow : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Prelude.3805852345._hygCtx._hyg.9 : Pow.{u_1, u_2} α β], HPow.{u_1, u_2, u_1} α β α
def instHPow : forall {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Prelude.3805852345._hygCtx._hyg.9 : Pow.{u_1, u_2} α β], HPow.{u_1, u_2, u_1} α β α :=
  fun {α : Type.{u_1}} {β : Type.{u_2}} [inst._@.Init.Prelude.3805852345._hygCtx._hyg.9 : Pow.{u_1, u_2} α β] => HPow.mk.{u_1, u_2, u_1} α β α (fun (a : α) (b : β) => Pow.pow.{u_1, u_2} α β inst._@.Init.Prelude.3805852345._hygCtx._hyg.9 a b)
