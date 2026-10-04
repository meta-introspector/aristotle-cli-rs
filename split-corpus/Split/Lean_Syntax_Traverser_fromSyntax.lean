import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Traverser.fromSyntax : Lean.Syntax -> Lean.Syntax.Traverser
def Lean.Syntax.Traverser.fromSyntax : Lean.Syntax -> Lean.Syntax.Traverser :=
  fun (stx : Lean.Syntax) => Lean.Syntax.Traverser.mk stx (List.toArray.{0} Lean.Syntax (List.nil.{0} Lean.Syntax)) (List.toArray.{0} Nat (List.nil.{0} Nat))
