import Mathlib

set_option pp.all true
-- spec: Lean.Level.hasParam : Lean.Level -> Bool
def Lean.Level.hasParam : Lean.Level -> Bool :=
  fun (u : Lean.Level) => Lean.Level.Data.hasParam (Lean.Level.data u)
