import Mathlib

set_option pp.all true
-- spec: Lean.Parser.ParserExtension.instInhabitedOLeanEntry : Inhabited.{1} Lean.Parser.ParserExtension.OLeanEntry
def Lean.Parser.ParserExtension.instInhabitedOLeanEntry : Inhabited.{1} Lean.Parser.ParserExtension.OLeanEntry :=
  Inhabited.mk.{1} Lean.Parser.ParserExtension.OLeanEntry Lean.Parser.ParserExtension.instInhabitedOLeanEntry.default
