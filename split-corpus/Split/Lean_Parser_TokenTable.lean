import Mathlib

set_option pp.all true
-- spec: Lean.Parser.TokenTable : Type
def Lean.Parser.TokenTable : Type :=
  Lean.Data.Trie Lean.Parser.Token
