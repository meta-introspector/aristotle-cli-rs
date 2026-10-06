import Mathlib

set_option pp.all true
-- spec: Lean.Elab.Command.instMonadExceptOfExceptionCommandElabM : MonadExceptOf.{0, 0, 0} Lean.Exception Lean.Elab.Command.CommandElabM
def Lean.Elab.Command.instMonadExceptOfExceptionCommandElabM : MonadExceptOf.{0, 0, 0} Lean.Exception Lean.Elab.Command.CommandElabM :=
  MonadExceptOf.mk.{0, 0, 0} Lean.Exception Lean.Elab.Command.CommandElabM (fun {α._@.Lean.Elab.Command.2392590005._hygCtx._hyg.9 : Type} => MonadExcept.throw.{0, 0, 0} Lean.Exception Lean.Elab.Command.CommandElabM (instMonadExceptOfMonadExceptOf.{0, 0, 0} Lean.Exception Lean.Elab.Command.CommandElabM (ReaderT.instMonadExceptOf.{0, 0, 0} Lean.Elab.Command.Context (StateRefT' IO.RealWorld Lean.Elab.Command.State (EIO Lean.Exception)) Lean.Exception (StateRefT'.instMonadExceptOf.{0} IO.RealWorld Lean.Elab.Command.State (EIO Lean.Exception) Lean.Exception (instMonadExceptOfEIO Lean.Exception)))) α._@.Lean.Elab.Command.2392590005._hygCtx._hyg.9) (fun {α._@.Lean.Elab.Command.2392590005._hygCtx._hyg.11 : Type} => Lean.Elab.Command.tryCatch α._@.Lean.Elab.Command.2392590005._hygCtx._hyg.11)
