import Mathlib

set_option pp.all true
-- spec: Lean.FVarIdSet : Type
def Lean.FVarIdSet : Type :=
  Std.TreeSet.{0} Lean.FVarId (fun (x1._@.Lean.Expr.4024934197._hygCtx._hyg.7 : Lean.FVarId) (x2._@.Lean.Expr.4024934197._hygCtx._hyg.7 : Lean.FVarId) => Lean.Name.quickCmp (Lean.FVarId.name x1._@.Lean.Expr.4024934197._hygCtx._hyg.7) (Lean.FVarId.name x2._@.Lean.Expr.4024934197._hygCtx._hyg.7))
