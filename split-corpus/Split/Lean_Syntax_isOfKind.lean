import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.isOfKind : Lean.Syntax -> Lean.SyntaxNodeKind -> Bool
def Lean.Syntax.isOfKind : Lean.Syntax -> Lean.SyntaxNodeKind -> Bool :=
  fun (stx : Lean.Syntax) (k : Lean.SyntaxNodeKind) => BEq.beq.{0} Lean.SyntaxNodeKind Lean.Name.instBEq (Lean.Syntax.getKind stx) k
