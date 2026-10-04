import Mathlib

-- spec: opaque Lean.Expr.findImpl? : ([mdata borrowed:1 Lean.Expr -> Bool]) -> ([mdata borrowed:1 Lean.Expr]) -> (Option.{0} Lean.Expr)
opaque Lean.Expr.findImpl? : ([mdata borrowed:1 Lean.Expr -> Bool]) -> ([mdata borrowed:1 Lean.Expr]) -> (Option.{0} Lean.Expr) :=
  fun (p : Lean.Expr -> Bool) (e : Lean.Expr) => Inhabited.default.{1} (Option.{0} Lean.Expr) (instInhabitedOption.{0} Lean.Expr)
