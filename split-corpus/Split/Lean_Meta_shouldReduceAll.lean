import Mathlib

set_option pp.all true
-- spec: Lean.Meta.shouldReduceAll : Lean.Meta.MetaM Bool
def Lean.Meta.shouldReduceAll : Lean.Meta.MetaM Bool :=
  Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) Lean.Meta.TransparencyMode Bool Lean.Meta.getTransparency (fun (__do_lift._@.Lean.Meta.Basic.140901562._hygCtx._hyg.22.0 : Lean.Meta.TransparencyMode) => Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) Bool (BEq.beq.{0} Lean.Meta.TransparencyMode Lean.Meta.instBEqTransparencyMode __do_lift._@.Lean.Meta.Basic.140901562._hygCtx._hyg.22.0 Lean.Meta.TransparencyMode.all))
