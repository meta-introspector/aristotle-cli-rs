import Mathlib

set_option pp.all true
-- spec: Lean.Message : Type
def Lean.Message : Type :=
  Lean.BaseMessage.{0} Lean.MessageData
