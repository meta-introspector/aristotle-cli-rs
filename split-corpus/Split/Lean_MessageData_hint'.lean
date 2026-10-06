import Mathlib

set_option pp.all true
-- spec: Lean.MessageData.hint' : Lean.MessageData -> Lean.MessageData
def Lean.MessageData.hint' : Lean.MessageData -> Lean.MessageData :=
  fun (hint : Lean.MessageData) => HAppend.hAppend.{0, 0, 0} Lean.MessageData Lean.MessageData Lean.MessageData (instHAppendOfAppend.{0} Lean.MessageData Lean.MessageData.instAppend) (HAppend.hAppend.{0, 0, 0} Lean.MessageData Lean.MessageData Lean.MessageData (instHAppendOfAppend.{0} Lean.MessageData Lean.MessageData.instAppend) (HAppend.hAppend.{0, 0, 0} Lean.MessageData Lean.MessageData Lean.MessageData (instHAppendOfAppend.{0} Lean.MessageData Lean.MessageData.instAppend) (Lean.MessageData.ofFormat Std.Format.line) (Lean.MessageData.ofFormat Std.Format.line)) (Function.comp.{1, 1, 1} String Std.Format Lean.MessageData Lean.MessageData.ofFormat (Std.ToFormat.format.{0} String Std.instToFormatString) "Hint: ")) hint
