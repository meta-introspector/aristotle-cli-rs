import Mathlib

set_option pp.all true
-- spec: Lean.instMonadOptionsOfMonadLift : forall {m : Type -> Type} {n : Type -> Type} [inst._@.Lean.Data.Options.364675132._hygCtx._hyg.9 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.Data.Options.364675132._hygCtx._hyg.13 : Lean.MonadOptions m], Lean.MonadOptions n
def Lean.instMonadOptionsOfMonadLift : forall {m : Type -> Type} {n : Type -> Type} [inst._@.Lean.Data.Options.364675132._hygCtx._hyg.9 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.Data.Options.364675132._hygCtx._hyg.13 : Lean.MonadOptions m], Lean.MonadOptions n :=
  fun {m : Type -> Type} {n : Type -> Type} [inst._@.Lean.Data.Options.364675132._hygCtx._hyg.9 : MonadLift.{0, 0, 0} m n] [inst._@.Lean.Data.Options.364675132._hygCtx._hyg.13 : Lean.MonadOptions m] => Lean.MonadOptions.mk n (liftM.{0, 0, 0} m n (instMonadLiftTOfMonadLift.{0, 0, 0, 0} m m n inst._@.Lean.Data.Options.364675132._hygCtx._hyg.9 (instMonadLiftT.{0, 0} m)) Lean.Options (Lean.MonadOptions.getOptions m inst._@.Lean.Data.Options.364675132._hygCtx._hyg.13))
