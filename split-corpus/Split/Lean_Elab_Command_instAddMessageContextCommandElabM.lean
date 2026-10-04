import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.instAddMessageContextCommandElabM : Lean.AddMessageContext Lean.Elab.Command.CommandElabM
def Lean.Elab.Command.instAddMessageContextCommandElabM : Lean.AddMessageContext Lean.Elab.Command.CommandElabM :=
  Lean.AddMessageContext.mk Lean.Elab.Command.CommandElabM (Lean.addMessageContextPartial Lean.Elab.Command.CommandElabM Lean.Elab.Command.instMonadCommandElabM Lean.Elab.Command.instMonadEnvCommandElabM Lean.Elab.Command.instMonadOptionsCommandElabM)
