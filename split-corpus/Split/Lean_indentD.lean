import Mathlib

set_option pp.all true
-- spec: Lean.indentD : Lean.MessageData -> Lean.MessageData
def Lean.indentD : Lean.MessageData -> Lean.MessageData :=
  fun (msg : Lean.MessageData) => Lean.MessageData.nestD (HAppend.hAppend.{0, 0, 0} Lean.MessageData Lean.MessageData Lean.MessageData (instHAppendOfAppend.{0} Lean.MessageData Lean.MessageData.instAppend) (Lean.MessageData.ofFormat Std.Format.line) msg)
