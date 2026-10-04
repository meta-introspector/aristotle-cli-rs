import Mathlib

set_option pp.all true
-- spec: Lean.instToMessageDataFormat : Lean.ToMessageData Std.Format
def Lean.instToMessageDataFormat : Lean.ToMessageData Std.Format :=
  Lean.ToMessageData.mk Std.Format Lean.MessageData.ofFormat
