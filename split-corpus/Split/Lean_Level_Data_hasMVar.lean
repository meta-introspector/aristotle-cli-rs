import Mathlib

set_option pp.all true
-- spec: Lean.Level.Data.hasMVar : Lean.Level.Data -> Bool
def Lean.Level.Data.hasMVar : Lean.Level.Data -> Bool :=
  fun (c : Lean.Level.Data) => BEq.beq.{0} UInt64 (instBEqOfDecidableEq.{0} UInt64 instDecidableEqUInt64) (UInt64.land (UInt64.shiftRight c (OfNat.ofNat.{0} UInt64 32 (UInt64.instOfNat 32))) (OfNat.ofNat.{0} UInt64 1 (UInt64.instOfNat 1))) (OfNat.ofNat.{0} UInt64 1 (UInt64.instOfNat 1))
