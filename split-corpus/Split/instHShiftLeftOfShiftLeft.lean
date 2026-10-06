import Mathlib

set_option pp.all true
-- spec: instHShiftLeftOfShiftLeft : forall {α : Type.{u_1}} [inst._@.Init.Prelude.534577705._hygCtx._hyg.5 : ShiftLeft.{u_1} α], HShiftLeft.{u_1, u_1, u_1} α α α
def instHShiftLeftOfShiftLeft : forall {α : Type.{u_1}} [inst._@.Init.Prelude.534577705._hygCtx._hyg.5 : ShiftLeft.{u_1} α], HShiftLeft.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.534577705._hygCtx._hyg.5 : ShiftLeft.{u_1} α] => HShiftLeft.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => ShiftLeft.shiftLeft.{u_1} α inst._@.Init.Prelude.534577705._hygCtx._hyg.5 a b)
