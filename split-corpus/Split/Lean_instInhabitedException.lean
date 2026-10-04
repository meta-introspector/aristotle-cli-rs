import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedException : Inhabited.{1} Lean.Exception
def Lean.instInhabitedException : Inhabited.{1} Lean.Exception :=
  Inhabited.mk.{1} Lean.Exception (Lean.Exception.error (Inhabited.default.{1} Lean.Syntax Lean.instInhabitedSyntax) (Inhabited.default.{1} Lean.MessageData Lean.instInhabitedMessageData))
