import Mathlib

-- spec: opaque Lean.MessageData.formatAux : Lean.NamingContext -> (Option.{0} Lean.MessageDataContext) -> Lean.MessageData -> (BaseIO Std.Format)
opaque Lean.MessageData.formatAux : Lean.NamingContext -> (Option.{0} Lean.MessageDataContext) -> Lean.MessageData -> (BaseIO Std.Format) :=
  fun (a._@._internal._hyg.0 : Lean.NamingContext) (a._@._internal._hyg.0 : Option.{0} Lean.MessageDataContext) (a._@._internal._hyg.0 : Lean.MessageData) => Inhabited.default.{1} (BaseIO Std.Format) (instInhabitedOfMonad.{0, 0} Std.Format BaseIO instMonadBaseIO Std.instInhabitedFormat)
