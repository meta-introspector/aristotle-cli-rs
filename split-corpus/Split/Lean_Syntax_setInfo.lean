import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.setInfo : Lean.SourceInfo -> Lean.Syntax -> Lean.Syntax
def Lean.Syntax.setInfo : Lean.SourceInfo -> Lean.Syntax -> Lean.Syntax :=
  fun (info : Lean.SourceInfo) (x._@.Init.Meta.Defs.2752455189._hygCtx._hyg.6 : Lean.Syntax) => _private.Init.Meta.Defs.0.Lean.Syntax.setInfo.match_1.{1} (fun (x._@.Init.Meta.Defs.2752455189._hygCtx.6.Init.Meta.Defs.2752455189._hygCtx._hyg.17 : Lean.Syntax) => Lean.Syntax) x._@.Init.Meta.Defs.2752455189._hygCtx._hyg.6 (fun (info._@.Init.Meta.Defs.2752455189._hygCtx._hyg.25 : Lean.SourceInfo) (val : String) => Lean.Syntax.atom info val) (fun (info._@.Init.Meta.Defs.2752455189._hygCtx._hyg.41 : Lean.SourceInfo) (rawVal : Substring.Raw) (val : Lean.Name) (pre : List.{0} Lean.Syntax.Preresolved) => Lean.Syntax.ident info rawVal val pre) (fun (info._@.Init.Meta.Defs.2752455189._hygCtx._hyg.57 : Lean.SourceInfo) (kind : Lean.SyntaxNodeKind) (args : Array.{0} Lean.Syntax) => Lean.Syntax.node info kind args) (fun (_ : Unit) => Lean.Syntax.missing)
