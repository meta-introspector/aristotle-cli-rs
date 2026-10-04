import Mathlib

-- spec: opaque Lean.Parser.parserExtension : Lean.Parser.ParserExtension
opaque Lean.Parser.parserExtension : Lean.Parser.ParserExtension :=
  Inhabited.default.{1} Lean.Parser.ParserExtension (Lean.instInhabitedScopedEnvExtension Lean.Parser.ParserExtension.OLeanEntry Lean.Parser.ParserExtension.instInhabitedOLeanEntry Lean.Parser.ParserExtension.Entry Lean.Parser.ParserExtension.State)
