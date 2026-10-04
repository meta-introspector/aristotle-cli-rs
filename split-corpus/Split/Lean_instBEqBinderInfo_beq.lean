import Mathlib

set_option pp.all true
-- spec: Lean.instBEqBinderInfo.beq : Lean.BinderInfo -> Lean.BinderInfo -> Bool
def Lean.instBEqBinderInfo.beq : Lean.BinderInfo -> Lean.BinderInfo -> Bool :=
  fun (x._@.Lean.Expr.2616605480._hygCtx._hyg.1 : Lean.BinderInfo) (y._@.Lean.Expr.2616605480._hygCtx._hyg.1 : Lean.BinderInfo) => BEq.beq.{0} Nat (instBEqOfDecidableEq.{0} Nat instDecidableEqNat) (Lean.BinderInfo.ctorIdx x._@.Lean.Expr.2616605480._hygCtx._hyg.1) (Lean.BinderInfo.ctorIdx y._@.Lean.Expr.2616605480._hygCtx._hyg.1)
