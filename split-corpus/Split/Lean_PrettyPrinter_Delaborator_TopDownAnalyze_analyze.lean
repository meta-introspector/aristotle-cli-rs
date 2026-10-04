import Mathlib

-- spec: opaque Lean.PrettyPrinter.Delaborator.TopDownAnalyze.analyze : (optParam.{1} Bool Bool.false) -> (Lean.PrettyPrinter.Delaborator.TopDownAnalyze.AnalyzeM Unit)
opaque Lean.PrettyPrinter.Delaborator.TopDownAnalyze.analyze : (optParam.{1} Bool Bool.false) -> (Lean.PrettyPrinter.Delaborator.TopDownAnalyze.AnalyzeM Unit) :=
  fun (parentIsApp : optParam.{1} Bool Bool.false) => Inhabited.default.{1} (Lean.PrettyPrinter.Delaborator.TopDownAnalyze.AnalyzeM Unit) (instInhabitedReaderT.{0, 0} Lean.PrettyPrinter.Delaborator.TopDownAnalyze.Context (StateRefT' IO.RealWorld Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State Lean.Meta.MetaM) Unit (instInhabitedOfMonad.{0, 0} Unit (StateRefT' IO.RealWorld Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State Lean.Meta.MetaM) (StateRefT'.instMonad IO.RealWorld Lean.PrettyPrinter.Delaborator.TopDownAnalyze.State Lean.Meta.MetaM Lean.Meta.instMonadMetaM) instInhabitedPUnit.{1}))
