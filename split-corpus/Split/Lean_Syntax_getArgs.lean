import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.getArgs : Lean.Syntax -> (Array.{0} Lean.Syntax)
def Lean.Syntax.getArgs : Lean.Syntax -> (Array.{0} Lean.Syntax) :=
  fun (stx : Lean.Syntax) => _private.Init.Prelude.0.Lean.Syntax.setKind.match_1.{1} (fun (stx._@.Init.Prelude.2659648078._hygCtx._hyg.8 : Lean.Syntax) => Array.{0} Lean.Syntax) stx (fun (info._@.Init.Prelude.2659648078._hygCtx._hyg.19 : Lean.SourceInfo) (kind._@.Init.Prelude.2659648078._hygCtx._hyg.20 : Lean.SyntaxNodeKind) (args : Array.{0} Lean.Syntax) => args) (fun (x._@.Init.Prelude.2659648078._hygCtx._hyg.25 : Lean.Syntax) => Array.empty.{0} Lean.Syntax)
