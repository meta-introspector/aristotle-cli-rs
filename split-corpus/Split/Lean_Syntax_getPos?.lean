import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.getPos? : Lean.Syntax -> (optParam.{1} Bool Bool.false) -> (Option.{0} String.Pos.Raw)
def Lean.Syntax.getPos? : Lean.Syntax -> (optParam.{1} Bool Bool.false) -> (Option.{0} String.Pos.Raw) :=
  fun (stx : Lean.Syntax) (canonicalOnly : Bool) => Lean.SourceInfo.getPos? (Lean.Syntax.getHeadInfo stx) canonicalOnly
