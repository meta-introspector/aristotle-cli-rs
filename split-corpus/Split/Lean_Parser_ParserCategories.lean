import Mathlib

set_option pp.all true
-- spec: Lean.Parser.ParserCategories : Type
def Lean.Parser.ParserCategories : Type :=
  Lean.PersistentHashMap.{0, 0} Lean.Name Lean.Parser.ParserCategory Lean.Name.instBEq Lean.instHashableName
