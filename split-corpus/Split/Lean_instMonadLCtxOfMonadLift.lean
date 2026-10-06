import Mathlib

set_option pp.all true
-- spec: Lean.instMonadLCtxOfMonadLift : forall {m : Type -> Type} {n : Type -> Type} [inst._@.Lean.LocalContext.3932915843._hygCtx._hyg.9 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.LocalContext.3932915843._hygCtx._hyg.13 : Lean.MonadLCtx m], Lean.MonadLCtx n
def Lean.instMonadLCtxOfMonadLift : forall {m : Type -> Type} {n : Type -> Type} [inst._@.Lean.LocalContext.3932915843._hygCtx._hyg.9 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.LocalContext.3932915843._hygCtx._hyg.13 : Lean.MonadLCtx m], Lean.MonadLCtx n :=
  fun {m : Type -> Type} {n : Type -> Type} [inst._@.Lean.LocalContext.3932915843._hygCtx._hyg.9 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.LocalContext.3932915843._hygCtx._hyg.13 : Lean.MonadLCtx m] => Lean.MonadLCtx.mk n (liftM.{0, 0, 0} m n (instMonadLiftTOfMonadLift.{0, 0, 0, 0} m m n inst._@.Lean.LocalContext.3932915843._hygCtx._hyg.9 (instMonadLiftT.{0, 0} m)) Lean.LocalContext (Lean.MonadLCtx.getLCtx m inst._@.Lean.LocalContext.3932915843._hygCtx._hyg.13))
