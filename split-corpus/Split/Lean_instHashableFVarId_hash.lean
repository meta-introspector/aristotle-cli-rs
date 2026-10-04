import Mathlib

set_option pp.all true
-- spec: Lean.instHashableFVarId.hash : Lean.FVarId -> UInt64
def Lean.instHashableFVarId.hash : Lean.FVarId -> UInt64 :=
  fun (x._@.Lean.Expr.2479116559._hygCtx._hyg.51 : Lean.FVarId) => _private.Lean.Expr.0.Lean.instHashableFVarId.hash.match_1.{1} (fun (x._@.Lean.Expr.2479116559._hygCtx.51.Lean.Expr.1363585667._hygCtx._hyg.7 : Lean.FVarId) => UInt64) x._@.Lean.Expr.2479116559._hygCtx._hyg.51 (fun (a._@.Lean.Expr.2479116559._hygCtx._hyg.52 : Lean.Name) => mixHash (OfNat.ofNat.{0} UInt64 0 (UInt64.instOfNat 0)) (Hashable.hash.{1} Lean.Name Lean.instHashableName a._@.Lean.Expr.2479116559._hygCtx._hyg.52))
