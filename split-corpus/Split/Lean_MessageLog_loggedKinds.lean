import Mathlib

set_option pp.all true
-- spec: Lean.MessageLog.loggedKinds : Lean.MessageLog -> Lean.NameSet
def Lean.MessageLog.loggedKinds : Lean.MessageLog -> Lean.NameSet :=
  fun (self : Lean.MessageLog) => self.3
