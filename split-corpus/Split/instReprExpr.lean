import Mathlib

set_option pp.all true
-- spec: instReprExpr : Repr.{0} Expr
def instReprExpr : Repr.{0} Expr :=
  Repr.mk.{0} Expr instReprExpr.repr
