import Mathlib

set_option pp.all true
-- spec: Lean.mkFreshLMVarId : forall {m : Type -> Type} [inst._@.Lean.Expr.772518494._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Lean.Expr.772518494._hygCtx._hyg.8 : Lean.MonadNameGenerator m], m Lean.LMVarId
def Lean.mkFreshLMVarId : forall {m : Type -> Type} [inst._@.Lean.Expr.772518494._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Lean.Expr.772518494._hygCtx._hyg.8 : Lean.MonadNameGenerator m], m Lean.LMVarId :=
  fun {m : Type -> Type} [inst._@.Lean.Expr.772518494._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Lean.Expr.772518494._hygCtx._hyg.8 : Lean.MonadNameGenerator m] => Bind.bind.{0, 0} m (Monad.toBind.{0, 0} m inst._@.Lean.Expr.772518494._hygCtx._hyg.5) Lean.Name Lean.LMVarId (Lean.mkFreshId m inst._@.Lean.Expr.772518494._hygCtx._hyg.5 inst._@.Lean.Expr.772518494._hygCtx._hyg.8) (fun (__do_lift._@.Lean.Expr.772518494._hygCtx._hyg.20.0 : Lean.Name) => Pure.pure.{0, 0} m (Applicative.toPure.{0, 0} m (Monad.toApplicative.{0, 0} m inst._@.Lean.Expr.772518494._hygCtx._hyg.5)) Lean.LMVarId (Lean.LevelMVarId.mk __do_lift._@.Lean.Expr.772518494._hygCtx._hyg.20.0))
