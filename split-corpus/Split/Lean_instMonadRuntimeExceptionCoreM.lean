import Mathlib

set_option pp.all true
-- spec: Lean.instMonadRuntimeExceptionCoreM : Lean.MonadRuntimeException Lean.Core.CoreM
def Lean.instMonadRuntimeExceptionCoreM : Lean.MonadRuntimeException Lean.Core.CoreM :=
  Lean.MonadRuntimeException.mk Lean.Core.CoreM (fun {α._@.Lean.CoreM.639935820._hygCtx._hyg.8 : Type} => Lean.Core.tryCatchRuntimeEx α._@.Lean.CoreM.639935820._hygCtx._hyg.8)
