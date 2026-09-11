import Lean

/-!
# Stage 4 — Introduce Meta-Level Construction

Construct expressions manually. We now have:
* object level (`True`)
* meta level (`Expr`)
* transformation layer (`MetaM`)

This is the first real reflective layer.
-/

open Lean Meta

def mkTrueExpr : MetaM Expr := do
  return mkConst ``True

#check mkTrueExpr
