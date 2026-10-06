import Mathlib

set_option pp.all true
-- spec: Lean.MonadRef.mkInfoFromRefPos : forall {m : Type -> Type} [inst._@.Init.Prelude.73114285._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Init.Prelude.73114285._hygCtx._hyg.8 : Lean.MonadRef m], m Lean.SourceInfo
def Lean.MonadRef.mkInfoFromRefPos : forall {m : Type -> Type} [inst._@.Init.Prelude.73114285._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Init.Prelude.73114285._hygCtx._hyg.8 : Lean.MonadRef m], m Lean.SourceInfo :=
  fun {m : Type -> Type} [inst._@.Init.Prelude.73114285._hygCtx._hyg.5 : Monad.{0, 0} m] [inst._@.Init.Prelude.73114285._hygCtx._hyg.8 : Lean.MonadRef m] => Bind.bind.{0, 0} m (Monad.toBind.{0, 0} m inst._@.Init.Prelude.73114285._hygCtx._hyg.5) Lean.Syntax Lean.SourceInfo (Lean.MonadRef.getRef m inst._@.Init.Prelude.73114285._hygCtx._hyg.8) (fun (__do_lift._@.Init.Prelude.73114285._hygCtx._hyg.20.0 : Lean.Syntax) => Pure.pure.{0, 0} m (Applicative.toPure.{0, 0} m (Monad.toApplicative.{0, 0} m inst._@.Init.Prelude.73114285._hygCtx._hyg.5)) Lean.SourceInfo (Lean.SourceInfo.fromRef __do_lift._@.Init.Prelude.73114285._hygCtx._hyg.20.0 Bool.false))
