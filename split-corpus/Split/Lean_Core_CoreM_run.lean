import Mathlib

set_option pp.all true
-- spec: Lean.Core.CoreM.run : forall {α : Type}, (Lean.Core.CoreM α) -> Lean.Core.Context -> Lean.Core.State -> (EIO Lean.Exception (Prod.{0, 0} α Lean.Core.State))
def Lean.Core.CoreM.run : forall {α : Type}, (Lean.Core.CoreM α) -> Lean.Core.Context -> Lean.Core.State -> (EIO Lean.Exception (Prod.{0, 0} α Lean.Core.State)) :=
  fun {α : Type} (x : Lean.Core.CoreM α) (ctx : Lean.Core.Context) (s : Lean.Core.State) => StateRefT'.run IO.RealWorld Lean.Core.State (EIO Lean.Exception) (instMonadEIO Lean.Exception) (instMonadLiftTOfMonadLift.{0, 0, 0, 0} (ST IO.RealWorld) BaseIO (EIO Lean.Exception) (instMonadLiftBaseIOEIO Lean.Exception) (instMonadLiftTOfMonadLift.{0, 0, 0, 0} (ST IO.RealWorld) (ST IO.RealWorld) BaseIO IO.instMonadLiftSTRealWorldBaseIO (instMonadLiftT.{0, 0} (ST IO.RealWorld)))) α (_private.Lean.CoreM.0.Lean.Core.withConsistentCtx α x ctx) s
