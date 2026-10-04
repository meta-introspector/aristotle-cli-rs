import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.setArg : Lean.Syntax -> Nat -> Lean.Syntax -> Lean.Syntax
def Lean.Syntax.setArg : Lean.Syntax -> Nat -> Lean.Syntax -> Lean.Syntax :=
  fun (stx : Lean.Syntax) (i : Nat) (arg : Lean.Syntax) => _private.Init.Syntax.0.Lean.Syntax.setArgs.match_1.{1} (fun (stx._@.Init.Syntax.757155482._hygCtx._hyg.9 : Lean.Syntax) => Lean.Syntax) stx (fun (info : Lean.SourceInfo) (k : Lean.SyntaxNodeKind) (args : Array.{0} Lean.Syntax) => Lean.Syntax.node info k (Array.setIfInBounds.{0} Lean.Syntax args i arg)) (fun (stx : Lean.Syntax) => stx)
