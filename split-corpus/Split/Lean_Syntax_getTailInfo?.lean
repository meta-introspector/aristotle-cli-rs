import Mathlib

-- spec: opaque Lean.Syntax.getTailInfo? : Lean.Syntax -> (Option.{0} Lean.SourceInfo)
opaque Lean.Syntax.getTailInfo? : Lean.Syntax -> (Option.{0} Lean.SourceInfo) :=
  fun (a._@._internal._hyg.0 : Lean.Syntax) => Inhabited.default.{1} (Option.{0} Lean.SourceInfo) (instInhabitedOption.{0} Lean.SourceInfo)
