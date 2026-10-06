import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.getTailInfo : Lean.Syntax -> Lean.SourceInfo
def Lean.Syntax.getTailInfo : Lean.Syntax -> Lean.SourceInfo :=
  fun (stx : Lean.Syntax) => Option.getD.{0} Lean.SourceInfo (Lean.Syntax.getTailInfo? stx) Lean.SourceInfo.none
