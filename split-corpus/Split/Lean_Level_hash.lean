import Mathlib

set_option pp.all true
-- spec: Lean.Level.hash : Lean.Level -> UInt64
def Lean.Level.hash : Lean.Level -> UInt64 :=
  fun (u : Lean.Level) => Lean.Level.Data.hash (Lean.Level.data u)
