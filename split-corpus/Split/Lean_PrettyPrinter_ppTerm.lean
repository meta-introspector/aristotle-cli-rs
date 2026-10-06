import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.ppTerm : Lean.Syntax.Term -> (Lean.Core.CoreM Std.Format)
def Lean.PrettyPrinter.ppTerm : Lean.Syntax.Term -> (Lean.Core.CoreM Std.Format) :=
  fun (stx : Lean.Syntax.Term) => Lean.PrettyPrinter.ppCategory (Lean.Name.mkStr1 "term") (Lean.TSyntax.raw (List.cons.{0} Lean.SyntaxNodeKind (Lean.Name.mkStr1 "term") (List.nil.{0} Lean.SyntaxNodeKind)) stx)
