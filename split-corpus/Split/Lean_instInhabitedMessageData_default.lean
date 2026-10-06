import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedMessageData.default : Lean.MessageData
def Lean.instInhabitedMessageData.default : Lean.MessageData :=
  Lean.MessageData.ofGoal (Inhabited.default.{1} Lean.MVarId Lean.instInhabitedMVarId)
