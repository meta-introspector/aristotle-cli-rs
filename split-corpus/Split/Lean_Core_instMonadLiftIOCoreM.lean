import Mathlib

set_option pp.all true
-- spec: Lean.Core.instMonadLiftIOCoreM : MonadLift.{0, 0, 0} IO Lean.Core.CoreM
def Lean.Core.instMonadLiftIOCoreM : MonadLift.{0, 0, 0} IO Lean.Core.CoreM :=
  MonadLift.mk.{0, 0, 0} IO Lean.Core.CoreM (fun {α._@.Lean.CoreM.1713186863._hygCtx._hyg.9 : Type} => Lean.Core.liftIOCore α._@.Lean.CoreM.1713186863._hygCtx._hyg.9)
