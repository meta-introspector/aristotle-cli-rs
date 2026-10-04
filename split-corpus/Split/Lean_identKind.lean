import Mathlib

set_option pp.all true
-- spec: Lean.identKind : Lean.SyntaxNodeKind
def Lean.identKind : Lean.SyntaxNodeKind :=
  Lean.Name.mkStr1 "ident"
