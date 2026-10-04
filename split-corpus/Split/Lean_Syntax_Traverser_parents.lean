import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Traverser.parents : Lean.Syntax.Traverser -> (Array.{0} Lean.Syntax)
def Lean.Syntax.Traverser.parents : Lean.Syntax.Traverser -> (Array.{0} Lean.Syntax) :=
  fun (self : Lean.Syntax.Traverser) => self.2
