import Mathlib

set_option pp.all true
-- spec: Lean.mkLevelParam : Lean.Name -> Lean.Level
def Lean.mkLevelParam : Lean.Name -> Lean.Level :=
  fun (name : Lean.Name) => Lean.Level.param name
