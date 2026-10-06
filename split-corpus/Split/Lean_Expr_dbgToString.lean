import Mathlib

-- spec: opaque Lean.Expr.dbgToString : ([mdata borrowed:1 Lean.Expr]) -> String
opaque Lean.Expr.dbgToString : ([mdata borrowed:1 Lean.Expr]) -> String :=
  fun (e : Lean.Expr) => Inhabited.default.{1} String String.instInhabited
