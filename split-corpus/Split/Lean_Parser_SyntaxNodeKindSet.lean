import Mathlib

set_option pp.all true
-- spec: Lean.Parser.SyntaxNodeKindSet : Type
def Lean.Parser.SyntaxNodeKindSet : Type :=
  Lean.PersistentHashMap.{0, 0} Lean.SyntaxNodeKind Unit Lean.Name.instBEq Lean.instHashableName
