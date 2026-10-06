import Mathlib

set_option pp.all true
-- spec: Lean.instToMessageDataName : Lean.ToMessageData Lean.Name
def Lean.instToMessageDataName : Lean.ToMessageData Lean.Name :=
  Lean.ToMessageData.mk Lean.Name Lean.MessageData.ofName
