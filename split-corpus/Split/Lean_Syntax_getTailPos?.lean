import Mathlib

-- spec: opaque Lean.Syntax.getTailPos? : Lean.Syntax -> (optParam.{1} Bool Bool.false) -> (Option.{0} String.Pos.Raw)
opaque Lean.Syntax.getTailPos? : Lean.Syntax -> (optParam.{1} Bool Bool.false) -> (Option.{0} String.Pos.Raw) :=
  fun (stx : Lean.Syntax) (canonicalOnly : optParam.{1} Bool Bool.false) => Inhabited.default.{1} (Option.{0} String.Pos.Raw) (instInhabitedOption.{0} String.Pos.Raw)
