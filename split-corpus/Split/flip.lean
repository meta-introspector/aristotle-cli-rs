import Mathlib

set_option pp.all true
-- spec: flip : forall {α : Sort.{u}} {β : Sort.{v}} {φ : Sort.{w}}, (α -> β -> φ) -> β -> α -> φ
def flip : forall {α : Sort.{u}} {β : Sort.{v}} {φ : Sort.{w}}, (α -> β -> φ) -> β -> α -> φ :=
  fun {α : Sort.{u}} {β : Sort.{v}} {φ : Sort.{w}} (f : α -> β -> φ) (b : β) (a : α) => f a b
