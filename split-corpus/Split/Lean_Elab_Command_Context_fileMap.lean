import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.fileMap : Lean.Elab.Command.Context -> Lean.FileMap
def Lean.Elab.Command.Context.fileMap : Lean.Elab.Command.Context -> Lean.FileMap :=
  fun (self : Lean.Elab.Command.Context) => self.2
