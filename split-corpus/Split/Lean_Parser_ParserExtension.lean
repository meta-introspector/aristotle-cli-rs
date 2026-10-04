import Mathlib

set_option pp.all true
-- spec: Lean.Parser.ParserExtension : Type
def Lean.Parser.ParserExtension : Type :=
  Lean.ScopedEnvExtension Lean.Parser.ParserExtension.OLeanEntry Lean.Parser.ParserExtension.Entry Lean.Parser.ParserExtension.State
