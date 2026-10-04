import Mathlib

set_option pp.all true
-- spec: Lean.Meta.instMonadLCtxMetaM : Lean.MonadLCtx Lean.Meta.MetaM
def Lean.Meta.instMonadLCtxMetaM : Lean.MonadLCtx Lean.Meta.MetaM :=
  Lean.MonadLCtx.mk Lean.Meta.MetaM (Bind.bind.{0, 0} Lean.Meta.MetaM (Monad.toBind.{0, 0} Lean.Meta.MetaM Lean.Meta.instMonadMetaM) Lean.Meta.Context Lean.LocalContext (MonadReader.read.{0, 0} Lean.Meta.Context Lean.Meta.MetaM (instMonadReaderOfMonadReaderOf.{0, 0} Lean.Meta.Context Lean.Meta.MetaM (instMonadReaderOfReaderTOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM)))) (fun (__do_lift._@.Lean.Meta.Basic.586765874._hygCtx._hyg.14.0 : Lean.Meta.Context) => Pure.pure.{0, 0} Lean.Meta.MetaM (Applicative.toPure.{0, 0} Lean.Meta.MetaM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Meta.Context (StateRefT' IO.RealWorld Lean.Meta.State Lean.Core.CoreM) (StateRefT'.instMonad IO.RealWorld Lean.Meta.State Lean.Core.CoreM Lean.Core.instMonadCoreM))) Lean.LocalContext (Lean.Meta.Context.lctx __do_lift._@.Lean.Meta.Basic.586765874._hygCtx._hyg.14.0)))
