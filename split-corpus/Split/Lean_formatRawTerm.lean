import Mathlib

set_option pp.all true
-- spec: Lean.formatRawTerm : Lean.PPContext -> Lean.Syntax.Term -> Std.Format
def Lean.formatRawTerm : Lean.PPContext -> Lean.Syntax.Term -> Std.Format :=
  fun (ctx : Lean.PPContext) (stx : Lean.Syntax.Term) => Lean.Syntax.formatStx (Lean.TSyntax.raw (List.cons.{0} Lean.SyntaxNodeKind (Lean.Name.mkStr1 "term") (List.nil.{0} Lean.SyntaxNodeKind)) stx) (Option.some.{0} Nat (Lean.Option.get Nat Lean.KVMap.instValueNat (Lean.PPContext.opts ctx) Lean.pp.raw.maxDepth)) (Lean.Option.get Bool Lean.KVMap.instValueBool (Lean.PPContext.opts ctx) Lean.pp.raw.showInfo)
