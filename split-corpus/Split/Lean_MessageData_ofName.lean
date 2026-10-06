import Mathlib

set_option pp.all true
-- spec: Lean.MessageData.ofName : Lean.Name -> Lean.MessageData
def Lean.MessageData.ofName : Lean.Name -> Lean.MessageData :=
  fun (n : Lean.Name) => Lean.MessageData.ofFormat (Std.ToFormat.format.{0} Lean.Name Lean.instToFormatName_lean n)
