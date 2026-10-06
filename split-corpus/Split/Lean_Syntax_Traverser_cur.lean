import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.Traverser.cur : Lean.Syntax.Traverser -> Lean.Syntax
def Lean.Syntax.Traverser.cur : Lean.Syntax.Traverser -> Lean.Syntax :=
  fun (self : Lean.Syntax.Traverser) => self.1
