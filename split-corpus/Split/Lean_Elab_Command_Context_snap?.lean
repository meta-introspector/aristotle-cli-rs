import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.Context.snap? : Lean.Elab.Command.Context -> (Option.{0} (Lean.Language.SnapshotBundle Lean.Language.DynamicSnapshot))
def Lean.Elab.Command.Context.snap? : Lean.Elab.Command.Context -> (Option.{0} (Lean.Language.SnapshotBundle Lean.Language.DynamicSnapshot)) :=
  fun (self : Lean.Elab.Command.Context) => self.9
