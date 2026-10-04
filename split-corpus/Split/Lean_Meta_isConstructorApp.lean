import Mathlib

set_option pp.all true
-- spec: Lean.Meta.isConstructorApp : Lean.Expr -> (Lean.Meta.MetaM Bool)
def Lean.Meta.isConstructorApp : Lean.Expr -> (Lean.Meta.MetaM Bool) :=
  fun (e : Lean.Expr) => Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) (Option.{0} Lean.ConstructorVal) Bool (Lean.Meta.isConstructorApp? e) (fun (__do_lift._@.Lean.Meta.CtorRecognizer.313637280._hygCtx._hyg.12.0 : Option.{0} Lean.ConstructorVal) => Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) Bool (Option.isSome.{0} Lean.ConstructorVal __do_lift._@.Lean.Meta.CtorRecognizer.313637280._hygCtx._hyg.12.0))
