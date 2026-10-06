import Mathlib

set_option pp.all true
-- spec: Lean.PrettyPrinter.Delaborator.TopDownAnalyze.AnalyzeM : Type -> Type
def Lean.PrettyPrinter.Delaborator.TopDownAnalyze.AnalyzeM : Type -> Type :=
  ReaderT.{0, 0} Lean.PrettyPrinter.Delaborator.TopDownAnalyze.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State Lean.Meta.MetaM)
