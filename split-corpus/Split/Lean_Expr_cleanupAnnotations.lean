import Mathlib

-- spec: opaque Lean.Expr.cleanupAnnotations : Lean.Expr -> Lean.Expr
opaque Lean.Expr.cleanupAnnotations : Lean.Expr -> Lean.Expr :=
  fun (e : Lean.Expr) => let inst : Inhabited.{1} Lean.Expr := Inhabited.mk.{1} Lean.Expr e; Inhabited.default.{1} Lean.Expr inst
