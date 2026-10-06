import Mathlib

set_option pp.all true
-- spec: Lean.Core.instInhabitedCoreM : forall {α : Type}, Inhabited.{1} (Lean.Core.CoreM α)
def Lean.Core.instInhabitedCoreM : forall {α : Type}, Inhabited.{1} (Lean.Core.CoreM α) :=
  fun {α : Type} => Inhabited.mk.{1} (Lean.Core.CoreM α) (fun (x._@.Lean.CoreM.3451204723._hygCtx._hyg.17 : Lean.Core.Context) (x._@.Lean.CoreM.3451204723._hygCtx._hyg.19 : ST.Ref IO.RealWorld Lean.Core.State) => MonadExcept.throw.{0, 0, 0} Lean.Exception (EIO Lean.Exception) (instMonadExceptOfMonadExceptOf.{0, 0, 0} Lean.Exception (EIO Lean.Exception) (instMonadExceptOfEIO Lean.Exception)) α (Inhabited.default.{1} Lean.Exception Lean.instInhabitedException))
