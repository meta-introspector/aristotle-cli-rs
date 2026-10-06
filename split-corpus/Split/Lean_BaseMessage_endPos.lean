import Mathlib

set_option pp.all true
-- spec: Lean.BaseMessage.endPos : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> (Option.{0} Lean.Position)
def Lean.BaseMessage.endPos : forall {α : Type.{u}}, (Lean.BaseMessage.{u} α) -> (Option.{0} Lean.Position) :=
  fun (α : Type.{u}) (self : Lean.BaseMessage.{u} α) => self.3
