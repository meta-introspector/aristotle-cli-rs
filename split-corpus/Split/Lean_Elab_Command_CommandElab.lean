import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.CommandElab : Type
def Lean.Elab.Command.CommandElab : Type :=
  Lean.Syntax -> (Lean.Elab.Command.CommandElabM Unit)
