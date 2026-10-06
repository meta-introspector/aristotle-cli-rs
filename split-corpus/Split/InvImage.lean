import Mathlib

set_option pp.all true
-- spec: InvImage : forall {α : Sort.{u}} {β : Sort.{v}}, (β -> β -> Prop) -> (α -> β) -> α -> α -> Prop
def InvImage : forall {α : Sort.{u}} {β : Sort.{v}}, (β -> β -> Prop) -> (α -> β) -> α -> α -> Prop :=
  fun {α : Sort.{u}} {β : Sort.{v}} (r : β -> β -> Prop) (f : α -> β) (a₁ : α) (a₂ : α) => r (f a₁) (f a₂)
