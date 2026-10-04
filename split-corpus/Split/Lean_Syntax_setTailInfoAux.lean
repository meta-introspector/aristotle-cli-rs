import Mathlib

-- spec: opaque Lean.Syntax.setTailInfoAux : Lean.SourceInfo -> Lean.Syntax -> (Option.{0} Lean.Syntax)
opaque Lean.Syntax.setTailInfoAux : Lean.SourceInfo -> Lean.Syntax -> (Option.{0} Lean.Syntax) :=
  fun (info : Lean.SourceInfo) (a._@._internal._hyg.0 : Lean.Syntax) => Inhabited.default.{1} (Option.{0} Lean.Syntax) (instInhabitedOption.{0} Lean.Syntax)
