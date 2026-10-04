import Mathlib

set_option pp.all true
-- spec: Lean.TSyntax.getId : Lean.Syntax.Ident -> Lean.Name
def Lean.TSyntax.getId : Lean.Syntax.Ident -> Lean.Name :=
  fun (s : Lean.Syntax.Ident) => Lean.Syntax.getId (Lean.TSyntax.raw (List.cons.{0} Lean.SyntaxNodeKind Lean.identKind (List.nil.{0} Lean.SyntaxNodeKind)) s)
