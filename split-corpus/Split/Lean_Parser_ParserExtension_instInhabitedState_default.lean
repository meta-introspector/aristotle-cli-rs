import Mathlib

set_option pp.all true
-- spec: Lean.Parser.ParserExtension.instInhabitedState.default : Lean.Parser.ParserExtension.State
def Lean.Parser.ParserExtension.instInhabitedState.default : Lean.Parser.ParserExtension.State :=
  Lean.Parser.ParserExtension.State.mk (Inhabited.default.{1} Lean.Parser.TokenTable (Lean.Data.Trie.instInhabited Lean.Parser.Token)) (Inhabited.default.{1} Lean.Parser.SyntaxNodeKindSet (Lean.PersistentHashMap.instInhabited.{0, 0} Lean.SyntaxNodeKind Unit Lean.Name.instBEq Lean.instHashableName)) (Inhabited.default.{1} Lean.Parser.ParserCategories (Lean.PersistentHashMap.instInhabited.{0, 0} Lean.Name Lean.Parser.ParserCategory Lean.Name.instBEq Lean.instHashableName))
