import Mathlib

set_option pp.all true
-- spec: Lean.BaseMessage.data : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> α
def Lean.BaseMessage.data : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> α :=
  fun (α : Type.{u}) (self : Lean.BaseMessage.{u} α) => self.8
