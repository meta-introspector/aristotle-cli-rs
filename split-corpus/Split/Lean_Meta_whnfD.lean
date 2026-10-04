import Mathlib

set_option pp.all true
-- spec: Lean.Meta.whnfD : Lean.Expr -> (Lean.Meta.MetaM Lean.Expr)
def Lean.Meta.whnfD : Lean.Expr -> (Lean.Meta.MetaM Lean.Expr) :=
  fun (e : Lean.Expr) => Lean.Meta.withTransparency.{0} Lean.Meta.MetaM (instMonadControlTOfPure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM)))) Lean.Meta.instMonadMetaM Lean.Expr Lean.Meta.TransparencyMode.default (Lean.Meta.whnf e)
