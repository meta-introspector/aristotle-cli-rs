import Mathlib

set_option pp.all true
-- spec: Lean.instInhabitedTSyntax : forall {ks : Lean.SyntaxNodeKinds}, Inhabited.{1} (Lean.TSyntax ks)
def Lean.instInhabitedTSyntax : forall {ks : Lean.SyntaxNodeKinds}, Inhabited.{1} (Lean.TSyntax ks) :=
  fun {ks : Lean.SyntaxNodeKinds} => Inhabited.mk.{1} (Lean.TSyntax ks) (Lean.TSyntax.mk ks (Inhabited.default.{1} Lean.Syntax Lean.instInhabitedSyntax))
