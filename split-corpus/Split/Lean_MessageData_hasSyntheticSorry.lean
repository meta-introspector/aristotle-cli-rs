import Mathlib

set_option pp.all true
-- spec: Lean.MessageData.hasSyntheticSorry : Lean.MessageData -> Bool
def Lean.MessageData.hasSyntheticSorry : Lean.MessageData -> Bool :=
  fun (msg : Lean.MessageData) => _private.Lean.Message.0.Lean.MessageData.hasSyntheticSorry.visit (Option.none.{0} Lean.MetavarContext) msg
