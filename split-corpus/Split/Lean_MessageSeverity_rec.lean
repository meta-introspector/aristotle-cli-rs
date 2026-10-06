import Mathlib

-- spec: recursor Lean.MessageSeverity.rec : forall {motive : Lean.MessageSeverity -> Sort.{u}}, (motive Lean.MessageSeverity.information) -> (motive Lean.MessageSeverity.warning) -> (motive Lean.MessageSeverity.error) -> (forall (t : Lean.MessageSeverity), motive t)
