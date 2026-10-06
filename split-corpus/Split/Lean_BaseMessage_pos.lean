import Mathlib

set_option pp.all true
-- spec: Lean.BaseMessage.pos : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> Lean.Position
def Lean.BaseMessage.pos : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> Lean.Position :=
  fun (α : Type.{u}) (self : Lean.BaseMessage.{u} α) => self.2
