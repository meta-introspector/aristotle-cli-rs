import Mathlib

set_option pp.all true
-- spec: Lean.PPFns.ppExprWithInfos : Lean.PPFns -> Lean.PPContext -> Lean.Expr -> (IO Lean.FormatWithInfos)
def Lean.PPFns.ppExprWithInfos : Lean.PPFns -> Lean.PPContext -> Lean.Expr -> (IO Lean.FormatWithInfos) :=
  fun (self : Lean.PPFns) => self.1
