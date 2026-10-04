import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.usedQuotCtxts : Lean.Elab.Command.State -> Lean.NameSet
def Lean.Elab.Command.State.usedQuotCtxts : Lean.Elab.Command.State -> Lean.NameSet :=
  fun (self : Lean.Elab.Command.State) => self.4
