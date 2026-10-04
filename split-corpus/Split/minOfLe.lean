import Mathlib

set_option pp.all true
-- spec: minOfLe : forall {α : Type.{u_1}} [inst._@.Init.Prelude.636837753._hygCtx._hyg.5 : LE.{u_1} α] [inst._@.Init.Prelude.636837753._hygCtx._hyg.8 : DecidableRel.{succ u_1, succ u_1} α α (LE.le.{u_1} α inst._@.Init.Prelude.636837753._hygCtx._hyg.5)], Min.{u_1} α
def minOfLe : forall {α : Type.{u_1}} [inst._@.Init.Prelude.636837753._hygCtx._hyg.5 : LE.{u_1} α] [inst._@.Init.Prelude.636837753._hygCtx._hyg.8 : DecidableRel.{succ u_1, succ u_1} α α (LE.le.{u_1} α inst._@.Init.Prelude.636837753._hygCtx._hyg.5)], Min.{u_1} α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.636837753._hygCtx._hyg.5 : LE.{u_1} α] [inst._@.Init.Prelude.636837753._hygCtx._hyg.8 : DecidableRel.{succ u_1, succ u_1} α α (LE.le.{u_1} α inst._@.Init.Prelude.636837753._hygCtx._hyg.5)] => Min.mk.{u_1} α (fun (x : α) (y : α) => ite.{succ u_1} α (LE.le.{u_1} α inst._@.Init.Prelude.636837753._hygCtx._hyg.5 x y) (inst._@.Init.Prelude.636837753._hygCtx._hyg.8 x y) x y)
