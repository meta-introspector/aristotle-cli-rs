import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Term : Type
def Lean.Syntax.Term : Type :=
  Lean.TSyntax (List.cons.{0} Lean.SyntaxNodeKind (Lean.Name.mkStr1 "term") (List.nil.{0} Lean.SyntaxNodeKind))
