import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Level : Type
def Lean.Syntax.Level : Type :=
  Lean.TSyntax (List.cons.{0} Lean.SyntaxNodeKind (Lean.Name.mkStr1 "level") (List.nil.{0} Lean.SyntaxNodeKind))
