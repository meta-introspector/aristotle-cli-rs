import Mathlib

set_option pp.all true
-- spec: Lean.Core.State.snapshotTasks : Lean.Core.State -> (Array.{0} (Lean.Language.SnapshotTask Lean.Language.SnapshotTree))
def Lean.Core.State.snapshotTasks : Lean.Core.State -> (Array.{0} (Lean.Language.SnapshotTask Lean.Language.SnapshotTree)) :=
  fun (self : Lean.Core.State) => self.9
