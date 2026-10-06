import Mathlib

set_option pp.all true
-- spec: Lean.mkLevelSucc : Lean.Level -> Lean.Level
def Lean.mkLevelSucc : Lean.Level -> Lean.Level :=
  fun (u : Lean.Level) => Lean.Level.succ u
