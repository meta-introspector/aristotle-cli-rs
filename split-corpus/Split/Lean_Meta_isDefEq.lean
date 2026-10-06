import Mathlib

set_option pp.all true
-- spec: Lean.Meta.isDefEq : Lean.Expr -> Lean.Expr -> (Lean.Meta.MetaM Bool)
def Lean.Meta.isDefEq : Lean.Expr -> Lean.Expr -> (Lean.Meta.MetaM Bool) :=
  fun (t : Lean.Expr) (s : Lean.Expr) => Lean.Meta.isExprDefEq t s
