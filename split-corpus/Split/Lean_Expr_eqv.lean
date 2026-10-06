import Mathlib

-- spec: opaque Lean.Expr.eqv : ([mdata borrowed:1 Lean.Expr]) -> ([mdata borrowed:1 Lean.Expr]) -> Bool
opaque Lean.Expr.eqv : ([mdata borrowed:1 Lean.Expr]) -> ([mdata borrowed:1 Lean.Expr]) -> Bool :=
  fun (a : Lean.Expr) (b : Lean.Expr) => Inhabited.default.{1} Bool instInhabitedBool
