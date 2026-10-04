import Mathlib

-- spec: opaque Lean.Meta.isExprDefEqAux : Lean.Expr -> Lean.Expr -> (Lean.Meta.MetaM Bool)
opaque Lean.Meta.isExprDefEqAux : Lean.Expr -> Lean.Expr -> (Lean.Meta.MetaM Bool) :=
  Inhabited.default.{1} (Lean.Expr -> Lean.Expr -> (Lean.Meta.MetaM Bool)) (Pi.instInhabited.{1, 1} Lean.Expr (fun (a._@._internal._hyg.0 : Lean.Expr) => Lean.Expr -> (Lean.Meta.MetaM Bool)) (fun (a : Lean.Expr) => Pi.instInhabited.{1, 1} Lean.Expr (fun (a._@._internal._hyg.0 : Lean.Expr) => Lean.Meta.MetaM Bool) (fun (a : Lean.Expr) => Lean.Meta.instInhabitedMetaM Bool)))
