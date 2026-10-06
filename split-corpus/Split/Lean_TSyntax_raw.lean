import Mathlib

set_option pp.all true
-- spec: Lean.TSyntax.raw : forall {ks : Lean.SyntaxNodeKinds}, (Lean.TSyntax ks) -> Lean.Syntax
def Lean.TSyntax.raw : forall {ks : Lean.SyntaxNodeKinds}, (Lean.TSyntax ks) -> Lean.Syntax :=
  fun (ks : Lean.SyntaxNodeKinds) (self : Lean.TSyntax ks) => self.1
