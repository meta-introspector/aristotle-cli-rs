import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.getNumArgs : Lean.Syntax -> Nat
def Lean.Syntax.getNumArgs : Lean.Syntax -> Nat :=
  fun (stx : Lean.Syntax) => _private.Init.Prelude.0.Lean.Syntax.setKind.match_1.{1} (fun (stx._@.Init.Prelude.3614862076._hygCtx._hyg.7 : Lean.Syntax) => Nat) stx (fun (info._@.Init.Prelude.3614862076._hygCtx._hyg.18 : Lean.SourceInfo) (kind._@.Init.Prelude.3614862076._hygCtx._hyg.19 : Lean.SyntaxNodeKind) (args : Array.{0} Lean.Syntax) => Array.size.{0} Lean.Syntax args) (fun (x._@.Init.Prelude.3614862076._hygCtx._hyg.24 : Lean.Syntax) => OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))
