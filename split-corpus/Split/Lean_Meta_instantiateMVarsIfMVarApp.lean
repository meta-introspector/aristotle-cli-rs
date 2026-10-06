import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instantiateMVarsIfMVarApp : Lean.Expr -> (Lean.Meta.MetaM Lean.Expr)
def Lean.Meta.instantiateMVarsIfMVarApp : Lean.Expr -> (Lean.Meta.MetaM Lean.Expr) :=
  fun (e : Lean.Expr) => ite.{1} (Lean.Meta.MetaM Lean.Expr) (Eq.{1} Bool (Lean.Expr.isMVar (Lean.Expr.getAppFn e)) Bool.true) (instDecidableEqBool (Lean.Expr.isMVar (Lean.Expr.getAppFn e)) Bool.true) (Lean.instantiateMVars Lean.Meta.MetaM Lean.Meta.instMonadMetaM Lean.Meta.instMonadMCtxMetaM e) (Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) Lean.Expr e)
