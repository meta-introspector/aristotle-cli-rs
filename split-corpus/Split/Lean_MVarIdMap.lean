import Mathlib

set_option pp.all true
-- spec: Lean.MVarIdMap : Type -> Type
def Lean.MVarIdMap : Type -> Type :=
  fun (α : Type) => Std.TreeMap.{0, 0} Lean.MVarId α (fun (x1._@.Lean.Expr.1315856367._hygCtx._hyg.9 : Lean.MVarId) (x2._@.Lean.Expr.1315856367._hygCtx._hyg.9 : Lean.MVarId) => Lean.Name.quickCmp (Lean.MVarId.name x1._@.Lean.Expr.1315856367._hygCtx._hyg.9) (Lean.MVarId.name x2._@.Lean.Expr.1315856367._hygCtx._hyg.9))
