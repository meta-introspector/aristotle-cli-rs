import Mathlib

-- spec: opaque Lean.Expr.mkData : UInt64 -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} UInt32 (OfNat.ofNat.{0} UInt32 0 (UInt32.instOfNat 0))) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> Lean.Expr.Data
opaque Lean.Expr.mkData : UInt64 -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} UInt32 (OfNat.ofNat.{0} UInt32 0 (UInt32.instOfNat 0))) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> Lean.Expr.Data :=
  fun (h : UInt64) (looseBVarRange : Nat) (approxDepth : UInt32) (hasFVar : Bool) (hasExprMVar : Bool) (hasLevelMVar : Bool) (hasLevelParam : Bool) => Inhabited.default.{1} Lean.Expr.Data Lean.instInhabitedData_1
