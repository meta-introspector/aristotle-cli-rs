import Mathlib

set_option pp.all true
-- spec: Lean.Expr.mkDataForBinder : UInt64 -> Nat -> UInt32 -> Bool -> Bool -> Bool -> Bool -> Lean.Expr.Data
def Lean.Expr.mkDataForBinder : UInt64 -> Nat -> UInt32 -> Bool -> Bool -> Bool -> Bool -> Lean.Expr.Data :=
  fun (h : UInt64) (looseBVarRange : Nat) (approxDepth : UInt32) (hasFVar : Bool) (hasExprMVar : Bool) (hasLevelMVar : Bool) (hasLevelParam : Bool) => Lean.Expr.mkData h looseBVarRange approxDepth hasFVar hasExprMVar hasLevelMVar hasLevelParam
