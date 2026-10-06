import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Traverser.idxs : Lean.Syntax.Traverser -> (Array.{0} Nat)
def Lean.Syntax.Traverser.idxs : Lean.Syntax.Traverser -> (Array.{0} Nat) :=
  fun (self : Lean.Syntax.Traverser) => self.3
