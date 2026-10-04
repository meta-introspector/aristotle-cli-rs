import Mathlib

set_option pp.all true
-- spec: Lean.MessageSeverity.casesOn : forall {motive : Lean.MessageSeverity -> Sort.{u}} (t : Lean.MessageSeverity), (motive Lean.MessageSeverity.information) -> (motive Lean.MessageSeverity.warning) -> (motive Lean.MessageSeverity.error) -> (motive t)
def Lean.MessageSeverity.casesOn : forall {motive : Lean.MessageSeverity -> Sort.{u}} (t : Lean.MessageSeverity), (motive Lean.MessageSeverity.information) -> (motive Lean.MessageSeverity.warning) -> (motive Lean.MessageSeverity.error) -> (motive t) :=
  fun {motive : Lean.MessageSeverity -> Sort.{u}} (t : Lean.MessageSeverity) (information : motive Lean.MessageSeverity.information) (warning : motive Lean.MessageSeverity.warning) (error : motive Lean.MessageSeverity.error) => Lean.MessageSeverity.rec.{u} motive information warning error t
