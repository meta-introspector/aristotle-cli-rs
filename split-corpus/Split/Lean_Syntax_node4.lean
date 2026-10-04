import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.node4 : Lean.SourceInfo -> Lean.SyntaxNodeKind -> Lean.Syntax -> Lean.Syntax -> Lean.Syntax -> Lean.Syntax -> Lean.Syntax
def Lean.Syntax.node4 : Lean.SourceInfo -> Lean.SyntaxNodeKind -> Lean.Syntax -> Lean.Syntax -> Lean.Syntax -> Lean.Syntax -> Lean.Syntax :=
  fun (info : Lean.SourceInfo) (kind : Lean.SyntaxNodeKind) (a₁ : Lean.Syntax) (a₂ : Lean.Syntax) (a₃ : Lean.Syntax) (a₄ : Lean.Syntax) => Lean.Syntax.node info kind (Array.mkArray4.{0} Lean.Syntax a₁ a₂ a₃ a₄)
