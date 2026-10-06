import Mathlib

set_option pp.all true
-- spec: Lean.Meta.reduceProj? : Lean.Expr -> (Lean.Meta.MetaM (Option.{0} Lean.Expr))
def Lean.Meta.reduceProj? : Lean.Expr -> (Lean.Meta.MetaM (Option.{0} Lean.Expr)) :=
  fun (e : Lean.Expr) => _private.Lean.Meta.WHNF.0.Lean.Meta.reduceProj?.match_1.{1} (fun (e._@.Lean.Meta.WHNF.2698661555._hygCtx._hyg.23 : Lean.Expr) => Lean.Meta.MetaM (Option.{0} Lean.Expr)) e (fun (typeName._@.Lean.Meta.WHNF.2698661555._hygCtx._hyg.33 : Lean.Name) (i : Nat) (c : Lean.Expr) => Lean.Meta.project? c i) (fun (x._@.Lean.Meta.WHNF.2698661555._hygCtx._hyg.41 : Lean.Expr) => Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) (Option.{0} Lean.Expr) (Option.none.{0} Lean.Expr))
