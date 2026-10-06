import Mathlib

set_option pp.all true
-- spec: Lean.instToMessageDataOfToFormat : forall {α : Type} [inst._@.Lean.Message.694953399._hygCtx._hyg.5 : Std.ToFormat.{0} α], Lean.ToMessageData α
def Lean.instToMessageDataOfToFormat : forall {α : Type} [inst._@.Lean.Message.694953399._hygCtx._hyg.5 : Std.ToFormat.{0} α], Lean.ToMessageData α :=
  fun {α : Type} [inst._@.Lean.Message.694953399._hygCtx._hyg.5 : Std.ToFormat.{0} α] => Lean.ToMessageData.mk α (Function.comp.{1, 1, 1} α Std.Format Lean.MessageData Lean.MessageData.ofFormat (Std.ToFormat.format.{0} α inst._@.Lean.Message.694953399._hygCtx._hyg.5))
