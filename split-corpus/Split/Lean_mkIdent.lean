import Mathlib

set_option pp.all true
-- spec: Lean.mkIdent : Lean.Name -> Lean.Syntax.Ident
def Lean.mkIdent : Lean.Name -> Lean.Syntax.Ident :=
  fun (val : Lean.Name) => Lean.TSyntax.mk (List.cons.{0} Lean.SyntaxNodeKind Lean.identKind (List.nil.{0} Lean.SyntaxNodeKind)) (Lean.Syntax.ident Lean.SourceInfo.none (String.toRawSubstring (_private.Init.Meta.Defs.0.Lean.Name.Internal.Meta.toString val Bool.true)) val (List.nil.{0} Lean.Syntax.Preresolved))
