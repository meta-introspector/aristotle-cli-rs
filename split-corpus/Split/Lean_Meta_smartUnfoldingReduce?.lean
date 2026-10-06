import Mathlib

set_option pp.all true
-- spec: Lean.Meta.smartUnfoldingReduce? : Lean.Expr -> (Lean.Meta.MetaM (Option.{0} Lean.Expr))
def Lean.Meta.smartUnfoldingReduce? : Lean.Expr -> (Lean.Meta.MetaM (Option.{0} Lean.Expr)) :=
  fun (e : Lean.Expr) => OptionT.run.{0, 0} Lean.Meta.MetaM Lean.Expr (_private.Lean.Meta.WHNF.0.Lean.Meta.smartUnfoldingReduce?.go e)
