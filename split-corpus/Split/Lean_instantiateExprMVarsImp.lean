import Mathlib

-- spec: opaque Lean.instantiateExprMVarsImp : Lean.MetavarContext -> Lean.Expr -> (Prod.{0, 0} Lean.MetavarContext Lean.Expr)
opaque Lean.instantiateExprMVarsImp : Lean.MetavarContext -> Lean.Expr -> (Prod.{0, 0} Lean.MetavarContext Lean.Expr) :=
  fun (mctx : Lean.MetavarContext) (e : Lean.Expr) => Inhabited.default.{1} (Prod.{0, 0} Lean.MetavarContext Lean.Expr) (instInhabitedProd.{0, 0} Lean.MetavarContext Lean.Expr Lean.instInhabitedMetavarContext Lean.instInhabitedExpr)
