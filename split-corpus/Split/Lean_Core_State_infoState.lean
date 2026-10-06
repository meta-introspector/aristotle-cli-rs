import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.infoState : Lean.Core.State -> Lean.Elab.InfoState
def Lean.Core.State.infoState : Lean.Core.State -> Lean.Elab.InfoState :=
  fun (self : Lean.Core.State) => self.8
