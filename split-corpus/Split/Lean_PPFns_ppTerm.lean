import Mathlib

set_option pp.all true
-- spec: Lean.PPFns.ppTerm : Lean.PPFns -> Lean.PPContext -> Lean.Syntax.Term -> (IO Std.Format)
def Lean.PPFns.ppTerm : Lean.PPFns -> Lean.PPContext -> Lean.Syntax.Term -> (IO Std.Format) :=
  fun (self : Lean.PPFns) => self.3
