import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.maxRecDepth : Lean.Elab.Command.State -> Nat
def Lean.Elab.Command.State.maxRecDepth : Lean.Elab.Command.State -> Nat :=
  fun (self : Lean.Elab.Command.State) => self.6
