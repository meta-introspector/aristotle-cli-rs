import Mathlib

set_option pp.all true
-- spec: Lean.SyntaxNodeKinds : Type
def Lean.SyntaxNodeKinds : Type :=
  List.{0} Lean.SyntaxNodeKind
