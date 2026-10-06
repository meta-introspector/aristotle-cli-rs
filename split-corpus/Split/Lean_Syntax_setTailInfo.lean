import Mathlib

set_option pp.all true
-- spec: Lean.Syntax.setTailInfo : Lean.Syntax -> Lean.SourceInfo -> Lean.Syntax
def Lean.Syntax.setTailInfo : Lean.Syntax -> Lean.SourceInfo -> Lean.Syntax :=
  fun (stx : Lean.Syntax) (info : Lean.SourceInfo) => _private.Init.Meta.Defs.0.Lean.Syntax.setTailInfo.match_1.{1} (fun (x._@.Init.Meta.Defs.2438806589._hygCtx._hyg.14 : Option.{0} Lean.Syntax) => Lean.Syntax) (Lean.Syntax.setTailInfoAux info stx) (fun (stx : Lean.Syntax) => stx) (fun (_ : Unit) => stx)
