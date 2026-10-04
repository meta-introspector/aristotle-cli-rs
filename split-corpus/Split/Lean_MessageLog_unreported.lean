import Mathlib

set_option pp.all true
-- spec: Lean.MessageLog.unreported : Lean.MessageLog -> (Lean.PersistentArray.{0} Lean.Message)
def Lean.MessageLog.unreported : Lean.MessageLog -> (Lean.PersistentArray.{0} Lean.Message) :=
  fun (self : Lean.MessageLog) => self.2
