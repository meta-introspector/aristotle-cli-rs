import Mathlib

set_option pp.all true
-- spec: Lean.Core.instAddMessageContextCoreM : Lean.AddMessageContext Lean.Core.CoreM
def Lean.Core.instAddMessageContextCoreM : Lean.AddMessageContext Lean.Core.CoreM :=
  Lean.AddMessageContext.mk Lean.Core.CoreM (Lean.addMessageContextPartial Lean.Core.CoreM Lean.Core.instMonadCoreM Lean.Core.instMonadEnvCoreM Lean.Core.instMonadOptionsCoreM)
