import Mathlib

set_option pp.all true
-- spec: Lean.instMonadExceptOfExceptionCoreM : MonadExceptOf.{0, 0, 0} Lean.Exception Lean.Core.CoreM
def Lean.instMonadExceptOfExceptionCoreM : MonadExceptOf.{0, 0, 0} Lean.Exception Lean.Core.CoreM :=
  MonadExceptOf.mk.{0, 0, 0} Lean.Exception Lean.Core.CoreM (fun {α._@.Lean.CoreM.2885032625._hygCtx._hyg.9 : Type} => MonadExcept.throw.{0, 0, 0} Lean.Exception Lean.Core.CoreM (instMonadExceptOfMonadExceptOf.{0, 0, 0} Lean.Exception Lean.Core.CoreM (Lean.MonadError.toMonadExceptOf Lean.Core.CoreM (Lean.MonadError.mk Lean.Core.CoreM (ReaderT.instMonadExceptOf.{0, 0, 0} Lean.Core.Context (StateRefT' IO.RealWorld Lean.Core.State (EIO Lean.Exception)) Lean.Exception (StateRefT'.instMonadExceptOf.{0} IO.RealWorld Lean.Core.State (EIO Lean.Exception) Lean.Exception (instMonadExceptOfEIO Lean.Exception))) Lean.Core.instMonadRefCoreM (Lean.instAddErrorMessageContextOfAddMessageContextOfMonad Lean.Core.CoreM Lean.Core.instAddMessageContextCoreM Lean.Core.instMonadCoreM)))) α._@.Lean.CoreM.2885032625._hygCtx._hyg.9) (fun {α._@.Lean.CoreM.2885032625._hygCtx._hyg.11 : Type} => Lean.Core.tryCatch α._@.Lean.CoreM.2885032625._hygCtx._hyg.11)
