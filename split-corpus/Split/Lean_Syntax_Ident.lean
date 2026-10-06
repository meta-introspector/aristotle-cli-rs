import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Ident : Type
def Lean.Syntax.Ident : Type :=
  Lean.TSyntax (List.cons.{0} Lean.SyntaxNodeKind Lean.identKind (List.nil.{0} Lean.SyntaxNodeKind))
