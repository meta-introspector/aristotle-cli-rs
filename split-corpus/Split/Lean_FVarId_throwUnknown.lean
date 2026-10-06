import Mathlib

set_option pp.all true
-- spec: Lean.FVarId.throwUnknown : forall {α : Type}, Lean.FVarId -> (Lean.Core.CoreM α)
def Lean.FVarId.throwUnknown : forall {α : Type}, Lean.FVarId -> (Lean.Core.CoreM α) :=
  fun {α : Type} (fvarId : Lean.FVarId) => Lean.throwError Lean.Core.CoreM α Lean.Core.instMonadCoreM (Lean.MonadError.mk Lean.Core.CoreM Lean.instMonadExceptOfExceptionCoreM Lean.Core.instMonadRefCoreM (Lean.instAddErrorMessageContextOfAddMessageContextOfMonad Lean.Core.CoreM Lean.Core.instAddMessageContextCoreM Lean.Core.instMonadCoreM)) (HAppend.hAppend.{0, 0, 0} Lean.MessageData Lean.MessageData Lean.MessageData (instHAppendOfAppend.{0} Lean.MessageData Lean.MessageData.instAppend) (HAppend.hAppend.{0, 0, 0} Lean.MessageData Lean.MessageData Lean.MessageData (instHAppendOfAppend.{0} Lean.MessageData Lean.MessageData.instAppend) (Lean.ToMessageData.toMessageData String Lean.instToMessageDataString "unknown free variable `") (Lean.ToMessageData.toMessageData Lean.Expr Lean.instToMessageDataExpr (Lean.mkFVar fvarId))) (Lean.ToMessageData.toMessageData String Lean.instToMessageDataString "`"))
