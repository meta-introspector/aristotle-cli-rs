import Mathlib

set_option pp.all true
-- spec: instHMod : forall {α : Type.{u_1}} [inst._@.Init.Prelude.2224171311._hygCtx._hyg.5 : Mod.{u_1} α], HMod.{u_1, u_1, u_1} α α α
def instHMod : forall {α : Type.{u_1}} [inst._@.Init.Prelude.2224171311._hygCtx._hyg.5 : Mod.{u_1} α], HMod.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.2224171311._hygCtx._hyg.5 : Mod.{u_1} α] => HMod.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => Mod.mod.{u_1} α inst._@.Init.Prelude.2224171311._hygCtx._hyg.5 a b)
