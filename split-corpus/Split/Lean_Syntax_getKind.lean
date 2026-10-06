import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.getKind : Lean.Syntax -> Lean.SyntaxNodeKind
def Lean.Syntax.getKind : Lean.Syntax -> Lean.SyntaxNodeKind :=
  fun (stx : Lean.Syntax) => _private.Init.Prelude.0.Lean.Syntax.getKind.match_1.{1} (fun (stx._@.Init.Prelude.29326839._hygCtx._hyg.7 : Lean.Syntax) => Lean.SyntaxNodeKind) stx (fun (info._@.Init.Prelude.29326839._hygCtx._hyg.18 : Lean.SourceInfo) (k : Lean.SyntaxNodeKind) (args._@.Init.Prelude.29326839._hygCtx._hyg.19 : Array.{0} Lean.Syntax) => k) (fun (_ : Unit) => Lean.Name.mkStr1 "missing") (fun (info._@.Init.Prelude.29326839._hygCtx._hyg.32 : Lean.SourceInfo) (v : String) => Lean.Name.mkSimple v) (fun (info._@.Init.Prelude.29326839._hygCtx._hyg.49 : Lean.SourceInfo) (rawVal._@.Init.Prelude.29326839._hygCtx._hyg.50 : Substring.Raw) (val._@.Init.Prelude.29326839._hygCtx._hyg.51 : Lean.Name) (preresolved._@.Init.Prelude.29326839._hygCtx._hyg.52 : List.{0} Lean.Syntax.Preresolved) => Lean.identKind)
