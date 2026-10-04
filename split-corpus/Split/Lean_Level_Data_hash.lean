import Mathlib

set_option pp.all true
-- spec: Lean.Level.Data.hash : Lean.Level.Data -> UInt64
def Lean.Level.Data.hash : Lean.Level.Data -> UInt64 :=
  fun (c : Lean.Level.Data) => UInt32.toUInt64 (UInt64.toUInt32 c)
