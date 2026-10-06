import Mathlib

set_option pp.all true
-- spec: Lean.MessageData.toString : Lean.MessageData -> (BaseIO String)
def Lean.MessageData.toString : Lean.MessageData -> (BaseIO String) :=
  fun (msgData : Lean.MessageData) => Bind.bind.{0, 0} BaseIO (Monad.toBind.{0, 0} BaseIO instMonadBaseIO) Std.Format String (Lean.MessageData.format msgData (Option.none.{0} Lean.MessageDataContext)) (fun (__do_lift._@.Lean.Message.2738761430._hygCtx._hyg.10.0 : Std.Format) => Pure.pure.{0, 0} BaseIO (Applicative.toPure.{0, 0} BaseIO (Monad.toApplicative.{0, 0} BaseIO instMonadBaseIO)) String (ToString.toString.{0} Std.Format instToStringFormat __do_lift._@.Lean.Message.2738761430._hygCtx._hyg.10.0))
