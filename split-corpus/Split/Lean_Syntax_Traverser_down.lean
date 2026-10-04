import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Traverser.down : Lean.Syntax.Traverser -> Nat -> Lean.Syntax.Traverser
def Lean.Syntax.Traverser.down : Lean.Syntax.Traverser -> Nat -> Lean.Syntax.Traverser :=
  fun (t : Lean.Syntax.Traverser) (idx : Nat) => ite.{1} Lean.Syntax.Traverser (LT.lt.{0} Nat instLTNat idx (Lean.Syntax.getNumArgs (Lean.Syntax.Traverser.cur t))) (Nat.decLt idx (Lean.Syntax.getNumArgs (Lean.Syntax.Traverser.cur t))) (Lean.Syntax.Traverser.mk (Lean.Syntax.getArg (Lean.Syntax.Traverser.cur t) idx) (Array.push.{0} Lean.Syntax (Lean.Syntax.Traverser.parents t) (Lean.Syntax.setArg (Lean.Syntax.Traverser.cur t) idx (Inhabited.default.{1} Lean.Syntax Lean.instInhabitedSyntax))) (Array.push.{0} Nat (Lean.Syntax.Traverser.idxs t) idx)) (Lean.Syntax.Traverser.mk Lean.Syntax.missing (Array.push.{0} Lean.Syntax (Lean.Syntax.Traverser.parents t) (Lean.Syntax.Traverser.cur t)) (Array.push.{0} Nat (Lean.Syntax.Traverser.idxs t) idx))
