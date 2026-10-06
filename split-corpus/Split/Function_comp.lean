import Mathlib

set_option pp.all true
-- spec: Function.comp : forall {α : Sort.{u}} {β : Sort.{v}} {δ : Sort.{w}}, (β -> δ) -> (α -> β) -> α -> δ
def Function.comp : forall {α : Sort.{u}} {β : Sort.{v}} {δ : Sort.{w}}, (β -> δ) -> (α -> β) -> α -> δ :=
  fun {α : Sort.{u}} {β : Sort.{v}} {δ : Sort.{w}} (f : β -> δ) (g : α -> β) (x : α) => f (g x)
