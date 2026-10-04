import Mathlib

set_option pp.all true
-- spec: Lean.replaceRef : Lean.Syntax -> Lean.Syntax -> Lean.Syntax
def Lean.replaceRef : Lean.Syntax -> Lean.Syntax -> Lean.Syntax :=
  fun (ref : Lean.Syntax) (oldRef : Lean.Syntax) => _private.Init.Prelude.0.Lean.replaceRef.match_1.{1} (fun (x._@.Init.Prelude.617397431._hygCtx._hyg.8 : Option.{0} String.Pos.Raw) => Lean.Syntax) (Lean.Syntax.getPos? ref Bool.false) (fun (val._@.Init.Prelude.617397431._hygCtx._hyg.15 : String.Pos.Raw) => ref) (fun (x._@.Init.Prelude.617397431._hygCtx._hyg.20 : Option.{0} String.Pos.Raw) => oldRef)
