import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.currRecDepth : Lean.Elab.Command.Context -> Nat
def Lean.Elab.Command.Context.currRecDepth : Lean.Elab.Command.Context -> Nat :=
  fun (self : Lean.Elab.Command.Context) => self.3
