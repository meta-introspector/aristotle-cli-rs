import Mathlib

set_option pp.all true
-- spec: Lean.Core.instMonadOptionsCoreM : Lean.MonadOptions Lean.Core.CoreM
def Lean.Core.instMonadOptionsCoreM : Lean.MonadOptions Lean.Core.CoreM :=
  Lean.MonadOptions.mk Lean.Core.CoreM (Bind.bind.{0, 0} Lean.Core.CoreM (Monad.toBind.{0, 0} Lean.Core.CoreM Lean.Core.instMonadCoreM) Lean.Core.Context Lean.Options (MonadReader.read.{0, 0} Lean.Core.Context Lean.Core.CoreM (instMonadReaderOfMonadReaderOf.{0, 0} Lean.Core.Context Lean.Core.CoreM (instMonadReaderOfReaderTOfMonad.{0, 0} Lean.Core.Context (StateRefT' IO.RealWorld Lean.Core.State (EIO Lean.Exception)) (StateRefT'.instMonad IO.RealWorld Lean.Core.State (EIO Lean.Exception) (instMonadEIO Lean.Exception))))) (fun (__do_lift._@.Lean.CoreM.3157496678._hygCtx._hyg.14.0 : Lean.Core.Context) => Pure.pure.{0, 0} Lean.Core.CoreM (Applicative.toPure.{0, 0} Lean.Core.CoreM (ReaderT.instApplicativeOfMonad.{0, 0} Lean.Core.Context (StateRefT' IO.RealWorld Lean.Core.State (EIO Lean.Exception)) (StateRefT'.instMonad IO.RealWorld Lean.Core.State (EIO Lean.Exception) (instMonadEIO Lean.Exception)))) Lean.Options (Lean.Core.Context.options __do_lift._@.Lean.CoreM.3157496678._hygCtx._hyg.14.0)))
