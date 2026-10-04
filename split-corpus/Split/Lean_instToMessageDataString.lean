import Mathlib

set_option pp.all true
-- spec: Lean.instToMessageDataString : Lean.ToMessageData String
def Lean.instToMessageDataString : Lean.ToMessageData String :=
  Lean.ToMessageData.mk String Lean.stringToMessageData
