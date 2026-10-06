import Mathlib

set_option pp.all true
-- spec: Lean.BaseMessage.isSilent : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> Bool
def Lean.BaseMessage.isSilent : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> Bool :=
  fun (α : Type.{u}) (self : Lean.BaseMessage.{u} α) => self.6
