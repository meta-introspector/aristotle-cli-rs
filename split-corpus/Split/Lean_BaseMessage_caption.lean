import Mathlib

set_option pp.all true
-- spec: Lean.BaseMessage.caption : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> String
def Lean.BaseMessage.caption : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> String :=
  fun (α : Type.{u}) (self : Lean.BaseMessage.{u} α) => self.7
