import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.messages : Lean.Core.State -> Lean.MessageLog
def Lean.Core.State.messages : Lean.Core.State -> Lean.MessageLog :=
  fun (self : Lean.Core.State) => self.7
