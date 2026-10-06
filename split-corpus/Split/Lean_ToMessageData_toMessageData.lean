import Mathlib

set_option pp.all true
-- spec: Lean.ToMessageData.toMessageData : forall {α : Type} [self : Lean.ToMessageData α], α -> Lean.MessageData
def Lean.ToMessageData.toMessageData : forall {α : Type} [self : Lean.ToMessageData α], α -> Lean.MessageData :=
  fun (α : Type) [self : Lean.ToMessageData α] => self.1
