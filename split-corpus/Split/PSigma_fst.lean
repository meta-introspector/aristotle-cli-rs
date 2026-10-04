import Mathlib

set_option pp.all true
-- spec: PSigma.fst : forall {α : Sort.{u}} {β : α -> Sort.{v}}, (PSigma.{u, v} α β) -> α
def PSigma.fst : forall {α : Sort.{u}} {β : α -> Sort.{v}}, (PSigma.{u, v} α β) -> α :=
  fun (α : Sort.{u}) (β : α -> Sort.{v}) (self : PSigma.{u, v} α β) => self.1
