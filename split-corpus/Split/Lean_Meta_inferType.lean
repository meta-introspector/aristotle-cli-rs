import Mathlib

-- spec: opaque Lean.Meta.inferType : Lean.Expr -> (Lean.Meta.MetaM Lean.Expr)
opaque Lean.Meta.inferType : Lean.Expr -> (Lean.Meta.MetaM Lean.Expr) :=
  Inhabited.default.{1} (Lean.Expr -> (Lean.Meta.MetaM Lean.Expr)) (instInhabitedForallOfMonad.{0, 0} Lean.Expr Lean.Meta.MetaM Lean.Meta.instMonadMetaM)
