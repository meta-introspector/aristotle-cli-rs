import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedMessageData : Inhabited.{1} Lean.MessageData
def Lean.instInhabitedMessageData : Inhabited.{1} Lean.MessageData :=
  Inhabited.mk.{1} Lean.MessageData Lean.instInhabitedMessageData.default
