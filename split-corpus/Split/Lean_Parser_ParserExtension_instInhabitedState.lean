import Mathlib

set_option pp.all true
-- spec: Lean.Parser.ParserExtension.instInhabitedState : Inhabited.{1} Lean.Parser.ParserExtension.State
def Lean.Parser.ParserExtension.instInhabitedState : Inhabited.{1} Lean.Parser.ParserExtension.State :=
  Inhabited.mk.{1} Lean.Parser.ParserExtension.State Lean.Parser.ParserExtension.instInhabitedState.default
