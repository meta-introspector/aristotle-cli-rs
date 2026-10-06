import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.node2 : Lean.SourceInfo -> Lean.SyntaxNodeKind -> Lean.Syntax -> Lean.Syntax -> Lean.Syntax
def Lean.Syntax.node2 : Lean.SourceInfo -> Lean.SyntaxNodeKind -> Lean.Syntax -> Lean.Syntax -> Lean.Syntax :=
  fun (info : Lean.SourceInfo) (kind : Lean.SyntaxNodeKind) (a₁ : Lean.Syntax) (a₂ : Lean.Syntax) => Lean.Syntax.node info kind (Array.mkArray2.{0} Lean.Syntax a₁ a₂)
