import Mathlib

set_option pp.all true
-- spec: Lean.MessageData.instAppend : Append.{0} Lean.MessageData
def Lean.MessageData.instAppend : Append.{0} Lean.MessageData :=
  Append.mk.{0} Lean.MessageData Lean.MessageData.compose
