import Mathlib

set_option pp.all true
-- spec: Lean.mkLevelMVar : Lean.LMVarId -> Lean.Level
def Lean.mkLevelMVar : Lean.LMVarId -> Lean.Level :=
  fun (mvarId : Lean.LMVarId) => Lean.Level.mvar mvarId
