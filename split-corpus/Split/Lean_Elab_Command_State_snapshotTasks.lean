import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.State.snapshotTasks : Lean.Elab.Command.State -> (Array.{0} (Lean.Language.SnapshotTask Lean.Language.SnapshotTree))
def Lean.Elab.Command.State.snapshotTasks : Lean.Elab.Command.State -> (Array.{0} (Lean.Language.SnapshotTask Lean.Language.SnapshotTree)) :=
  fun (self : Lean.Elab.Command.State) => self.11
