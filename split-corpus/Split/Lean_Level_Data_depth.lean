import Mathlib

set_option pp.all true
-- spec: Lean.Level.Data.depth : Lean.Level.Data -> UInt32
def Lean.Level.Data.depth : Lean.Level.Data -> UInt32 :=
  fun (c : Lean.Level.Data) => UInt64.toUInt32 (UInt64.shiftRight c (OfNat.ofNat.{0} UInt64 40 (UInt64.instOfNat 40)))
