import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.annotatePos : Lean.SubExpr.Pos -> Lean.Syntax.Term -> Lean.Syntax.Term
def Lean.PrettyPrinter.Delaborator.annotatePos : Lean.SubExpr.Pos -> Lean.Syntax.Term -> Lean.Syntax.Term :=
  fun (pos : Lean.SubExpr.Pos) (stx : Lean.Syntax.Term) => Lean.TSyntax.mk (List.cons.{0} Lean.SyntaxNodeKind (Lean.Name.mkStr1 "term") (List.nil.{0} Lean.SyntaxNodeKind)) (Lean.Syntax.setInfo (Lean.SourceInfo.synthetic (String.Pos.Raw.mk pos) (String.Pos.Raw.mk pos) Bool.false) (Lean.TSyntax.raw (List.cons.{0} Lean.SyntaxNodeKind (Lean.Name.mkStr1 "term") (List.nil.{0} Lean.SyntaxNodeKind)) stx))
