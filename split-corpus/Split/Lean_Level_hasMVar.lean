import Mathlib

set_option pp.all true
-- spec: Lean.Level.hasMVar : Lean.Level -> Bool
def Lean.Level.hasMVar : Lean.Level -> Bool :=
  fun (u : Lean.Level) => Lean.Level.Data.hasMVar (Lean.Level.data u)
