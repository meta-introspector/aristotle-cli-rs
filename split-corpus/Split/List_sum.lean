import Mathlib

set_option pp.all true
-- spec: List.sum : forall {α : Type.{u_1}} [inst._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.6 : Add.{u_1} α] [inst._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.9 : Zero.{u_1} α], (List.{u_1} α) -> α
def List.sum : forall {α : Type.{u_1}} [inst._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.6 : Add.{u_1} α] [inst._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.9 : Zero.{u_1} α], (List.{u_1} α) -> α :=
  fun {α : Type.{u_1}} [inst._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.6 : Add.{u_1} α] [inst._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.9 : Zero.{u_1} α] => List.foldr.{u_1, u_1} α α (fun (x1._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.19 : α) (x2._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.19 : α) => HAdd.hAdd.{u_1, u_1, u_1} α α α (instHAdd.{u_1} α inst._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.6) x1._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.19 x2._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.19) (OfNat.ofNat.{u_1} α 0 (Zero.toOfNat0.{u_1} α inst._@.Init.Data.List.Basic.2803572646._hygCtx._hyg.9))
