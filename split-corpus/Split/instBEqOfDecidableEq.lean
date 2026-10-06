import Mathlib

set_option pp.all true
-- spec: instBEqOfDecidableEq : forall {α : Type.{u_1}} [inst._@.Init.Prelude.2223096031._hygCtx._hyg.5 : DecidableEq.{succ u_1} α], BEq.{u_1} α
def instBEqOfDecidableEq : forall {α : Type.{u_1}} [inst._@.Init.Prelude.2223096031._hygCtx._hyg.5 : DecidableEq.{succ u_1} α], BEq.{u_1} α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.2223096031._hygCtx._hyg.5 : DecidableEq.{succ u_1} α] => BEq.mk.{u_1} α (fun (a : α) (b : α) => Decidable.decide (Eq.{succ u_1} α a b) (inst._@.Init.Prelude.2223096031._hygCtx._hyg.5 a b))
