import Mathlib

-- spec: opaque Lean.Expr.mkAppData : Lean.Expr.Data -> Lean.Expr.Data -> Lean.Expr.Data
opaque Lean.Expr.mkAppData : Lean.Expr.Data -> Lean.Expr.Data -> Lean.Expr.Data :=
  fun (fData : Lean.Expr.Data) (aData : Lean.Expr.Data) => Inhabited.default.{1} Lean.Expr.Data Lean.instInhabitedData_1
