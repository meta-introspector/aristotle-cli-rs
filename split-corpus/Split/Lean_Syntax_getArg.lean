import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.getArg : Lean.Syntax -> Nat -> Lean.Syntax
def Lean.Syntax.getArg : Lean.Syntax -> Nat -> Lean.Syntax :=
  fun (stx : Lean.Syntax) (i : Nat) => _private.Init.Prelude.0.Lean.Syntax.setKind.match_1.{1} (fun (stx._@.Init.Prelude.3089524335._hygCtx._hyg.8 : Lean.Syntax) => Lean.Syntax) stx (fun (info._@.Init.Prelude.3089524335._hygCtx._hyg.19 : Lean.SourceInfo) (kind._@.Init.Prelude.3089524335._hygCtx._hyg.20 : Lean.SyntaxNodeKind) (args : Array.{0} Lean.Syntax) => Array.getD.{0} Lean.Syntax args i Lean.Syntax.missing) (fun (x._@.Init.Prelude.3089524335._hygCtx._hyg.27 : Lean.Syntax) => Lean.Syntax.missing)
