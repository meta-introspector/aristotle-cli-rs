import Mathlib

set_option pp.all true
-- spec: Lean.Parser.ParserExtension.instInhabitedOLeanEntry.default : Lean.Parser.ParserExtension.OLeanEntry
def Lean.Parser.ParserExtension.instInhabitedOLeanEntry.default : Lean.Parser.ParserExtension.OLeanEntry :=
  Lean.Parser.ParserExtension.OLeanEntry.token (Inhabited.default.{1} Lean.Parser.Token String.instInhabited)
