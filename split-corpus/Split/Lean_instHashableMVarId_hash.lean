import Mathlib

set_option pp.all true
-- spec: Lean.instHashableMVarId.hash : Lean.MVarId -> UInt64
def Lean.instHashableMVarId.hash : Lean.MVarId -> UInt64 :=
  fun (x._@.Lean.Expr.4051099792._hygCtx._hyg.51 : Lean.MVarId) => _private.Lean.Expr.0.Lean.instHashableMVarId.hash.match_1.{1} (fun (x._@.Lean.Expr.4051099792._hygCtx.51.Lean.Expr.1363585668._hygCtx._hyg.7 : Lean.MVarId) => UInt64) x._@.Lean.Expr.4051099792._hygCtx._hyg.51 (fun (a._@.Lean.Expr.4051099792._hygCtx._hyg.52 : Lean.Name) => mixHash (OfNat.ofNat.{0} UInt64 0 (UInt64.instOfNat 0)) (Hashable.hash.{1} Lean.Name Lean.instHashableName a._@.Lean.Expr.4051099792._hygCtx._hyg.52))
