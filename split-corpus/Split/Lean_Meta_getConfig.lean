import Mathlib

set_option pp.all true
-- spec: Lean.Meta.getConfig : Lean.Meta.MetaM Lean.Meta.Config
def Lean.Meta.getConfig : Lean.Meta.MetaM Lean.Meta.Config :=
  Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) Lean.Meta.Context Lean.Meta.Config (MonadReader.read.{0, 0} Lean.Meta.Context Lean.Meta.MetaM (instMonadReaderOfMonadReaderOf.{0, 0} Lean.Meta.Context Lean.Meta.MetaM (instMonadReaderOfReaderTOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM)))) (fun (__do_lift._@.Lean.Meta.Basic.1769190971._hygCtx._hyg.22.0 : Lean.Meta.Context) => Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) Lean.Meta.Config (Lean.Meta.Context.config __do_lift._@.Lean.Meta.Basic.1769190971._hygCtx._hyg.22.0))
