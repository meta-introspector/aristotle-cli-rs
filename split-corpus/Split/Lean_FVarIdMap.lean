import Mathlib

set_option pp.all true
-- spec: Lean.FVarIdMap : Type -> Type
def Lean.FVarIdMap : Type -> Type :=
  fun (α : Type) => Std.TreeMap.{0, 0} Lean.FVarId α (fun (x1._@.Lean.Expr.3305537814._hygCtx._hyg.9 : Lean.FVarId) (x2._@.Lean.Expr.3305537814._hygCtx._hyg.9 : Lean.FVarId) => Lean.Name.quickCmp (Lean.FVarId.name x1._@.Lean.Expr.3305537814._hygCtx._hyg.9) (Lean.FVarId.name x2._@.Lean.Expr.3305537814._hygCtx._hyg.9))
