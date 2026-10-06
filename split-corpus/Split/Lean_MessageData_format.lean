import Mathlib

set_option pp.all true
-- spec: Lean.MessageData.format : Lean.MessageData -> (optParam.{1} (Option.{0} Lean.MessageDataContext) (Option.none.{0} Lean.MessageDataContext)) -> (BaseIO Std.Format)
def Lean.MessageData.format : Lean.MessageData -> (optParam.{1} (Option.{0} Lean.MessageDataContext) (Option.none.{0} Lean.MessageDataContext)) -> (BaseIO Std.Format) :=
  fun (msgData : Lean.MessageData) (ctx? : Option.{0} Lean.MessageDataContext) => Lean.MessageData.formatAux (Lean.NamingContext.mk Lean.Name.anonymous (List.nil.{0} Lean.OpenDecl)) ctx? msgData
