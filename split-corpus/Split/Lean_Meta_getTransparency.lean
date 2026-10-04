import Mathlib

set_option pp.all true
-- spec: Lean.Meta.getTransparency : Lean.Meta.MetaM Lean.Meta.TransparencyMode
def Lean.Meta.getTransparency : Lean.Meta.MetaM Lean.Meta.TransparencyMode :=
  Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) Lean.Meta.Config Lean.Meta.TransparencyMode Lean.Meta.getConfig (fun (__do_lift._@.Lean.Meta.Basic.1490478278._hygCtx._hyg.22.0 : Lean.Meta.Config) => Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) Lean.Meta.TransparencyMode (Lean.Meta.Config.transparency __do_lift._@.Lean.Meta.Basic.1490478278._hygCtx._hyg.22.0))
