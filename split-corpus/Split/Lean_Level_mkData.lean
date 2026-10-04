import Mathlib

-- spec: opaque Lean.Level.mkData : UInt64 -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> Lean.Level.Data
opaque Lean.Level.mkData : UInt64 -> (optParam.{1} Nat (OfNat.ofNat.{0} Nat 0 (instOfNatNat 0))) -> (optParam.{1} Bool Bool.false) -> (optParam.{1} Bool Bool.false) -> Lean.Level.Data :=
  fun (h : UInt64) (depth : Nat) (hasMVar : Bool) (hasParam : Bool) => Inhabited.default.{1} Lean.Level.Data Lean.instInhabitedData
