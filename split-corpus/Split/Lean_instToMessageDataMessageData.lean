import Mathlib

set_option pp.all true
-- spec: Lean.instToMessageDataMessageData : Lean.ToMessageData Lean.MessageData
def Lean.instToMessageDataMessageData : Lean.ToMessageData Lean.MessageData :=
  Lean.ToMessageData.mk Lean.MessageData (id.{1} Lean.MessageData)
