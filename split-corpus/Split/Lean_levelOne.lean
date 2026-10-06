import Mathlib

set_option pp.all true
-- spec: Lean.levelOne : Lean.Level
def Lean.levelOne : Lean.Level :=
  Lean.mkLevelSucc Lean.levelZero
