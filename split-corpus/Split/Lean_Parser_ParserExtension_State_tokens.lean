import Mathlib

set_option pp.all true
-- spec: Lean.Parser.ParserExtension.State.tokens : Lean.Parser.ParserExtension.State -> Lean.Parser.TokenTable
def Lean.Parser.ParserExtension.State.tokens : Lean.Parser.ParserExtension.State -> Lean.Parser.TokenTable :=
  fun (self : Lean.Parser.ParserExtension.State) => self.1
