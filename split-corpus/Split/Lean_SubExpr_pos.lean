import Mathlib

set_option pp.all true
-- spec: Lean.SubExpr.pos : Lean.SubExpr -> Lean.SubExpr.Pos
def Lean.SubExpr.pos : Lean.SubExpr -> Lean.SubExpr.Pos :=
  fun (self : Lean.SubExpr) => self.2
