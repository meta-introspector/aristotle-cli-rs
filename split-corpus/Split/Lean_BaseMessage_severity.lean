import Mathlib

set_option pp.all true
-- spec: Lean.BaseMessage.severity : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> Lean.MessageSeverity
def Lean.BaseMessage.severity : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> Lean.MessageSeverity :=
  fun (α : Type.{u}) (self : Lean.BaseMessage.{u} α) => self.5
