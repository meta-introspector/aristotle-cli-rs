import Mathlib

set_option pp.all true
-- spec: instHShiftRightOfShiftRight : forall {α : Type.{u_1}} [inst._@.Init.Prelude.2395489171._hygCtx._hyg.5 : ShiftRight.{u_1} α], HShiftRight.{u_1, u_1, u_1} α α α
def instHShiftRightOfShiftRight : forall {α : Type.{u_1}} [inst._@.Init.Prelude.2395489171._hygCtx._hyg.5 : ShiftRight.{u_1} α], HShiftRight.{u_1, u_1, u_1} α α α :=
  fun {α : Type.{u_1}} [inst._@.Init.Prelude.2395489171._hygCtx._hyg.5 : ShiftRight.{u_1} α] => HShiftRight.mk.{u_1, u_1, u_1} α α α (fun (a : α) (b : α) => ShiftRight.shiftRight.{u_1} α inst._@.Init.Prelude.2395489171._hygCtx._hyg.5 a b)
