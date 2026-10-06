import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.getHeadInfo : Lean.Syntax -> Lean.SourceInfo
def Lean.Syntax.getHeadInfo : Lean.Syntax -> Lean.SourceInfo :=
  fun (stx : Lean.Syntax) => _private.Init.Prelude.0.Lean.Syntax.getHeadInfo?.loop.match_1.{1} (fun (x._@.Init.Prelude.3431228194._hygCtx._hyg.7 : Option.{0} Lean.SourceInfo) => Lean.SourceInfo) (Lean.Syntax.getHeadInfo? stx) (fun (info : Lean.SourceInfo) => info) (fun (_ : Unit) => Lean.SourceInfo.none)
