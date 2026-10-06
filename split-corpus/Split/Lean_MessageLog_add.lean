import Mathlib

set_option pp.all true
-- spec: Lean.MessageLog.add : Lean.Message -> Lean.MessageLog -> Lean.MessageLog
def Lean.MessageLog.add : Lean.Message -> Lean.MessageLog -> Lean.MessageLog :=
  fun (msg : Lean.Message) (log : Lean.MessageLog) => Lean.MessageLog.mk (Lean.MessageLog.reported log) (Lean.PersistentArray.push.{0} Lean.Message (Lean.MessageLog.unreported log) msg) (Lean.MessageLog.loggedKinds log)
